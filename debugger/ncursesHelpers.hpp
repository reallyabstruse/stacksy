#pragma once

#include <string>
#include <panel.h>
#include <vector>

using namespace std;

void relMoveCursor(WINDOW *win, int rely, int relx);
vector<string> split(const string& s);
int getColorPair(unsigned short foreground, unsigned short background);
void mvwaddstr_wattr(int attr, WINDOW *win, int y, int x, const char *str);
string getStringFromWindow(WINDOW *win);