/datum/outfit/admin/ert/elyran_trooper
	name = "Elyran Navy Crewman"

	uniform = /obj/item/clothing/under/rank/elyran_fatigues
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/distress
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	id = /obj/item/card/id/ert
	head = /obj/item/clothing/head/helmet/space/void/valkyrie
	suit = /obj/item/clothing/suit/space/void/valkyrie
	mask = /obj/item/clothing/mask/gas
	back = /obj/item/tank/jetpack/carbondioxide
	suit_store = /obj/item/gun/projectile/plasma/bolter

	belt = /obj/item/storage/belt/military
	belt_contents = list(
			/obj/item/ammo_magazine/plasma/light = 3,
			/obj/item/ammo_magazine/c45m = 2,
			/obj/item/shield/energy = 1,
			/obj/item/melee/energy/sword = 1,
			/obj/item/grenade/frag = 1,
			/obj/item/grenade/flashbang = 1
	)


	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/sec/lethal = 1)

/datum/outfit/admin/ert/elyran_trooper/get_id_access()
	return get_distress_access()

/datum/outfit/admin/ert/elyran_trooper/leader
	name = "Elyran Navy Officer"

	uniform = /obj/item/clothing/under/rank/elyran_fatigues/commander

	belt_contents = list(
			/obj/item/ammo_magazine/plasma = 5,
			/obj/item/shield/energy = 1,
			/obj/item/melee/energy/sword = 1,
			/obj/item/grenade/frag = 2,
			/obj/item/grenade/flashbang = 2
	)

	l_hand = /obj/item/gun/projectile/plasma


/datum/outfit/admin/ert/elyran_trooper/engineer
	name = "Elyran Navy Engineer"

	back = /obj/item/storage/backpack/duffel/eng
	belt = /obj/item/storage/belt/utility/very_full
	r_pocket = /obj/item/plastique

	backpack_contents = list(
		/obj/item/tank/oxygen = 1,
		/obj/item/clothing/gloves/yellow = 1,
		/obj/item/melee/energy/sword = 1
	)

	belt_contents = null

/datum/outfit/admin/ert/elyran_trooper/medical
	name = "Elyran Navy Corpsman"

	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/storage/backpack/satchel/med
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex

	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/c45m = 3,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/energy/sword = 1
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

/datum/outfit/admin/ert/elyran_trooper/heavy
	name = "Elyran Navy Heavy Specialist"

	head = null
	suit = null
	gloves = null
	shoes = /obj/item/clothing/shoes/swat
	mask = /obj/item/clothing/mask/gas/tactical
	back = /obj/item/rig/elyran
	l_pocket = /obj/item/plastique
	r_pocket = /obj/item/crowbar/red
	belt_contents = list(
			/obj/item/ammo_magazine/plasma = 5,
			/obj/item/shield/energy = 1,
			/obj/item/melee/energy/sword = 1,
			/obj/item/grenade/frag = 2,
			/obj/item/grenade/flashbang = 2
	)

	l_hand = /obj/item/gun/projectile/plasma

	accessory = /obj/item/clothing/accessory/storage/black_vest
	accessory_contents = list(/obj/item/device/flash = 1, /obj/item/handcuffs = 2, /obj/item/gun/projectile/pistol = 1)
