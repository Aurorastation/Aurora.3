/obj/machinery/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'icons/obj/machinery/stasis_cage.dmi'
	icon_state = "stasis_cage"
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	req_access = list(ACCESS_RESEARCH)
	idle_power_usage = 0
	active_power_usage = 5000
	use_power = POWER_USE_IDLE

	/// The wires of the cage
	var/datum/wires/stasis_cage/wires

	/// The mob in the cage
	var/mob/living/contained

	/// Internal atmosphere of the cage
	var/datum/gas_mixture/airtank

	/// If the cage works
	var/broken = FALSE

	/// If the cage will prevent human mobs from being stored
	var/safety = TRUE

	/// The cell used to power this
	var/obj/item/cell/cell = null

	parts_power_mgmt = FALSE

/obj/machinery/stasis_cage/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>capacitors</b> will reduce power usage."

/obj/machinery/stasis_cage/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if (contained)
		. += SPAN_NOTICE("\The [contained] is kept inside.")
	if (broken)
		. += SPAN_WARNING("\The [src]'s lid is broken. It probably can not be used.")
	if (cell)
		. += SPAN_NOTICE("\The [src]'s power gauge shows [cell.percent()]% remaining.")

/obj/machinery/stasis_cage/Initialize()
	. = ..()
	airtank = new /datum/gas_mixture(src)
	airtank.temperature = T20C
	airtank.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, FALSE)
	airtank.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)

	cell = new /obj/item/cell(src)

	var/mob/living/A = locate() in loc
	if(!A)
		release(A)
	else
		contain(A)

	wires = new /datum/wires/stasis_cage(src)

/obj/machinery/stasis_cage/Destroy()
	release()
	QDEL_NULL(airtank)
	QDEL_NULL(contained)
	QDEL_NULL(cell)
	QDEL_NULL(wires)
	return ..()

/obj/machinery/stasis_cage/process(seconds_per_tick)
	if (use_power || !cell || !cell.charge)
		return
	cell.use(2 * seconds_per_tick)
	if (contained)
		if (iscarbon(contained))
			var/mob/living/carbon/C = contained
			C.SetStasis(20 * seconds_per_tick)
		else if (isanimal(contained))
			var/mob/living/simple_animal/SA = contained
			SA.in_stasis = TRUE

/obj/machinery/stasis_cage/proc/try_release(mob/user)
	if(!contained)
		to_chat(user, SPAN_WARNING("There's no animals inside \the [src]"))
		return
	if (broken)
		to_chat(user, SPAN_WARNING("\The [src]'s lid is broken!"))
		return
	if (!allowed(user))
		to_chat(user, SPAN_WARNING("\The [src] refuses access."))
		return
	if (!use_power)
		to_chat(user, SPAN_WARNING("\The [src] is unpowered."))
		return

	user.visible_message(SPAN_NOTICE("[user] begins undoing the locks and latches on \the [src]."))
	if(do_after(user, 2 SECONDS, src))
		user.visible_message(SPAN_NOTICE("[user] releases \the [contained] from \the [src]!"))
		release()

/obj/machinery/stasis_cage/proc/release()
	if (contained)
		contained.dropInto(src)
		contained = null
		playsound(get_turf(src), 'sound/machines/airlock.ogg', 40)
		update_icon()
		update_use_power(POWER_USE_IDLE)

/obj/machinery/stasis_cage/proc/contain(mob/user, mob/thing)
	if(contained || broken)
		return
	if (!use_power)
		to_chat(usr, SPAN_WARNING("\The [src] is unpowered."))
		return
	user.visible_message(SPAN_NOTICE("[user] has stuffed \the [thing] into \the [src]."), SPAN_NOTICE("You have stuffed \the [thing] into \the [src]."))
	set_contained(thing)
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/stasis_cage/proc/set_contained(mob/contained)
	src.contained = contained
	if(contained)
		contained.forceMove(src)
	update_icon()


/obj/machinery/stasis_cage/attack_hand(mob/user)
	if (!panel_open)
		try_release(user)
	else
		wires.interact(user)

/obj/machinery/stasis_cage/attack_robot(mob/user)
	if (Adjacent(user))
		if(!panel_open)
			try_release(user)
		else
			wires.interact(user)

/obj/machinery/stasis_cage/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	// Crowbar - Pry thing out of cage
	if (attacking_item.iscrowbar())
		if (panel_open)
			to_chat(user, SPAN_NOTICE("\The [src]'s panel is open!"))
			return TRUE
		if (contained)
			if (use_power)
				to_chat(user, SPAN_NOTICE("\The [src] is still powered shut."))
				return TRUE
			user.visible_message(SPAN_DANGER("\The [user] begins to pry open \the [src] with the crowbar!"), SPAN_DANGER("You being to pry open \the [src] with the crowbar."))
			playsound(loc, 'sound/machines/airlock_open_force.ogg', 40)
			if (!do_after(user, 7 SECONDS, src))
				return TRUE
			if (prob(20))
				user.visible_message(SPAN_DANGER("\The [user] jams open \the [src]'s lid, damaging it in the process!"), SPAN_DANGER("You successfully manage to jam open \the [src]'s lid, damaging it in the process."))
				release()
				broken = TRUE
				update_icon()
				return TRUE
			user.visible_message(SPAN_DANGER("\The [user] jams open \the [src]'s lid!") ,SPAN_DANGER("You successfully manage to jam open \the [src]'s lid."))
			release()
			return TRUE

	// Wrench - Repair lid
	if (attacking_item.iswrench())
		if (broken)
			user.visible_message(SPAN_NOTICE("\The [user] begins to clamp \the [src]'s lid back into position."), SPAN_NOTICE("You begin to clamp \the [src]'s lid back into position."))
			playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
			if (!do_after(user, 5 SECONDS, src))
				return TRUE
			user.visible_message(SPAN_NOTICE("\The [user] successfully repairs \the [src]'s lid!"), SPAN_NOTICE("You successfully repair \the [src]'s lid!"))
			broken = FALSE
			update_icon()
			return TRUE

	// Screwdriver - Open panel
	if(attacking_item.isscrewdriver())
		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "unscrew" : "screw shut"] the maintainance panel of \the [src]"))

