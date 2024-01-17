/datum/ghostspawner/simplemob/spider_queen
	short_name = "spiderqueen"
	name = "Greimorian Queen"
	desc = "Hunt your quarry. Build a glorious hive."
	tags = list("External")
	spawnpoints = list("spiderqueen")

	max_count = 1
	enabled = FALSE

	away_site = TRUE

	respawn_flag = null

	spawn_mob = /mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen
