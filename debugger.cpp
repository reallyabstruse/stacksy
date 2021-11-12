#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <cerrno>
#include <cstring>
#include <unordered_map>
#include <sys/user.h>
#include <fcntl.h> 
#include <inttypes.h>
#include <fstream>
#include <sstream>
#include <filesystem>

#include "libelfin-fbreg/dwarf/dwarf++.hh"
#include "libelfin-fbreg/elf/elf++.hh"

#include "linenoise/linenoise.h"

using namespace std;

class DebuggerException : public exception {
	public:
		DebuggerException(const char *msg) {
			cerr << msg;
			mMsg = msg;
		}
		
		const char *what() {
			return mMsg;
		}
		
	private:
		const char *mMsg;
};

class Breakpoint {
	public:
		Breakpoint(pid_t pid, intptr_t addr) {
			mPid = pid;
			mAddr = addr;
			mEnabled = false;
		}
		
		void enable() {
			if (mEnabled) {
				return;
			}
			
			changeByte(int3);
			 
			mEnabled = true;
		}
		
		void disable() {
			if (!mEnabled) {
				return;
			}
			
			changeByte(mOldVal);
			
			mEnabled = false;
		}
		
		bool isEnabled() {
			return mEnabled;
		}
		
	private:
		void changeByte(unsigned char newVal) {
			errno = 0;
			auto olddata = ptrace(PTRACE_PEEKDATA, mPid, mAddr, nullptr);
			
			if (errno != 0) {
				cerr << "Could not peek data of process. " << strerror(errno);
				return;
			}
			
			mOldVal = olddata & 0xff;
			auto newdata = (olddata & ~0xff) | newVal;
			 
			if (ptrace(PTRACE_POKEDATA, mPid, mAddr, newdata) == -1) {
				cerr << "Could not poke data to process. " << strerror(errno);
				return;
			}
		}
	
		const unsigned char int3 = 0xCC;
	
		bool mEnabled;
		unsigned char mOldVal;
		intptr_t mAddr;
		pid_t mPid;
};

enum X64Register {
	R15, R14, R13, R12,
	RBP, RBX, R11, R10,
	R9,  R8,  RAX, RCX,
	RDX, RSI, RDI, ORIG_EAX,
	RIP, CS,  RFLAGS, RSP, 
	SS,	FS_BASE, GS_BASE, 
	DS,	ES, FS, GS
};

class StacksyDebugger {
	public:
		StacksyDebugger(string path, pid_t pid) {
			filesystem::path relPath = path;
			mLoadAddress = 0;
			mRunning = false;
			
			mPath = filesystem::absolute(relPath).string();
			cout << mPath;
			mPid = pid;
			
			auto fp = open(path.c_str(), O_RDONLY);
			mElf = elf::elf{elf::create_mmap_loader(fp)};
			mDwarf = dwarf::dwarf{dwarf::elf::create_loader(mElf)};
			
			dump_all();
			loadFunctionAddresses();
			
			if (mFunctions.count("func_entry") == 0) {
				throw(DebuggerException("No entry function found."));
			}
		}
	
		int run() {
			int status;
			if (waitpid(mPid, &status, 0) == -1 || __WIFEXITED(status)) {
				cerr << "Could not start child process " << mPath << "\n";
				return -1;
			}
			
			mRunning = true;
			
			initLoadAddress();
			cout << hex << mLoadAddress;
			getRegisters();
			addBreakpoint(getFunctionAddress("func_entry"));
			continueExecution();
			
			char* line = nullptr;
			while((line = linenoise("> ")) != nullptr) {
				cout << hex << readRegister(X64Register::RIP) << "\n";
				
				handleCommand(line);
				linenoiseHistoryAdd(line);
				linenoiseFree(line);
			}
			
			return 0;
		}
		
		void handleCommand(string line) {
			if (mRunning) {
				if (line[0] == 'c') {
					continueExecution();
				}
			}
		}
		
		void continueExecution() {
			stepOverBreakpoint();
			
			if (ptrace(PTRACE_CONT, mPid, nullptr, nullptr) == -1) {
				cerr << strerror(errno);
				return;
			 }
			
			wait();
		}
		
		void addBreakpoint(intptr_t addr) {
			Breakpoint bp = mBreakpoints.try_emplace(addr, mPid, addr).first->second;
			bp.enable();
		}
		
