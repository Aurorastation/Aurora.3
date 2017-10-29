#define TURF_REMOVE_CROWBAR     1
#define TURF_REMOVE_SCREWDRIVER 2
#define TURF_REMOVE_SHOVEL      4
#define TURF_REMOVE_WRENCH      8
#define TURF_CAN_BREAK          16
#define TURF_CAN_BURN           32
#define TURF_HAS_EDGES          64
#define TURF_HAS_CORNERS        128
#define TURF_IS_FRAGILE         256
#define TURF_ACID_IMMUNE        512

// Roof related flags
#define ROOF_FORCE_SPAWN        1
#define ROOF_CLEANUP            2

// MultiZ faller control. (Bit flags.)
// Default flag is needed for assoc lists to work.
#define CLIMBER_DEFAULT 1
#define CLIMBER_NO_EXIT 2
