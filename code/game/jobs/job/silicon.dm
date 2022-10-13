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
	for(var/obj/effect/landmark/start/sloc in landmarks_list)
		if (sloc.name == "AI")
			spawnpoints++
	return spawnpoints

/datum/job/ai/get_total_positions()
	var/active_ai_count = 0
	for(var/mob/living/silicon/ai/ai in silicon_mob_list)
		if(ai.client)
			active_ai_count++
	return empty_playable_ai_cores.len + active_ai_count

/datum/job/ai/is_position_available()
	return empty_playable_ai_cores.len > 0

/datum/job/ai/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/straight_jacket(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), slot_head)
	return 1
