/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	//alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Security Cadet", "Visitor")
	alt_titles = list("Visitor")

/datum/job/assistant/equip(var/mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/obj/item/clothing/under/color/grey/G = new /obj/item/clothing/under/color/grey(H)
	if(H.equip_to_slot_or_del(G, slot_w_uniform))
		G.autodrobe_no_remove = TRUE
	var/obj/item/clothing/shoes/black/B = new /obj/item/clothing/shoes/black(H)
	if(H.equip_to_slot_or_del(B, slot_shoes))
		B.autodrobe_no_remove = TRUE
	return TRUE

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
