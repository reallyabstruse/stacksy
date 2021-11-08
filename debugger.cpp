#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/ptrace.h>

using namespace std;

int main(int argc, char *argv[]) {
	if (argc < 2) {
		throw "No file specified";
	}
	
	char *path = argv[1];
	
	auto pid = fork();
	
	if (pid == 0) {
		 ptrace(PTRACE_TRACEME, 0, nullptr, nullptr);
	     execl(path, path, nullptr);
		 cout << "child";
	} else {
		cout << "parent";
	}
}