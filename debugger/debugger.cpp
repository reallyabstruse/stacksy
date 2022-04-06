#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <cerrno>
#include <cstring>
#include <unordered_map>
#include <unordered_set>
#include <sys/user.h>
#include <fcntl.h> 
#include <inttypes.h>
#include <fstream>
#include <sstream>
#include <filesystem>
#include <cmath>

#include "libelfin-fbreg/dwarf/dwarf++.hh"
#include "libelfin-fbreg/elf/elf++.hh"

#include "debugger.hpp"
#include "debuggerview.hpp"
#include "linenoise/linenoise.h"
#include "debuginfo.hpp"
#include "breakpoint.hpp"


using namespace std;


StacksyDebugger::StacksyDebugger(string path, pid_t pid) : mDebugInfo(path, pid) {
	filesystem::path relPath = path;
	mLoadAddress = 0;
	mRunning = false;

	mPid = pid;
	
	if (!mDebugInfo.getFunctionAddr("entry")) {
		throw(DebuggerException("No entry function found."));
	}
}

		
void StacksyDebugger::continueExecution() {
	stepOverBreakpoint();
	
	if (ptrace(PTRACE_CONT, mPid, nullptr, nullptr) == -1) {
		cerr << strerror(errno);
		return;
	 }
	
	wait();
}
		
void StacksyDebugger::addBreakpoint(uint64_t addr, const LineEntry *le/* = nullptr*/) {
	if (le == nullptr) {
		le = mDebugInfo.getLineEntry(addr);
	}
	Breakpoint &bp = mBreakpoints.try_emplace(addr, mPid, addr, le).first->second;
	bp.enable();
}

void StacksyDebugger::addBreakpoint(unsigned line, unsigned column, unsigned fileNum) {
	intptr_t addr = mDebugInfo.getAddressFromLineCol(line, column, fileNum);
	if (addr == 0) {
		throw(DebuggerException("No address linked to " + mDebugInfo.lineColToString(line, column, fileNum)));
	}
	
	addBreakpoint(addr, mDebugInfo.getLineEntry(fileNum, line, column));
}
		
void StacksyDebugger::removeBreakpoint(uint64_t addr) {
	auto it = mBreakpoints.find(addr);
	if (it != mBreakpoints.end()) {
		it->second.disable();
	}
}
		
bool StacksyDebugger::hasBreakpoint(uint64_t addr) {
	auto it = mBreakpoints.find(addr);
	return it != mBreakpoints.end() && it->second.isEnabled();
}

bool StacksyDebugger::hasBreakpoint(unsigned file, unsigned line/* = 0*/, unsigned column/* = 0*/) {
	for (const auto &[idx, b] : mBreakpoints) {
		if (b.isIn(file, line, column) && b.isEnabled()) {
			return true;
		}
	}
	return false;
}
		
void StacksyDebugger::writeMemory(uint64_t addr, uint64_t val) {
	if (ptrace(PTRACE_POKEDATA, mPid, addr, val) == -1) {
		cerr << "Could not write data to process. " << strerror(errno);
		return;
	}
}

uint64_t StacksyDebugger::tryReadMemory(uint64_t addr) {
	errno = 0;
	return ptrace(PTRACE_PEEKDATA, mPid, addr, nullptr);
}
	
uint64_t StacksyDebugger::readMemory(uint64_t addr) {
	auto res = tryReadMemory(addr);
	if (errno != 0) {
		throw DebuggerException(strerror(errno));
	}
	
	return res;
}

string StacksyDebugger::readMemoryString(uint64_t addr, int size) {
	stringstream res;
	
	res << '"';
	
	while (size > 0) {
		uint64_t val = readMemory(addr);
		unsigned N = min(size, QWORD_SIZE);
		
		for (unsigned i = 0; i < N; i++) {
			char c = (val >> (8 * i)) & 0xff;
			if (c == '\n') {
				res << "\\n";
			} else if (c == '\r') {
				res << "\\r";
			} else if (c < 0x20 || c > 0x7f) {
				res << "\\" << oct << c;
			} else {
				res << c;
			}
		}
		
		
		size -= QWORD_SIZE;
		addr += QWORD_SIZE;
	}
	res << '"';
	return res.str();
}
	
