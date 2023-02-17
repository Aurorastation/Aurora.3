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
