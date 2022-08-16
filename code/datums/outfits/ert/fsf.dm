/datum/outfit/admin/ert/fsf
	name = "Free Solarian Fleets Marine"

	uniform = /obj/item/clothing/under/rank/sol/marine
	shoes = /obj/item/clothing/shoes/swat/ert
	gloves = /obj/item/clothing/gloves/swat/ert
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel/norm
	head = /obj/item/clothing/head/helmet/space/void/sol/fsf
	suit = /obj/item/clothing/suit/space/void/sol/fsf
	suit_store = /obj/item/gun/projectile/automatic/rifle/sol
	id = /obj/item/card/id/distress/fsf
	l_pocket = /obj/item/tank/emergency_oxygen/double

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/melee/energy/sword/knife/sol = 1
    )

	belt_contents = list(
		/obj/item/ammo_magazine/c762/sol = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/frag = 1
    )

	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1)

	id_iff = IFF_FSF

/datum/outfit/admin/ert/fsf/get_id_access()
	return get_distress_access_lesser()

/datum/outfit/admin/ert/fsf/medic
	name = "Free Solarian Fleets Medic"

	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/storage/backpack/satchel/med
	glasses = /obj/item/clothing/glasses/hud/health
	suit_store = /obj/item/gun/projectile/shotgun/pump/combat/sol
	gloves = /obj/item/clothing/gloves/latex

	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/energy/sword/knife/sol = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

/datum/outfit/admin/ert/fsf/sapper
	name = "Free Solarian Fleets Sapper"

	back = /obj/item/storage/backpack/industrial
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow
	back = /obj/item/storage/backpack/duffel/eng
	suit_store = /obj/item/gun/projectile/shotgun/pump/combat/sol
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5
	)

	backpack_contents = list(
		/obj/item/melee/energy/sword/knife/sol = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/gun/projectile/pistol/sol = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/grenade/frag = 2
	)

	belt_contents = null

/datum/outfit/admin/ert/fsf/leader
	name = "Free Solarian Fleets Fireteam Leader"
	l_hand = /obj/item/gun/projectile/automatic/rifle/sol
	r_hand = null
	back = /obj/item/rig/military/fsf
	suit_store = null
	suit = null
	head = null

	backpack_contents = list()

	belt_contents = list(
		/obj/item/ammo_magazine/c762/sol = 1,
		/obj/item/melee/energy/sword/knife/sol = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/handcuffs/ziptie = 2
	)

/datum/outfit/admin/ert/fsf/synth
	name = "Free Solarian Fleets Synthetic Unit"

	uniform = /obj/item/clothing/under/rank/sol
	accessory = /obj/item/clothing/accessory/storage/webbingharness/pouches/ert
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol = 1, /obj/item/ammo_magazine/mc9mm = 2)
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/storage/belt/utility/very_full
	head = /obj/item/clothing/head/helmet/pilot
	suit = null
	suit_store = null
	l_pocket = null
	belt_contents = null

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/melee/energy/sword/knife/sol = 1,
		/obj/item/grenade/smokebomb = 2,
		/obj/item/device/binoculars = 1
	)
