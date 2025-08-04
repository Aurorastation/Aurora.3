//TODO: Fix Power Usage
/obj/machinery/case_button
	name = "Forcefield Button"
	desc = "A button in a case protected with a forcefield."
	icon = 'icons/obj/glasscasebutton.dmi'
	icon_state = "c1"
	anchored = 1
	idle_power_usage = 50 //50W because the forcefield is disabled
	active_power_usage = 2000 //2kW because of the forcefield
	power_channel = AREA_USAGE_EQUIP
	req_access = list(ACCESS_KEYCARD_AUTH) //Access required to unlock the cover
	//Style variables
	var/case = 1 //What case to use - c value
	var/cover = 1 //What cover to use - g value
	var/button = 1 //What button to use - b value
	//Status variables
	var/covered = 1 //If the cover is active
	var/active = 0 //If the button is active
	var/button_type = "button_case_generic" //Button type for the listener
	var/listener/listener //Listener for button updates
	//Spam Protection
	var/last_toggle_time = 0
	var/timeout = 10 //How long you have to wait between pressing the button

/obj/machinery/case_button/Initialize()
	. = ..()
	listener = new(button_type, src)
	update_icon()

/obj/machinery/case_button/Destroy()
	QDEL_NULL(listener)
	return ..()

/obj/machinery/case_button/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/card))
		if(src.allowed(user))
			covered = !covered //Enable / Disable the forcefield
		update_use_power(covered + 1) //Update the power usage
		. = TRUE
	else
		if(covered && (stat & NOPOWER)) //Only bounce off if its powered (i.e. shield active)
			. = ..()
		else
			user.visible_message(SPAN_DANGER("[src] has been hit by [user] with [attacking_item], but it bounces off the forcefield."),
									SPAN_DANGER("You hit [src] with [attacking_item], but it bounces off the forcefield."),
									"You hear something bouncing off a forcefield.")
			. = TRUE
	update_icon()

/obj/machinery/case_button/attack_hand(mob/user as mob)
	if(!covered)
		//Spam Check
		if((last_toggle_time + timeout) > world.time)
			user.visible_message(SPAN_NOTICE("\The [user] presses the button, but nothing happens."),
									SPAN_NOTICE("You press the button, but it is not responding."),
									"You hear something being pressed.")

			return ..()
		last_toggle_time = world.time
		if(!active)
			if(activate(user))
				for(var/button in get_listeners_by_type(button_type,/obj/machinery/case_button))
					var/obj/machinery/case_button/cb = button
					cb.active = 1
					cb.update_icon()
		else
			if(deactivate(user))
				for(var/button in get_listeners_by_type(button_type,/obj/machinery/case_button))
					var/obj/machinery/case_button/cb = button
					cb.active = 0
					cb.update_icon()
	else
		..()
	return

/obj/machinery/case_button/power_change()
	. = ..()
	update_icon()
	return

/obj/machinery/case_button/update_icon()
	ClearOverlays()
	if(stat & NOPOWER)
		update_use_power(POWER_USE_OFF)
		AddOverlays("b[button]d") //Add the deactivated button overlay
		AddOverlays("g[cover]d") //Add the deactivated cover overlay
		return
	AddOverlays("b[button][active]") //Add the button as overlay
	AddOverlays("g[cover][covered]") //Add the glass/shield overlay
	return

//Activate the button - Needs to return 1 for the activation to be successful
/obj/machinery/case_button/proc/activate(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] presses the button."),
							SPAN_NOTICE("<span class='notice'>You press the button."),
							"You hear something being pressed.")
	return 1

//Deactivate Button - Needs ro return 1 for the activation to be successful
/obj/machinery/case_button/proc/deactivate(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] resets the button."),
							SPAN_NOTICE("<span class='notice'>You reset the button."),
							"You hear something being pressed.")
	return 1




/obj/machinery/case_button/shuttle
	name = "bluespace jump button"
	desc = "A button in a case protected with a forcefield."
	icon_state = "c2"
	button_type = "button_case_emergencyshuttle"
	case = 2
	button = 4

/obj/machinery/case_button/shuttle/activate(mob/user)
	..()
	return call_shuttle_proc(user, TRANSFER_JUMP)

/obj/machinery/case_button/shuttle/deactivate(mob/user)
	..()
	return cancel_call_proc(user)
