#include <curses.h>
#include <panel.h>
#include <unordered_set>
#include <sys/wait.h>
#include <cmath>
#include <ext/stdio_filebuf.h>

#include "debuggerview.hpp"


void relMoveCursor(WINDOW *win, int rely, int relx) {
	int x, y;
	getyx(win, y, x);
	wmove(win, y + rely, x + relx);
}

vector<string> split(const string& s)
{
    stringstream ss(s);
    vector<string> words;
    for (string w; ss>>w; ) words.push_back(w);
    return words;
}


string DebuggerNcursesView::getInputString() {
	string res;
	
	int ch;
	while ((ch = wgetch(mInputWindow)) != '\n') {
		res.push_back(ch);
		
		switch (ch) {
			case KEY_BACKSPACE:
			case 127:
			case 8: // ctrl+h
				relMoveCursor(mInputWindow, 0, -1);
				// fall through
			case KEY_DC: 
				wdelch(mInputWindow);
				break;
				
			case KEY_LEFT:
				relMoveCursor(mInputWindow, 0, -1);
				break;
			case KEY_RIGHT:
				relMoveCursor(mInputWindow, 0, 1);
				break;
				
			case KEY_UP:
			case KEY_DOWN:
				break;
				
			default:
				waddch(mInputWindow, ch);
		}
	}
	
	wclear(mInputWindow);
	
	
	
	return res;
}

string DebuggerNcursesView::getInputStringNonBlock() {
	static string res;
	
	nodelay(mInputWindow, true);
	int ch = wgetch(mInputWindow);
	nodelay(mInputWindow, false);
	
	if (ch == ERR) {
		return "";
	}
	
	res.push_back(ch);
	
	if (ch == '\n') {
		wclear(mInputWindow);
		string ret(res);
		res = "";
		return ret;
	}
	
	mvwaddstr(mInputWindow, 0, 0, res.c_str());
	
	return "";
}


DebuggerNcursesView::DebuggerNcursesView(string path, pid_t pid, DebugeePipe &dPipe) : StacksyDebugger(path, pid), mDebugeePipe(dPipe) {

	PANEL  *my_panels[4];
	
	clear();
	initscr();
	
	
	cbreak();
	noecho();

	auto outputHeight = 10;

	/* Create windows for the panels */
	mSrcWindow =   newwin(LINES-1-outputHeight, COLS / 2, 0, 0);
	mStackWindow = newwin(LINES-1-outputHeight, COLS / 2, 0, COLS / 2);
	mOutputWindow = newwin(outputHeight, COLS, LINES-1-outputHeight, 0);
	mInputWindow = newwin(1, COLS, LINES-1, 0);

	keypad(mInputWindow, true);

	/* Attach a panel to each window */
	my_panels[0] = new_panel(mSrcWindow);
	my_panels[1] = new_panel(mStackWindow);
	my_panels[2] = new_panel(mOutputWindow);
	my_panels[3] = new_panel(mInputWindow);

	if (has_colors()) {
		start_color();
		mHighlightColor = getColorPair(COLOR_BLACK, COLOR_CYAN);
	} 
}

int DebuggerNcursesView::run() {
	int status;
	if (waitpid(mPid, &status, 0) == -1 || __WIFEXITED(status)) {
		cerr << "Could not start child process \n";
		return -1;
	}
	
	mRunning = true;
	
	mDebugInfo.initLoadAddress();
	getRegisters();
	
	auto entryAddr = mDebugInfo.getFunctionPrologueEndAddress("entry");
	addBreakpoint(entryAddr);
	continueExecution();
	
	removeBreakpoint(entryAddr);
	
	mBottomStack = readRegister(X64Register::RSP);

	while(true) {
		
		printStack();
		printSource(mPc);
		printOutput();
		
		update_panels();
		doupdate();
		
		
		
		string request = getInputString();
		
		try {
			handleCommand(request);
		} catch(DebuggerException e) {
			outputError(e.what());
		}
		

		//linenoiseHistoryAdd(line);
		//linenoiseFree(line);
	}
	
	return 0;
}
		
