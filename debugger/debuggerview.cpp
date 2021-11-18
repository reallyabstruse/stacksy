#include <curses.h>
#include <panel.h>
#include <unordered_set>
#include <sys/wait.h>
#include <cmath>

#include "debuggerview.hpp"



string getstring() {
	string res;
	
	int ch;
	while ((ch = getch()) != '\n') {
		res.push_back(ch);
	}
	
	return res;
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
	addBreakpoint(mDebugInfo.getFunctionAddr("entry"));
	continueExecution();
	
	mBottomStack = readRegister(X64Register::RSP);

	while(true) {
		printStack();
		printSource(mPc);
		
		string request = getstring();
		
		handleCommand(request);
		

		//linenoiseHistoryAdd(line);
		//linenoiseFree(line);
	}
	
	return 0;
}
		
void DebuggerNcursesView::handleCommand(string line) {
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

int getColorPair(unsigned short foreground, unsigned short background) {
	static unordered_map<unsigned int, int> colors;
	unsigned int key = foreground | (background << 16);
	
	if (!colors.count(key)) {
		colors[key] = COLOR_PAIR(colors.size()+1);
		init_pair(colors.size(), foreground, background);
	}
	return colors[key];
}

DebuggerNcursesView::DebuggerNcursesView(string path, pid_t pid) : StacksyDebugger(path, pid) {
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
}

short DebuggerNcursesView::getWordColor(string word) {
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
		
void DebuggerNcursesView::printStack() {	
	intptr_t p = readRegister(X64Register::RSP);
	
	wclear(mStackWindow);
	
	for  (unsigned row = 1; p <= mBottomStack; ++row) {
		uint64_t val = readMemory(p);
		mvwprintw(mStackWindow, row, 1, "%lx",  val);
		
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
		cerr << (mDebugInfo.getFunctionAddr("entry")-mDebugInfo.mLoadAddress);
		cerr << string("No line info found ") << to_string(addr-mDebugInfo.mLoadAddress);
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
		
		int colorPair;
		
		string lineNum = to_string(curLine+1) + " ";
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
