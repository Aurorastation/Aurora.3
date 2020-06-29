var/datum/antagonist/loyalists/loyalists

/datum/antagonist/loyalists
	id = MODE_LOYALIST
	role_text = "Head Fellow"
	role_text_plural = "Fellowship"
	bantype = "loyalist"
	feedback_tag = "loyalist_objective"
	antag_indicator = "fellowshiphead"
	welcome_text = "You are one of the Fellowship leaders! Your goal is your choosing but you are a subversion of the Aurora Crew, you must lead your branch of the Fellowship and progress a story. <b>Use the uplink disguised as a station-bounced radio in your backpack to help start your story!</b>"
	victory_text = "The Contenders failed in their goals! You won!"
	loss_text = "The Contenders put an end to your Fellowship in one fell swoop."
	victory_feedback_tag = "You thwarted the Contenders in their devious ends."
	loss_feedback_tag = "You were thwarted by the Contenders."
	antaghud_indicator = "fellowship"

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	// Inround loyalists.
	faction_role_text = "Fellow"
	faction_descriptor = "Fellowship"
	faction_verb = /mob/living/proc/convert_to_loyalist
	faction_welcome = "You have joined a budding fellowship under the forward-thinking lead of a Fellowship leader. Follow their instructions and try to achieve the Fellowship's goals."
	faction_indicator = "fellowship"
	faction_invisible = FALSE

	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Detective", "Forensic Technician", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Captain", "Head of Security")
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

/datum/antagonist/loyalists/can_become_antag(var/datum/mind/player)
	if(!..())
		return FALSE
	for(var/obj/item/implant/mindshield/L in player.current)
		if(L?.imp_in == player.current)
			return FALSE
	return TRUE

/datum/antagonist/loyalists/equip(var/mob/living/carbon/human/player)

	if(!..())
		return FALSE

	if(!player.back)
		player.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(player), slot_back) // if they have no backpack, spawn one
	player.equip_to_slot_or_del(new /obj/item/device/announcer(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/device/special_uplink/rev(player, player.mind), slot_in_backpack)

	give_codewords(player)
	INVOKE_ASYNC(src, .proc/alert_fellow_status, player)
	return TRUE

/datum/antagonist/loyalists/proc/alert_fellow_status(var/mob/living/carbon/human/player) //This is still dumb but it works
	alert(player, "As a Head Fellow you are given an uplink with a lot of telecrystals. \
				Your goal is to create and progress a story. Use the announcement device you spawn with to whip people into a frenzy, \
				and the uplink disguised as a radio to equip them. DO NOT PLAY THIS ROLE AS A SUPER TRAITOR. \
				Doing so may lead to administrative action being taken.",
				"Antagonist Introduction", "I understand.")
