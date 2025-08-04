#define WORLD_MIN_SIZE 32
//This file is just for the necessary /world definition
//Try looking in /code/game/world.dm, where initialization order is defined

/**
 * # World
 *
 * Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying. ~ Arthur C. Clarke
 *
 * The byond world object stores some basic byond level config, and has a few hub specific procs for managing hub visiblity
 */
/world
	/* Aurora snowflake to avoid the window stretching when ran locally before the map is softloaded */
	maxx = WORLD_MIN_SIZE
	maxy = WORLD_MIN_SIZE
	/* End of aurora snowflake */

	mob = /mob/abstract/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Space Station 13"
	fps = 20
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	// map_format = SIDE_MAP //Possibly makes the sprites flicker and thus the clients lag
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif
