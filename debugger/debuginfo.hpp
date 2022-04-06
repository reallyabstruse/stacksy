#pragma once

#include <string>
#include <map>
#include <unordered_map>
#include <fcntl.h> 
#include <sys/types.h>
#include <fstream>
#include <unistd.h>

#include "libelfin-fbreg/dwarf/dwarf++.hh"
#include "libelfin-fbreg/elf/elf++.hh"

using namespace std;


class DebuggerException : public exception {
	public:
		DebuggerException(string msg) {
			mMsg = msg;
		}
		
		const char *what() {
			return mMsg.c_str();
		}
		
	private:
		string mMsg;
};

struct LineEntry {
	unsigned line, column, fileIndex;
	bool prologueEnd;
};

class DebugInfo {
	public:
		DebugInfo(const string &path, pid_t pid);
		
		intptr_t getFunctionAddr(const string &name) const;
		
		intptr_t getFunctionPrologueEndAddress(const string &name) const;
		
		intptr_t getFunctionEndAddress(const string &name) const;
		
		const string &getFunctionName(intptr_t addr) const;

		bool isAddressInFunction(intptr_t addr, const string &name) const;
		
		intptr_t getAddressFromLineCol(uint32_t line, uint16_t column, uint16_t file) const;
		
		const LineEntry* getLineEntry(intptr_t addr) const;
		
		const LineEntry* getLineEntry(unsigned file, unsigned line, unsigned column) const;
		
		bool isDynamic() const;
		
		const string &getFilePath(uint32_t index) const;
		
		void initLoadAddress();
		
		// Return true if same line, or if either entry has no line associated with it.
		static bool sameLine(const LineEntry *oldLine, const LineEntry *newLine);
		
		// Return true if same column, or if either entry has no line associated with it.
		static bool sameColumn(const LineEntry *oldLine, const LineEntry *newLine);
		
		static uint64_t getLineColumnHash(uint32_t line, uint16_t column, uint16_t file);
	
	
		unsigned getFileFromAddress(intptr_t addr) const;
		
		unsigned getFileFromName(string name) const;
		
		string lineColToString(unsigned line, unsigned column, unsigned fileIndex) const;

	private:
		
		
		void loadFunctionAddresses(elf::elf e);
		
		void loadLineEntries(dwarf::dwarf d);
		
		// Map from function name to address
		unordered_map<string, pair<intptr_t, intptr_t>> mFunctionAddresses;
		// Map from address to function name
		map<intptr_t, string> mFunctionNames;
		
		// Map from getLineColumnHash(line, col, file) to address
		unordered_map<uint64_t, intptr_t> mLineAddresses;
		// Map from address to LineEntry
		map<intptr_t, LineEntry> mLineEntries;
		
		// Paths to original source files
		vector<string> mFilePaths;
		
		// is dynamic executable?
		bool mDynamic;
		
		// Offset between addresses in debug info and running process
		intptr_t mLoadAddress;
		
		// Path of file to debug
		string mPath;
		
		// pid of process
		pid_t mPid;
};