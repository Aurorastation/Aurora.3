#define LAZYINITLIST(L) if (!L) L = list()

#define UNSETEMPTY(L) if (L && !L.len) L = null
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
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

/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]
/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]

/**
 * Binary search sorted insert from TG
 * INPUT: Object to be inserted
 * LIST: List to insert object into
 * TYPECONT: The typepath of the contents of the list
 * COMPARE: The object to compare against, usualy the same as INPUT
 * COMPARISON: The variable on the objects to compare
 * COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
 */
#define BINARY_INSERT(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON <= COMPARE.##COMPARISON) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON > COMPARE.##COMPARISON ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)
