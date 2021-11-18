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
		
void StacksyDebugger::addBreakpoint(uint64_t addr) {
	Breakpoint bp = mBreakpoints.try_emplace(addr, mPid, addr).first->second;
	bp.enable();
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
		
void StacksyDebugger::writeMemory(uint64_t addr, uint64_t val) {
	if (ptrace(PTRACE_POKEDATA, mPid, addr, val) == -1) {
		cerr << "Could not write data to process. " << strerror(errno);
		return;
	}
}
		
uint64_t StacksyDebugger::readMemory(uint64_t addr) {
	errno = 0;
	auto res = ptrace(PTRACE_PEEKDATA, mPid, addr, nullptr);
	if (errno != 0) {
		throw DebuggerException(strerror(errno));
	}
	
	return res;
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
			writeRegister(X64Register::RIP, prev_rip);
			it->second.disable();
			stepX64Instruction();
			it->second.enable();
			return true;
		}
	}
	return false;
}

		
void StacksyDebugger::stepOut() {
	uint64_t returnAddress = readRegister(X64Register::R12) - 8;
	if (!hasBreakpoint(returnAddress)) {
		addBreakpoint(returnAddress);
		continueExecution();
		removeBreakpoint(returnAddress);
	} else {
		continueExecution();
	}
}
		
void StacksyDebugger::stepColumn() {
	LineEntry *lineInfo = nullptr,
			  *newLineInfo = mDebugInfo.getLineEntry(mPc);
			  
	uint64_t newAddr;
	
	do {
		lineInfo = newLineInfo;
		stepX64Instruction();
		newAddr = mPc;
		newLineInfo = mDebugInfo.getLineEntry(newAddr);
	} while (DebugInfo::sameColumn(lineInfo, newLineInfo) && mDebugInfo.getFunctionName(newAddr).empty());
}
		
void StacksyDebugger::stepLine() {
	LineEntry *lineInfo = nullptr,
			  *newLineInfo = mDebugInfo.getLineEntry(mPc);
			  
	uint64_t newAddr;
	
	do {
		lineInfo = newLineInfo;
		stepX64Instruction();
		newAddr = mPc;
		newLineInfo = mDebugInfo.getLineEntry(newAddr);
	} while (DebugInfo::sameLine(lineInfo, newLineInfo) && mDebugInfo.getFunctionName(newAddr).empty());
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
				curLine.push_back(curWord);
				curWord = string(1, c);
				inWhitespace = !inWhitespace;
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
			cerr << "111";
			mPc = getPc() - 1;
		break;
		
	// single step, or unknown sigtrap
		case TRAP_TRACE:
		default:
			cerr << "222";
			mPc = getPc();
		break;
		
	}
	cerr << "xxx" << hex << mPc << " " << mDebugInfo.mLoadAddress << endl;
}

void StacksyDebugger::wait() {
	int status;
	if (waitpid(mPid, &status, 0) == -1) {
		cerr << "Error continuing\n";
	}
	
	getRegisters();
	
	siginfo_t info;
    ptrace(PTRACE_GETSIGINFO, mPid, nullptr, &info);
	
	switch (info.si_signo) {
		case SIGTRAP:
			handleSigtrap(info);
			break;
		case SIGSEGV:
			mPc = getPc();
			throw DebuggerException((string("Yay, segfault. Reason: ") + to_string(info.si_code)).c_str());
			break;
		default:
			mPc = getPc();
			throw DebuggerException((string("Got signal ") + strsignal(info.si_signo)).c_str());
    }
	
	if (__WIFEXITED(status)) {
		mRunning = false;
		return;
	}

}

int main(int argc, char *argv[]) {
	if (argc < 2) {
		cerr << "No file specified";
		return -1;
	}
	
	char *path = argv[1];
	
	pid_t pid = fork();
	if (pid == 0) {
		 if (ptrace(PTRACE_TRACEME, 0, nullptr, nullptr) == -1) {
			 cerr << strerror(errno);
			 return -1;
		 }
		 execl(path, path, nullptr);
		 
		 cerr << strerror(errno) << "\n";
		 return -1;
	} else {
		DebuggerNcursesView sd(path, pid);
		try {
			return sd.run();
		} catch (DebuggerException &de) {
			cerr << de.what() << endl;
		} catch(...) {
			cerr << "other err" << endl;
		} 
		
		
		endwin();
		return -1;
	}
}