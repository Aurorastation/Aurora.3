/datum/job/ai
	title = "AI"
	flag = AI
	departments = list(DEPARTMENT_EQUIPMENT = JOBROLE_SUPERVISOR)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = null // Not used by AI, see get_total_positions and is_position_available below
	spawn_positions = null // Not used by AI, see get_spawn_positions below
	selection_color = "#6c5b73"
	intro_prefix = "the"
	supervisors = "your laws"
	minimal_player_age = 7
	account_allowed = 0
	economic_modifier = 0

/datum/job/ai/equip(var/mob/living/carbon/human/H, var/alt_title)
		if(!H)	return 0
		return 1

/datum/job/ai/get_spawn_positions()
	var/spawnpoints = 0
	for(var/obj/effect/landmark/start/sloc in GLOB.landmarks_list)
		if (sloc.name == "AI")
			spawnpoints++
	return spawnpoints

/datum/job/ai/get_total_positions()
	var/active_ai_count = 0
	for(var/mob/living/silicon/ai/ai in GLOB.silicon_mob_list)
		if(ai.client)
			active_ai_count++
	return GLOB.empty_playable_ai_cores.len + active_ai_count

/datum/job/ai/is_position_available()
	return GLOB.empty_playable_ai_cores.len > 0

/datum/job/cyborg
	title = "Cyborg"
	flag = CYBORG
	departments = SIMPLEDEPT(DEPARTMENT_EQUIPMENT)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#6c5b73"
	minimal_player_age = 1
	alt_titles = list("Robot")
	account_allowed = 0
	economic_modifier = 0

/datum/job/cyborg/equip(var/mob/living/carbon/human/H, var/alt_title)
	if(!H)
		return FALSE
	return TRUE

/datum/job/cyborg/equip_preview(mob/living/carbon/human/H, datum/preferences/prefs, var/alt_title, var/faction_override)
	var/equip_preview_mob = prefs.equip_preview_mob

	if(equip_preview_mob & EQUIP_PREVIEW_JOB_HAT)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), slot_head)

	if(equip_preview_mob & EQUIP_PREVIEW_JOB_SUIT)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/cardborg(H), slot_wear_suit)

	return TRUE
