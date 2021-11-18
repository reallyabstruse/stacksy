#include <curses.h>

#include "debugger.hpp"


enum ColorPairs {
	CurLine = 1, CurCol
};

int getColorPair(unsigned short foreground, unsigned short background);

class DebuggerNcursesView : StacksyDebugger {
	public:
		DebuggerNcursesView(string path, pid_t pid);
		
		int run();
		
		void handleCommand(string line);
	
		short getWordColor(string word);
		
		void printStack();
		
		void printSource(uint64_t addr);

	
	private:
		int mHighlightColor;
		
		WINDOW * mSrcWindow;
		WINDOW * mStackWindow;
		WINDOW * mOutputWindow;
		
};
