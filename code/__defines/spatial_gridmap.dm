// Each cell in a spatial_grid is this many turfs in length and width
#define SPATIAL_GRID_CELLSIZE 17

#define SPATIAL_GRID_CELLS_PER_SIDE(world_bounds) ROUND_UP((world_bounds) / SPATIAL_GRID_CELLSIZE)

#define SPATIAL_GRID_CHANNELS 2

// grid contents channels

// Everything that is hearing sensitive is stored in this channel
#define SPATIAL_GRID_CONTENTS_TYPE_HEARING RECURSIVE_CONTENTS_HEARING_SENSITIVE
// Every movable that has a client in it is stored in this channel
#define SPATIAL_GRID_CONTENTS_TYPE_CLIENTS RECURSIVE_CONTENTS_CLIENT_MOBS
// Every /mob is stored in this channel
#define SPATIAL_GRID_CONTENTS_TYPE_TARGETS	RECURSIVE_CONTENTS_AI_TARGETS

// Whether movable is itself or containing something which should be in one of the spatial grid channels
#define HAS_SPATIAL_GRID_CONTENTS(movable) (movable.important_recursive_contents && \
	(movable.important_recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE] || movable.important_recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] || movable.important_recursive_contents[RECURSIVE_CONTENTS_AI_TARGETS]))


/**
 * Checks if two atoms are in line of sight (can see each other)
 *
 * * RETURN_VALUE - Where to store the result of this check (TRUE if LoS, FALSE otherwise)
 * * source - Source atom
 * * target - Target atom
 * * view_radius - How far the atom can see, usually you want to use `world.view` for the default value
 */
#define SPATIAL_CHECK_LOS(RETURN_VALUE, source, target, view_radius)\
	do{\
		var/turf/source_turf = get_turf(source);\
		var/turf/target_turf = get_turf(target);\
		var/distance = get_dist(source_turf, target_turf);\
		if(distance > view_radius){\
			RETURN_VALUE = FALSE;\
			break;\
		}\
		if(distance < 2){\
			RETURN_VALUE = TRUE;\
			break;\
		}\
		for(var/step_counter in 1 to distance){\
			source_turf = get_step_towards(source_turf, target_turf);\
			if(source_turf == target_turf){\
				RETURN_VALUE = TRUE;\
				break;\
			}\
			if(IS_OPAQUE_TURF(source_turf)){\
				RETURN_VALUE = FALSE;\
				break;\
			}\
		}\
	} while(FALSE)
