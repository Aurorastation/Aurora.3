var/datum/antagonist/ninja_minor/ninja_minors

/datum/antagonist/ninja_minor
	id = MODE_NINJA_MINOR
	role_text = "Minor Ninja"
	role_text_plural = "Minor Ninjas"
	bantype = "ninja"
	landmark_id = "ninjastart_minor"
	welcome_text = "<span class='info'>You are an elite stealth agent. You can equip your suit with the latest technology using your uplink.</span>"
	restricted_species = list("Diona")
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudninja"

	initial_spawn_req = 1
	initial_spawn_target = 3
	hard_cap = 3
	hard_cap_round = 3

	id_type = /obj/item/weapon/card/id/syndicate

/datum/antagonist/ninja_minor/New()
	..()
	ninja_minors = src

/datum/antagonist/ninja_minor/update_antag_mob(var/datum/mind/player)
	..()
	var/ninja_title = pick(ninja_titles)
	var/ninja_name = pick(ninja_names)
	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.real_name = "[ninja_title] [ninja_name]"
		H.name = H.real_name
	player.name = H.name


/datum/antagonist/ninja_minor/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset(player)
	player.equip_to_slot_or_del(R, slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_belt)
	player.equip_to_slot_or_del(new /obj/item/device/ninja_uplink(player, player.mind), slot_l_store)
	create_id("Infiltrator", player)

	var/obj/item/weapon/rig/light/stealth/ninja/ninjasuit = new(get_turf(player))
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