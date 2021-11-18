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
#include <curses.h>
#include <panel.h>
#include <cmath>

#include "libelfin-fbreg/dwarf/dwarf++.hh"
#include "libelfin-fbreg/elf/elf++.hh"

#include "linenoise/linenoise.h"

#define QWORD_SIZE 8

using namespace std;

string getstring() {
	string res;
	
	int ch;
	while ((ch = getch()) != '\n') {
		res.push_back(ch);
	}
	
	return res;
}

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

enum ColorPairs {
	CurLine = 1, CurCol
};

int getColorPair(unsigned short foreground, unsigned short background) {
	static unordered_map<unsigned int, int> colors;
	unsigned int key = foreground | (background << 16);
	
	if (!colors.count(key)) {
		colors[key] = COLOR_PAIR(colors.size()+1);
		init_pair(colors.size(), foreground, background);
	}
	return colors[key];
}

class StacksyDebugger {
	public:
		StacksyDebugger(string path, pid_t pid) {
			initscr();
		    //cbreak();
		    //noecho();
	
		    clear();

			PANEL  *my_panels[3];

			initscr();
			cbreak();
			noecho();

			auto outputHeight = 5;

			/* Create windows for the panels */
			mSrcWindow =   newwin(LINES-1-outputHeight, COLS / 2, 0, 0);
			mStackWindow = newwin(LINES-1-outputHeight, COLS / 2, 0, COLS / 2);
			mOutputWindow = newwin(outputHeight, 0, LINES-1-outputHeight, 0);

			/* Attach a panel to each window */ 	/* Order is bottom up */
			my_panels[0] = new_panel(mSrcWindow); 	/* Push 0, order: stdscr-0 */
			my_panels[1] = new_panel(mStackWindow); 	/* Push 1, order: stdscr-0-1 */
			my_panels[2] = new_panel(mOutputWindow); 	/* Push 1, order: stdscr-0-1 */
			
			box(mOutputWindow, 0, 0);
			
			if (has_colors()) {
				start_color();
				mHighlightColor = getColorPair(COLOR_BLACK, COLOR_CYAN);
			}
   
			
			filesystem::path relPath = path;
			mLoadAddress = 0;
			mRunning = false;
			
			mPath = filesystem::absolute(relPath).string();
			mPid = pid;
			
			auto fp = open(path.c_str(), O_RDONLY);
			mElf = elf::elf{elf::create_mmap_loader(fp)};
			mDwarf = dwarf::dwarf{dwarf::elf::create_loader(mElf)};
			
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
			getRegisters();
			addBreakpoint(getFunctionAddress("func_entry"));
			continueExecution();
			
			mBottomStack = readRegister(X64Register::RSP);

			while(true) {
				printStack();
				printSource(readRegister(X64Register::RIP));
				
				string request = getstring();
				
				handleCommand(request);
				

				//linenoiseHistoryAdd(line);
				//linenoiseFree(line);
			}
			endwin();
			return 0;
		}
		
