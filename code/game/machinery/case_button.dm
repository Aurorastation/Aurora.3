//TODO: Fix Power Usage
/obj/machinery/case_button
	name = "Forcefield Button"
	desc = "A button in a case protected with a forcefield."
	icon = 'icons/obj/glasscasebutton.dmi'
	icon_state = "c1"
	anchored = 1
	use_power = 1
	idle_power_usage = 50 //50W because the forcefield is disabled
	active_power_usage = 2000 //2kW because of the forcefield
	power_channel = EQUIP
	req_access = list(access_keycard_auth) //Access required to unlock the cover
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

/obj/machinery/case_button/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card))
		if(src.allowed(user))
			covered = !covered //Enable / Disable the forcefield
		update_use_power(covered + 1) //Update the power usage
	else
		if(covered && (stat & NOPOWER)) //Only bounce off if its powered (i.e. shield active)
			..()
		else
			user.visible_message("<span class='danger'>[src] has been hit by [user] with [W], but it bounces off the forcefield.</span>","<span class='danger'>You hit [src] with [W], but it bounces off the forcefield.</span>","You hear something boucing off a forcefield.")
	update_icon()
	return

/obj/machinery/case_button/attack_hand(mob/user as mob)
	if(!covered)
		//Spam Check
		if((last_toggle_time + timeout) > world.time)
			user.visible_message("<span class='notice'>\The [user] presses the button, but nothing happens.</span>","<span class='notice'>You press the button, but it is not responding.</span>","You hear something being pressed.")
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
	cut_overlays()
	if(stat & NOPOWER)
		update_use_power(0)
		add_overlay("b[button]d") //Add the deactivated button overlay
		add_overlay("g[cover]d") //Add the deactivated cover overlay
		return
	add_overlay("b[button][active]") //Add the button as overlay
	add_overlay("g[cover][covered]") //Add the glass/shield overlay
	return

//Activate the button - Needs to return 1 for the activation to be successful
/obj/machinery/case_button/proc/activate(mob/user)
	user.visible_message("<span class='notice'>\The [user] presses the button.</span>","<span class='notice'>You press the button.</span>","You hear something being pressed.")
	return 1

//Deactivate Button - Needs ro return 1 for the activation to be successful
/obj/machinery/case_button/proc/deactivate(mob/user)
	user.visible_message("<span class='notice'>\The [user] resets the button.</span>","<span class='notice'>You reset the button.</span>","You hear something being pressed.")
	return 1




/obj/machinery/case_button/shuttle
	name = "\improper Emergency Shuttle Button"
	desc = "A button in a case protected with a forcefield."
	icon_state = "c2"
	button_type = "button_case_emergencyshuttle"
	case = 2
	button = 4

/obj/machinery/case_button/shuttle/activate(mob/user)
	..()
	return call_shuttle_proc(user)

/obj/machinery/case_button/shuttle/deactivate(mob/user)
	..()
	return cancel_call_proc(user)