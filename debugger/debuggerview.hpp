#include <curses.h>
#include <ext/stdio_filebuf.h>

#include "debugger.hpp"
#include "debugeepipe.hpp"

// For ctrl+keyconstant
#define ctrl(x)           ((x) & 0x1f)

enum ColorPairs {
	CurLine = 1, CurCol
};

int getColorPair(unsigned short foreground, unsigned short background);

class DebuggerNcursesView : StacksyDebugger {
	public:
		DebuggerNcursesView(string path, pid_t pid, DebugeePipe &dPipe);
		
		int run();
		
		void updateWindows();
		
		void handleCommand(string line);
	
		short getWordColor(string word, unsigned column);
		
		bool probableString(uint64_t val, uint64_t nextVal);
		string inspectVariable(intptr_t p);

		void outputError(string err) override;
		
		void outputMessage(string msg, int color = 0) override;

	protected:
		int waitForDebugee() override;

	
	private:
		void printStack();
		void printSource(uint64_t addr);
		void printOutput();
		
		string getInputString(bool block = true);
		
		int mHighlightColor;
		
		WINDOW * mSrcWindow;
		WINDOW * mStackWindow;
		WINDOW * mOutputWindow;
		WINDOW * mInputWindow;
		
		DebugeePipe &mDebugeePipe;
		
		// Text to display in output panel
		vector<pair<string, int>> mOutput;
		
		
};
