/datum/outfit/admin/ert/nanotrasen
	name = "NanoTrasen ERT Responder"

	uniform = /obj/item/clothing/under/ert
	suit = null
	suit_store = null
	belt = /obj/item/storage/belt/military
	shoes = /obj/item/clothing/shoes/swat
	accessory = /obj/item/clothing/accessory/storage/black_vest
	gloves = null
	id = /obj/item/card/id/ert
	back = /obj/item/rig/ert/security

	l_ear = /obj/item/device/radio/headset/ert

	belt_contents = list(
		/obj/item/handcuffs = 2,
		/obj/item/shield/riot/tact = 1,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/a556/ap = 1
	)

/datum/outfit/admin/ert/nanotrasen/get_id_access()
	return get_all_station_access() | get_centcom_access("Emergency Response Team")

/datum/outfit/admin/ert/nanotrasen/specialist
	name = "NanoTrasen ERT Engineer Specialist"

	belt = /obj/item/storage/belt/utility/full
	back = /obj/item/rig/ert/engineer

	belt_contents = null

/datum/outfit/admin/ert/nanotrasen/specialist/medical
	name = "NanoTrasen ERT Medical Specialist"

	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/rig/ert/medical
	r_hand = /obj/item/storage/firstaid/combat

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/combat/empty = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1	
	)

/datum/outfit/admin/ert/nanotrasen/leader
	name = "NanoTrasen ERT Leader"

	back = /obj/item/rig/ert

	belt_contents = list(
		/obj/item/handcuffs = 1,
		/obj/item/shield/riot/tact = 1,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/a556/ap = 2
	)
