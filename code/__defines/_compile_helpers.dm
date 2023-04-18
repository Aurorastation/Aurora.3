#define BITFLAG(X) (1<<(X))
#define HAS_FLAG(flags, flag) (flags & flag)
#define NOT_FLAG(flags, flag) !HAS_FLAG(flags, flag)
