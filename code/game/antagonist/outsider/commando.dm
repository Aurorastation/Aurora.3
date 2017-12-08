var/datum/antagonist/deathsquad/mercenary/commandos

/datum/antagonist/deathsquad/mercenary
	id = MODE_COMMANDO
	landmark_id = "Syndicate-Commando"
	role_text = "Syndicate Commando"
	role_text_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to corporate interests."

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6


/datum/antagonist/deathsquad/mercenary/New()
	..(1)
	commandos = src

/datum/antagonist/deathsquad/mercenary/equip(var/mob/living/carbon/human/player)

	var/obj/item/clothing/accessory/holster/armpit/hold = new(player)

	var/obj/item/clothing/under/syndicate/under = new(player)
	under.attackby(hold, player)

	player.equip_to_slot_or_del(under, slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(player), slot_l_store)

	syndie_belt.contents += new /obj/item/ammo_magazine/c762
	syndie_belt.contents += new /obj/item/ammo_magazine/c762
	syndie_belt.contents += new /obj/item/ammo_magazine/c762
	player.equip_to_slot_or_del(syndie_belt, slot_belt)
	
	mercrig.seal_delay = 0
	player.put_in_hands(mercrig)
	player.equip_to_slot_or_del(mercrig,slot_back)
	if(mercrig)
		mercrig.toggle_seals(src,1)
		mercrig.seal_delay = initial(mercrig.seal_delay)

		if(rig.air_supply)
			player.internal = rig.air_supply

	spawn(10)
		if(player.internal)
			player.internals.icon_state = "internal1"
		else
			player << "<span class='danger'>You forgot to turn on your internals! Quickly, toggle the valve!</span>"

	id.access |= get_all_accesses()
	id.icon_state = "centcom"
	create_radio(SYND_FREQ, player)
	player.faction = "syndicate"

	return 1
