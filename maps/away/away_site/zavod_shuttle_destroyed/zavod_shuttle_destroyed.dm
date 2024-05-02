/datum/map_template/ruin/away_site/zavod_shuttle_destroyed
	name = "destroyed zavod shuttle"
	description = "A wrecked shuttle once owned by Zavodskoi Interstellar. It seems to have crashed into a large asteroid."

	prefix = "away_site/zavod_shuttle_destroyed/"
	suffixes = list("zavod_shuttle_destroyed.dmm")

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "destroyed zavod shuttle"

	unit_test_groups = list(1)

/singleton/submap_archetype/zavod_shuttle_destroyed
	map = "destroyed zavod shuttle"
	descriptor = "A wrecked shuttle once owned by Zavodskoi Interstellar. It seems to have crashed into a large asteroid."

/obj/effect/overmap/visitable/zavod_shuttle_destroyed
	name = "destroyed zavod shuttle"
	desc = "A wrecked shuttle once owned by Zavodskoi Interstellar. It seems to have crashed into a large asteroid."

/area/zavod_shuttle_destroyed
	name = "destroyed zavod shuttle"
	requires_power = TRUE
	base_turf = /turf/space
	no_light_control = TRUE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
