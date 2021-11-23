#pragma once

#include <sys/types.h>
#include <stdint.h>
#include <cerrno>
#include <iostream>
#include <sys/ptrace.h>
#include <cstring>

#include "debuginfo.hpp"

using namespace std;

class Breakpoint {
	public:
		Breakpoint(const Breakpoint&) = delete;
		Breakpoint &operator=(const Breakpoint&) = delete;
	
		Breakpoint(pid_t pid, intptr_t addr, const LineEntry* le = NULL) : mLineEntry(le) {
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
		
		bool isIn(unsigned file, unsigned line = 0, unsigned column = 0) const {
			if (mLineEntry == nullptr) {
				return false;
			}
			
			if (mLineEntry->fileIndex != file) {
				return false;
			}
			
			if (line && mLineEntry->line != line) {
				return false;
			}
			
			return !column || mLineEntry->column == column;
		}
		
		bool isEnabled() const {
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
	
		const static unsigned char int3 = 0xCC;
	
		bool mEnabled;
		unsigned char mOldVal;
		intptr_t mAddr;
		pid_t mPid;
		const LineEntry* mLineEntry;
};