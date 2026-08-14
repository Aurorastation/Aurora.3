/datum/map_template/ruin/away_site/boneyard
	name = "LDSB-#1 'The Boneyard'"
	description = "A vast conglomeration of many different objects - some natural, some resembling ships - \
		all mashed together into an incomprehensible complex of pressurised compartments."

	prefix = "scenarios/boneyard/"
	suffix = "the_boneyard.dmm"
	id = "the_boneyard"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 0
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(3)

/singleton/submap_archetype/boneyard
	map = "LDSB-#1 'The Boneyard'"
	descriptor = "A vast conglomeration of many different objects - some natural, some resembling ships - \
		all mashed together into an incomprehensible complex of pressurised compartments."

/obj/effect/overmap/visitable/sector/boneyard
	name = "LDSB-#1 'The Boneyard'"
	desc = "A vast conglomeration of many different objects - some natural, some resembling ships - \
		all mashed together into an incomprehensible complex of pressurised compartments."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	alignment = "Outer Eyes"
	icon_state = "battlestation"
	color = "#7c5f88"
	place_near_main = list(11,11)
	static_vessel = TRUE
	generic_object = FALSE
	comms_support = TRUE

	initial_generic_waypoints = list(
		"airlock_boneyard_east",
		"airlock_boneyard_west",
		"airlock_boneyard_middle"
	)
