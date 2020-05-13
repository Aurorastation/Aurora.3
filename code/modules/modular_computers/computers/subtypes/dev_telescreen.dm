/obj/item/modular_computer/telescreen
	name = "telescreen"
	desc = "A stationary wall-mounted touchscreen"
	icon = 'icons/obj/modular_telescreen.dmi'
	icon_state = "telescreen"
	icon_state_unpowered = "telescreen"
	icon_state_menu = "menu"
	icon_state_broken = "telescreen-broken"
	hardware_flag = PROGRAM_TELESCREEN
	anchored = TRUE
	density = FALSE
	base_idle_power_usage = 75
	base_active_power_usage = 300
	message_output_range = 1
	max_hardware_size = 2
	steel_sheet_cost = 10
	light_strength = 4
	w_class = ITEMSIZE_HUGE
	is_holographic = TRUE

/obj/item/modular_computer/telescreen/attackby(obj/item/W, mob/user)
	if(W.iscrowbar())
		if(anchored)
			shutdown_computer()
			anchored = FALSE
			screen_on = FALSE
			pixel_x = 0
			pixel_y = 0
			to_chat(user, SPAN_NOTICE("You unsecure \the [src]."))
		else
			var/choice = input(user, "Where do you want to place \the [src]?", "Offset selection") in list("North", "South", "West", "East", "This tile", "Cancel")
			var/valid = FALSE
			switch(choice)
				if("North")
					valid = TRUE
					pixel_y = 32
				if("South")
					valid = TRUE
					pixel_y = -32
				if("West")
					valid = TRUE
					pixel_x = -32
				if("East")
					valid = TRUE
					pixel_x = 32
				if("This tile")
					valid = TRUE

			if(valid)
				anchored = TRUE
				screen_on = TRUE
				to_chat(user, SPAN_NOTICE("You secure \the [src]."))
			return
	..()