void DebuggerNcursesView::handleCommand(string line) {
	auto arr = split(line);
	
	if (mRunning) {
		if (arr[0] == "c") {
			continueExecution();
		} else if (arr[0] == "sc") {
			stepColumn();
		} else if (arr[0] == "sl") {
			stepLine();
		} else if (arr[0] == "so") {
			stepOut();
		} else if (arr[0] == "b") {
			if (arr.size() >= 2) {
				
				if (!isdigit(arr[1][0])) {
					addBreakpoint(mDebugInfo.getFunctionPrologueEndAddress(arr[1]));
					return;
				} else {
					long lineNum = strtol(arr[1].c_str(), NULL, 0);
					long columnNum = 1;
					if (arr.size() > 2) {
						columnNum = strtol(arr[2].c_str(), NULL, 0);
					}
					
					if (lineNum > 0 && columnNum > 0) {
						long fileNum = arr.size() > 3 ? mDebugInfo.getFileFromName(arr[3]) : mDebugInfo.getFileFromAddress(getPc());
						addBreakpoint(lineNum, columnNum, fileNum);
						return;
					}
				}
			}
			
			outputError("Invalid break command usage: b function or b line [columm] [filename]");
		}
	}
}

int getColorPair(unsigned short foreground, unsigned short background) {
	static unordered_map<unsigned int, int> colors;
	unsigned int key = foreground | (background << 16);
	
	if (!colors.count(key)) {
		colors[key] = COLOR_PAIR(colors.size()+1);
		init_pair(colors.size(), foreground, background);
	}
	return colors[key];
}

void mvwaddstr_wattr(int attr, WINDOW *win, int y, int x, const char *str) {
	wattron(win, attr);
	mvwaddstr(win, y, x, str);
	wattroff(win, attr);
}

void DebuggerNcursesView::outputError(string err) {
	outputMessage(err);
}
		
void DebuggerNcursesView::outputMessage(string msg) {
	mOutput.push_back(msg);
}

short DebuggerNcursesView::getWordColor(string word) {
	if (word.empty()) {
		return COLOR_WHITE;
	}
	
	const unordered_set<string> keywords( {"while", "do", "elihw", "if", "fi"} );
	
	switch(word[0]) {
		case '#':
			return COLOR_GREEN;
		case '@':
			return COLOR_BLUE;
		case '\'':
		case '"':
		case '$':
			return COLOR_YELLOW;
		default:
			if (isdigit(word[0]) || (word[0] == '-' && word.length() > 1 && isdigit(word[1]))) {
				return COLOR_YELLOW;
			}
			if (keywords.count(word)) {
				return COLOR_BLUE;
			}
	}

	return COLOR_WHITE;
}

void DebuggerNcursesView::printOutput() {	
	int height, width;

	getmaxyx(mSrcWindow, height, width);

	wclear(mOutputWindow);
	
	auto start = max(0, (int)mOutput.size() - height);
	auto end = min((int)mOutput.size(), start + height);
	
	
	for  (unsigned row = start; row < end; ++row) {
		mvwaddstr(mOutputWindow, row-start, 0, mOutput[row].c_str());
	}
}
		
bool DebuggerNcursesView::probableString(uint64_t val, uint64_t nextVal) {
	if (val > 1000 || val < 1) {
		return false;
	}
	
	unsigned loopAmt = min(QWORD_SIZE, (int)val);
	for (unsigned i = 0; i < loopAmt; i++) {
		unsigned char byte = (nextVal >> (8*i)) & 0xFF;
		if (byte >= 0x7F) {
			return false;
		}
		if (byte == 0 && i == loopAmt-1) {
			return true;
		}
		if (byte < 0x20 && byte != '\r' && byte != '\n' && byte != '\t') {
			return false;
		}			
	}
	return true;
}
		
