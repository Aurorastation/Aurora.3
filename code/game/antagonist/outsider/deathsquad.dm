var/datum/antagonist/deathsquad/deathsquad

/datum/antagonist/deathsquad
	id = MODE_DEATHSQUAD
	role_text = "Death Commando"
	role_text_plural = "Death Commandos"
	welcome_text = "You work in the service of corporate Asset Protection, answering directly to the Board of Directors."
	landmark_id = "Commando"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_OVERRIDE_MOB | ANTAG_HAS_NUKE | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	default_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	antaghud_indicator = "huddeathsquad"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

	var/deployed = 0

/datum/antagonist/deathsquad/New(var/no_reference)
	..()
	if(!no_reference)
		deathsquad = src

/datum/antagonist/deathsquad/attempt_spawn()
	if(..())
		deployed = 1

/datum/antagonist/deathsquad/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	var/obj/item/clothing/accessory/holster/armpit/hold = new(player)
	var/obj/item/weapon/gun/projectile/revolver/mateba/weapon = new(player)
	hold.contents += weapon
	hold.holstered = weapon

	var/obj/item/clothing/under/ert/under = new(player)
	under.attackby(hold, player)

	player.equip_to_slot_or_del(under, slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/tactical(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(player), slot_l_ear)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/weapon/pinpointer(player), slot_l_store)
		player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_r_store)
	else
		player.equip_to_slot_or_del(new /obj/item/weapon/plastique(player), slot_l_store)
		player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_r_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/rifle/pulse(player), slot_l_hand)

	var/obj/item/weapon/storage/belt/security/tactical/commando_belt = new(player)
	commando_belt.contents += new /obj/item/ammo_magazine/a454
	commando_belt.contents += new /obj/item/ammo_magazine/a454
	commando_belt.contents += new /obj/item/weapon/melee/baton/loaded
	commando_belt.contents += new /obj/item/weapon/shield/energy
	commando_belt.contents += new /obj/item/weapon/grenade/flashbang
	commando_belt.contents += new /obj/item/weapon/grenade/flashbang
	commando_belt.contents += new /obj/item/weapon/handcuffs
	commando_belt.contents += new /obj/item/weapon/handcuffs
	commando_belt.contents += new /obj/item/weapon/grenade/frag
	player.equip_to_slot_or_del(commando_belt, slot_belt)

	var/obj/item/weapon/rig/ert/assetprotection/mercrig = new(get_turf(player))
	mercrig.seal_delay = 0
	player.put_in_hands(mercrig)
	player.equip_to_slot_or_del(mercrig,slot_back)
	if(mercrig)
		mercrig.toggle_seals(src,1)
		mercrig.seal_delay = initial(mercrig.seal_delay)

	if(istype(player.back,/obj/item/weapon/rig))
		var/obj/item/weapon/rig/rig = player.back
		if(rig.air_supply)
			player.internal = rig.air_supply

	spawn(10)
		if(player.internal)
			player.internals.icon_state = "internal1"
		else
			player << "<span class='danger'>You forgot to turn on your internals! Quickly, toggle the valve!</span>"

	var/obj/item/weapon/card/id/id = create_id("Asset Protection", player)
	if(id)
		id.access |= get_all_station_access()
		id.icon_state = "centcom"

	//gives them a martial art as well

	var/datum/martial_art/sol_combat/F = new/datum/martial_art/sol_combat(null)
	F.teach(player)

/datum/antagonist/deathsquad/create_antagonist()
	if(..() && !deployed)
		deployed = 1
