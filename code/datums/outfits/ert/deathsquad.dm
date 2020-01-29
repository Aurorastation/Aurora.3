/datum/outfit/admin/deathsquad
	name = "Asset Protection"

	uniform = /obj/item/clothing/under/ert
	back = null
	belt = /obj/item/storage/belt/security/tactical
	shoes = null
	gloves = null
	mask = /obj/item/clothing/mask/gas/swat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	id = /obj/item/card/id/asset_protection
	l_pocket = /obj/item/plastique
	r_pocket = /obj/item/melee/energy/sword
	l_hand = /obj/item/gun/energy/rifle/pulse

	belt_contents = list(
		/obj/item/ammo_magazine/a454 = 2,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/shield/energy = 1,
		/obj/item/grenade/flashbang = 2,
		/obj/item/handcuffs = 2,
		/obj/item/grenade/frag = 1
	)

	var/syndie = FALSE

/datum/outfit/admin/deathsquad/leader
	name = "Asset Protection Lead"

	l_pocket = /obj/item/pinpointer

/datum/outfit/admin/deathsquad/get_id_access()
	return get_all_accesses()

/datum/outfit/admin/deathsquad/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/clothing/accessory/holster/armpit/hold = new(H)
	var/obj/item/gun/projectile/weapon


	if(syndie)
		weapon = new /obj/item/gun/projectile/silenced(H)
	else
		weapon = new /obj/item/gun/projectile/revolver/mateba(H)

	if(weapon)
		hold.contents += weapon
		hold.holstered = weapon

	var/obj/item/clothing/under/U = H.get_equipped_item(slot_w_uniform)
	U.attackby(hold, H)

	var/obj/item/rig/mercrig

	if(syndie)
		mercrig = new /obj/item/rig/merc(get_turf(H))
	else
		mercrig = new /obj/item/rig/ert/assetprotection(get_turf(H))

	if(mercrig)
		H.put_in_hands(mercrig)
		H.equip_to_slot_or_del(mercrig, slot_back)
		addtimer(CALLBACK(mercrig, /obj/item/rig/.proc/toggle_seals, H, TRUE), 2 SECONDS)