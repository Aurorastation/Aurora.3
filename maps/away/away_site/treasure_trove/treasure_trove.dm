/datum/map_template/ruin/away_site/trove
	name = "isolated garden planetoid"
	description = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."

	prefix = "away_site/treasure_trove/"
	suffix = "treasure_trove.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "trove"

	traits = list(
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	unit_test_groups = list(1)

/singleton/submap_archetype/treasure_trove
	map = "isolated garden planetoid"
	descriptor = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."

/obj/effect/overmap/visitable/sector/trove
	name = "isolated garden planetoid"
	desc = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."
	icon_state = "globe"
	color = "#25666b"


// ----- Map Effects and Assets

/obj/effect/step_trigger/teleport_fancy/trove/to_ocean
	uses = 0
	locationx = 12
	locationy = 235
	icon_state = "wave3"

/obj/effect/step_trigger/teleport_fancy/trove/to_beach
	uses = 0
	locationx = 23
	locationy = 14
	icon_state = "wave3"


// ------ Fluff Items

/obj/item/paper/fluff/treasure_trove/dead_end
	name = "left behind note"
	desc = "A single piece of paper with a note to the finder."
	info = "\
		You went the wrong way.\
		"
