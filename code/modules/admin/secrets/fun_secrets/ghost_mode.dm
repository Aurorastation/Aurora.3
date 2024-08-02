/datum/admin_secret_item/fun_secret/ghost_mode
	name = "Ghost Mode"
	var/list/affected_mobs

/datum/admin_secret_item/fun_secret/ghost_mode/New()
	..()
	affected_mobs = list()

/datum/admin_secret_item/fun_secret/ghost_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/list/affected_areas = list()
	for(var/mob/M in GLOB.living_mob_list)
		if(M.stat == CONSCIOUS && !(M in affected_mobs))
			affected_mobs |= M
			switch(rand(1,4))
				if(1)
					M.show_message(SPAN_NOTICE("You shudder as if cold..."), 1)
				if(2)
					M.show_message(SPAN_NOTICE("You feel something gliding across your back..."), 1)
				if(3)
					M.show_message(SPAN_NOTICE("Your eyes twitch, you feel like something you can't see is here..."), 1)
				if(4)
					M.show_message(SPAN_NOTICE("You notice something moving out of the corner of your eye, but nothing is there..."), 1)

			for(var/obj/W in orange(5,M))
				if(prob(25) && !W.anchored)
					step_rand(W)

			var/area/A = get_area(M)
			if(A.requires_power && !A.always_unpowered && A.power_light && !is_centcom_level(A.z) && !is_reserved_level(A.z))
				affected_areas |= get_area(M)

	affected_mobs |= user
	for(var/area/AffectedArea in affected_areas)
		AffectedArea.power_light = 0
		AffectedArea.power_change()
		spawn(rand(25,50))
			AffectedArea.power_light = 1
			AffectedArea.power_change()

	sleep(100)
	for(var/mob/M in affected_mobs)
		M.show_message(SPAN_NOTICE("The chilling wind suddenly stops..."), 1)
	affected_mobs.Cut()
	affected_areas.Cut()
