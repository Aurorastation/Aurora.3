var/datum/antagonist/burglar/burglars

/datum/antagonist/burglar
	id = MODE_BURGLAR
	role_text = "Burglar"
	role_text_plural = "Burglars"
	bantype = "burglar"
	antag_indicator = "mutineer"
	landmark_id = "burglarspawn"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudmutineer"
	required_age = 7

	hard_cap = 2
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 2

	faction = "syndicate"

	id_type = /obj/item/card/id/syndicate

	var/list/burglar_guns = list(
		/obj/item/gun/energy/rifle/icelance,
		/obj/item/gun/energy/retro,
		/obj/item/gun/projectile/silenced,
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/revolver/deckard,
		/obj/item/gun/projectile/revolver/lemat
		)

/datum/antagonist/burglar/New()
	..()
	burglars = src

/datum/antagonist/burglar/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.name = "[player.real_name]'s Passport"
			id.registered_name = player.real_name
			W.name = "[initial(W.name)] ([id.name])"

/datum/antagonist/burglar/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for(var/obj/item/I in player)
		if(istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/raider/burglar, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/raider/burglar, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()
	equip_weapons(player)

	return TRUE

/datum/antagonist/burglar/proc/equip_weapons(var/mob/living/carbon/human/player)
	var/new_gun = pick(burglar_guns)
	var/turf/T = get_turf(player)

	var/obj/item/primary = new new_gun(T)
	var/obj/item/clothing/accessory/holster/armpit/holster

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new /obj/item/clothing/accessory/holster/armpit(T)
		holster.holstered = primary
		primary.forceMove(holster)
	else if(!player.belt && (primary.slot_flags & SLOT_BELT))
		player.equip_to_slot_or_del(primary, slot_belt)
	else if(!player.back && (primary.slot_flags & SLOT_BACK))
		player.equip_to_slot_or_del(primary, slot_back)
	else
		player.put_in_any_hand_if_possible(primary)

	//If they got a projectile gun, give them a little bit of spare ammo
	equip_ammo(player, primary)

	if(holster)
		var/obj/item/clothing/under/uniform = player.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, player)
		else
			player.put_in_any_hand_if_possible(holster)

/datum/antagonist/burglar/proc/equip_ammo(var/mob/living/carbon/human/player, var/obj/item/gun/gun)
	if(istype(gun, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/bullet_thrower = gun
		if(bullet_thrower.magazine_type)
			player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_l_store)
			if(prob(20)) //don't want to give them too much
				player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_r_store)
		else if(bullet_thrower.ammo_type)
			var/obj/item/storage/box/ammobox = new(get_turf(player.loc))
			for(var/i in 1 to rand(3,5) + rand(0,2))
				new bullet_thrower.ammo_type(ammobox)
			player.put_in_any_hand_if_possible(ammobox)
		return

/datum/antagonist/burglar/get_antag_radio()
	return "Burglar"