/datum/outfit/admin/ert/mercenary
	name = "Mercenary Freelancer"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/swat/ert
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel
	l_hand = /obj/item/clothing/suit/space/void/freelancer
	r_hand = /obj/item/clothing/head/helmet/space/void/freelancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/colt)
	id = /obj/item/card/id/syndicate
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	l_pocket = /obj/item/tank/emergency_oxygen/double

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/gun/projectile/automatic/tommygun = 1,
		/obj/item/storage/belt/utility/full = 1,
		/obj/item/clothing/gloves/yellow = 1,
	)

	belt_contents = list(
		/obj/item/ammo_magazine/submachinedrum = 1,
		/obj/item/ammo_magazine/submachinemag = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/shield/energy = 1,
		/obj/item/material/knife/trench = 1
	)

	id_iff = IFF_FREELANCER

/datum/outfit/admin/ert/mercenary/get_id_access()
	return get_distress_access_lesser()

/datum/outfit/admin/ert/mercenary/specialist
	name = "Mercenary Freelancer Medic"

	glasses = /obj/item/clothing/glasses/hud/health/aviator
	belt = /obj/item/storage/belt/medical/first_responder/combat
	gloves = /obj/item/clothing/gloves/latex

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/gun/projectile/automatic/tommygun = 1,
		/obj/item/ammo_magazine/submachinemag = 2,
		/obj/item/ammo_magazine/c45m = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/coagzolug = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/material/knife/trench = 1
	)

/datum/outfit/admin/ert/mercenary/engineer
	name = "Mercenary Freelancer Combat Engineer"

	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/duffel
	gloves = /obj/item/clothing/gloves/yellow
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
								/obj/item/plastique = 5
							)

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/projectile/shotgun/pump/combat/sol = 1,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/landmine/frag = 1,
		/obj/item/landmine/emp = 1,
		/obj/item/storage/belt/utility/very_full = 1,
		/obj/item/gun/projectile/colt = 1
	)

	belt_contents = list(
		/obj/item/material/knife/trench = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/shield/energy = 1,
		/obj/item/device/flashlight/flare = 1,
	)

/datum/outfit/admin/ert/mercenary/leader
	name = "Mercenary Freelancer Leader"
	l_hand = /obj/item/gun/projectile/automatic/rifle/shorty
	r_hand = null
	back = /obj/item/rig/merc/distress
	suit_store = null
	suit = null
	head = null
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/revolver = 1)

	backpack_contents = list()

	belt_contents = list(
		/obj/item/ammo_magazine/c762 = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/shield/energy = 1,
		/obj/item/ammo_magazine/a357 = 2,
		/obj/item/material/knife/trench = 1
	)
