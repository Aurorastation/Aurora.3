/datum/job/merchant
	title = "Merchant"
	faction = "Station"
	department = "Civilian"
	flag = MERCHANT
	department_flag = CIVILIAN
	total_positions = 0
	spawn_positions = 0
	supervisors = "yourself and the market"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/merchant
	minimal_player_age = 10
	economic_modifier = 5
	ideal_character_age = 30
	create_record = 0
	account_allowed = 0

	access = list(access_merchant)
	minimal_access = list(access_merchant)

	latejoin_at_spawnpoints = TRUE

/datum/job/merchant/equip(var/mob/living/carbon/human/H)
	if(!H)
		return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/merchant(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/device/price_scanner(H), slot_r_store)

	H << "You are a merchant heading to the [station_name()] to make profit, your main objective is to sell and trade with the crew."

	return TRUE

/datum/job/merchant/New()
	..()
	if(prob(config.merchant_chance))
		spawn_positions = 1
		total_positions = 1
