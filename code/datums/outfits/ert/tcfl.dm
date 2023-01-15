/datum/outfit/admin/ert/legion
	name = "TCFL Volunteer"

	head = /obj/item/clothing/head/beret/legion/field
	uniform = /obj/item/clothing/under/legion
	l_ear = /obj/item/device/radio/headset/legion
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/swat/ert
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	back = /obj/item/storage/backpack/legion
	id = /obj/item/card/id/distress/legion

	backpack_contents = null

	id_iff = IFF_TCFL

/datum/outfit/admin/ert/legion/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

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
	head = /obj/item/clothing/head/helmet/pilot/legion
	suit = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion/alt
	gloves = null
	back = null
	belt = /obj/item/storage/belt/security/tactical
	accessory = /obj/item/clothing/accessory/storage/webbingharness/pouches/ert
	accessory_contents = list(/obj/item/gun/energy/blaster/pilot_special = 1, /obj/item/device/binoculars = 1)

	backpack_contents = null

/datum/outfit/admin/ert/legion/sentinel
	name = "TCFL Sentinel"
	head = /obj/item/clothing/head/beret/legion/sentinel
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
		/obj/item/clothing/gloves/swat/ert = 1,
		/obj/item/material/knife/bayonet = 1
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
