#include <curses.h>
#include <ext/stdio_filebuf.h>

#include "debugger.hpp"
#include "debugeepipe.hpp"

enum ColorPairs {
	CurLine = 1, CurCol
};

int getColorPair(unsigned short foreground, unsigned short background);

class DebuggerNcursesView : StacksyDebugger {
	public:
		DebuggerNcursesView(string path, pid_t pid, DebugeePipe &dPipe);
		
		int run();
		
		void handleCommand(string line);
	
		short getWordColor(string word);
		
		bool probableString(uint64_t val, uint64_t nextVal);
		string inspectVariable(intptr_t p);

		void outputError(string err) override;
		
		void outputMessage(string msg) override;

	protected:
		int waitForDebugee() override;

	
	private:
		void printStack();
		void printSource(uint64_t addr);
		void printOutput();
		
		string getInputString();
		string getInputStringNonBlock();
	
		int mHighlightColor;
		
		WINDOW * mSrcWindow;
		WINDOW * mStackWindow;
		WINDOW * mOutputWindow;
		WINDOW * mInputWindow;
		
		DebugeePipe &mDebugeePipe;
		
		// Text to display in output panel
		vector<string> mOutput;
		
		
};
