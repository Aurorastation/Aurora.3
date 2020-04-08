/datum/outfit/admin/ert/legion
	name = "TCFL Volunteer"

	head = /obj/item/clothing/head/legion
	uniform = /obj/item/clothing/under/legion
	l_ear = /obj/item/device/radio/headset/legion
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/swat/ert
	glasses =  /obj/item/clothing/glasses/sunglasses/aviator
	back = /obj/item/storage/backpack/legion
	id = /obj/item/card/id/distress/legion

	backpack_contents = null

/datum/outfit/admin/ert/legion/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/legion/specialist
	name = "TCFL Legionnaire"
	accessory = /obj/item/clothing/accessory/legion/specialist

/datum/outfit/admin/ert/legion/leader
	name = "TCFL Prefect"
	accessory = /obj/item/clothing/accessory/legion

/datum/outfit/admin/ert/legion/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	.=..()
	var/obj/item/card/id/distress/legion/I = H.wear_id
	I.access += (access_cent_specops)

/datum/outfit/admin/ert/legion/pilot
	name = "TCFL Dropship Pilot"
	uniform = /obj/item/clothing/under/legion/pilot
	head = /obj/item/clothing/head/helmet/legion_pilot
	suit = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion
	gloves = null
	back = null
	belt = /obj/item/storage/belt/security/tactical
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/blaster/revolver/pilot  = 1)

/datum/outfit/admin/ert/legion/sentinel
	name = "TCFL Sentinel"
	head = /obj/item/clothing/head/legion/sentinel
	uniform = /obj/item/clothing/under/legion/sentinel
	suit = /obj/item/clothing/suit/storage/vest/legion
	gloves = null
	belt = /obj/item/storage/belt/security/tactical
	suit_store = /obj/item/gun/energy/blaster/rifle
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/blaster/revolver = 1)

	backpack_contents = list(
		/obj/item/gun/energy/blaster/carbine = 1,
		/obj/item/handcuffs/ziptie = 3,
		/obj/item/clothing/mask/gas/tactical = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/clothing/gloves/swat/ert = 1
	)

	belt_contents = list(
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/shield/energy/legion = 1,
		/obj/item/reagent_containers/spray/pepper = 1,
		/obj/item/grenade/flashbang = 2,
		/obj/item/melee/telebaton = 1
	)

/datum/outfit/admin/ert/legion/sentinel/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	.=..()
	var/obj/item/card/id/distress/legion/I = H.wear_id
	I.access += (access_cent_specops)