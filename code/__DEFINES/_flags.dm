#define ALL (~0) //For convenience.
#define NONE 0

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// for /datum/var/datum_flags
#define DF_USE_TAG (1<<0)
#define DF_ISPROCESSING (1<<2)

///Whether /atom/Initialize() has already run for the object
#define INITIALIZED_1 (1<<5)

/*
	These defines are used specifically with the atom/pass_flags bitmask
	the atom/checkpass() proc uses them (tables will call movable atom checkpass(PASSTABLE) for example)
*/
//flags for pass_flags
/// Allows you to pass over tables.
#define PASSTABLE (1<<0)
/// Allows you to pass over glass(this generally includes anything see-through that's glass-adjacent, ie. windows, windoors, airlocks with glass, etc.)
#define PASSGLASS (1<<1)
/// Allows you to pass over grilles.
#define PASSGRILLE (1<<2)
/// Allows you to pass over blob tiles.
#define PASSBLOB (1<<3)
/// Allows you to pass over mobs.
#define PASSMOB (1<<4)
/// Allows you to pass over closed turfs, ie. walls.
#define PASSCLOSEDTURF (1<<5)
/// Let thrown things past us. **ONLY MEANINGFUL ON pass_flags_self!**
#define LETPASSTHROW (1<<6)
/// Allows you to pass over machinery, ie. vending machines, computers, protolathes, etc.
#define PASSMACHINE (1<<7)
/// Allows you to pass over structures, ie. racks, tables(if you don't already have PASSTABLE), etc.
#define PASSSTRUCTURE (1<<8)
/// Allows you to pass over plastic flaps, often found at cargo or MULE dropoffs.
#define PASSFLAPS (1<<9)
/// Allows you to pass over airlocks and mineral doors.
#define PASSDOORS (1<<10)
/// Allows you to pass over vehicles, ie. mecha
#define PASSVEHICLE (1<<11)
/// Allows you to pass over dense items.
#define PASSITEM (1<<12)
/// Do not intercept click attempts during Adjacent() checks. See [turf/proc/ClickCross]. **ONLY MEANINGFUL ON pass_flags_self!**
#define LETPASSCLICKS (1<<13)
/// Allows you to pass over windows and window-adjacent stuff, like windows and windoors. Does not include airlocks with glass in them.
#define PASSWINDOW (1<<14)

/* AURORA SNOWFLAKE CODE */
#define PASSDOORHATCH	(1<<15)
#define PASSTRACE	(1<<16) //Used by turrets in the check_trajectory proc to target mobs hiding behind certain things (such as closets)
#define PASSRAILING	(1<<17)

//Movement Types
#define GROUND (1<<0)
#define FLYING (1<<1)
#define VENTCRAWLING (1<<2)
#define FLOATING (1<<3)
/// When moving, will Cross() everything, but won't stop or Bump() anything.
#define PHASING (1<<4)
/// The mob is walking on the ceiling. Or is generally just, upside down.
#define UPSIDE_DOWN (1<<5)

//TURF FLAGS
/// If a turf is an usused reservation turf awaiting assignment
#define UNUSED_RESERVATION_TURF BITFLAG(1)
/// If a turf is a reserved turf
#define RESERVATION_TURF BITFLAG(2)

// Turf-only flags.
///Blocks the jaunting spell from accessing the turf
#define TURF_FLAG_NOJAUNT BITFLAG(3)

///Used by shuttle movement to determine if it should be ignored by turf translation
#define TURF_FLAG_BACKGROUND BITFLAG(4)
