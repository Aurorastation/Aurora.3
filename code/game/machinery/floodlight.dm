
/obj/machinery/floodlight
	name = "industrial floodlight"
	desc = "A series of large LEDs housed in a reflective frame, this is a cheap and easy way of lighting large areas during construction."
	icon = 'icons/obj/machinery/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	obj_flags = OBJ_FLAG_ROTATABLE
	var/on = FALSE
	var/obj/item/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = FALSE
	var/open = FALSE
	var/brightness_on = 12		//can't remember what the maxed out value is
	light_color = LIGHT_COLOR_TUNGSTEN
	light_wedge = LIGHT_WIDE

/obj/machinery/floodlight/Initialize()
	. = ..()
	cell = new /obj/item/cell/device(src) // 41minutes @ 200W

/obj/machinery/floodlight/examine(mob/user)
	. = ..()
	if(cell)
		if(!cell.charge)
			to_chat(user, SPAN_WARNING("The installed [cell.name] is completely flat!"))
			return
		to_chat(user, SPAN_NOTICE("The installed [cell.name] has [Percent(cell.charge, cell.maxcharge)]% charge remaining."))
	else
		to_chat(user, SPAN_WARNING("\The [src] has no cell installed!"))

/obj/machinery/floodlight/update_icon()
	cut_overlays()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(TRUE)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(brightness_on/3, 0.5)
		addtimer(CALLBACK(src, .proc/stop_flicker), 5, TIMER_UNIQUE)

	cell.use(use*CELLRATE)

/obj/machinery/floodlight/proc/stop_flicker()
	if(on)
		set_light(brightness_on, 1)

// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(var/loud = FALSE)
	if(!cell)
		return FALSE
	if(cell.charge < (use * CELLRATE))
		return FALSE

	on = TRUE
	set_light(brightness_on, 1)
	update_icon()
	if(loud)
		visible_message(SPAN_NOTICE("\The [src] turns on."))
	return TRUE

/obj/machinery/floodlight/proc/turn_off(var/loud = FALSE)
	on = FALSE
	set_light(0)
	update_icon()
	if(loud)
		visible_message(SPAN_NOTICE("\The [src] shuts down."))

/obj/machinery/floodlight/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(TRUE)
	else
		if(!turn_on(TRUE))
			to_chat(user, SPAN_WARNING("You try to turn on \the [src] but it does not work."))


/obj/machinery/floodlight/attack_hand(mob/user)
	if(open && cell)
		user.put_in_hands(cell)
		cell.add_fingerprint(user)
		cell.update_icon()
		cell = null

		on = FALSE
		set_light(0)
		to_chat(user, SPAN_NOTICE("You remove the power cell."))
		update_icon()
		return

	if(on)
		turn_off(TRUE)
	else
		if(!turn_on(TRUE))
			to_chat(user, SPAN_WARNING("You try to turn on \the [src] but it does not work."))

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver())
		if(!open)
			unlocked = !unlocked
			var/msg = unlocked ? "You unscrew the battery panel." : "You screw the battery panel into place."
			to_chat(user, SPAN_NOTICE(msg))
		else
			to_chat(user, SPAN_WARNING("\The [src]'s battery panel is open and cannot be screwed down!"))
		return TRUE
	if(W.iscrowbar())
		if(unlocked)
			open = !open
			var/msg = open ? "You remove the battery panel." : "You crowbar the battery panel into place."
			to_chat(user, SPAN_NOTICE(msg))
		else
			to_chat(user, SPAN_WARNING("\The [src]'s battery panel is still screwed shut!"))
		return TRUE
	if(istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
				return
			else
				user.drop_from_inventory(W, src)
				cell = W
				to_chat(user, SPAN_NOTICE("You insert the power cell."))
		return TRUE
	update_icon()

/obj/machinery/floodlight/randomcharge
	// Intentionally left empty as it's the same as the parent, but the cell is randomized.

/obj/machinery/floodlight/randomcharge/Initialize()
	. = ..()
	if(cell)
		cell.charge = rand(1, cell.maxcharge)
