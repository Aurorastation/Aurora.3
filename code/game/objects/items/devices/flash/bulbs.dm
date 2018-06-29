/obj/item/weapon/flash_bulb
	name = "flash bulb"
	desc = "A small bulb built to be fit inside a flash."
	icon = 'icons/obj/flash.dmi'
	icon_state = "bulb_normal"

	var/on = FALSE
	var/strength = 1
	var/is_burnt = FALSE
	var/last_used = 0 //Time when the bulb was used. Internal value.
	var/heat_damage_to_add = 30 //How much heat damage to add per use.
	var/max_heat_damage = 100 //Maximum heat damage the flash can sustain.
	var/heat_damage = 0 //Heat damage. Reach max_heat_damage and it breaks
	var/cooldown_delay = 1 SECOND //How long it takes to remove max_heat_damage heat damage

/obj/item/weapon/flash_bulb/weak
	name = "weak flash bulb"
	desc = "A small bulb built to be fit inside a flash. This one is cheaply made."
	icon_state = "bulb_weak"
	strength = 0.5

/obj/item/weapon/flash_bulb/strong
	name = "strong flash bulb"
	desc = "A small bulb built to be fit inside a flash. This one seems to be made with stronger materials."
	icon_state = "bulb_strong"
	strength = 2

/obj/item/weapon/flash_bulb/proc/add_heat(var/heat_multiplier)
	//Yes, this is fucky.
	//And also a clever way to avoid processing things we don't need to process.

	var/heat_amount = heat_multiplier * heat_damage_to_add

	var/last_used_difference = world.time - last_used

	if(last_used_difference > cooldown_delay)
		heat_damage = max(0,heat_damage - ( ((last_used_difference*0.1) / cooldown_delay) * max_heat_damage) )

	heat_damage += heat_amount

	if(heat_amount >= max_heat_damage)
		do_break()

/obj/item/weapon/flash_bulb/proc/do_break() //Burn the bulp
	is_burnt = TRUE
	update_icon()

/obj/item/weapon/flash_bulb/update_icon()
	if(is_burnt || !on)
		icon_state = "bulb_burnt"
	else
		icon_state = initial(icon_state)