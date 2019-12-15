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
	minimal_player_age = 10
	economic_modifier = 5
	ideal_character_age = 30
	create_record = 0
	account_allowed = 0

	access = list(access_merchant)
	minimal_access = list(access_merchant)

	latejoin_at_spawnpoints = TRUE

	outfit = /datum/outfit/job/merchant

/datum/job/merchant/announce(mob/living/carbon/human/H)
	to_chat(H,"You are a merchant heading to the [station_name()] to make profit, your main objective is to sell and trade with the crew.")

/datum/job/merchant/New()
	..()
	if(prob(config.merchant_chance))
		spawn_positions = 1
		total_positions = 1

/datum/outfit/job/merchant
	name = "Merchant"
	jobtype = /datum/job/merchant

	uniform =/obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/brown
	id = /obj/item/card/id/merchant
	pda = /obj/item/device/pda/merchant
	r_pocket = /obj/item/device/price_scanner

/datum/outfit/job/merchant/assistant
	name = "Merchant's Assistant"

/datum/outfit/job/merchant/assistant/get_id_rank(mob/living/carbon/human/H)
	return "Merchant's Assistant"