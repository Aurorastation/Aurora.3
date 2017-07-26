/datum/job/merchant
	title = "Merchant"
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "yourself"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id
	minimal_player_age = 10
	economic_modifier = 5
	ideal_character_age = 30
	create_record = 0
	account_allowed = 0

	access = list(access_merchant)
	minimal_access = list(access_merchant)


/datum/job/merchant/equip(var/mob/living/carbon/human/H)
	if(!H)
		return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	return TRUE

/datum/job/merchant/New()
	..()
	if(prob(50))
		spawn_positions = 0