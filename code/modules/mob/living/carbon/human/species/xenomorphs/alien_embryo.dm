/obj/item/organ/parasite/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yuck."
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "larva0_dead"
	parent_organ = "chest"
	organ_tag = "alien embryo"
	origin_tech = list(TECH_BIO = 5)
	stage_interval = 200


/obj/item/organ/parasite/alien_embryo/Destroy()
	if(owner)
		owner.status_flags &= ~(XENO_HOST)
		RemoveInfectionImages(owner)
	return ..()


/obj/item/organ/parasite/alien_embryo/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	..(target, affected)
	if(owner && ishuman(owner))
		START_PROCESSING(SSprocessing, src)
		AddInfectionImages(owner)

/obj/item/organ/parasite/alien_embryo/removed(var/mob/living/user)
	if(owner)
		owner.status_flags &= ~(XENO_HOST)
		RemoveInfectionImages(owner)
	..(user)

/obj/item/organ/parasite/alien_embryo/stage_effect()
	RefreshInfectionImage(owner)
	return

/obj/item/organ/parasite/alien_embryo/process()

	..()

	if(!owner)
		return

	if(stage >= 2)
		if(prob(1))
			owner.emote("sneeze")
		if(prob(1))
			owner.emote("cough")
		if(prob(1))
			to_chat(owner, "<span class='danger'>Your throat feels sore.</span>")
		if(prob(1))
			to_chat(owner, "<span class='danger'>Mucous runs down the back of your throat.</span>")

	if(stage >= 3)
		if(prob(1))
			owner.emote("sneeze")
		if(prob(1))
			owner.emote("cough")
		if(prob(2))
			to_chat(owner, "<span class='danger'>Your muscles ache.</span>")
			if(prob(20))
				owner.take_organ_damage(1)
		if(prob(2))
			to_chat(owner, "<span class='danger'>Your stomach hurts.</span>")
			if(prob(20))
				owner.adjustToxLoss(1)
				owner.updatehealth()

	if(stage >= 4)
		to_chat(owner, "<span class='danger'>You feel something tearing its way out of your stomach!</span>")
		owner.adjustToxLoss(10)
		owner.updatehealth()
		if(prob(50))
			AttemptGrow()

/obj/item/organ/parasite/alien_embryo/proc/AttemptGrow()
	var/list/candidates = get_alien_candidates()
	var/picked = null

	// To stop clientless larva, we will check that our host has a client
	// if we find no ghosts to become the alien. If the host has a client
	// he will become the alien but if he doesn't then we will set the stage
	// to 2, so we don't do a process heavy check everytime.

	if(candidates.len)
		picked = pick(candidates)
	else if(owner.client)
		picked = owner.key
	else
		stage = 4 // Let's try again later.
		return

	var/mob/living/carbon/alien/larva/new_xeno = new(owner.loc)
	new_xeno.key = picked
	new_xeno << sound('sound/voice/hiss5.ogg',0,0,0,100)	//To get the player's attention
	owner.apply_damage(500, BRUTE, "chest")
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/*----------------------------------------
Proc: RefreshInfectionImage()
Des: Removes all infection images from aliens and places an infection image on all infected mobs for aliens.
----------------------------------------*/
/obj/item/organ/parasite/alien_embryo/proc/RefreshInfectionImage()

	for(var/mob/living/carbon/alien in player_list)

		if(!locate(/obj/item/organ/xenos/hivenode) in alien.internal_organs)
			continue

		if(alien.client)
			for(var/image/I in alien.client.images)
				if(dd_hasprefix_case(I.icon_state, "infected"))
					alien.client.images -= I
			for(var/mob/living/L in mob_list)
				if(iscarbon(L))
					if(L.status_flags & XENO_HOST)
						var/image/I = image('icons/mob/npc/alien.dmi', loc = L, icon_state = "infected[stage]")
						alien.client.images += I

/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Checks if the passed mob (C) is infected with the alien egg, then gives each alien client an infected image at C.
----------------------------------------*/
/obj/item/organ/parasite/alien_embryo/proc/AddInfectionImages(var/mob/living/C)
	if(C)

		for(var/mob/living/carbon/alien in player_list)

			if(!locate(/obj/item/organ/xenos/hivenode) in alien.internal_organs)
				continue

			if(alien.client)
				if(C.status_flags & XENO_HOST)
					var/image/I = image('icons/mob/npc/alien.dmi', loc = C, icon_state = "infected[stage]")
					alien.client.images += I

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes the alien infection image from all aliens in the world located in passed mob (C).
----------------------------------------*/

/obj/item/organ/parasite/alien_embryo/proc/RemoveInfectionImages(var/mob/living/C)

	if(C)

		for(var/mob/living/carbon/alien in player_list)

			if(!locate(/obj/item/organ/xenos/hivenode) in alien.internal_organs)
				continue

			if(alien.client)
				for(var/image/I in alien.client.images)
					if(I.loc == C)
						if(dd_hasprefix_case(I.icon_state, "infected"))
							alien.client.images -= I