string DebuggerNcursesView::inspectVariable(intptr_t p) {
	uint64_t val = readMemory(p);
	
	auto content = tryReadMemory(val);
	
	stringstream res;
	res << hex << val;
	
	// Pointer?
	if (!errno) {
		uint64_t nextVal = tryReadMemory(val+QWORD_SIZE);
		// Can access next val in memory
		if (!errno && probableString(content, nextVal)) {
			res << " = str(" << content << "): ";
		} else {
			res << " ptr: " << content;
		}
	}
	
	return res.str();
}
		
void DebuggerNcursesView::printStack() {	
	intptr_t p = readRegister(X64Register::RSP);
	
	wclear(mStackWindow);
	
	for  (unsigned row = 1; p < mBottomStack; ++row) {
		
		mvwaddstr(mStackWindow, row, 1, inspectVariable(p).c_str());
		
		p += QWORD_SIZE;
	}
	
	box(mStackWindow, 0, 0);
}

void DebuggerNcursesView::printSource(uint64_t addr) {
	int height, width;

	getmaxyx(mSrcWindow, height, width);
	height -= 2;
	width -= 2;
	
	auto lineEntry = mDebugInfo.getLineEntry(addr);
	
	if (lineEntry == nullptr) {
		cerr << "No line info found at addr: " << to_string(addr);
		return;
	}

	const auto &source = getSource(mDebugInfo.getFilePath(lineEntry->fileIndex));
	unsigned int line = lineEntry->line - 1;
	unsigned int column = lineEntry->column - 1;
	
	unsigned int size = (height - 1) / 2;
	
	unsigned int firstLine = line > size ? line - size : 0;
	unsigned int lastLine = min(line + size, (unsigned)source.size()-1);
	
	unsigned int lineNumWidth = lastLine ? log10(lastLine+1) + 1 : 1;

	wclear(mSrcWindow);
	
	for (unsigned curLine = firstLine; curLine <= lastLine; curLine++) {
		bool isCurLine = curLine == line;
		auto screenLine = curLine-firstLine+1; 
		unsigned screenCol = 1;
		
		int colorPair = 0;
		
		string lineNum = to_string(curLine+1) + " ";
		if (hasBreakpoint(lineEntry->fileIndex, curLine+1)) {
			colorPair = getColorPair(COLOR_WHITE, COLOR_RED);
		}
		mvwaddstr_wattr(colorPair, mSrcWindow, screenLine, screenCol + lineNumWidth - lineNum.length() + 1, lineNum.c_str());
		
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
			int attr = 0;
			if (!isCurLine) {
				attr |= getColorPair(getWordColor(source[curLine][i]), COLOR_BLACK);
			}

			if (isCurCol) {
				attr |= A_STANDOUT;
			}
			mvwaddstr_wattr(attr, mSrcWindow, screenLine, screenCol, source[curLine][i].c_str());
			
			screenCol += source[curLine][i].length();
		}
		
		if (isCurLine) {
			if (width > screenCol) {
				mvwaddstr(mSrcWindow, screenLine, screenCol, string(width - screenCol, ' ').c_str());
			}
			wattroff(mSrcWindow, colorPair);
		}
	}
	
	box(mSrcWindow, 0, 0);
}

int DebuggerNcursesView::waitForDebugee() {

	int res;
	int status;
	do {
		usleep(10000);
		res = waitpid(mPid, &status, WNOHANG);
		
		// Send stdin to debugee
		string str = getInputStringNonBlock();
		if (!str.empty()) {
			mDebugeePipe.sendString(str);
		}
		
		// Get stdout from debugee
		string s = mDebugeePipe.getLine();
		
		if (!s.empty()) {
			outputMessage(s);
			
			printOutput();
			update_panels();
			doupdate();
		}
		
		if (res == -1) {
			cerr << "Error continuing\n";
			break;
		}
	} while (res == 0);

	return status;
}