var/datum/antagonist/revolutionary/revs

/datum/antagonist/revolutionary
	id = MODE_REVOLUTIONARY
	role_text = "Head Revolutionary"
	role_text_plural = "Revolutionaries"
	bantype = "revolutionary"
	feedback_tag = "rev_objective"
	antag_indicator = "contenderhead"
	victory_text = "You eliminated the Loyalists in one fell swoop."
	loss_text = "The Loyalists threw a wrench into your plans -- permanently."
	victory_feedback_tag = "You eliminated the Loyalists in one fell swoop."
	loss_feedback_tag = "No matter your efforts, you failed to thwart them."
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	antaghud_indicator = "contender"

	hard_cap = 3
	hard_cap_round = 4
	initial_spawn_req = 1
	initial_spawn_target = 4

	// Inround revs.
	faction_role_text = "Revolutionary"
	faction_descriptor = "Revolutionaries"
	faction_verb = /mob/living/proc/convert_to_rev
	faction_indicator = "contender"
	faction_invisible = FALSE

	restricted_jobs = list("AI", "Cyborg", "Merchant")
	protected_jobs = list("Lab Assistant", "Medical Intern", "Engineering Apprentice", "Assistant", "Security Cadet", "Captain", "Head of Security")
	required_age = 31

/datum/antagonist/revolutionary/New()
	..()
	revs = src

/datum/antagonist/revolutionary/create_antagonist()
	faction_welcome = "You joined a subversive organization in the crew of the [current_map.station_name]. United under a forward-thinking leader, you must achieve their goals."
	welcome_text = "You are a subversive seeking to demolish the current order on the [current_map.station_type] by whatever means possible. Recruit friends and strangers alike to bring [current_map.company_short]'s tyranny to an end! Or whatever your objective is."

/datum/antagonist/revolutionary/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(!player.mind || player.stat == DEAD || !(player.mind.assigned_role in command_positions))
			continue
		var/datum/objective/rev/rev_obj = new
		rev_obj.target = player.mind
		rev_obj.explanation_text = "Assassinate, capture or convert [player.real_name], the [player.mind.assigned_role]."
		global_objectives += rev_obj

/datum/antagonist/revolutionary/can_become_antag(var/datum/mind/player)
	if(!..())
		return FALSE
	for(var/obj/item/implant/mindshield/L in player.current)
		if(L?.imp_in == player.current)
			return FALSE
	return TRUE

/datum/antagonist/revolutionary/equip(var/mob/living/carbon/human/player)

	if(!..())
		return FALSE

	if(!player.back)
		player.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(player), slot_back) // if they have no backpack, spawn one
	player.equip_to_slot_or_del(new /obj/item/device/announcer(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/device/special_uplink/rev(player, player.mind), slot_in_backpack)

	give_codewords(player)
	INVOKE_ASYNC(src, PROC_REF(alert_revolutionary_status), player)
	return TRUE

/datum/antagonist/revolutionary/proc/alert_revolutionary_status(var/mob/living/carbon/human/player) //This is so dumb.
	alert(player, "As a Head Revolutionary you are given an uplink with a lot of telecrystals. \
				Your goal is to create and progress a story. Use the announcement device you spawn with to whip people into a frenzy, \
				and the uplink disguised as a radio to equip them. DO NOT PLAY THIS ROLE AS A SUPER TRAITOR. \
				Doing so may lead to administrative action being taken.",
				"Antagonist Introduction", "I understand.")

/datum/antagonist/revolutionary/get_antag_radio()
	return "Mercenary"
