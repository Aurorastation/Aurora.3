#define IS_OPAQUE_TURF(turf)	(turf.opacity || turf.has_opaque_atom)

#define TURF_REMOVE_CROWBAR     BITFLAG(1)
#define TURF_REMOVE_SCREWDRIVER BITFLAG(2)
#define TURF_REMOVE_SHOVEL      BITFLAG(3)
#define TURF_REMOVE_WRENCH      BITFLAG(4)
#define TURF_REMOVE_WELDER      BITFLAG(5)
#define TURF_CAN_BREAK          BITFLAG(6)
#define TURF_CAN_BURN           BITFLAG(7)
#define TURF_HAS_EDGES          BITFLAG(8)
#define TURF_HAS_CORNERS        BITFLAG(9)
#define TURF_HAS_INNER_CORNERS	BITFLAG(10)
#define TURF_IS_FRAGILE			BITFLAG(11)
#define TURF_ACID_IMMUNE		BITFLAG(12)
#define TURF_NORUINS            BITFLAG(13)

//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes

// Roof related flags
#define ROOF_FORCE_SPAWN        1
#define ROOF_CLEANUP            2

// MultiZ faller control. (Bit flags.)
// Default flag is needed for assoc lists to work.
#define CLIMBER_DEFAULT 1
#define CLIMBER_NO_EXIT 2
