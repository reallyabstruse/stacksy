// 
//
// Based on: https://gist.github.com/konstantint/d49ab683b978b3d74172 Example of communication with a subprocess via stdin/stdout
// Author: Konstantin Tretyakov
// License: MIT
//

#pragma once

class cpipe {
	private:
		int fd[2];
	public:
		const inline int read_fd() const { return fd[0]; }
		const inline int write_fd() const { return fd[1]; }
		cpipe(bool block) { 
			if (pipe2(fd, block ? 0 : O_NONBLOCK)) 
				throw std::runtime_error("Failed to create pipe"); 
		}
		void close() { ::close(fd[0]); ::close(fd[1]); }
		~cpipe() { close(); }
};

class DebugeePipe {
	public:
		DebugeePipe() : mStdin(NULL), mStdout(NULL), readPipe(false), writePipe(true) {}
		
		void childInit() {
			while (dup2(writePipe.read_fd(), STDIN_FILENO) == -1) {
				if (errno != EINTR) {
					throw DebuggerException("Could not dup pipe for stdin");
				}
			}
			
			while (dup2(readPipe.write_fd(), STDOUT_FILENO) == -1) {
				if (errno != EINTR) {
					throw DebuggerException("Could not dup pipe for stdout");
				}
			}
			
			writePipe.close();
			readPipe.close();
		}
		
		void parentInit() {
			close(writePipe.read_fd());
            close(readPipe.write_fd());
			
			mWriteBuf = std::unique_ptr<__gnu_cxx::stdio_filebuf<char> >(new __gnu_cxx::stdio_filebuf<char>(writePipe.write_fd(), std::ios::out));
			mReadBuf = std::unique_ptr<__gnu_cxx::stdio_filebuf<char> >(new __gnu_cxx::stdio_filebuf<char>(readPipe.read_fd(), std::ios::in));
			mStdout.rdbuf(mReadBuf.get());
			mStdin.rdbuf(mWriteBuf.get());
		}
		
		string getLine() {
			string s;
			mStdout.clear();
			getline(mStdout, s);
			return s;
		}
		
		void sendString(string str) {
			mStdin << str;
			mStdin.flush();
		}
		

	private:
		cpipe writePipe;
		cpipe readPipe;
		
		
		std::unique_ptr<__gnu_cxx::stdio_filebuf<char> > mReadBuf;
		std::unique_ptr<__gnu_cxx::stdio_filebuf<char> > mWriteBuf;
	
	
		std::ostream mStdin;
		std::istream mStdout;
};