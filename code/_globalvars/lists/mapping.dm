GLOBAL_LIST_INIT(cardinals, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
))
GLOBAL_LIST_INIT(cardinals_multiz, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	UP,
	DOWN,
))
GLOBAL_LIST_INIT(diagonals, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
))
GLOBAL_LIST_INIT(corners_multiz, list(
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(diagonals_multiz, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,

	UP|NORTH,
	UP|SOUTH,
	UP|EAST,
	UP|WEST,
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,

	DOWN|NORTH,
	DOWN|SOUTH,
	DOWN|EAST,
	DOWN|WEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(alldirs_multiz, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,

	UP,
	UP|NORTH,
	UP|SOUTH,
	UP|EAST,
	UP|WEST,
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,

	DOWN,
	DOWN|NORTH,
	DOWN|SOUTH,
	DOWN|EAST,
	DOWN|WEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(alldirs, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
))

/// Used in N_* directions (defined in \code\_DEFINES\icon_smoothing.dm) to Byond native conversions
GLOBAL_LIST_INIT(ndir_to_dir, alist(
	N_NORTH    = NORTH,
	N_SOUTH    = SOUTH,
	N_EAST     = EAST,
	N_WEST     = WEST,
	N_NORTHEAST = NORTHEAST,
	N_NORTHWEST = NORTHWEST,
	N_SOUTHEAST = SOUTHEAST,
	N_SOUTHWEST = SOUTHWEST
))

/// Used to get native equalivent of N_* directions. Useful if you need to manually hand adjacencies to smoothing system, if calculate_adjacencies() isn't viable.
GLOBAL_LIST_INIT(dir_to_ndir, alist(
	NORTH    = N_NORTH,
	SOUTH    = N_SOUTH,
	EAST     = N_EAST,
	WEST     = N_WEST,
	NORTHEAST = N_NORTHEAST,
	NORTHWEST = N_NORTHWEST,
	SOUTHEAST = N_SOUTHEAST,
	SOUTHWEST = N_SOUTHWEST
))

/// Just a list of all the area objects in the game
/// Note, areas can have duplicate types
GLOBAL_LIST_EMPTY(areas)
/// Used by jump-to-area etc. Updated by area/updateName()
/// If this is null, it needs to be recalculated. Use get_sorted_areas() as a getter please
GLOBAL_LIST_EMPTY(sortedAreas)
