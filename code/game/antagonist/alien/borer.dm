var/datum/antagonist/xenos/borer/borers

/datum/antagonist/xenos/borer
	id = MODE_BORER
	role_text = "Cortical Borer"
	role_text_plural = "Cortical Borers"
	mob_path = /mob/living/simple_animal/borer/roundstart
	bantype = "Borer"
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with ,x."
	antag_indicator = "brainworm"
	antaghud_indicator = "hudborer"

	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB

	landmark_id = "borerstart"

	faction_role_text = "Borer Thrall"
	faction_descriptor = "Unity"
	faction_welcome = "You are now a thrall to a cortical borer. Please listen to what they have to say; they're in your head."

	initial_spawn_req = 2
	initial_spawn_target = 3

/datum/antagonist/xenos/borer/New()
	..(TRUE)
	borers = src

/datum/antagonist/xenos/borer/create_objectives(var/datum/mind/player)
	if(!..())
		return
	player.objectives += new /datum/objective/borer_survive()
	player.objectives += new /datum/objective/borer_reproduce()
	player.objectives += new /datum/objective/escape()

/datum/antagonist/xenos/borer/place_mob(var/mob/living/M)
	if(istype(M, /mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/borer = M

		var/list/hosts = list()
		for(var/mob/living/carbon/human/H in mob_list)
			if(!H.mind)
				continue
			if(H.mind?.special_role)
				continue
			if(!(MODE_BORER in H.client.prefs.be_special_role)) //Don't draft people that don't have the borer pref on.
				continue
			if(H.stat == DEAD)
				continue
			if(H.isSynthetic() || H.is_diona())
				continue
			if(H.has_brain_worms())
				continue
			hosts += H

		if(length(hosts))
			var/mob/living/carbon/human/chosen_host = pick(hosts)

			borer.host = chosen_host
			borer.host.status_flags |= PASSEMOTES
			borer.forceMove(chosen_host)

			if(borer.host.mind)
				borers.add_antagonist_mind(borer.host.mind, 1, borers.faction_role_text, borers.faction_welcome)

			var/obj/item/organ/external/head = borer.host.get_organ(BP_HEAD)
			head.implants += borer
		else
			..()