/datum/job/merchant
	title = "Merchant"
	faction = "Station"
	flag = MERCHANT
	department_flag = CIVILIAN
	total_positions = 0
	spawn_positions = 0
	supervisors = "yourself and the market"
	minimal_player_age = 10
	economic_modifier = 5
	ideal_character_age = 30

	create_record = FALSE
	account_allowed = TRUE
	public_account = FALSE
	initial_funds_override = 2500

	access = list(access_merchant)
	minimal_access = list(access_merchant)

	latejoin_at_spawnpoints = TRUE

	outfit = /datum/outfit/job/merchant
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

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

	uniform =/obj/item/clothing/under/suit_jacket/charcoal
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/that
	id = /obj/item/card/id/merchant
	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/merchant
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	tablet = /obj/item/modular_computer/handheld/preset/civilian
	r_pocket = /obj/item/device/price_scanner

/datum/outfit/merchant_assistant
	name = "Merchant's Assistant"
	id = /obj/item/card/id/merchant
	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/merchant
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	tablet = /obj/item/modular_computer/handheld/preset/civilian
	r_pocket = /obj/item/device/price_scanner
	belt = /obj/item/storage/belt/utility/full
	uniform = list(
		/obj/item/clothing/under/det/black,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/tan,
		)
	shoes = list(
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/cowboy
		)
	head = list(
		/obj/item/clothing/head/fez,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/cowboy,
		/obj/item/clothing/head/turban/grey,
		/obj/item/clothing/head/ushanka
		)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green,
		/obj/item/clothing/suit/storage/toggle/trench,
		/obj/item/clothing/suit/storage/hooded/wintercoat
		)
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/wallet/random = 1
		)

/datum/outfit/merchant_assistant/get_id_rank(mob/living/carbon/human/H)
	return "Merchant's Assistant"

/datum/outfit/merchant_assistant/get_id_access()
	return list(access_merchant)
