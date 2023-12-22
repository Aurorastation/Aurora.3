// Wires for cameras.

/datum/wires/camera
	proper_name = "Camera"
	holder_type = /obj/machinery/camera

/datum/wires/camera/New(atom/holder)
	wires = list(
		WIRE_POWER, WIRE_FOCUS,
		WIRE_LIGHT, WIRE_ALARM
	)
	add_duds(1)
	..()

/datum/wires/camera/get_status()
	var/obj/machinery/camera/C = holder
	. = ..()
	. += "[(C.view_range == initial(C.view_range) ? "The focus light is on." : "The focus light is off.")]"
	. += "[(C.can_use() ? "The power link light is on." : "The power link light is off.")]"
	. += "[(C.light_disabled ? "The camera light is off." : "The camera light is on.")]"
	. += "[(C.alarm_on ? "The alarm light is on." : "The alarm light is off.")]"

/datum/wires/camera/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/camera/C = holder
	return C.panel_open

/datum/wires/camera/on_cut(wire, mend, source)
	var/obj/machinery/camera/C = holder

	switch(wire)
		if(WIRE_FOCUS)
			var/range = (mend ? initial(C.view_range) : C.short_range)
			C.setViewRange(range)

		if(WIRE_POWER)
			if(C.status && !mend || !C.status && mend)
				C.deactivate(usr, 1)

		if(WIRE_LIGHT)
			C.light_disabled = !mend

		if(WIRE_ALARM)
			if(!mend)
				C.triggerCameraAlarm()
			else
				C.cancelCameraAlarm()
	return

/datum/wires/camera/on_pulse(wire)
	var/obj/machinery/camera/C = holder
	if(is_cut(wire))
		return
	switch(wire)
		if(WIRE_FOCUS)
			var/new_range = (C.view_range == initial(C.view_range) ? C.short_range : initial(C.view_range))
			C.setViewRange(new_range)

		if(WIRE_POWER)
			C.kick_viewers() // Kicks anyone watching the camera

		if(WIRE_LIGHT)
			C.light_disabled = !C.light_disabled

		if(WIRE_ALARM)
			C.visible_message("[icon2html(C, viewers(get_turf(C)))] *beep*", "[icon2html(C, viewers(get_turf(C)))] *beep*")
	return

/datum/wires/camera/proc/CanDeconstruct()
	if(is_cut(WIRE_POWER) && is_cut(WIRE_FOCUS) && is_cut(WIRE_LIGHT))
		return TRUE
	else
		return FALSE
