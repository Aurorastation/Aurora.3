/datum/map_template/ruin/exoplanet/desolate_farm
	name = "Desolate Farm"
	id = "desolate_farm"
	description = "A small hut nearby a fenced off farming plot."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI)

	prefix = "biesel/"
	suffixes = list("desolate_farm.dmm")
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
