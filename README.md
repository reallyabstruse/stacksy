# stacksy
Stacksy is a stack based programming language with white space seperated operators.

Square brackets [] indicate optional arguments.
(Top) represents the value on top of the stack. (Top-N) represents the value N steps down from the top of the stack.

A .stacksy file can contain the following operators:
* import:filepath -- Include the file at filepath as if it was a part of this file
* @name:number -- allocate number bytes in memory pointed to by name
* $name:value -- set a constant name to value
* #functionname functioncontent # -- define a function with the name functionname and some operations in functioncontent

Comments are indicated by the ; character. The rest of the line is then ignored

A function can contain the following literals:
* integers (example 1, -100) -- push the number to top of stack
* character surrounded by ' (example 'c') -- push the ascii value of the character to top of stack
* string surrounded by " (example "string"), standard c escaping is supported (example "\n\"\0") -- push the pointer to string to top of stack. A string contains a 64bit size followed by the bytes of the string

A function can contain the following operations:
* + - * / % -- pops the top two values from stack, perform the given operation and push the result on stack
* divmod -- pops the top two values from stack, push the result of dividing the values and the result of mod on the values
* = != < > <= >= -- pops the top two values from stack, push the result of comparing the values with the given operator. 1 if true, 0 oif false.
* or -- pops the top two values from stack, push the result of a binary or operation on them
* & -- pops the top two values from stack, push the result of a binary and operation on them
* pop -- remove top value from stack
* while -- start of while block
* do -- used with while, if (Top) is not 0 go to next instruction else jump to after corresponding elihw
* elihw -- end of while block, jump back to corresponding while instruction
* if -- if (Top) is not 0 go to next instruction else jump to after corresponding else or fi instruction
* else -- used with if, jump to after corresponding fi instruction
* fi -- indicates end of if/else block
* @name -- push the pointer to the memory referenced by name to top of stack
* $name -- push the value of constant name to top of stack
* copy[:n[:count]] -- copy the value (Top-n) count times. The copies are places on top of the stack. n defaults to 0, count defaults to 1.
* swap[:n[:m]] -- swap the values at (Top-n) with (Top-m). n defaults to 1 and m defaults to 0.
* syscall:n -- call the syscall n
* get:size -- read size bytes from the ptr at (Top). Replace (Top) with the value read.
* set:size -- write size bytes with the value at (Top) to the ptr at (Top-1). Pops (Top) and (Top-1)
