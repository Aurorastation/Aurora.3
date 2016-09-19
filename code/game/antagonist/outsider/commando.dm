var/datum/antagonist/deathsquad/mercenary/commandos

/datum/antagonist/deathsquad/mercenary
	id = MODE_COMMANDO
	landmark_id = "Syndicate-Commando"
	role_text = "Syndicate Commando"
	role_text_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to NanoTrasen."

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6


/datum/antagonist/deathsquad/mercenary/New()
	..(1)
	commandos = src

/datum/antagonist/deathsquad/mercenary/equip(var/mob/living/carbon/human/player)

	var/obj/item/clothing/accessory/holster/armpit/hold = new(player)
	var/obj/item/weapon/gun/projectile/silenced/weapon = new(player)
	hold.contents += weapon
	hold.holstered = weapon

	var/obj/item/clothing/under/syndicate/under = new(player)
	under.attackby(hold, player)

	player.equip_to_slot_or_del(under, slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(player), slot_l_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_r_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/rig/merc(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/rifle/sts35(player), slot_l_hand)
	
	var/obj/item/weapon/storage/belt/military/syndie_belt = new(player)
	syndie_belt.contents += new /obj/item/ammo_magazine/c762
	syndie_belt.contents += new /obj/item/ammo_magazine/c762
	syndie_belt.contents += new /obj/item/ammo_magazine/c762
	syndie_belt.contents += new /obj/item/weapon/pinpointer
	syndie_belt.contents += new /obj/item/weapon/shield/energy
	syndie_belt.contents += new /obj/item/weapon/handcuffs
	syndie_belt.contents += new /obj/item/weapon/grenade/flashbang
	syndie_belt.contents += new /obj/item/weapon/plastique
	syndie_belt.contents += new /obj/item/weapon/plastique
	player.equip_to_slot_or_del(syndie_belt, slot_belt)

	var/obj/item/weapon/card/id/id = create_id("Commando", player)
	id.access |= get_all_accesses()
	id.icon_state = "centcom"
	create_radio(SYND_FREQ, player)