		void writeMemory(intptr_t addr, uint64_t val) {
			if (ptrace(PTRACE_POKEDATA, mPid, addr, val) == -1) {
				cerr << "Could not write data to process. " << strerror(errno);
				return;
			}
		}
		
		uint64_t readMemory(intptr_t addr) {
			errno = 0;
			auto res = ptrace(PTRACE_PEEKDATA, mPid, addr, nullptr);
			if (errno != 0) {
				throw DebuggerException(strerror(errno));
			}
			
			return res;
		}
	
		uint64_t readRegister(X64Register reg) {
			return ((uint64_t*)&mRegs)[reg];
		}
		
		void writeRegister(X64Register reg, uint64_t val) {
			((uint64_t*)&mRegs)[reg] = val;
			
			if (ptrace(PTRACE_SETREGS, mPid, nullptr, &mRegs) == -1) {
				cerr << strerror(errno);
				throw(DebuggerException("Can't write registers"));
			}
		}
		
		void stepX64Instruction() {
			if (ptrace(PTRACE_SINGLESTEP, mPid, nullptr, nullptr) == -1) {
				cerr << strerror(errno);
				throw(DebuggerException("Couldn't step"));
			}
			
			wait();
		}
		
		void stepOverBreakpoint() {
			auto prev_rip = readRegister(X64Register::RIP) - 1;
			
			auto it = mBreakpoints.find(prev_rip);
			if (it != mBreakpoints.end()) {
				if (it->second.isEnabled()) {
					writeRegister(X64Register::RIP, prev_rip);
					it->second.disable();
					stepX64Instruction();
					it->second.enable();
				}
			}
		}
		
		void dump_all() {
			for (auto cu : mDwarf.compilation_units()) {
                printf("--- <%x>\n", (unsigned int)cu.get_section_offset());
                dump_line_table(cu.get_line_table());
                printf("\n");
			}
		}
		
		void loadFunctionAddresses() {
			for (auto &sec : mElf.sections()) {
                if (sec.get_hdr().type != elf::sht::symtab)
                        continue;

                for (auto sym : sec.as_symtab()) {
					const string &name = sym.get_name();
					if (name.rfind("func_", 0) == 0) {
						intptr_t addr = sym.get_data().value;
						
						mFunctions[name] = addr;
					}
                }
			}
		}
		
		void
		dump_line_table(const dwarf::line_table &lt)
		{
				for (auto &line : lt) {
						if (line.end_sequence)
								printf("\n");
						else
								printf("%-40s%8d%8d%#20" PRIx64 "\n", line.file->path.c_str(),
									   line.line, line.column, line.address);
				}
		}

	
	private:
		string mPath;
		pid_t mPid;
		unordered_map<intptr_t, Breakpoint> mBreakpoints;
		user_regs_struct mRegs;
		dwarf::dwarf mDwarf;
		elf::elf mElf;
		unordered_map<string, intptr_t> mFunctions;
		uint64_t mLoadAddress;
		bool mRunning;
		
		void getRegisters() {
			if (ptrace(PTRACE_GETREGS, mPid, nullptr, &mRegs) == -1) {
				cerr << strerror(errno);
				throw(DebuggerException("Can't read registers"));
			}
			
			for (int i = 0; i < 20; i++) {
				//cout << dec << i << ": " << hex << readRegister((X64Register)i) << "\n";
			}
		}
		
		void wait() {
			int status;
			if (waitpid(mPid, &status, 0) == -1) {
				cerr << "Error continuing\n";
			}
			
			if (__WIFEXITED(status)) {
				mRunning = false;
				return;
			}
			
			getRegisters();
		}
		
		void initLoadAddress() {
			if (mElf.get_hdr().type == elf::et::dyn) {
				ifstream map("/proc/" + to_string(mPid) + "/maps");
				string line;
				while (getline(map, line)) {
					if (line.ends_with(mPath)) {
						mLoadAddress = stoll(line, 0, 16);
						return;
					}
				}
				cerr << "Load address not found";
				throw(DebuggerException("Load address not found"));
			}
		}
		
		intptr_t getFunctionAddress(string name) {
			auto it = mFunctions.find(name);
			if (it == mFunctions.end()) {
				cerr << "Function " << name << " not found.";
				return 0;
			} else {
				return mLoadAddress + it->second;
			}
		}
};

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
		cout << "starting debugging of pid" << pid << "\n";
		
		StacksyDebugger sd(path, pid);
		return sd.run();
	}
}