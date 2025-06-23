/datum/map_template/ruin/exoplanet/moghes_wasteland_tyrant
	name = "Plains Tyrant Den - Wasteland"
	id = "moghes_wasteland_tyrant"
	description = "The den of a mighty plains tyrant."

	spawn_weight = 0.3 //endangered species, more common away from civilisation
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_tyrant.dmm"
	unit_test_groups = list(3)