uint64_t StacksyDebugger::readRegister(X64Register reg) {
	return ((uint64_t*)&mRegs)[reg];
}
		
void StacksyDebugger::writeRegister(X64Register reg, uint64_t val) {
	((uint64_t*)&mRegs)[reg] = val;
	
	if (ptrace(PTRACE_SETREGS, mPid, nullptr, &mRegs) == -1) {
		cerr << strerror(errno);
		throw(DebuggerException("Can't write registers"));
	}
}

uint64_t StacksyDebugger::getPc() {
	return readRegister(X64Register::RIP);
}
		
void StacksyDebugger::stepX64Instruction() {
	if (!stepOverBreakpoint()) {
		if (ptrace(PTRACE_SINGLESTEP, mPid, nullptr, nullptr) == -1) {
			cerr << strerror(errno);
			throw(DebuggerException("Couldn't step"));
		}
		
		wait();
	}
}
		
bool StacksyDebugger::stepOverBreakpoint() {
	auto prev_rip = mPc;
	
	auto it = mBreakpoints.find(prev_rip);
	if (it != mBreakpoints.end()) {
		if (it->second.isEnabled()) {
			it->second.disable();
			stepX64Instruction();
			it->second.enable();
			return true;
		}
	}
	return false;
}

uint64_t StacksyDebugger::getReturnAddress() {
	return readMemory(readRegister(X64Register::R12) - 8);
}
		
void StacksyDebugger::stepOut(uint32_t ct/* = 1*/) {
	while (ct--) {
		uint64_t returnAddress = getReturnAddress();
		if (!hasBreakpoint(returnAddress)) {
			addBreakpoint(returnAddress);
			continueExecution();
			removeBreakpoint(returnAddress);
		} else {
			continueExecution();
		}
	}
}
	
		
void StacksyDebugger::stepOver(bool column/* = false*/, uint32_t ct/* = 1*/) {
	auto comparator = column ? DebugInfo::sameColumn : DebugInfo::sameLine;
	
	while (ct--) {
		uint64_t returnAddress = getReturnAddress();
		
		const string curFuncName = mDebugInfo.getFunctionName(mPc);
		const LineEntry *lineInfo = mDebugInfo.getLineEntry(mPc);
		do {
			stepFrom(lineInfo, column, returnAddress);
			while (mRunning && mPc != returnAddress && !mDebugInfo.isAddressInFunction(mPc, curFuncName)) {
				stepOut();
			}
		} while(mRunning && mPc != returnAddress && comparator(lineInfo, mDebugInfo.getLineEntry(mPc)));
	}
}
		
	
void StacksyDebugger::step(bool column/* = false*/, uint32_t ct/* = 1*/) {		  
	const LineEntry *lineInfo = mDebugInfo.getLineEntry(mPc);
	while (ct--) {
		lineInfo = stepFrom(lineInfo, column);
	}
}

const LineEntry * StacksyDebugger::stepFrom(const LineEntry *lineInfo, bool column/* = false*/, uint64_t returnAddress/* = 0*/) {
	const LineEntry *newLineInfo = nullptr;
			  
	auto comparator = column ? DebugInfo::sameColumn : DebugInfo::sameLine;
	do {
		stepX64Instruction();
		newLineInfo = mDebugInfo.getLineEntry(mPc);
	} while (mRunning && mPc != returnAddress && comparator(lineInfo, newLineInfo));
	
	return newLineInfo;
}
		
		
const vector<vector<string>> &StacksyDebugger::getSource(string path) {
	const unsigned TAB_WIDTH = 4;
	
	if (mSources.count(path)) {
		return mSources[path];
	}
	
	ifstream file(path);
	
	vector<vector<string>> res;
	bool inWhitespace = true;
	vector<string> curLine;
	string curWord;
	char c;
	
	while (file.get(c).good()) {
		if (c == '\r') {
			c = ' ';
		}
		if (c == '\n') {
			curLine.push_back(curWord);
			res.push_back(curLine);
			curWord = "";
			curLine = vector<string>();
			inWhitespace = true;
		} else {
			if (c == '\t') {
				if (inWhitespace) {
					curWord.append(TAB_WIDTH, ' ');
				} else {
					curLine.push_back(curWord);
					curWord = string(TAB_WIDTH, ' ');
				}
			} else if ((c == ' ') == inWhitespace) {
				curWord.push_back(c);
			} else {
				if (c == '"' || c == '\'') {
					if (inWhitespace) {
						curLine.push_back(curWord);
						curWord = string(1, c);
					}
					inWhitespace = false;
					
					char c2;
					while (file.get(c2).good()) {
						curWord.push_back(c2);
						if (c2 == c) {
							break;
						} else if (c2 == '\\' && file.get(c2).good()) {
							curWord.push_back(c2);
						}
					}
				} else {
					curLine.push_back(curWord);
					curWord = string(1, c);
					
					inWhitespace = !inWhitespace;
				}
			}
		}
	}
	
	curLine.push_back(curWord);
	res.push_back(curLine);
	
	mSources[path] = res;
	
	return mSources[path];
}

