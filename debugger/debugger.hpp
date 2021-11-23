#pragma once

#include <sys/user.h>

#include "breakpoint.hpp"
#include "debuginfo.hpp"

// TODO: REMOVE!
#include <curses.h>

#define QWORD_SIZE 8

using namespace std;


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
		StacksyDebugger(string path, pid_t pid);
	
		void continueExecution();
		
		void addBreakpoint(uint64_t addr, LineEntry *le = nullptr);
		void addBreakpoint(unsigned line, unsigned column, unsigned fileNum);
		
		void removeBreakpoint(uint64_t addr);
		
		bool hasBreakpoint(uint64_t addr);
		bool hasBreakpoint(unsigned file, unsigned line = 0, unsigned column = 0);
		
		void writeMemory(uint64_t addr, uint64_t val);
		
		// Try to read value from addr, sett errno on fail
		uint64_t tryReadMemory(uint64_t addr);
		// Read value from addr, throw on fail
		uint64_t readMemory(uint64_t addr);
	
		uint64_t readRegister(X64Register reg);
		
		uint64_t getPc();
		
		void writeRegister(X64Register reg, uint64_t val);
		
		void stepX64Instruction();
		
		bool stepOverBreakpoint();
		
		void stepOut();
		
		void stepColumn();
		
		void stepLine();
		
		virtual void outputError(string err);
		
		virtual void outputMessage(string msg);
		
		const vector<vector<string>> &getSource(string path);
	protected:
		string mPath;
		pid_t mPid;
		unordered_map<uint64_t, Breakpoint> mBreakpoints;
		user_regs_struct mRegs;
		
		uint64_t mLoadAddress;
		bool mRunning;
		
		uint64_t mBottomStack;
		uint64_t mPc;
		
		DebugInfo mDebugInfo;
		
		unordered_map<string, vector<vector<string>>> mSources;
		


		void getRegisters();
		void wait();
		void handleSigtrap(siginfo_t info);
		
		// Call waitpid and return when debugee breaks. Returns waitpid status
		virtual int waitForDebugee();
		
};
