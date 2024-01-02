var/datum/antagonist/technomancer/technomancers

/datum/antagonist/technomancer
	id = MODE_TECHNOMANCER
	role_text = "Technomancer"
	role_text_plural = "Technomancers"
	bantype = "wizard"
	landmark_id = "wizard"
	welcome_text = "You will need to purchase <b>functions</b> and perhaps some <b>equipment</b> from the various machines around your \
	base. Choose your technological arsenal carefully.  Remember that without the <b>core</b> on your back, your functions are \
	powerless, and therefore you will be as well.<br>\
	In your pockets you will find a one-time use teleport device. Use it to leave the base and go to the station, when you are ready. Your clothing is holographic, you should change its look before leaving."
	antag_sound = 'sound/effects/antag_notice/technomancer_alert.ogg'
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE | ANTAG_VOTABLE
	antaghud_indicator = "hudwizard"

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1

	id_type = /obj/item/card/id/syndicate

	has_idris_account = FALSE

/datum/antagonist/technomancer/New()
	..()
	technomancers = src

/datum/antagonist/technomancer/update_antag_mob(var/datum/mind/technomancer)
	..()
	technomancer.store_memory("<B>Remember:</B> Do not forget to purchase the functions and equipment you need.")
	technomancer.current.real_name = random_name(technomancer.current.gender, technomancer.current.get_species())
	technomancer.current.name = technomancer.current.real_name

/datum/antagonist/technomancer/equip(var/mob/living/carbon/human/technomancer_mob)
	if(!..())
		return FALSE

	technomancer_mob.preEquipOutfit(/datum/outfit/admin/techomancer, FALSE)
	technomancer_mob.equipOutfit(/datum/outfit/admin/techomancer, FALSE)

	return TRUE

/datum/antagonist/technomancer/proc/equip_apprentice(var/mob/living/carbon/human/technomancer_mob)
	technomancer_mob.preEquipOutfit(/datum/outfit/admin/techomancer/apprentice, FALSE)
	technomancer_mob.equipOutfit(/datum/outfit/admin/techomancer/apprentice, FALSE)
	return TRUE

/datum/antagonist/technomancer/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat == DEAD)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - technomancer killed")
		to_world("<span class='danger'><font size = 3>The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been killed!</font></span>")

/datum/antagonist/technomancer/print_player_summary()
	..()
	for(var/obj/item/technomancer_core/core in technomancer_belongings)
		if(core.wearer)
			continue // Only want abandoned cores.
		if(!core.spells.len)
			continue // Cores containing spells only.
		to_world("Abandoned [core] had [english_list(core.spells)].<br>")

/datum/antagonist/technomancer/print_player_full(var/datum/mind/player)
	var/text = print_player_lite(player)

	var/obj/item/technomancer_core/core
	if(player.original)
		core = locate() in player.original
		if(core)
			text += "<br>Bought [english_list(core.spells)], and used \a [core]."
		else
			text += "<br>They've lost their core."

	return text

/datum/antagonist/technomancer/proc/is_technomancer(var/datum/mind/player)
	if(player in current_antagonists)
		return TRUE
	if(raider_techno.is_antagonist(player))
		return TRUE
	return FALSE

/datum/antagonist/technomancer/is_obvious_antag(datum/mind/player)
	return TRUE
