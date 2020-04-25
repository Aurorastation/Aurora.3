var/datum/antagonist/revolutionary/revs

/datum/antagonist/revolutionary
	id = MODE_REVOLUTIONARY
	role_text = "Head Revolutionary"
	role_text_plural = "Revolutionaries"
	bantype = "revolutionary"
	feedback_tag = "rev_objective"
	antag_indicator = "rev_head"
	welcome_text = "You are a Head Revolutionary! Your goal is to create and progress a story. <b>Use the uplink disguised as a station-bounced radio in your backpack to help start your story!</b>"
	victory_text = "The heads of staff were relieved of their posts! The revolutionaries win!"
	loss_text = "The heads of staff managed to stop the revolution!"
	victory_feedback_tag = "win - heads killed"
	loss_feedback_tag = "loss - rev heads killed"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	antaghud_indicator = "hudrevolutionary"

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	//Inround revs.
	faction_role_text = "Revolutionary"
	faction_descriptor = "Revolution"
	faction_verb = /mob/living/proc/convert_to_rev
	faction_welcome = "Help the cause overturn the ruling class. Do not harm your fellow freedom fighters."
	faction_indicator = "rev"
	faction_invisible = TRUE

	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Detective", "Forensic Technician", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Captain", "Head of Security", "Internal Affairs Agent")
	required_age = 31

/datum/antagonist/revolutionary/New()
	..()
	revs = src

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
	INVOKE_ASYNC(src, .proc/alert_rev_status, player)
	return TRUE

/datum/antagonist/revolutionary/proc/alert_rev_status(var/mob/living/carbon/human/player) //This is so dumb.
	alert(player, "As a Head Revolutionary, you are given an uplink with a lot of telecrystals. \
				Your goal is to create and progress a story. Use the announcement device you spawn with to whip people into a frenzy, \
				and the uplink disguised as a radio to equip them. DO NOT PLAY THIS ROLE AS A SUPER TRAITOR. \
				Doing so may lead to administrative action being taken.",
				"Antagonist Introduction", "I understand.")