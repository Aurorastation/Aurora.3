/obj/outfit/admin/ert/dominia
	name = "Imperial Fleet Responder"
	uniform = /obj/item/clothing/under/dominia/fleet/armsman
	suit = /obj/item/clothing/suit/space/void/dominia/voidsman
	head = /obj/item/clothing/head/helmet/space/void/dominia/voidsman
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/safety/goggles/tactical/generic
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/tank/jetpack/carbondioxide
	r_pocket = /obj/item/tank/emergency_oxygen/double
	l_pocket = /obj/item/crowbar/red
	suit_accessory = /obj/item/clothing/accessory/dominia
	id = /obj/item/card/id/imperial_fleet
	l_ear = /obj/item/device/radio/headset/distress
	mask = /obj/item/clothing/mask/gas
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(
		/obj/item/gun/projectile/pistol/dominia = 1
	)
	suit_store = /obj/item/gun/projectile/automatic/rifle/dominia
	belt = /obj/item/storage/belt/military
	belt_contents = list(
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/c45m/dominia = 1,
		/obj/item/shield/energy/dominia = 1,
		/obj/item/material/knife/bayonet = 1,
		/obj/item/grenade/frag = 1,
		/obj/item/handcuffs/ziptie = 1
	)

/obj/outfit/admin/ert/dominia/get_id_access()
	return list(ACCESS_DISTRESS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP)

/obj/outfit/admin/ert/dominia/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H?.shoes)
		var/obj/item/clothing/shoes/magboots/boots = new(H)
		H.equip_to_slot_if_possible(boots, slot_shoes)

/obj/outfit/admin/ert/dominia/medic
	name = "Imperial Fleet Medic"
	uniform = /obj/item/clothing/under/dominia/fleet
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex
	belt = /obj/item/storage/belt/medical/first_responder/combat
	back = /obj/item/storage/backpack/dominia
	suit_store = /obj/item/gun/projectile/automatic/tommygun/dom
	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/ammo_magazine/c45m/dominia = 1,
		/obj/item/ammo_magazine/submachinemag = 2,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/material/knife/bayonet= 1,
		/obj/item/roller = 1
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

/obj/outfit/admin/ert/dominia/engi
	name = "Imperial Fleet Sapper"
	uniform = /obj/item/clothing/under/dominia/fleet
	back = /obj/item/storage/backpack/duffel/eng
	belt = /obj/item/storage/belt/utility/very_full
	gloves = /obj/item/clothing/gloves/yellow
	glasses = /obj/item/clothing/glasses/welding/superior
	backpack_contents = list(
		/obj/item/plastique = 3,
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/c45m/dominia = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/grenade/frag = 2
	)
	belt_contents = null

/obj/outfit/admin/ert/dominia/officer
	name = "Imperial Fleet Officer"
	uniform = /obj/item/clothing/under/dominia/fleet/officer
	belt_contents = list(
		/obj/item/ammo_magazine/a556 = 2,
		/obj/item/ammo_magazine/c45m/dominia = 1,
		/obj/item/shield/energy/dominia = 1,
		/obj/item/material/knife/bayonet = 1,
		/obj/item/grenade/frag = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/energy/sword/pirate/generic = 1
	)