void StacksyDebugger::getRegisters() {
	if (ptrace(PTRACE_GETREGS, mPid, nullptr, &mRegs) == -1) {
		cerr << strerror(errno);
		throw(DebuggerException("Can't read registers"));
	}
}

void StacksyDebugger::handleSigtrap(siginfo_t info) {
	switch (info.si_code) {
    // breakpoint
		case SI_KERNEL:
		case TRAP_BRKPT:
			mPc = getPc() - 1;
			writeRegister(X64Register::RIP, mPc);
		break;
		
	// single step, or unknown sigtrap
		case TRAP_TRACE:
		default:
			mPc = getPc();
		break;
		
	}
}

int StacksyDebugger::waitForDebugee() {
	int status;
	
	if (waitpid(mPid, &status, 0) == -1) {
		cerr << "Error continuing\n";
	}
	
	return status;
}

void StacksyDebugger::wait() {
	int status = waitForDebugee();
	
	if (__WIFEXITED(status)) {
		outputMessage("Process exited normally");
		mRunning = false;
		return;
	} else {
		getRegisters();
	}
	
	siginfo_t info;
    if (ptrace(PTRACE_GETSIGINFO, mPid, nullptr, &info) == -1) {
		outputError(strerror(errno));
		return;
	}
	
	switch (info.si_signo) {
		case SIGTRAP:
			handleSigtrap(info);
			break;
		case SIGSEGV:
			mPc = getPc();
			outputError("Segfault:" + to_string(info.si_code) + " at " + to_string(uint64_t(info.si_addr)));
			break;
		case 0:
			outputMessage("Program exited normally");
			break;
		default:
			mPc = getPc();
			outputError("Got signal " + to_string(info.si_signo) + " " + strsignal(info.si_signo));
    }

}

void StacksyDebugger::outputError(string err) {
	cerr << err << endl;
}
		
void StacksyDebugger::outputMessage(string msg, int) {
	cout << msg << endl;
}


int main(int argc, char *argv[]) {
	if (argc < 2) {
		cerr << "No file specified";
		return -1;
	}
	
	char *path = argv[1];
	
	DebugeePipe dPipe;
	
	pid_t pid = fork();
	if (pid == 0) {
		 if (ptrace(PTRACE_TRACEME, 0, nullptr, nullptr) == -1) {
			 cerr << strerror(errno);
			 return -1;
		 }
		 dPipe.childInit();
		 execl(path, path, nullptr);
		 
		 cerr << strerror(errno) << "\n";
		 return -1;
	} else {
		dPipe.parentInit();
		try {
			DebuggerNcursesView sd(path, pid, dPipe);

		
			
			sd.run();
		} catch (DebuggerException &de) {
			endwin();
			cerr << "exception" << de.what() << endl;
		} catch(...) {
			endwin();
			std::exception_ptr p = std::current_exception();
			if (p) {
				cerr << p.__cxa_exception_type()->name();
			}
			else {
				cerr<< "unknown exception";
			}
		} 

		
		return -1;
	}
}