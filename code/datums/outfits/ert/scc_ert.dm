/datum/outfit/admin/ert/scc
	name = "ERT Security Specialist (SCC)"

	uniform = /obj/item/clothing/under/rank/security
	belt = /obj/item/storage/belt/military
	shoes = /obj/item/clothing/shoes/swat
	accessory = /obj/item/clothing/accessory/storage/black_vest
	id = /obj/item/card/id/ert/scc
	back = /obj/item/rig/ert/scc/security

	l_ear = /obj/item/device/radio/headset/ert

	belt_contents = list(
		/obj/item/handcuffs = 2,
		/obj/item/shield/riot/tact = 1,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/a556/ap = 1
	)

/datum/outfit/admin/ert/scc/get_id_access()
	return get_all_station_access() | get_centcom_access("Emergency Response Team")

/datum/outfit/admin/ert/scc/engineer
	name = "ERT Engineering Specialist (SCC)"

	belt = /obj/item/storage/belt/utility/full
	back = /obj/item/rig/ert/scc/engineer

	belt_contents = null

/datum/outfit/admin/ert/scc/medic
	name = "ERT Medical Specialist (SCC)"

	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/rig/ert/scc/medical
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

/datum/outfit/admin/ert/scc/commander
	name = "ERT Commander (SCC)"

	back = /obj/item/rig/ert/scc
