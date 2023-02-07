/datum/map_template/ruin/exoplanet/hut
	name = "hut"
	id = "hut"
	description = "A small and simple little research hut."
	suffixes = list("grove/hut/hut.dmm")
	spawn_weight = 1
	spawn_cost = 0.5
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT

/datum/map_template/ruin/exoplanet/crashsurvivors
	name = "Crashed Shuttle"
	id = "crashsurvivors"
	description = "A crashed shuttle, with some gear and survivors left behind."
	suffixes = list("grove/crashsurvivors/crashsurvivors.dmm")
	spawn_weight = 1
	spawn_cost = 0.5
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT