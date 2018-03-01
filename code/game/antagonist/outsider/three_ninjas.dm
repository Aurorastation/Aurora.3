var/datum/antagonist/combat_ninjas
var/datum/antagonist/mobility_ninjas
var/datum/antagonist/stealth_ninjas

/datum/antagonist/ninja/tri

/datum/antagonist/ninja/tri/combat
	id = MODE_NINJA_COMBAT
	role_text = "Tiger"
	role_text_plural = "Tiger Ninja"
	landmark_id = "tigetstart"
	welcome_text = "<span class='info'>You are an elite warrior representing the interests of the powerful Tiger Clan, specializing in offensive and defensive techiques.\
	Through intense interrogation, we have determined that there are potentially two other rival clans visiting this station.\
	You may choose to work with them if you wish, such as trading and selling equipment, but be warned: betrayal is more than likely.\
	Gear up by purchasing equipment from our company's vending machine, then use the teleporter to travel to the station.\
	</span>"

	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 1
	hard_cap_round = 3

	id_type = /obj/item/weapon/card/id/syndicate/combat_ninja

/datum/antagonist/ninja/tri/mobility
	id = MODE_NINJA_MOBILITY
	role_text = "Spider"
	role_text_plural = "Spider Ninja"
	landmark_id = "spiderstart"
	welcome_text = "<span class='info'>You are an elite thief representing the interests of the cunning Spider Clan, specializing in mobility and capture techniques.\
	Using our wits, we have determined that there are potentially two other rival clans visiting this station.\
	You may choose to work with them if you wish, such as trading and selling equipment, but be warned: betrayal is more than likely.\
	Gear up by purchasing equipment from our company's vending machine, then use the teleporter to travel to the station.\
	</span>"

	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 1
	hard_cap_round = 3

	id_type = /obj/item/weapon/card/id/syndicate/mobility_ninja

/datum/antagonist/ninja/tri/stealth
	id = MODE_NINJA_STEALTH
	role_text = "Snake"
	role_text_plural = "Snake Ninja"
	landmark_id = "snakestart"
	welcome_text = "<span class='info'>You are an elite spy representing the interests of the secretive Snake Clan, specializing in stealth and hacking techniques.\
	Using our vast network of spies, we have determined that there are potentially two other rival clans visiting this station.\
	You may choose to work with them if you wish, such as trading and selling equipment, but be warned: betrayal is more than likely.\
	Gear up by purchasing equipment from our company's vending machine, then use the teleporter to travel to the station.\
	</span>"

	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 1
	hard_cap_round = 3

	id_type = /obj/item/weapon/card/id/syndicate/stealth_ninja

/datum/antagonist/ninja/tri/combat/New()
	..()
	combat_ninjas = src

/datum/antagonist/ninja/tri/mobility/New()
	..()
	mobility_ninjas = src

/datum/antagonist/ninja/tri/stealth/New()
	..()
	stealth_ninjas = src


/datum/antagonist/ninja/tri/equip(var/mob/living/carbon/human/player)

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset(player)
	player.equip_to_slot_or_del(R, slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_belt)
	create_id(role_text, player)

	var/obj/item/weapon/rig/light/ninja/ninjasuit = new(get_turf(player))
	ninjasuit.seal_delay = 0
	player.put_in_hands(ninjasuit)
	player.equip_to_slot_or_del(ninjasuit,slot_back)
	if(ninjasuit)
		ninjasuit.toggle_seals(src,1)
		ninjasuit.seal_delay = initial(ninjasuit.seal_delay)

	if(istype(player.back,/obj/item/weapon/rig))
		var/obj/item/weapon/rig/rig = player.back
		if(rig.air_supply)
			player.internal = rig.air_supply

	spawn(10)
		if(player.internal)
			player.internals.icon_state = "internal1"
		else
			player << "<span class='danger'>You forgot to turn on your internals! Quickly, toggle the valve!</span>"