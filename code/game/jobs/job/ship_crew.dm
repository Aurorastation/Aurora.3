/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	intro_prefix = "an"
	supervisors = "absolutely everyone"
	selection_color = "#949494"
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
	title = "Off-Duty Crew Member"
	flag = VISITOR
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/visitor

/datum/outfit/job/visitor
	name = "Off-Duty Crew Member"
	jobtype = /datum/job/visitor

	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/black

/datum/outfit/job/visitor/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!H)
		return
	if(isvaurca(H, TRUE))
		var/citizenship = H.citizenship
		H.equip_to_slot_or_del(new /obj/item/clothing/under/gearharness(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		switch(citizenship)
			if(CITIZENSHIP_ZORA)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec(H), slot_back)
			if(CITIZENSHIP_KLAX)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/klax(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder/klax(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder/klax(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/klax(H), slot_back)
			if(CITIZENSHIP_CTHUR)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/cthur(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder/cthur(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder/cthur(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/cthur(H), slot_back)
			if(CITIZENSHIP_BIESEL)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/biesel(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec(H), slot_back)
			if(CITIZENSHIP_IZWESKI)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/hegemony(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder/klax(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder/klax(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/klax(H), slot_back)
			if(CITIZENSHIP_NRALAKK)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/nralakk(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder/nralakk(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder/nralakk(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/cthur(H), slot_back)
/datum/outfit/job/visitor/passenger
	name = "Passenger"
	jobtype = /datum/job/passenger

/datum/job/passenger
	title = "Passenger"
	flag = PASSENGER
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/visitor/passenger
	blacklisted_species = null
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)
