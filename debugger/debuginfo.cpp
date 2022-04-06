#include <string>
#include <map>
#include <unordered_map>
#include <filesystem>
#include <sys/types.h>
#include <fcntl.h> 
#include <fstream>
#include <unistd.h>
#include <sstream>

#include "debuginfo.hpp"


#include "libelfin-fbreg/dwarf/dwarf++.hh"
#include "libelfin-fbreg/elf/elf++.hh"


DebugInfo::DebugInfo(const string &path, pid_t pid) {
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

intptr_t DebugInfo::getFunctionAddr(const string &name) const {
	auto it = mFunctionAddresses.find(name);
	if (it == mFunctionAddresses.end()) {
		return 0;
	}
	
	return it->second.first + mLoadAddress;
}

intptr_t DebugInfo::getFunctionPrologueEndAddress(const string &name) const {
	auto itFunc = mFunctionAddresses.find(name);
	if (itFunc == mFunctionAddresses.end()) {
		throw DebuggerException("Could not find function " + name);
	}

	auto itLineEntry = mLineEntries.upper_bound(itFunc->second.first);
	if (itLineEntry == mLineEntries.end()) {
		throw DebuggerException("Could not find end of prologue for function " + name);
	}
	if (itLineEntry->first >= itFunc->second.second) {
		throw DebuggerException("No line entries found in function " + name);
	}
	
	return itLineEntry->first + mLoadAddress;
}

intptr_t DebugInfo::getFunctionEndAddress(const string &name) const {
	auto it = mFunctionAddresses.find(name);
	
	if (it == mFunctionAddresses.end()) {
		throw DebuggerException("Trying to find end address of non existent function");
	}
	
	return it->second.second;
}

const string &DebugInfo::getFunctionName(intptr_t addr) const {		
	intptr_t origAddr = addr - mLoadAddress;
	auto it = mFunctionNames.upper_bound(origAddr);
	if (it == mFunctionNames.begin()) {
		throw DebuggerException("No function at addr " +  to_string(origAddr));
	}
	--it;
	
	const string &name = it->second;
	
	if (getFunctionEndAddress(name) <= origAddr) {
		throw DebuggerException("2. No function at addr " +  to_string(origAddr));
	}
	
	return name;
}

bool DebugInfo::isAddressInFunction(intptr_t addr, const string &name) const {
	return getFunctionName(addr) == name;
}

intptr_t DebugInfo::getAddressFromLineCol(uint32_t line, uint16_t column, uint16_t file) const {
	auto it = mLineAddresses.find(getLineColumnHash(line, column, file));
	if (it == mLineAddresses.end()) {
		return 0;
	}
	
	return it->second + mLoadAddress;
}

const LineEntry* DebugInfo::getLineEntry(intptr_t addr) const {
	auto it = mLineEntries.find(addr - mLoadAddress);
	if (it == mLineEntries.end()) {
		return nullptr;
	}
	
	return &it->second;
}	

const LineEntry* DebugInfo::getLineEntry(unsigned file, unsigned line, unsigned column) const {
	return getLineEntry(getAddressFromLineCol(line, column, file));
}

bool DebugInfo::isDynamic() const {
	return mDynamic;
}

const string &DebugInfo::getFilePath(uint32_t index) const {
	return mFilePaths[index];
}

void DebugInfo::initLoadAddress() {
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
bool DebugInfo::sameLine(const LineEntry *oldLine, const LineEntry *newLine) {
	if (newLine == nullptr) {
		return true;
	}
	if (oldLine == nullptr) {
		return false;
	}
	if (oldLine->line == newLine->line && oldLine->fileIndex == newLine->fileIndex) {
		return true;
	}
	return false;
}

// Return true if same column, or if either entry has no line associated with it.
bool DebugInfo::sameColumn(const LineEntry *oldLine, const LineEntry *newLine) {
	if (newLine == nullptr) {
		return true;
	}
	if (oldLine == nullptr) {
		return false;
	}
	if (oldLine->column == newLine->column && oldLine->line == newLine->line && oldLine->fileIndex == newLine->fileIndex) {
		return true;
	}
	return false;
}

uint64_t DebugInfo::getLineColumnHash(uint32_t line, uint16_t column, uint16_t file) {
		return ((uint64_t)line << 32) | ((uint32_t)column << 16) | file;
}

 
unsigned DebugInfo::getFileFromAddress(intptr_t addr) const {
	auto le = getLineEntry(addr);
	
	if (le == nullptr) {
		throw DebuggerException("No file found for current addr: " + to_string(addr));
	}
	
	return le->fileIndex;
}

unsigned DebugInfo::getFileFromName(string name) const {
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

string DebugInfo::lineColToString(unsigned line, unsigned column, unsigned fileIndex) const {
	if (fileIndex >= mFilePaths.size()) {
		throw DebuggerException("Non existant file index");
	}
	stringstream res;
	res << mFilePaths[fileIndex] << " line: " << line << " col: " << column;
	return res.str();
}

void DebugInfo::loadFunctionAddresses(elf::elf e) {
	for (auto &sec : e.sections()) {
		if (sec.get_hdr().type != elf::sht::symtab)
				continue;

		for (auto sym : sec.as_symtab()) {
			const string &name = sym.get_name();
			if (name.starts_with("func_")) {
				intptr_t addr = sym.get_data().value;
				string funcName = name.substr(5);
				
				mFunctionNames[addr] = funcName;
				if (mFunctionAddresses.count(funcName)) {
					throw DebuggerException("Function already defined: " + funcName);
				}
				mFunctionAddresses[funcName] = {addr, 0};
			} else if (name.starts_with("funcend_")) {
				string funcName = name.substr(8);
				intptr_t addr = sym.get_data().value;
				auto it = mFunctionAddresses.find(funcName);
				if (it == mFunctionAddresses.end()) {
					throw DebuggerException("Function not defined before " + funcName);
				}
				mFunctionAddresses[funcName].second = addr;
			}
		}
	}
	
	for (auto &[name, addrs] : mFunctionAddresses) {
		if (addrs.second == 0) {
			throw DebuggerException("Function end not defined for " + name);
		}
	}
}

void DebugInfo::loadLineEntries(dwarf::dwarf d) {
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
