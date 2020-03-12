/datum/antagonist/egg
	id = MODE_EGG
	role_text = "Egg Inhabitant"
	role_text_plural = "Egg Inhabitants"
	mob_path = /mob/living/egg
	bantype = "Egg"
	welcome_text = null // custom text
	antag_indicator = "egg_inhabitant"
	antaghud_indicator = "hudegg"

	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB | ANTAG_CHOOSE_NAME

	landmark_id = "borerstart" // good enough for my purposes

	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/egg/place_mob(var/mob/living/egg/E)
	if(istype(E))
		var/list/viable_eggs = list()
		for(var/obj/item/caretaker_egg/egg in global_eggs)
			if(egg.player.ckey || egg.player.client)
				continue
			viable_eggs += egg

		var/obj/item/caretaker_egg/chosen_egg
		if(length(viable_eggs))
			chosen_egg = pick(viable_eggs)
		else
			chosen_egg = new /obj/item/caretaker_egg(get_turf(pick(player_list)))
		E.forceMove(chosen_egg)
		chosen_egg.player = E
		E.my_egg = chosen_egg
		E.forceMove(chosen_egg) // do it twice to make sure
		E.introduction()
		qdel(E)