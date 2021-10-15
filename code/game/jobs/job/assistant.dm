/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	intro_prefix = "an"
	supervisors = "absolutely everyone"
	selection_color = "#90524b"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/datum/job/assistant/get_access(selected_title)
	if(config.assistant_maint && selected_title == "Assistant")
		return list(access_maint_tunnels)
	else
		return list()

/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/black

/datum/job/visitor
	title = "Visitor"
	flag = VISITOR
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#90524b"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/visitor
	blacklisted_species = null

/datum/outfit/job/visitor
	name = "Visitor"
	jobtype = /datum/job/visitor

	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/black

/datum/outfit/job/visitor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H && !visualsOnly)
		if(isvaurca(H, TRUE))

			H.unEquip(H.shoes)
			qdel(H.wear_mask)
			var/obj/item/organ/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
			H.internal = preserve
			H.internals.icon_state = "internal1"

			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder(H), slot_wear_suit)
		
	..()
