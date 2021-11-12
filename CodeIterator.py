# -*- coding: utf-8 -*-
"""
Created on Sun Nov  7 11:07:26 2021

@author: Sindre
"""

class CodeException(Exception):
    def __init__(self, pString, pIterator):
        super().__init__(f"{pString} at {pIterator}")

class CodeIterator:
    def __init__(self, path):
        # path to all currently opened files, most recently imported last
        self.paths = []
        # current line number of respective open files
        self.line_nums = []
        # current operator number of current line in respective files
        self.op_nums = []
        # strings containing current line of respective files
        self.lines = []
        # file objects for all currently opened files
        self.files = []
        # indices in current line of respective files
        self.line_indices = []
        # Stores all imported paths as key and value is number of that file starting at 1 for first file
        # used to ensure non-duplicate imports and provide file num for debug info
        self.all_imported_paths = {}
        
        self.add_import(path)
        
        
    def get_file_num(self):
        return self.all_imported_paths[self.paths[-1]]
            
    def add_import(self, path):
        if path in self.all_imported_paths:
            print(path, "already imported")
            return
        
        self.all_imported_paths[path] = len(self.all_imported_paths) + 1
        
        self.paths.append(path)
        self.line_nums.append(0)
        self.op_nums.append(0)
        self.lines.append([])
        self.line_indices.append(0)
        try:
            self.files.append(open(path, "r"))
        except Exception as e:
            raise CodeException(str(e), self)
         
    def read_string_character(self, end):
        c = self.lines[-1][self.line_indices[-1]]
        self.line_indices[-1] += 1
    
        if c == "\\":
            c = self.lines[-1][self.line_indices[-1]]
            self.line_indices[-1] += 1
            if c == "n":
                return "\n"
            elif c == "t":
                return "\t"
            elif c == "r":
                return "\r"
            #octal numbers
            elif 0x30 <= ord(c) <= 0x37: # '0' <= c <= '7'
                digits = c
                for j in range(2):
                    c = self.lines[-1][self.line_indices[-1]]
                    if not(0x30 <= ord(c) <= 0x37): # '0' <= c <= '7'
                        break
                    digits += c
                    self.line_indices[-1] += 1
                    
                return chr(int(digits, 8))
                    
            else:
                return c
        else:
            if c == end:
                return ""
            return c
         
    def get_next_op(self):
        N = len(self.lines[-1])
        res = ""

        while self.line_indices[-1] < N and self.lines[-1][self.line_indices[-1]].isspace():
            self.line_indices[-1] += 1
           
        if self.line_indices[-1] < N:
            if self.lines[-1][self.line_indices[-1]] == '"':
                res += '"'
                self.line_indices[-1] += 1
                found_end = False
                while self.line_indices[-1] < N:
                    c = self.read_string_character('"')
                    if not c:
                        found_end = True
                        break
                    res += c
                    
                if not found_end:
                    raise CodeException("Expected \" to terminate string", self)
                
                res += '"'   
            else:
                while self.line_indices[-1] < len(self.lines[-1]) and not (c := self.lines[-1][self.line_indices[-1]]).isspace():
                    res += c
                    self.line_indices[-1] += 1
            
        return res
        
    def skip_line(self):
        self.line_indices[-1] = len(self.lines[-1])
            
    def get_line_number(self):
        return self.line_nums[-1]
    
    def get_op_number(self):
        return self.op_nums[-1]
    
    def get_path(self):
        return self.paths[-1]
        
    def __next__(self):
        while not (op := self.get_next_op()):
            self.line_nums[-1] += 1
            self.op_nums[-1] = 0
            self.line_indices[-1] = 0
            try:
                self.lines[-1] = next(self.files[-1])
            except StopIteration:
                self.files[-1].close()
                del self.files[-1]
                del self.line_nums[-1]
                del self.op_nums[-1]
                del self.paths[-1]
                del self.lines[-1]
                del self.line_indices[-1]
                if not len(self.files):
                    raise
        
        self.op_nums[-1] += 1
        
        return op
    
    def __str__(self):
        if not self.paths:
            return ""
        return f"{self.paths[-1]}:{self.line_nums[-1]}:{self.op_nums[-1]-1}"
    
    def __iter__(self):
        return self