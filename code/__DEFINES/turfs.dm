/*##############################
			DEFINES
################################*/

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

/*##############################
		MACROS/FUNCTIONS
################################*/

/**
 * Checks if a turf is opaque,
 * NOT the same inner-working as the TG version, but should be equivalent
 *
 * * turf - The `/turf` to check
 */
#define IS_OPAQUE_TURF(turf)	(turf.opacity || turf.has_opaque_atom)

//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
///Returns a list of turf in a square
#define RANGE_TURFS(RADIUS, CENTER) \
	RECT_TURFS(RADIUS, RADIUS, CENTER)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
	locate(max((CENTER).x-(H_RADIUS),1), max((CENTER).y-(V_RADIUS),1), (CENTER).z), \
	locate(min((CENTER).x+(H_RADIUS),world.maxx), min((CENTER).y+(V_RADIUS),world.maxy), (CENTER).z) \
	)

///Returns all turfs in a zlevel
#define Z_TURFS(ZLEVEL) block(locate(1,1,ZLEVEL), locate(world.maxx, world.maxy, ZLEVEL))

///Returns all currently loaded turfs
#define ALL_TURFS(...) block(locate(1, 1, 1), locate(world.maxx, world.maxy, world.maxz))

///Returns a turf from a coordinate `/list` (ie: list(X, Y, Z))
#define TURF_FROM_COORDS_LIST(List) (locate(List[1], List[2], List[3]))

/// Returns a list of turfs in the rectangle specified by BOTTOM LEFT corner and height/width, checks for being outside the world border for you
#define CORNER_BLOCK(corner, width, height) CORNER_BLOCK_OFFSET(corner, width, height, 0, 0)

/// Returns a list of turfs similar to CORNER_BLOCK but with offsets
#define CORNER_BLOCK_OFFSET(corner, width, height, offset_x, offset_y) ((block(locate(corner.x + offset_x, corner.y + offset_y, corner.z), locate(min(corner.x + (width - 1) + offset_x, world.maxx), min(corner.y + (height - 1) + offset_y, world.maxy), corner.z))))

/// Returns an outline (neighboring turfs) of the given block
#define CORNER_OUTLINE(corner, width, height) ( \
	CORNER_BLOCK_OFFSET(corner, width + 2, 1, -1, -1) + \
	CORNER_BLOCK_OFFSET(corner, width + 2, 1, -1, height) + \
	CORNER_BLOCK_OFFSET(corner, 1, height, -1, 0) + \
	CORNER_BLOCK_OFFSET(corner, 1, height, width, 0))

/// Returns a list of around us
#define TURF_NEIGHBORS(turf) (CORNER_BLOCK_OFFSET(turf, 3, 3, -1, -1) - turf)

/**
 * Get the turf that `A` resides in, regardless of any containers.
 *
 * Use in favor of `A.loc` or `src.loc` so that things work correctly when
 * stored inside an inventory, locker, or other container.
 */
#define get_turf(A) (get_step(A, 0))

/**
 * Get the ultimate area of `A`, similarly to [get_turf].
 *
 * Use instead of `A.loc.loc`.
 */
#define get_area(A) (isarea(A) ? A : get_step(A, 0)?.loc)

/// Turf will be passable if density is 0
#define TURF_PATHING_PASS_DENSITY 0
/// Turf will be passable depending on [CanAStarPass] return value
#define TURF_PATHING_PASS_PROC 1
/// Turf is never passable
#define TURF_PATHING_PASS_NO 2

/*##############################
			AURORA SHIT
################################*/

// Turf-only flags.
///Blocks the jaunting spell from accessing the turf
#define TURF_FLAG_NOJAUNT BITFLAG(1)

///Used by shuttle movement to determine if it should be ignored by turf translation
#define TURF_FLAG_BACKGROUND BITFLAG(2)


/**
 * Get the turf above the current atom, if any
 *
 * Returns a `/turf` if there's a turf on the Z-level above, `null` otherwise
 *
 * * atom - The `/atom` you want to know the above turf of
 */
#define GET_ABOVE(atom) (HasAbove(atom.z) ? get_step(atom, UP) : null)

/**
 * Get the turf below the current atom, if any
 *
 * Returns a `/turf` if there's a turf on the Z-level below, `null` otherwise
 *
 * * atom - The `/atom` you want to know the below turf of
 */
#define GET_BELOW(atom) (HasBelow(atom.z) ? get_step(atom, DOWN) : null)

#define NORTH_OF_TURF(T)	locate(T.x, T.y + 1, T.z)
#define EAST_OF_TURF(T)		locate(T.x + 1, T.y, T.z)
#define SOUTH_OF_TURF(T)	locate(T.x, T.y - 1, T.z)
#define WEST_OF_TURF(T)		locate(T.x - 1, T.y, T.z)
