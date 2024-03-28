/obj/outfit/admin/ert/hephaestus
	name = "Hephaestus Asset Protection"
	uniform = /obj/item/clothing/under/rank/security/heph
	shoes = /obj/item/clothing/shoes/jackboots
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless
	)
	back = /obj/item/storage/backpack/satchel/heph
	suit = /obj/item/clothing/suit/space/void/hephaestus
	head = /obj/item/clothing/head/helmet/space/void/hephaestus
	belt = /obj/item/storage/belt/military
	l_ear = /obj/item/device/radio/headset/distress
	id = /obj/item/card/id/hephaestus
	mask = /obj/item/clothing/mask/gas/tactical
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	suit_store = /obj/item/gun/projectile/shotgun/pump/combat

	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/sec/lethal)
	belt_contents = list(
			/obj/item/shield/energy = 1,
			/obj/item/handcuffs/ziptie = 1,
			/obj/item/melee/baton/loaded = 1,
			/obj/item/grenade/flashbang = 2,
			/obj/item/ammo_magazine/c45m = 2
	)

	backpack_contents = list(
		/obj/item/gun/projectile/sec/lethal = 1,
		/obj/item/storage/box/shotgunammo = 1,
		/obj/item/storage/box/shotgunshells = 1
	)

	id_iff = IFF_HEPH

/obj/outfit/admin/ert/hephaestus/get_id_access()
	return get_distress_access()

/obj/outfit/admin/ert/hephaestuss/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/hephaestus/medic
	name = "Hephaestus Medic"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/latex/unathi
	)
	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/c45m = 3,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/gun/projectile/sec/lethal = 1,
		/obj/item/storage/box/shotgunammo = 1,
		/obj/item/storage/box/shotgunshells = 1
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

/obj/outfit/admin/ert/hephaestus/engi
	name = "Hephaestus Engineer"
	back = /obj/item/storage/backpack/duffel/heph
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu
	)

	backpack_contents = list(
		/obj/item/plastique = 3,
		/obj/item/ammo_magazine/c45m = 3,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/projectile/sec/lethal = 1,
		/obj/item/storage/box/shotgunammo = 1,
		/obj/item/storage/box/shotgunshells = 1
	)
	belt_contents = null

/obj/outfit/admin/ert/hephaestus/leader
	name = "Hephaestus Squad Leader"
	uniform = /obj/item/clothing/under/rank/captain/hephaestus
