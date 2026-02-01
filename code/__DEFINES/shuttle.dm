//Shuttles.
#define SHUTTLE_FLAGS_NONE    0
#define SHUTTLE_FLAGS_PROCESS 1
#define SHUTTLE_FLAGS_SUPPLY  2
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)

//Overmap landable shuttles.
#define SHIP_STATUS_LANDED   1
#define SHIP_STATUS_TRANSIT  2
#define SHIP_STATUS_OVERMAP  3

#define is_shuttle_turf(T) (!isnull(T.depth_to_find_baseturf(/turf/baseturf_skipover/shuttle)))

// Shuttle moving turf flags
#define MOVE_TURF BITFLAG(0)
#define MOVE_AREA BITFLAG(1)
#define MOVE_CONTENTS BITFLAG(2)

// Shuttle rotating params
#define ROTATE_DIR BITFLAG(0)
#define ROTATE_SMOOTH BITFLAG(1)
#define ROTATE_OFFSET BITFLAG(2)

// Shuttle crush-things handling
/// Do nothing to things taking up our landing zone
#define LAND_NOTHING 1
/// gib() living things beneath us
#define LAND_CRUSH 2
/// living things take fall damage (we're an elevator)
#define LAND_FALL 3

//Docking error flags
#define DOCKING_SUCCESS 0
#define DOCKING_BLOCKED BITFLAG(0)
#define DOCKING_IMMOBILIZED BITFLAG(1)
#define DOCKING_AREA_EMPTY BITFLAG(2)
#define DOCKING_NULL_DESTINATION BITFLAG(3)
#define DOCKING_NULL_SOURCE BITFLAG(4)
#define DOCKING_BINGO_FUEL BITFLAG(5)

// Shuttle return values
#define SHUTTLE_CAN_DOCK "can_dock"
#define SHUTTLE_NOT_A_LANDMARK "not a landmark"
#define SHUTTLE_DWIDTH_TOO_LARGE "docking width too large"
#define SHUTTLE_WIDTH_TOO_LARGE "width too large"
#define SHUTTLE_DHEIGHT_TOO_LARGE "docking height too large"
#define SHUTTLE_HEIGHT_TOO_LARGE "height too large"
#define SHUTTLE_ALREADY_DOCKED "we are already docked"
#define SHUTTLE_SOMEONE_ELSE_DOCKED "someone else docked"

//Shuttle defaults
#define SHUTTLE_DEFAULT_SHUTTLE_AREA_TYPE /area/shuttle
#define SHUTTLE_DEFAULT_UNDERLYING_AREA /area/space

#define SHUTTLE_TRANSIT_BORDER 16

// These define the time taken for the shuttle to get to the space station, and the time before it leaves again.
#define SHUTTLE_PREPTIME                300 // 5 minutes = 300 seconds - after this time, the shuttle departs centcom and cannot be recalled.
#define SHUTTLE_LEAVETIME               180 // 3 minutes = 180 seconds - the duration for which the shuttle will wait at the station after arriving.
#define SHUTTLE_FORCETIME               300 // 5 minutes = 300 seconds - time after which the shuttle is automatically forced
#define SHUTTLE_TRANSIT_DURATION        300 // 5 minutes = 300 seconds - how long it takes for the shuttle to get to the station.
#define SHUTTLE_TRANSIT_DURATION_RETURN 120 // 2 minutes = 120 seconds - for some reason it takes less time to come back, go figure.

// Shuttle moving status.
#define SHUTTLE_IDLE      "idle"
#define SHUTTLE_WARMUP    "taking off"
#define SHUTTLE_INTRANSIT "in flight"
#define SHUTTLE_LANDING	  "landing"
#define SHUTTLE_HALT      "stranded" // State of no recovery

// Ferry shuttle processing status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

#define TRANSIT_REQUEST 0
#define TRANSIT_READY 1

//Note that the dirs here are REVERSE because they're used for entry points, so it'd be the dir facing starboard for example.
//These are strings because otherwise the list indexes would be out of bounds. Thanks BYOND.

GLOBAL_LIST_INIT(naval_to_dir, list(
	"1" = list(
		"starboard" = WEST,
		"port" = EAST,
		"fore" = SOUTH,
		"aft" = NORTH
	),
	"2" = list(
		"starboard" = EAST,
		"port" = WEST,
		"fore" = NORTH,
		"aft" = SOUTH
	),
	"4" = list(
		"starboard" = NORTH,
		"port" = SOUTH,
		"fore" = WEST,
		"aft" = EAST
	),
	"4" = list(
		"starboard" = NORTH,
		"port" = SOUTH,
		"fore" = WEST,
		"aft" = EAST
	),
	"8" = list(
		"starboard" = SOUTH,
		"port" = NORTH,
		"fore" = EAST,
		"aft" = WEST
	)
))

GLOBAL_LIST_INIT(headings_to_naval, list(
	"1" = list(
		"1" = "aft",
		"2" = "fore",
		"4" = "port",
		"5" = "port",
		"6" = "port",
		"8" = "starboard",
		"9" = "starboard",
		"10" = "starboard"
	),
	"2" = list(
		"1" = "fore",
		"2" = "aft",
		"4" = "starboard",
		"5" = "starboard",
		"6" = "starboard",
		"8" = "port",
		"9" = "port",
		"10" = "port"
	),
	"4" = list(
		"1" = "starboard",
		"2" = "port",
		"4" = "aft",
		"5" = "starboard",
		"6" = "port",
		"8" = "fore",
		"9" = "starboard",
		"10" = "port"
	),
	"5" = list( //northeast
		"1" = "starboard",
		"2" = "port",
		"4" = "port",
		"5" = "aft",
		"6" = "port",
		"8" = "starboard",
		"9" = "starboard",
		"10" = "fore"
	),
	"6" = list( //southeast
		"1" = "starboard",
		"2" = "port",
		"4" = "starboard",
		"5" = "starboard",
		"6" = "aft",
		"8" = "port",
		"9" = "fore",
		"10" = "port"
	),
	"8" = list(
		"1" = "port",
		"2" = "starboard",
		"4" = "fore",
		"5" = "port",
		"6" = "starboard",
		"8" = "aft",
		"9" = "port",
		"10" = "starboard"
	),
	"9" = list(  //northwest
		"1" = "port",
		"2" = "starboard",
		"4" = "port",
		"5" = "port",
		"6" = "fore",
		"8" = "starboard",
		"9" = "aft",
		"10" = "starboard"
	),
	"10" = list( //southwest
		"1" = "port",
		"2" = "starboard",
		"4" = "starboard",
		"5" = "fore",
		"6" = "starboard",
		"8" = "port",
		"9" = "port",
		"10" = "aft"
	)
))
