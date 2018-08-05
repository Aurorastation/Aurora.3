/obj/item/weapon/flash_bulb //Get these from cargo
	name = "flash bulb"
	desc = "A small bulb built to be fit inside a flash."
	icon = 'icons/obj/flash.dmi'
	icon_state = "bulb_normal"

	matter = list("glass" = 1000)

	var/on = FALSE
	var/strength = 1
	var/is_burnt = FALSE
	var/last_used = 0 //Time when the bulb was used. Internal value.
	var/heat_damage_to_add = 1 //How much heat damage to add per use.
	var/max_heat_damage = 5 //Maximum heat damage the flash can sustain.
	var/heat_damage = 0 //Heat damage. Reach max_heat_damage and it breaks
	var/cooldown_delay = 30 SECONDS //How long it takes to remove max_heat_damage heat damage
	var/build_name = "flash"

/obj/item/weapon/flash_bulb/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/flash_bulb/proc/add_heat(var/heat_multiplier)
	//Yes, this is fucky.
	//And also a clever way to avoid processing things we don't need to process.
	if(!cooldown_delay)
		return

	var/heat_amount = heat_multiplier * heat_damage_to_add
	var/time_passed = (world.time - last_used) //In deciseconds
	heat_damage = max(0, heat_damage - (time_passed/cooldown_delay)*max_heat_damage)
	heat_damage += heat_amount
	if(heat_damage >= max_heat_damage)
		do_break()

	last_used = world.time

/obj/item/weapon/flash_bulb/proc/do_break() //Burn the bulb
	is_burnt = TRUE
	playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg')
	update_icon()

/obj/item/weapon/flash_bulb/update_icon()
	if(is_burnt || !on)
		icon_state = "bulb_burnt"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/flash_bulb/emp_act(var/severity = 3.0)
	do_break()

/obj/item/weapon/flash_bulb/ex_act(var/severity = 3.0)
	do_break()
	qdel(src)