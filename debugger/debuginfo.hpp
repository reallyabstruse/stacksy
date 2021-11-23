#pragma once

#include <string>
#include <map>
#include <unordered_map>
#include <filesystem>
#include <sys/types.h>
#include <fcntl.h> 
#include <fstream>
#include <unistd.h>


#include "libelfin-fbreg/dwarf/dwarf++.hh"
#include "libelfin-fbreg/elf/elf++.hh"

using namespace std;


class DebuggerException : public exception {
	public:
		DebuggerException(string msg) {
			cerr << msg;
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
		DebugInfo(const string &path, pid_t pid) {
			mPath = filesystem::canonical(path).string();
			mPid = pid;
			
			auto fp = open(path.c_str(), O_RDONLY);
			
			elf::elf e = elf::elf{elf::create_mmap_loader(fp)};
			dwarf::dwarf d = dwarf::dwarf{dwarf::elf::create_loader(e)};
			
			loadFunctionAddresses(e);
			loadLineEntries(d);
			
			mDynamic = e.get_hdr().type == elf::et::dyn;
			mLoadAddress = 0;
			
			close(fp);
		}
		
		intptr_t getFunctionAddr(const string &name) {
			auto it = mFunctionAddresses.find("func_" + name);
			if (it == mFunctionAddresses.end()) {
				return 0;
			}
			
			return it->second + mLoadAddress;
		}
		
		intptr_t getFunctionPrologueEndAddress(const string &name) {
			auto itFunc = mFunctionAddresses.find("func_" + name);
			if (itFunc == mFunctionAddresses.end() || !itFunc->second) {
				throw DebuggerException("Could not find function " + name);
			}

			auto itLineEntry = mLineEntries.upper_bound(itFunc->second);
			if (itLineEntry == mLineEntries.end()) {
				throw DebuggerException("Could not find end of prologue for function " + name);
			}
			
			return itLineEntry->first + mLoadAddress;
		}
		
		const string &getFunctionName(intptr_t addr) {		
			auto it = mFunctionNames.find(addr - mLoadAddress);
			if (it == mFunctionNames.end()) {
				static const string notFound = "";
				return notFound;
			}
			
			return it->second;
		}
		
		bool isFunctionEntry(intptr_t addr) {		
			return mFunctionNames.count(addr - mLoadAddress);
		}
		
		intptr_t getAddressFromLineCol(uint32_t line, uint16_t column, uint16_t file) {
			auto it = mLineAddresses.find(getLineColumnHash(line, column, file));
			if (it == mLineAddresses.end()) {
				return 0;
			}
			
			return it->second + mLoadAddress;
		}
		
		LineEntry* getLineEntry(intptr_t addr) {
			auto it = mLineEntries.find(addr - mLoadAddress);
			if (it == mLineEntries.end()) {
				return nullptr;
			}
			
			return &it->second;
		}	
		
		LineEntry* getLineEntry(unsigned file, unsigned line, unsigned column) {
			return getLineEntry(getAddressFromLineCol(line, column, file));
		}

		bool isDynamic() {
			return mDynamic;
		}
		
		const string &getFilePath(uint32_t index) {
			return mFilePaths[index];
		}
		
		void initLoadAddress() {
			if (isDynamic()) {
				ifstream map("/proc/" + to_string(mPid) + "/maps");
				string line;
				while (getline(map, line)) {
					if (line.ends_with(mPath)) {
						mLoadAddress = stoll(line, 0, 16);
						return;
					}
				}
				throw(DebuggerException("Load address not found"));
			}
		}
		
		// Return true if same line, or if either entry has no line associated with it.
		static bool sameLine(LineEntry *oldLine, LineEntry *newLine) {
			if (oldLine == nullptr || newLine == nullptr) {
				return true;
			}
			if (oldLine->line == newLine->line && oldLine->fileIndex == newLine->fileIndex) {
				return true;
			}
			return false;
		}
		
		// Return true if same column, or if either entry has no line associated with it.
		static bool sameColumn(LineEntry *oldLine, LineEntry *newLine) {
			if (oldLine == nullptr || newLine == nullptr) {
				return true;
			}
			if (oldLine->column == newLine->column && oldLine->line == newLine->line && oldLine->fileIndex == newLine->fileIndex) {
				return true;
			}
			return false;
		}
		
		uint64_t getLineColumnHash(uint32_t line, uint16_t column, uint16_t file) {
				return ((uint64_t)line << 32) | ((uint32_t)column << 16) | file;
		}
	
	
		unsigned getFileFromAddress(intptr_t addr) {
			auto le = getLineEntry(addr);
			
			if (le == nullptr) {
				throw DebuggerException("No file found for current addr: " + to_string(addr));
			}
			
			return le->fileIndex;
		}
		
		unsigned getFileFromName(string name) {
			if (name[0] != '/') {
				name = "/" + name;
			}
			
			for (unsigned i = 0; i < mFilePaths.size(); i++) {
				if (mFilePaths[i].ends_with(name)) {
					return i;
				}
			}
			
			throw DebuggerException("No such file: " + name);
		}

	private:
		
		
		void loadFunctionAddresses(elf::elf e) {
			for (auto &sec : e.sections()) {
				if (sec.get_hdr().type != elf::sht::symtab)
						continue;

				for (auto sym : sec.as_symtab()) {
					const string &name = sym.get_name();
					if (name.starts_with("func_")) {
						intptr_t addr = sym.get_data().value;
						
						mFunctionAddresses[name] = addr;
					}
				}
			}
		}
		
		void loadLineEntries(dwarf::dwarf d) {
			for (auto &cu : d.compilation_units()) {
				auto &lt = cu.get_line_table();
				unsigned maxIndex = 0;
				
				for (auto &lineEntry : lt) {
					unsigned fileIndex = lineEntry.file_index + mFilePaths.size() - 1;
					
					if (lineEntry.file_index > maxIndex) {
						maxIndex = lineEntry.file_index;
					}
					
					mLineEntries[lineEntry.address] = {lineEntry.line, lineEntry.column, fileIndex, lineEntry.prologue_end};
					mLineAddresses[getLineColumnHash(lineEntry.line, lineEntry.column, fileIndex)] = lineEntry.address;
				}
				
				for (unsigned i = 1; i <= maxIndex; i++) {  
					mFilePaths.push_back(lt.get_file(i)->path);
				}
			}
		}
		
		
		// Map from function name to address
		unordered_map<string, intptr_t> mFunctionAddresses;
		// Map from address to function name
		unordered_map<intptr_t, string> mFunctionNames;
		
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