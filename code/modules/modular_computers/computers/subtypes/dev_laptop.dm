/obj/item/modular_computer/laptop
	anchored = TRUE
	name = "laptop computer"
	desc = "A portable computer."
	description_info = "You can alt-click the laptop while it's set down on surface to open it up and work with it. Left clicking while it is open will allow you to operate it."
	hardware_flag = PROGRAM_LAPTOP
	can_reset = TRUE
	icon_state_unpowered = "laptop-open"
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-open"
	icon_state_broken = "laptop-broken"
	randpixel = 6
	center_of_mass = list("x"=14, "y"=10)
	base_idle_power_usage = 25
	base_active_power_usage = 200
	message_output_range = 1
	max_hardware_size = 2
	light_strength = 3
	max_damage = 50
	broken_damage = 25
	var/icon_state_closed = "laptop-closed"

/obj/item/modular_computer/laptop/AltClick()
	if(use_check(usr))
		return
	// Prevents carrying of open laptops inhand.
	// While they work inhand, i feel it'd make tablets lose some of their high-mobility advantage they have over laptops now.
	if(!isturf(loc))
		to_chat(usr, SPAN_NOTICE("\The [src] has to be on a stable surface first!"))
		return
	anchored = !anchored
	screen_on = anchored
	update_icon()

/obj/item/modular_computer/laptop/update_icon()
	if(anchored)
		..()
	else
		cut_overlays()
		if(damage >= broken_damage)
			icon_state = icon_state_broken + "-closed"
		else
			icon_state = icon_state_closed