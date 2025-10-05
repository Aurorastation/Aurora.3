/datum/map_template/ruin/away_site/trove
	name = "isolated garden planetoid"
	description = "A hidden but beautiful planetoid; breathable air, lush vegetation, a thriving biosphere and pristine oceans make it seem too good to be true."

	prefix = "away_site/treasure_trove/"
	suffix = "treasure_trove.dmm"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "trove"
	exoplanet_lightlevel = 3
	exoplanet_lightcolor = COLOR_WHITE

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
	color = "#10ad4c"
	initial_generic_waypoints = list(
	"nav_point_beach_01",
	"nav_point_beach_02a",
	"nav_point_beach_02b",
	"nav_point_beach_02c",
	"nav_point_beach_02d",
	"nav_point_beach_03",
	"nav_point_beach_04"
	)

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

/obj/item/paper/fluff/treasure_trove/warning
	name = "final warning"
	desc = "A warning to any who come here."
	info = "\
		So you made it through and found my loot? Enjoy the rest, but what's in here is mine."


/obj/item/paper/fluff/treasure_trove/survivor
	name = "journal page"
	desc = "A single page remaining from a survivor's journal."
	info = "\
		I'm going to die here. This place is a death trap.<br> \
		We buried Rena, Markus, and the unathi but pretty quick something came<br> \
		and started digging them up. Staying away from the jungle.<br> \
		<br> \
		Alsir and Jena are intent on going into the caves. I told them no. \
		I'm not looking to die but it seems like this place is hungry for blood anyway. \
		<br> \
		They went into the caves two days ago. \
		They haven't come back. \
		<br> \
		Nearly got carried away by a riptide. Even the water is trying to kill me. \
		<br> \
		Found what seems to be an old prospecting setup, but it's too close to the jungle. I think something \
		caught my scent. It always feels like something is watching me... waiting. \
		"
