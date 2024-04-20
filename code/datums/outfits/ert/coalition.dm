/obj/outfit/admin/ert/coalition
	name = "Coalition Ranger ERT"
	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/distress
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	id = /obj/item/card/id/ert
	head = /obj/item/clothing/head/helmet/space/void/coalition
	suit = /obj/item/clothing/suit/space/void/coalition
	mask = /obj/item/clothing/mask/gas
	back = /obj/item/tank/jetpack/carbondioxide
	suit_store = /obj/item/gun/projectile/automatic/rifle/shorty
	belt = /obj/item/storage/belt/military
	belt_contents = list(
			/obj/item/ammo_magazine/c762 = 3,
			/obj/item/ammo_magazine/c45m = 2,
			/obj/item/material/knife/tacknife = 1,
			/obj/item/grenade/frag = 1,
			/obj/item/grenade/flashbang = 1
	)
	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/colt = 1)

/obj/outfit/admin/ert/coalition/get_id_access()
	return list(ACCESS_DISTRESS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_COALITION, ACCESS_COALITION_NAVY)

/obj/outfit/admin/ert/coalition/medic
	name = "Coalition Medic"
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
		/obj/item/material/knife/tacknife = 1
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

/obj/outfit/admin/ert/coalition/sapper
	name = "Coalition Sapper"
	back = /obj/item/storage/backpack/duffel/eng
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow
	suit_store = /obj/item/gun/projectile/shotgun/pump/combat
	backpack_contents = list(
		/obj/item/plastique = 3,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/ammo_magazine/c45m = 3,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/grenade/frag = 2
	)

	belt_contents = null

/obj/outfit/admin/ert/coalition/leader
	name = "Coalition Team Leader"
	head = null
	suit = null
	gloves = null
	shoes = /obj/item/clothing/shoes/combat
	mask = /obj/item/clothing/mask/gas/tactical
	back = /obj/item/rig/gunslinger/equipped/ert
	suit_store = /obj/item/tank/oxygen
	l_hand = /obj/item/gun/projectile/automatic/rifle/shorty
	belt_contents = list(
			/obj/item/ammo_magazine/plasma = 3,
			/obj/item/ammo_magazine/c45m = 2,
			/obj/item/material/knife/tacknife = 1,
			/obj/item/grenade/frag = 1,
			/obj/item/grenade/flashbang = 1
	)

/obj/outfit/admin/ert/konyang
	name = "KASF Emergency Responder"
	uniform = /obj/item/clothing/under/rank/konyang/space
	suit = /obj/item/clothing/suit/space/void/sol/konyang
	head = /obj/item/clothing/head/helmet/space/void/sol/konyang
	shoes = /obj/item/clothing/shoes/magboots
	back = /obj/item/tank/jetpack/carbondioxide
	l_pocket = /obj/item/tank/emergency_oxygen/double
	r_pocket = /obj/item/crowbar/red
	l_ear = /obj/item/device/radio/headset/distress
	gloves = /obj/item/clothing/gloves/swat/ert
	mask = /obj/item/clothing/mask/gas/tactical
	suit_store = /obj/item/gun/projectile/automatic/rifle/konyang/k556
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/sol/konyang = 1)
	belt = /obj/item/storage/belt/military
	id = /obj/item/card/id/ert

	belt_contents = list(
		/obj/item/ammo_magazine/a556/k556 = 2,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/grenade/frag = 1,
		/obj/item/melee/energy/sword/knife/sol = 1
	)

/obj/outfit/admin/ert/konyang/get_id_access()
	return list(ACCESS_DISTRESS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_COALITION, ACCESS_COALITION_NAVY, ACCESS_KONYANG_POLICE)

/obj/outfit/admin/ert/konyang/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H.isSynthetic())
		H.equip_to_slot_or_del(new /obj/item/device/suit_cooling_unit(H), slot_back)

/obj/outfit/admin/ert/konyang/medic
	name = "KASF Medic"
	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/storage/backpack/satchel/med
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex

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

	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/mc9mm = 2,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/melee/energy/sword/knife/sol = 1
	)

/obj/outfit/admin/ert/konyang/sapper
	name = "KASF Sapper"
	back = /obj/item/storage/backpack/industrial
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow
	suit_store = /obj/item/gun/projectile/automatic/rifle/shotgun/konyang
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
		/obj/item/plastique = 5,
		/obj/item/ammo_magazine/konyang_shotgun = 2
	)
	backpack_contents = list(
		/obj/item/ammo_magazine/mc9mm = 3,
		/obj/item/gun/projectile/pistol/sol/konyang = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/grenade/frag = 2
	)

	belt_contents = null

/obj/outfit/admin/ert/konyang/leader
	name = "KASF Officer"
	uniform = /obj/item/clothing/under/rank/konyang/space/officer
