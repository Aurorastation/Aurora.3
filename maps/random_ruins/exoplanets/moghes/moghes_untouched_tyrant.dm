/datum/map_template/ruin/exoplanet/moghes_untouched_tyrant
	name = "Plains Tyrant Den"
	id = "moghes_untouched_tyrant"
	description = "The den of a mighty plains tyrant."

	spawn_weight = 0.1 //endangered species
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_untouched_tyrant.dmm"

	unit_test_groups = list(3)

/datum/ghostspawner/simplemob/moghes_plains_tyrant
	short_name = "moghes_plains_tyrant"
	name = "Plains Tyrant"
	desc = "Terrorize the land as a feared plains tyrant, the apex predator of Moghes."
	tags = list("External")

	spawnpoints = list("moghes_plains_tyrant")
	max_count = 1

	spawn_mob = /mob/living/simple_animal/hostile/biglizard

	respawn_flag = null