/obj/machinery/stasis_cage/return_air() //Used to make stasis cage protect from vacuum.
	if (!use_power)
		return
	if(airtank)
		return airtank
	..()

/obj/machinery/stasis_cage/RefreshParts()
	..()
	var/charge_multiplier
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		charge_multiplier += C.rating / 2
	change_power_consumption(initial(active_power_usage) / charge_multiplier, POWER_USE_ACTIVE)

/obj/machinery/stasis_cage/emp_act(severity)
	. = ..()
	if(contained)
		if(prob(30))
			visible_message(SPAN_DANGER("\The [src]'s lights flicker, unlocking the container!"))
			release()
			broken = TRUE
			update_icon()
			spark(src, 1)
			return
	visible_message(SPAN_DANGER("\The [src] sparks violently, damaging the lid!"))
	broken = TRUE
	spark(src, 1)

	if (cell)
		cell.emp_act(severity)

	update_icon()

/obj/machinery/stasis_cage/update_icon()
	. = ..()
	ClearOverlays()
	if (use_power)
		if (contained)
			if (broken)
				icon_state = "[initial(icon_state)]_broke"
			else
				icon_state = "[initial(icon_state)]_on"
		else
			if (broken)
				icon_state = "[initial(icon_state)]_broke"
			else
				icon_state = "[initial(icon_state)]_power"
	else
		if (broken)
			icon_state = "[initial(icon_state)]_dead"
		else
			icon_state = initial(icon_state)

/obj/machinery/stasis_cage/mouse_drop_receive(atom/dropped, mob/user, params)
	if (!isanimal(dropped) && safety)
		to_chat(user, SPAN_WARNING("\The [src] smartly refuses \the [dropped]."))
		return

	var/mob/living/simple_animal/target = dropped

	if (!allowed(user))
		to_chat(user, SPAN_NOTICE("\The [src] blinks, refusing access."))
		return
	if (!target.stat && !target.captured)
		to_chat(user, SPAN_NOTICE("It's going to be difficult to convince \the [target] to move into \the [src] without capturing it in a net."))
		return
	user.visible_message(SPAN_NOTICE("\The [user] begins stuffing \the [target] into \the [src]."), SPAN_NOTICE("You begin stuffing \the [target] into \the [src]."))
	playsound(src, 'sound/machines/AirlockClose.ogg', 100)
	add_fingerprint(user)
	if (do_after(user, 2 SECONDS, src))
		if(target.buckled_to)
			target.buckled_to.unbuckle()
		contain(user, target)


/datum/wires/stasis_cage
	proper_name = "Stasis Cage"
	holder_type = /obj/machinery/stasis_cage


/datum/wires/stasis_cage/New(atom/holder)
	wires = list(
		WIRE_SAFETY,
		WIRE_RELEASE,
		WIRE_LOCK
	)
	add_duds(3)
	..()

/datum/wires/stasis_cage/interactable(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	var/obj/machinery/stasis_cage/stasis_cage = holder
	if (stasis_cage.panel_open)
		return TRUE
	return FALSE


/datum/wires/stasis_cage/get_status()
	var/obj/machinery/stasis_cage/stasis_cage = holder
	. = ..()
	if(!stasis_cage.use_power)
		. += "The panel is unpowered."
	else
		. += "The panel is powered."
		. += "The biometric safety sensors are [(WIRE_SAFETY in cut_wires) ? "connected" : "disconnected"]."
		. += "The cage's emergency auto-release mechanism is [(WIRE_RELEASE in cut_wires) ? "disabled" : "enabled"]."
		. += "The cage lid motors are [(WIRE_LOCK in cut_wires) ? "overriden" : "nominal"]."


/datum/wires/stasis_cage/on_cut(wire, mend, source)
	var/obj/machinery/stasis_cage/stasis_cage = holder
	switch (wire)
		if (WIRE_SAFETY)
			stasis_cage.safety = !stasis_cage.safety
		if (WIRE_RELEASE)
			if (stasis_cage.contained && !mend)
				stasis_cage.release()
				holder.update_icon()
		if (WIRE_LOCK)
			if (!mend)
				playsound(stasis_cage.loc, 'sound/machines/BoltsDown.ogg', 60)
				holder.visible_message(SPAN_WARNING("The cage's lid bolts down destructively, denting itself!"), SPAN_NOTICE("You notice the cage lid override flag blink hastily."))
				stasis_cage.broken = TRUE
				holder.update_icon()


/datum/wires/stasis_cage/on_pulse(wire)
	var/obj/machinery/stasis_cage/stasis_cage = holder
	switch (wire)
		if (WIRE_SAFETY)
			if (stasis_cage.contained)
				if (prob(20))
					holder.visible_message(SPAN_WARNING("The cage hastily flicks open its lid!"), SPAN_NOTICE("You notice the biometric sensor flag blink fervently."))
					stasis_cage.release()

