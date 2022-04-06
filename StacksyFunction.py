class StacksyFunctionX64:
    def __init__(self, name):
        self.name = name
        self._asm = ""

    def get_prologue(self):
        return f"func_{self.name}:\n" + ".cfi_startproc\n"
               
    def get_epilogue(self):
        return ".cfi_endproc\n" + f"funcend_{self.name}:\n"
               
    def append_asm(self, asm):
        self._asm += asm + "\n"

    def get_asm(self):
        return self.get_prologue() + self._asm + self.get_epilogue()
        
    