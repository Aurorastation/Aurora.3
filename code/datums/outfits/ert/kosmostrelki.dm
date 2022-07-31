/datum/outfit/admin/ert/pra_cosmonaut
	name = "Kosmostrelki Trooper"

	id = /obj/item/card/id/ert
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/black/tajara
	uniform = /obj/item/clothing/under/tajaran/cosmonaut
	l_ear = /obj/item/device/radio/headset/distress
	head = /obj/item/clothing/head/helmet/space/void/pra
	suit = /obj/item/clothing/suit/space/void/pra
	suit_store = /obj/item/tank/oxygen/red

	belt = /obj/item/storage/belt/military
	belt_contents = list(
						/obj/item/ammo_magazine/boltaction = 5,
						/obj/item/grenade/smokebomb = 1,
						/obj/item/ammo_magazine/mc9mm = 1,
						/obj/item/gun/projectile/pistol/adhomai = 1,
						/obj/item/material/knife/trench = 1
						)

	back = /obj/item/gun/projectile/automatic/rifle/adhomian
	accessory = /obj/item/clothing/accessory/badge/hadii_card
	r_pocket = /obj/item/crowbar/red

/datum/outfit/admin/ert/pra_cosmonaut/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/pra_cosmonaut/commissar
	name = "Kosmostrelki Commissar"

	uniform = /obj/item/clothing/under/tajaran/cosmonaut/commissar
	belt_contents = list(
						/obj/item/ammo_magazine/a50 = 4,
						/obj/item/grenade/smokebomb = 2,
						/obj/item/grenade/frag = 1,
						/obj/item/plastique = 1,
						/obj/item/material/knife/trench = 1
						)

	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
						/obj/item/book/manual/pra_manifesto = 1,
						/obj/item/storage/box/hadii_card = 1,
						/obj/item/gun/projectile/deagle/adhomai = 1,
						/obj/item/clothing/accessory/holster/hip/brown = 1,
						/obj/item/clothing/head/tajaran/cosmonaut_commissar = 1
						)

	l_pocket = /obj/item/device/megaphone
	accessory = /obj/item/clothing/accessory/hadii_pin

/datum/outfit/admin/ert/pra_cosmonaut/commander
	name = "Kosmostrelki Commander"

	back = /obj/item/storage/backpack/satchel/leather

	belt_contents = list(
						/obj/item/ammo_magazine/mc9mm = 2,
						/obj/item/ammo_magazine/submachinemag = 2,
						/obj/item/grenade/frag = 2,
						/obj/item/grenade/smokebomb = 1,
						/obj/item/gun/projectile/pistol/adhomai = 1,
						/obj/item/material/knife/trench = 1
						)

	backpack_contents = list(
						/obj/item/gun/projectile/automatic/tommygun = 1,
						/obj/item/clothing/accessory/holster/hip/brown = 1,
						/obj/item/device/binoculars = 1,
						/obj/item/ammo_magazine/submachinedrum = 1)

	l_pocket = /obj/item/device/megaphone

/datum/outfit/admin/ert/pra_cosmonaut/tesla
	name = "Tesla Trooper"
	r_hand = /obj/item/gun/energy/rifle/icelance
	l_hand = /obj/item/rig/tesla
	head = null
	suit = null
	suit_store = null
	back = null
	shoes = null
	gloves = null
	belt_contents = list(
						/obj/item/ammo_magazine/mc9mm = 4,
						/obj/item/grenade/frag = 2,
						/obj/item/grenade/smokebomb = 1,
						/obj/item/gun/projectile/pistol/adhomai = 1,
						/obj/item/material/knife/trench = 1
						)

/datum/outfit/admin/ert/pra_cosmonaut/tesla/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/tesla/advanced(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()

/datum/outfit/admin/ert/pra_cosmonaut/medic
	name = "Kosmostrelki Combat Medic"

	gloves = /obj/item/clothing/gloves/latex/nitrile/tajara

	glasses = /obj/item/clothing/glasses/hud/health

	belt = /obj/item/storage/belt/medical/first_responder/combat

	back = /obj/item/storage/backpack/satchel/leather

	backpack_contents = list(
		/obj/item/gun/projectile/automatic/mini_uzi = 1,
		/obj/item/ammo_magazine/c45uzi = 2,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/flashlight/pen = 1,
		/obj/item/gun/projectile/pistol/adhomai = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/device/healthanalyzer = 1
	)

/datum/outfit/admin/ert/pra_cosmonaut/engineer
	name = "Kosmostrelki Sapper"

	gloves = /obj/item/clothing/gloves/yellow/specialt

	glasses = /obj/item/clothing/glasses/welding

	belt = /obj/item/storage/belt/utility/very_full

	back = /obj/item/storage/backpack/duffel/eng

	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)

	backpack_contents = list(
		/obj/item/gun/projectile/shotgun/pump/rifle/obrez = 1,
		/obj/item/ammo_magazine/boltaction = 4,
		/obj/item/gun/projectile/pistol/adhomai = 1,
		/obj/item/material/knife/trench = 1
	)

	belt_contents = null
