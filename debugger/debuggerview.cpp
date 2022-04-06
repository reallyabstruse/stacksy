#include <curses.h>
#include <panel.h>
#include <unordered_set>
#include <sys/wait.h>
#include <cmath>
#include <ext/stdio_filebuf.h>
#include <sstream>

#include "debuggerview.hpp"
#include "ncursesHelpers.hpp"

string DebuggerNcursesView::getInputString(bool block/* = true*/) {
	nodelay(mInputWindow, !block);

	while (true) {
		int ch = wgetch(mInputWindow);
		
		switch (ch) {
			case '\n':
			{
				string res = getStringFromWindow(mInputWindow);
				if (res.empty() && block) {
					continue;
				}
				
				wclear(mInputWindow);
				return res;
			}
			case KEY_BACKSPACE:
			case 127:
			case 8: // ctrl+h
				relMoveCursor(mInputWindow, 0, -1);
				// fall through
			case KEY_DC: // DEL
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
			case ERR:
				if (!block) {
					return "";
				}
				throw DebuggerException("Error reading from stdin");
				
			case ctrl(KEY_UP):
				outputMessage("YO");
				break;
			
			case KEY_RESIZE:
			{
				auto outputHeight = 10;
				mvwin(mStackWindow, 0, COLS / 2);
				mvwin(mOutputWindow, LINES-1-outputHeight, 0);
				mvwin(mInputWindow, LINES-1, 0);
				
				wresize(mSrcWindow, LINES-1-outputHeight, COLS / 2);
				wresize(mStackWindow, LINES-1-outputHeight, COLS / 2);
				wresize(mOutputWindow, outputHeight, COLS);
				wresize(mInputWindow, 1, COLS);
				
				updateWindows();
				break;
			}
				
			default:
				waddch(mInputWindow, ch);
		}
	}
		
	// Never reached
	
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

void DebuggerNcursesView::updateWindows() {
	printStack();
	printSource(mPc);
	printOutput();
	
	update_panels();
	doupdate();
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
		
		updateWindows();

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
		if (arr[0] == "continue" || arr[0] == "cont" || arr[0] == "c") {
			continueExecution();
		} else if (arr[0] == "run" || arr[0] == "r") {
			;
		} else if (arr[0] == "stepc" || arr[0] == "sc") {
			step(true);
		} else if (arr[0] == "step" || arr[0] == "s") {
			step();
		} else if (arr[0] == "next" || arr[0] == "n") {
			stepOver();
		} else if (arr[0] == "nextc" || arr[0] == "nc") {
			stepOver(true);
		} else if (arr[0] == "finish" || arr[0] == "fin") {
			stepOut();
		} else if (arr[0] == "break" || arr[0] == "b") {
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

void DebuggerNcursesView::outputError(string err) {
	outputMessage(err, getColorPair(COLOR_RED, COLOR_BLACK));
}
		
void DebuggerNcursesView::outputMessage(string msg, int color/* = 0*/) {
	istringstream st(msg);
	string line;
	while (getline(st, line)) {
		if (!line.empty()) {
			mOutput.push_back({line, color});
		}
	}
}

short DebuggerNcursesView::getWordColor(string word, unsigned column) {	
	static bool inComment = false;
	
	if (column == 0) {
		inComment = false;
	} else if (inComment) {
		return COLOR_MAGENTA;
	}
	
	if (word.empty()) {
		return COLOR_WHITE;
	}
	
	const unordered_set<string> keywords( {"while", "do", "elihw", "if", "fi"} );
	
	switch(word[0]) {
		case ';':
			inComment = true;
			return COLOR_MAGENTA;
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

	getmaxyx(mOutputWindow, height, width);

	wclear(mOutputWindow);
	
	
	long end = mOutput.size();
	long start = max(0L, end - height);
	
	for  (unsigned row = start; row < end; ++row) {
		mvwaddstr_wattr(mOutput[row].second, mOutputWindow, row-start, 0, mOutput[row].first.c_str());
	}
}
		
bool DebuggerNcursesView::probableString(uint64_t val, uint64_t nextVal) {
	if (val > 10000 || val < 1) {
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
	int64_t val = readMemory(p);
	
	auto content = tryReadMemory(val);
	
	stringstream res;
	
	if (val > 9) {
		res << hex << showbase << val;
	} else {
		res << dec << val;
	}
	
	// Pointer?
	if (!errno) {
		uint64_t nextVal = tryReadMemory(val+QWORD_SIZE);
		// Can access next val in memory
		if (!errno && probableString(content, nextVal)) {
			res << " = str(" << dec << content << "): " << readMemoryString(val+QWORD_SIZE, min(50UL, content));
		} else {
			res << " ptr: " << showbase << hex << content;
		}
	}
	
	return res.str();
}
		
void DebuggerNcursesView::printStack() {		
	wclear(mStackWindow);
	
	box(mStackWindow, 0, 0);
	
	if (!mRunning) {
		return;
	}
	
	intptr_t p = readRegister(X64Register::RSP);
	
	for  (unsigned row = 1; p < mBottomStack; ++row) {
		
		mvwaddstr(mStackWindow, row, 1, inspectVariable(p).c_str());
		
		p += QWORD_SIZE;
	}
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
	int line = lineEntry->line - 1;
	int column = lineEntry->column - 1;
	
	int firstLine = max(line - (height - 1) / 2, 0);
	int lastLine = min(firstLine + height, (int)source.size()-1);
	
	if (lastLine - firstLine < height) {
		firstLine = max(0, lastLine - height);
	}
	
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
				attr |= getColorPair(getWordColor(source[curLine][i], i), COLOR_BLACK);
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
		
		// Send stdin to debugee when press enter
		string str = getInputString(false);
		if (!str.empty()) {
			mDebugeePipe.sendString(str);
		}
		
		// Get stdout from debugee
		string s;
		bool gotNewOutput = false;
		while (!(s = mDebugeePipe.getLine()).empty()) {
			gotNewOutput = true;
			outputMessage(s);
		}
		
		if (gotNewOutput) {
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