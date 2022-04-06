#include <string>
#include <panel.h>
#include <vector>
#include <sstream>
#include <unordered_map>

#include "ncursesHelpers.hpp"
#include "debuginfo.hpp"

using namespace std;

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


string getStringFromWindow(WINDOW *win) {
	char buffer[COLS+1];
	
	auto size = mvwinnstr(win, 0, 0, buffer, COLS);
	if (size == ERR) {
		throw DebuggerException("Error retreiving data from input window");
	}

	auto end = &*find_if_not(make_reverse_iterator(buffer+size-1), make_reverse_iterator(buffer-1), [](unsigned char ch) {
        return isspace(ch);
    }) + 1;
	
	if (end <= 0) {
		return "";
	}
	
	return string(buffer, end);
}
