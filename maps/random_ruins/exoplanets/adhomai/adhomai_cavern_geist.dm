/datum/map_template/ruin/exoplanet/adhomai_cavern_geist
	name = "Cavern Geist Den"
	id = "adhomai_cavern_geist"
	description = "The den of a cavern geist."

	spawn_weight = 0.5
	spawn_cost = 2
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_cavern_geist.dmm")

//ghost roles

/datum/ghostspawner/human/adhomai_cavern_geist
	short_name = "adhomai_cavern_geist"
	name = "Cavern Geist"
	desc = "Terrorize the land as a feared cavern geist, the apex predator of Adhomai."
	tags = list("External")

	spawnpoints = list("adhomai_cavern_geist")
	max_count = 1

	spawn_mob = /mob/living/simple_animal/hostile/cavern_geist

	respawn_flag = null