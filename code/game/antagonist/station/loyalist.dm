var/datum/antagonist/loyalists/loyalists

/datum/antagonist/loyalists
	id = MODE_LOYALIST
	role_text = "Head Loyalist"
	role_text_plural = "Loyalists"
	bantype = "loyalist"
	feedback_tag = "loyalist_objective"
	antag_indicator = "fellowshiphead"
	welcome_text = "You are one of the Loyalist leaders! You are seeking to protect the establishment at all costs. Give your hearts for the Company! <b>Use the uplink disguised as a station-bounced radio in your backpack to help start your story!</b>"
	victory_text = "The Revolutionaries failed in their goals! You won!"
	loss_text = "The Revolutionaries put an end to your Loyalists in one fell swoop."
	victory_feedback_tag = "You thwarted the Revolutionaries in their devious ends."
	loss_feedback_tag = "You were thwarted by the Revolutionaries."
	antaghud_indicator = "fellowship"

	hard_cap = 3
	hard_cap_round = 4
	initial_spawn_req = 1
	initial_spawn_target = 4

	// Inround loyalists.
	faction_role_text = "Loyalist"
	faction_descriptor = "Loyalists"
	faction_verb = /mob/living/proc/convert_to_loyalist
	faction_welcome = "You have decided to defend the establishment, no matter what it takes.. Follow your leaders' instructions and try to achieve the Loyalists' goals."
	faction_indicator = "fellowship"
	faction_invisible = FALSE

	restricted_jobs = list("AI", "Cyborg", "Merchant")
	protected_jobs = list("Lab Assistant", "Medical Intern", "Engineering Apprentice", "Assistant", "Security Cadet")
	required_age = 31

/datum/antagonist/loyalists/New()
	..()
	loyalists = src

/datum/antagonist/loyalists/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(!player.mind || player.stat == DEAD || !(player.mind.assigned_role in command_positions))
			continue
		var/datum/objective/protect/loyal_obj = new
		loyal_obj.target = player.mind
		loyal_obj.explanation_text = "Protect [player.real_name], the [player.mind.assigned_role]."
		global_objectives += loyal_obj

/datum/antagonist/loyalists/equip(var/mob/living/carbon/human/player)

	if(!..())
		return FALSE

	if(!player.back)
		player.equip_to_slot_or_del(new /obj/item/storage/backpack(player), slot_back) // if they have no backpack, spawn one
	player.equip_to_slot_or_del(new /obj/item/device/announcer(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/device/special_uplink/rev(player, player.mind), slot_in_backpack)

	give_codewords(player)
	INVOKE_ASYNC(src, PROC_REF(alert_loyalist_status), player)
	return TRUE

/datum/antagonist/loyalists/proc/alert_loyalist_status(var/mob/living/carbon/human/player) //This is still dumb but it works
	alert(player, "As a Head Loyalist you are given an uplink with a lot of telecrystals. \
				Your goal is to create and progress a story. Use the announcement device you spawn with to whip people into a frenzy, \
				and the uplink disguised as a radio to equip them. DO NOT PLAY THIS ROLE AS A SUPER TRAITOR. \
				Doing so may lead to administrative action being taken.",
				"Antagonist Introduction", "I understand.")
