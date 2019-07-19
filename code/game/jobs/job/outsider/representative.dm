/datum/job/representative
	title = "Corporate Liaison"
	flag = LAWYER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials"
	selection_color = "#dddddd"
	economic_modifier = 7
	latejoin_at_spawnpoints = TRUE
	access = list(access_lawyer, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_heads)
	outfit = /datum/outfit/job/representative
	alt_titles = list("Tau Ceti Representative","Sol Consular Officer", "PRA Consular Officer")
	outfit = /datum/outfit/job/representative
	alt_outfits = list(
		"Tau Ceti Representative"=/datum/outfit/job/representative/ceti,
		"Sol Consular Officer"=/datum/outfit/job/representative/sol,
		"PRA Consular Officer"= /datum/outfit/job/representative/pra
		)

/datum/outfit/job/representative
	name = "Corporate Liaison"
	jobtype = /datum/job/representative

	head = /obj/item/clothing/head/beret/liaison
	uniform = /obj/item/clothing/under/rank/liaison
	suit = /obj/item/clothing/suit/storage/toggle/liaison
	pda = /obj/item/device/pda/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_ear = /obj/item/device/radio/headset/representative
	l_hand =  /obj/item/weapon/storage/briefcase
	backpack_contents = list(
		/obj/item/weapon/gun/energy/pistol = 1
	)

/datum/outfit/job/representative/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		send_representative_mission(H)

	return TRUE

/datum/outfit/job/representative/proc/get_objectives(mob/living/carbon/human/H)

/datum/outfit/job/representative/ceti
	name = "Tau Ceti Representative"

	uniform = /obj/item/clothing/under/lawyer/blue
	head = null
	suit = null
	backpack_contents = list(
		/obj/item/clothing/accessory/tc_pin = 1,
		/obj/item/weapon/storage/box/ceti_visa = 1,
		/obj/item/weapon/gun/energy/pistol = 1
	)

/datum/outfit/job/representative/sol
	name = "Sol Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/navy
	head = null
	suit = null
	backpack_contents = list(
		/obj/item/clothing/accessory/sol_pin = 1,
		/obj/item/weapon/storage/box/sol_visa = 1,
		/obj/item/weapon/gun/projectile/pistol/sol = 1
	)

/datum/outfit/job/representative/pra
	name = "PRA Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/checkered
	head = /obj/item/clothing/head/fedora
	suit = null
	backpack_contents = list(
		/obj/item/clothing/accessory/hadii_pin = 1,
		/obj/item/weapon/storage/box/hadii_card = 1,
		/obj/item/weapon/gun/projectile/pistol = 1
	)