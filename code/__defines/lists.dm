#define LAZYINITLIST(L) if (!L) L = list()

#define UNSETEMPTY(L) if (L && !L.len) L = null
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!L.len) { L = null; } }
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= L.len ? L[I] : null) : L[I]) : null)
#define LAZYLEN(L) length(L)
#define LAZYCLEARLIST(L) if(L) L.Cut()
#define LAZYSET(L, K, V) if (!L) { L = list(); } L[K] = V;
#define LAZYPICK(L,DEFAULT) (LAZYLEN(L) ? pick(L) : DEFAULT)
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;

// Shims for some list procs in lists.dm.
#define isemptylist(L) (!LAZYLEN(L))
#define safepick(L) LAZYPICK(L,null)
#define listgetindex(L,I) LAZYACCESS(L,I)

#if DM_VERSION < 513
#define islist(L) istype(L,/list)
#endif

// binary search sorted insert
// IN: Object to be inserted
// LIST: List to insert object into
// TYPECONT: The typepath of the contents of the list
// COMPARE: The variable on the objects to compare
#define BINARY_INSERT(IN, LIST, TYPECONT, COMPARE) \
	var/__BIN_CTTL = length(LIST);\
	if(!__BIN_CTTL) {\
		LIST += IN;\
	} else {\
		var/__BIN_LEFT = 1;\
		var/__BIN_RIGHT = __BIN_CTTL;\
		var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
		var/##TYPECONT/__BIN_ITEM;\
		while(__BIN_LEFT < __BIN_RIGHT) {\
			__BIN_ITEM = LIST[__BIN_MID];\
			if(__BIN_ITEM.##COMPARE <= IN.##COMPARE) {\
				__BIN_LEFT = __BIN_MID + 1;\
			} else {\
				__BIN_RIGHT = __BIN_MID;\
			};\
			__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
		};\
		__BIN_ITEM = LIST[__BIN_MID];\
		__BIN_MID = __BIN_ITEM.##COMPARE > IN.##COMPARE ? __BIN_MID : __BIN_MID + 1;\
		LIST.Insert(__BIN_MID, IN);\
	}