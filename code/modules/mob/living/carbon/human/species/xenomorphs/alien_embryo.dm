/obj/item/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yuck."
	icon = 'icons/mob/alien.dmi'
	icon_state = "larva0_dead"
	var/mob/living/affected_mob
	var/stage = 0
	var/infected = FALSE

/obj/item/alien_embryo/Initialize()
	. = ..()
	if(istype(loc, /mob/living))
		affected_mob = loc
		START_PROCESSING(SSprocessing, src)
		AddInfectionImages(affected_mob)
	else
		qdel(src)

/obj/item/alien_embryo/Destroy()
	if(affected_mob)
		affected_mob.status_flags &= ~(XENO_HOST)
		RemoveInfectionImages(affected_mob)
	..()

/obj/item/alien_embryo/process()
	if(!affected_mob)	return
	if(loc != affected_mob)
		affected_mob.status_flags &= ~(XENO_HOST)
		STOP_PROCESSING(SSprocessing, src)
		RemoveInfectionImages(affected_mob)
		affected_mob = null
		return

	if(stage < 5 && prob(3))
		stage++
		RefreshInfectionImage(affected_mob)

	switch(stage)
		if(2, 3)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob  << "<span class='danger'>Your throat feels sore.</span>"
			if(prob(1))
				affected_mob  << "<span class='danger'>Mucous runs down the back of your throat.</span>"
		if(4)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(2))
				affected_mob  << "<span class='danger'>Your muscles ache.</span>"
				if(prob(20))
					affected_mob.take_organ_damage(1)
			if(prob(2))
				affected_mob  << "<span class='danger'>Your stomach hurts.</span>"
				if(prob(20))
					affected_mob.adjustToxLoss(1)
					affected_mob.updatehealth()
		if(5)
			affected_mob  << "<span class='danger'>You feel something tearing its way out of your stomach!</span>"
			affected_mob.adjustToxLoss(10)
			affected_mob.updatehealth()
			if(prob(50))
				AttemptGrow()

/obj/item/alien_embryo/proc/AttemptGrow()
	var/list/candidates = get_alien_candidates()
	var/picked = null

	// To stop clientless larva, we will check that our host has a client
	// if we find no ghosts to become the alien. If the host has a client
	// he will become the alien but if he doesn't then we will set the stage
	// to 2, so we don't do a process heavy check everytime.

	if(candidates.len)
		picked = pick(candidates)
	else if(affected_mob.client)
		picked = affected_mob.key
	else
		stage = 4 // Let's try again later.
		return

	var/mob/living/carbon/alien/larva/new_xeno = new(affected_mob.loc)
	new_xeno.key = picked
	new_xeno << sound('sound/voice/hiss5.ogg',0,0,0,100)	//To get the player's attention
	affected_mob.apply_damage(500, BRUTE, "chest")
	qdel(src)

/*----------------------------------------
Proc: RefreshInfectionImage()
Des: Removes all infection images from aliens and places an infection image on all infected mobs for aliens.
----------------------------------------*/
/obj/item/alien_embryo/proc/RefreshInfectionImage()

	for(var/mob/living/carbon/alien in player_list)

		if(!locate(/obj/item/organ/xenos/hivenode) in alien.internal_organs)
			continue

		if(alien.client)
			for(var/image/I in alien.client.images)
				if(dd_hasprefix_case(I.icon_state, "infected"))
					qdel(I)
			for(var/mob/living/L in mob_list)
				if(iscorgi(L) || iscarbon(L))
					if(L.status_flags & XENO_HOST)
						var/I = image('icons/mob/alien.dmi', loc = L, icon_state = "infected[stage]")
						alien.client.images += I

/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Checks if the passed mob (C) is infected with the alien egg, then gives each alien client an infected image at C.
----------------------------------------*/
/obj/item/alien_embryo/proc/AddInfectionImages(var/mob/living/C)
	if(C)

		for(var/mob/living/carbon/alien in player_list)

			if(!locate(/obj/item/organ/xenos/hivenode) in alien.internal_organs)
				continue

			if(alien.client)
				if(C.status_flags & XENO_HOST)
					var/I = image('icons/mob/alien.dmi', loc = C, icon_state = "infected[stage]")
					alien.client.images += I

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes the alien infection image from all aliens in the world located in passed mob (C).
----------------------------------------*/

/obj/item/alien_embryo/proc/RemoveInfectionImages(var/mob/living/C)

	if(C)

		for(var/mob/living/carbon/alien in player_list)

			if(!locate(/obj/item/organ/xenos/hivenode) in alien.internal_organs)
				continue

			if(alien.client)
				for(var/image/I in alien.client.images)
					if(I.loc == C)
						if(dd_hasprefix_case(I.icon_state, "infected"))
							qdel(I)