SYMBOL_TYPES = {
    "N_GSYM": 0x20,
	"N_FNAME": 0x22,
	"N_FUN": 0x24,
	"N_STSYM": 0x26,
	"N_LCSYM": 0x28,
	"N_MAIN": 0x2a,
	"N_ROSYM": 0x2c,
	"N_PC": 0x30,
	"N_NSYMS": 0x32,
	"N_NOMAP": 0x34,
	"N_MAC_DEFINE": 0x36,
	"N_OBJ": 0x38,
	"N_MAC_UNDEF": 0x3a,
	"N_OPT": 0x3c,
	"N_RSYM": 0x40,
	"N_M2C": 0x42,
	"N_SLINE": 0x44,
	"N_DSLINE": 0x46,
	"N_BSLINE": 0x48,
	"N_BROWS": 0x48,
	"N_DEFD": 0x4a,
	"N_FLINE": 0x4c,
	"N_EHDECL": 0x50,
	"N_MOD2": 0x50,
	"N_CATCH": 0x54,
	"N_SSYM": 0x60,
	"N_ENDM": 0x62,
	"N_SO": 0x64,
	"N_LSYM": 0x80,
	"N_BINCL": 0x82,
	"N_SOL": 0x84,
	"N_PSYM": 0xa0,
	"N_EINCL": 0xa2,
	"N_ENTRY": 0xa4,
	"N_LBRAC": 0xc0,
	"N_EXCL": 0xc2,
	"N_SCOPE": 0xc4,
	"N_RBRAC": 0xe0,
	"N_BCOMM": 0xe2,
	"N_ECOMM": 0xe4,
	"N_ECOML": 0xe8,
	"N_WITH": 0xea,
	"N_NBTEXT": 0xf0,
	"N_NBDATA": 0xf2,
	"N_NBBSS": 0xf4,
	"N_NBSTS": 0xf6,
	"N_NBLCS": 0xf8}
    
def nextLabel():
    nextLabel.i += 1
    return f"STABSL_{nextLabel.i}"
nextLabel.i = 0
    
def stabn(t, other, desc, val):
    return f".stabn {t},{other},{desc},{val}\n"

def sline(n):
    label = nextLabel()
    return stabn(SYMBOL_TYPES["N_SLINE"], 0, n, label) + f"{label}:\n"