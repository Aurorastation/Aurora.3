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

/datum/ghostspawner/simplemob/spider_queen/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)
