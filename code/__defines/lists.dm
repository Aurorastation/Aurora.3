#define LAZYINITLIST(L) if (!L) L = list()

#define UNSETEMPTY(L) if (L && !L.len) L = null
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!L.len) { L = null; } }
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= L.len ? L[I] : null) : L[I]) : null)
#define LAZYLEN(L) length(L)
#define LAZYCLEARLIST(L) if(L) L.Cut()
#define LAZYSET(L, K, V) if (!L) { L = list(); } L[K] = V;
#define LAZYPICK(L,DEFAULT) (LAZYLEN(L) ? pick(L) : DEFAULT)

// Shims for some list procs in lists.dm.
#define islist(L) istype(L,/list)
#define isemptylist(L) (!LAZYLEN(L))
#define safepick(L) LAZYPICK(L,null)
#define listgetindex(L,I) LAZYACCESS(L,I)
