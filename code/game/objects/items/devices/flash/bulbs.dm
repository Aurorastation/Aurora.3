/obj/item/weapon/flash_bulb
	name = "flash bulb"
	desc = "A small bulb built to be fit inside a flash."
	icon = 'icons/obj/flash.dmi'
	icon_state = "bulb_normal"

	var/on = FALSE
	var/strength = 1
	var/is_burnt = FALSE
	var/last_used = 0 //Time when the bulb was used. Internal value.
	var/heat_damage_to_add = 1 //How much heat damage to add per use.
	var/max_heat_damage = 5 //Maximum heat damage the flash can sustain.
	var/heat_damage = 0 //Heat damage. Reach max_heat_damage and it breaks
	var/cooldown_delay = 30 SECONDS //How long it takes to remove max_heat_damage heat damage
	var/build_name = "flash"

/obj/item/weapon/flash_bulb/weak
	name = "weak flash bulb"
	desc = "A small bulb built to be fit inside a flash. This one is cheaply made."
	icon_state = "bulb_weak"
	strength = 0.75
	build_name = "budget flash"
	heat_damage_to_add = 1
	max_heat_damage = 2
	cooldown_delay = 30 SECONDS

/obj/item/weapon/flash_bulb/strong
	name = "strong flash bulb"
	desc = "A small bulb built to be fit inside a flash. This one seems to be made with stronger materials."
	icon_state = "bulb_strong"
	strength = 1
	build_name = "advanced flash"
	heat_damage_to_add = 1
	max_heat_damage = 10
	cooldown_delay = 30 SECONDS

/obj/item/weapon/flash_bulb/proc/add_heat(var/heat_multiplier)
	//Yes, this is fucky.
	//And also a clever way to avoid processing things we don't need to process.

	var/heat_amount = heat_multiplier * heat_damage_to_add
	var/time_passed = (world.time - last_used) //In deciseconds
	heat_damage = max(0, heat_damage - (time_passed/cooldown_delay)*max_heat_damage)
	heat_damage += heat_amount
	if(heat_damage >= max_heat_damage)
		do_break()

	last_used = world.time

/obj/item/weapon/flash_bulb/proc/do_break() //Burn the bulb
	is_burnt = TRUE
	update_icon()

/obj/item/weapon/flash_bulb/update_icon()
	if(is_burnt || !on)
		icon_state = "bulb_burnt"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/flash_bulb/emp_act(severity)
	do_break()