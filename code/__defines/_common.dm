#define GLOBAL_PROC	"some_magic_bullshit"
#define DESC_PARENT "You shouldn't be seeing this. Please make an issue report."

/// Standard BYOND global, seriously do not use without an earthshakingly good reason
#define GLOBAL_REAL_VAR(X) var/global/##X;

/// Standard typed BYOND global, seriously do not use without an earthshakingly good reason
#define GLOBAL_REAL(X, Typepath) var/global##Typepath/##X;
