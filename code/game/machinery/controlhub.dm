ABSTRACT_TYPE(/obj/machinery/controlhub)
/obj/machinery/controlhub
	name = "control hub"
	desc = "A control interface that can manage multiple systems from a single point."
	icon = 'icons/obj/modular_telescreen.dmi'
	icon_state = "generic"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	idle_power_usage = 10
	active_power_usage = 50
	power_channel = AREA_USAGE_ENVIRON

	/// associative list of control configurations. key is control name, value is list("type", "id", optional "functions")
	var/list/controls

	/// maximum range in tiles for finding machinery to control
	var/range = 16

	/// associative list tracking toggle states for controls. key is control name, value is boolean
	var/list/control_states

/*
 * INITIALIZATION & POWER
 */

/obj/machinery/controlhub/Initialize()
	. = ..()
	control_states = list()
	update_icon()

/obj/machinery/controlhub/update_icon()
	ClearOverlays()

	if(stat & BROKEN)
		icon_state = "broken"
	else if(stat & NOPOWER)
		icon_state = "standby"
	else
		icon_state = initial(icon_state)

/obj/machinery/controlhub/power_change()
	..()
	update_icon()

/*
 * INTERACTION
 */

/obj/machinery/controlhub/attack_hand(mob/user)
	if(..())
		return TRUE

	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("\The [src]'s screen is shattered!"))
		return TRUE

	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] is not responding."))
		return TRUE

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	if(!length(controls))
		to_chat(user, SPAN_WARNING("\The [src] has no configured controls."))
		return TRUE

	var/list/choices = list()
	for(var/control_name in controls)
		var/list/control_data = controls[control_name]

		var/button_type
		switch(control_data["type"])
			if("holosign", "windowtint")
				button_type = /obj/machinery/button/switch
			if("blast_door")
				button_type = /obj/machinery/button/remote/blast_door
			if("airlock")
				button_type = /obj/machinery/button/remote/airlock
			if("flasher", "igniter", "emitter", "mass_driver")
				button_type = /obj/machinery/button

		choices[control_name] = image(icon = initial(button_type:icon), icon_state = initial(button_type:icon_state))

	var/chosen_control = show_radial_menu(user, src, choices, require_near = !issilicon(user), radius = 42, tooltips = TRUE)
	if(!chosen_control || stat & (BROKEN|NOPOWER))
		return TRUE

	use_power_oneoff(active_power_usage)
	playsound(src, 'sound/machines/holoclick.ogg', 100, FALSE)
	flick("holocontrol", src)

	var/list/control_data = controls[chosen_control]
	if(!control_data)
		return TRUE

	if(!issilicon(user))
		user.visible_message(SPAN_NOTICE("\The [user] presses the [chosen_control] button."))

	activate_control(chosen_control, control_data)

	return TRUE

/obj/machinery/controlhub/proc/activate_control(control_name, list/control_data)
	var/control_id = control_data["id"]

	switch(control_data["type"])
		if("windowtint")
			toggle_windowtint(control_id)
		if("holosign")
			toggle_holosign(control_id)
		if("blast_door")
			toggle_blast_doors(control_id)
		if("airlock")
			toggle_airlock(control_name, control_id, control_data["functions"])
		if("flasher")
			trigger_flasher(control_id)
		if("igniter")
			trigger_igniter(control_id)
		if("emitter")
			trigger_emitter(control_id)
		if("mass_driver")
			trigger_mass_driver(control_id)

/*
 * MACHINERY FINDING HELPERS
 */

/obj/machinery/controlhub/proc/find_machinery_by_id(machinery_type, target_id)
	. = list()

	for(var/obj/machinery/machinery as anything in SSmachinery.machinery)
		if(istype(machinery, machinery_type) && machinery:id == target_id)
			. += machinery

/obj/machinery/controlhub/proc/find_airlocks_by_id(target_id)
	. = list()

	for(var/obj/machinery/door/airlock/airlock as anything in SSmachinery.machinery)
		if(airlock.id_tag == target_id)
			. += airlock

/*
 * CONTROL FUNCTIONS
 */

/// toggles the tint on all polarized windows with matching ID within range
/obj/machinery/controlhub/proc/toggle_windowtint(window_id)
	for(var/obj/structure/window/window in range(src, range))
		if((istype(window, /obj/structure/window/reinforced/polarized) || istype(window, /obj/structure/window/full/reinforced/polarized)) && (window:id == window_id || !window:id))
			window:toggle()