		void handleCommand(string line) {
			if (mRunning) {
				
				if (line[0] == 'c') {
					continueExecution();
				} else if (line == "sc") {
					stepColumn();
				} else if (line == "sl") {
					stepLine();
				} else if (line == "so") {
					stepOut();
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
		
		void removeBreakpoint(intptr_t addr) {
			auto it = mBreakpoints.find(addr);
			if (it != mBreakpoints.end()) {
				it->second.disable();
			}
		}
		
		bool hasBreakpoint(intptr_t addr) {
			auto it = mBreakpoints.find(addr);
			return it != mBreakpoints.end() && it->second.isEnabled();
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
			if (!stepOverBreakpoint()) {
				if (ptrace(PTRACE_SINGLESTEP, mPid, nullptr, nullptr) == -1) {
					cerr << strerror(errno);
					throw(DebuggerException("Couldn't step"));
				}
				
				wait();
			}
		}
		
		bool stepOverBreakpoint() {
			auto prev_rip = readRegister(X64Register::RIP) - 1;
			
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
		
		void loadFunctionAddresses() {
			for (auto &sec : mElf.sections()) {
                if (sec.get_hdr().type != elf::sht::symtab)
                        continue;

                for (auto sym : sec.as_symtab()) {
					const string &name = sym.get_name();
					if (name.starts_with("func_")) {
						intptr_t addr = sym.get_data().value;
						
						mFunctions[name] = addr;
					}
                }
			}
		}
		uint64_t offsetLoadAddr(intptr_t addr) {
			return addr - mLoadAddress;
		}
		
		dwarf::line_table::entry getLineEntryFromAddr(uint64_t addr) {
			addr = offsetLoadAddr(addr);

			for (auto &cu : mDwarf.compilation_units()) {
				if (die_pc_range(cu.root()).contains(addr)) {
					auto &lt = cu.get_line_table();
					auto it = lt.find_address(addr);
					
					if (it == lt.end()) {
						throw DebuggerException("Could not find line entry");
					}
					return *it;
				}
			}
			throw DebuggerException("Could not find compilation unit and line entry");
		}
		
		
		void stepOut() {
			intptr_t returnAddress = readRegister(X64Register::R12) - 8;
			if (!hasBreakpoint(returnAddress)) {
				addBreakpoint(returnAddress);
				continueExecution();
				removeBreakpoint(returnAddress);
			} else {
				continueExecution();
			}
		}
		
		void stepColumn() {
			dwarf::line_table::entry line_info = getLineEntryFromAddr(readRegister(X64Register::RIP)), new_line_info;
			do {
				stepX64Instruction();
				new_line_info = getLineEntryFromAddr(readRegister(X64Register::RIP));
			} while (new_line_info.column == line_info.column && new_line_info.line == line_info.line && new_line_info.file_index == line_info.file_index);
		}
		
		void stepLine() {
			dwarf::line_table::entry line_info = getLineEntryFromAddr(readRegister(X64Register::RIP)), new_line_info;
			do {
				stepX64Instruction();
				new_line_info = getLineEntryFromAddr(readRegister(X64Register::RIP));
			} while (new_line_info.line == line_info.line && new_line_info.file_index == line_info.file_index);
		}
		
		
		const vector<vector<string>> &getSource(string path) {
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
		
		short getWordColor(string word) {
			if (word.empty()) {
				return COLOR_WHITE;
			}
			
			const unordered_set<string> keywords( {"while", "do", "elihw", "if", "fi"} );
			
			if (word[0] == '#') {
				return COLOR_GREEN;
			}
			if (word[0] == '@') {
				return COLOR_BLUE;
			}
			if (word[0] == '\'') {
				return COLOR_YELLOW;
			}
			if (word[0] == '"') {
				return COLOR_YELLOW;
			}
			if (isdigit(word[0]) || (word[0] == '-' && word.length() > 1 && isdigit(word[1]))) {
				return COLOR_YELLOW;
			}
			if (keywords.count(word)) {
				return COLOR_BLUE;
			}
			return COLOR_WHITE;
		}
		
		void printStack() {	
			intptr_t p = readRegister(X64Register::RSP);
			
			wclear(mStackWindow);
			
			for  (unsigned row = 1; p <= mBottomStack; ++row) {
				uint64_t val = readMemory(p);
				mvwprintw(mStackWindow, row, 1, "%lx",  val);
				
				p += QWORD_SIZE;
			}
			
			box(mStackWindow, 0, 0);
		}
		
		void printSource(uint64_t addr) {
			int height, width;

			getmaxyx(mSrcWindow, height, width);
			height -= 2;
			width -= 2;
			
			auto line_info = getLineEntryFromAddr(addr);

			const auto &source = getSource(line_info.file->path);
			unsigned int line = line_info.line - 1;
			unsigned int column = line_info.column - 1;
			
			unsigned int size = (height - 1) / 2;
			
			unsigned int firstLine = line > size ? line - size : 0;
			unsigned int lastLine = min(line + size, (unsigned)source.size()-1);
			
			unsigned int lineNumWidth = lastLine ? log10(lastLine) + 1 : 1;

			wclear(mSrcWindow);
			
			for (unsigned curLine = 0; curLine <= lastLine; curLine++) {
				bool isCurLine = curLine == line;
				auto screenLine = curLine-firstLine; 
				unsigned screenCol = 1;
				
				int colorPair;
				
				string lineNum = to_string(curLine) + " ";
				mvwaddstr(mSrcWindow, screenLine, screenCol + lineNumWidth - lineNum.length() + 1, lineNum.c_str());
				
				screenCol += lineNumWidth + 1;
				
				if (isCurLine) {
					colorPair = getColorPair(COLOR_BLACK, COLOR_CYAN);
					wattron(mSrcWindow, colorPair);
				}
				
				if (curLine == line) {
					if (!has_colors()) {
						mvwaddstr(mSrcWindow, screenLine, screenCol, "> ");
						screenCol += 2;
					}
				}
				else {
					if (!has_colors()) {
						mvwaddstr(mSrcWindow, screenLine, screenCol, "  ");
						screenCol += 2;
					}
				}
				
				
				for (unsigned i = 0; i < source[curLine].size(); i++) {
					bool isCurCol = i % 2 && curLine == line && i / 2 == column;
					
					short foreground, background;
					
					if (!isCurLine) {
						colorPair = getColorPair(getWordColor(source[curLine][i]), COLOR_BLACK);
						wattron(mSrcWindow, colorPair);
					}

					if (isCurCol) {
						wattron(mSrcWindow, A_STANDOUT);
					}
					mvwaddstr(mSrcWindow, screenLine, screenCol, source[curLine][i].c_str());
					screenCol += source[curLine][i].length();
					
					if (isCurCol) {
						wattroff(mSrcWindow, A_STANDOUT);
					}
					if (!isCurLine) {
						wattroff(mSrcWindow, colorPair);
					}
				}
				
				if (isCurLine) {
					if (width > screenCol) {
						mvwaddstr(mSrcWindow, screenLine, screenCol, string(width - screenCol, ' ').c_str());
					}
					wattroff(mSrcWindow, colorPair);
				}
			}
			
			box(mSrcWindow, 0, 0);
			
			update_panels();
			doupdate();
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
		
		intptr_t mBottomStack;
		
		int mHighlightColor;
		
		unordered_map<string, vector<vector<string>>> mSources;
		
		WINDOW * mSrcWindow;
		WINDOW * mStackWindow;
		WINDOW * mOutputWindow;
		
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
		StacksyDebugger sd(path, pid);
		try {
			return sd.run();
		} catch (DebuggerException &de) {
			cerr << de.what() << endl;
			return -1;
		} catch(...) {
			cerr << "other err" << endl;
			return -1;
		}
	}
}