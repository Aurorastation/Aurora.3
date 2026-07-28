/datum/wires/stasis_cage
	proper_name = "Stasis Cage"
	holder_type = /obj/structure/machinery/stasis_cage
	associated_skill = XENOBIOLOGY_SKILL_COMPONENT

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
	var/obj/structure/machinery/stasis_cage/stasis_cage = holder
	if (stasis_cage.panel_open)
		return TRUE
	return FALSE

/datum/wires/stasis_cage/get_status()
	var/obj/structure/machinery/stasis_cage/stasis_cage = holder
	. = ..()
	if(!stasis_cage.use_power)
		. += "The panel is unpowered."
	else
		. += "The panel is powered."
		. += "The biometric safety sensors are [(WIRE_SAFETY in cut_wires) ? "connected" : "disconnected"]."
		. += "The cage's emergency auto-release mechanism is [(WIRE_RELEASE in cut_wires) ? "disabled" : "enabled"]."
		. += "The cage lid motors are [(WIRE_LOCK in cut_wires) ? "overriden" : "nominal"]."

/datum/wires/stasis_cage/on_cut(wire, mend, source)
	var/obj/structure/machinery/stasis_cage/stasis_cage = holder
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
	var/obj/structure/machinery/stasis_cage/stasis_cage = holder
	switch (wire)
		if (WIRE_SAFETY)
			if (stasis_cage.contained)
				if (prob(20))
					holder.visible_message(SPAN_WARNING("The cage hastily flicks open its lid!"), SPAN_NOTICE("You notice the biometric sensor flag blink fervently."))
					stasis_cage.release()
