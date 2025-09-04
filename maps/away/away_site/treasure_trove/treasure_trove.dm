/datum/map_template/ruin/away_site/trove
	name = "isolated garden planetoid"
	description = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."

	prefix = "away_site/treasure_trove/"
	suffix = "treasure_trove.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "trove"

	unit_test_groups = list(1)

/singleton/submap_archetype/treasure_trove
	map = "isolated garden planetoid"
	descriptor = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."

/obj/effect/overmap/visitable/sector/trove
	name = "isolated garden planetoid"
	desc = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."
	icon_state = "globe"
	color = "#25666b"