/obj/machinery/controlhub/proc/toggle_holosign(holosign_id)
	for(var/obj/machinery/holosign/holosign in find_machinery_by_id(/obj/machinery/holosign, holosign_id))
		INVOKE_ASYNC(holosign, TYPE_PROC_REF(/obj/machinery/holosign, toggle))

/// toggles blast doors with matching ID based on first door's state
/obj/machinery/controlhub/proc/toggle_blast_doors(door_id)
	var/open_doors

	for(var/obj/machinery/door/blast/door in find_machinery_by_id(/obj/machinery/door/blast, door_id))
		if(isnull(open_doors))
			open_doors = door.density

		if(open_doors)
			door.open()
		else
			door.close()

/// controls airlocks with matching ID. special_functions bitflags: 1=open/close, 2=ID scan, 4=bolt, 8=electrify, 16=safeties
/obj/machinery/controlhub/proc/toggle_airlock(control_name, airlock_id, special_functions = 1)
	if(isnull(control_states[control_name]))
		control_states[control_name] = FALSE

	control_states[control_name] = !control_states[control_name]

	for(var/obj/machinery/door/airlock/airlock in SSmachinery.machinery)
		if(airlock.id_tag != airlock_id)
			continue

		if(special_functions & 1)
			if(airlock.density)
				airlock.open()
			else
				airlock.close()
			return

		if(control_states[control_name])
			if(special_functions & 2)
				airlock.set_idscan(FALSE)
			if(special_functions & 4)
				airlock.lock()
			if(special_functions & 8)
				airlock.electrify(-1)
			if(special_functions & 16)
				airlock.set_safeties(FALSE)
		else
			if(special_functions & 2)
				airlock.set_idscan(TRUE)
			if(special_functions & 4)
				airlock.unlock()
			if(special_functions & 8)
				airlock.electrify(0)
			if(special_functions & 16)
				airlock.set_safeties(TRUE)

/obj/machinery/controlhub/proc/trigger_flasher(flasher_id)
	for(var/obj/machinery/flasher/flasher in find_machinery_by_id(/obj/machinery/flasher, flasher_id))
		flasher.flash()

/obj/machinery/controlhub/proc/trigger_igniter(igniter_id)
	for(var/obj/machinery/sparker/sparker in find_machinery_by_id(/obj/machinery/sparker, igniter_id))
		INVOKE_ASYNC(sparker, TYPE_PROC_REF(/obj/machinery/sparker, ignite))

	for(var/obj/machinery/igniter/igniter in find_machinery_by_id(/obj/machinery/igniter, igniter_id))
		igniter.ignite()

/obj/machinery/controlhub/proc/trigger_emitter(emitter_id)
	for(var/obj/machinery/power/emitter/emitter in find_machinery_by_id(/obj/machinery/power/emitter, emitter_id))
		emitter.activate()

/// opens blast door, triggers mass driver, then closes blast door
/obj/machinery/controlhub/proc/trigger_mass_driver(driver_id)
	var/list/obj/machinery/door/blast/blast_doors = list()

	for(var/obj/machinery/door/blast/door in find_machinery_by_id(/obj/machinery/door/blast, driver_id))
		blast_doors += door
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/machinery/door/blast, open))

	sleep(2 SECONDS)

	for(var/obj/machinery/mass_driver/driver in find_machinery_by_id(/obj/machinery/mass_driver, driver_id))
		driver.drive()

	sleep(5 SECONDS)

	for(var/obj/machinery/door/blast/door in blast_doors)
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/machinery/door/blast, close))

/*
 * SUBTYPES
 */

/obj/machinery/controlhub/bar
	name = "bar control hub"
	icon_state = "holocontrol"
	req_access = list(ACCESS_BAR)
	controls = list(
		"bar holosign" = list("type" = "holosign", "id" = "bar"),
		"bar shutters" = list("type" = "blast_door", "id" = "bar_shutter"),
		"bar window tint" = list("type" = "windowtint", "id" = "bar_fore"),
		"bar window shutters" = list("type" = "blast_door", "id" = "bar_viewing_shutters")
	)

