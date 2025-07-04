/datum/map_template/ruin/away_site/zavod_shuttle_destroyed
	name = "destroyed zavod shuttle"
	description = "A wrecked shuttle once owned by Zavodskoi Interstellar. It seems to have crashed into a large asteroid."

	prefix = "away_site/zavod_shuttle_destroyed/"
	suffix = "zavod_shuttle_destroyed.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(ALL_UNCHARTED_SECTORS)
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

/obj/effect/overmap/visitable/zavod_shuttle_destroyed
	name = "Destroyed Zavodskoi Transport Shuttle"
	desc = "An overly large shuttle with several storage facilities onboard, though seems to be offline. Signals show that there was previously a bounty out for this vessel and it's cargo if it is able to be returned to Zavodskoi Interstellar hands... salvaging rights for the vessel are authorised, though there seems to be some lifeforms aboard alongside some... other movements aboard. Caution is advised."
	class = "ZIV"
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "generic"
	color = "#6d1217"
	initial_generic_waypoints = list(
		"nav_zavod_1",
		"nav_zavod_2",
		"nav_zavod_3",
		"nav_zavod_4",
		"nav_zavod_5",
		"nav_zavod_6",
	)
