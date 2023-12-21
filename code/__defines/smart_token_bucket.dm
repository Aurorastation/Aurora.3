///The source of the time to base the tokens calculations off
#define STB_REALTIMESOURCE world.timeofday

///All tokens have the same lifetime, set on the bucket
#define STB_MODE_FIXEDTTL BITFLAG(1)
///Each token can specify a different lifetime
#define STB_MODE_VARIABLETTL BITFLAG(2)
///Used to indicate that each token must expire on its own timer, rather than wait for the next operation on the bucket or the last token to expire to do something
#define STB_FLAG_LEAKYBUCKET BITFLAG(1)
