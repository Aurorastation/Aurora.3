/datum/wires/particle_acc/control_box
	proper_name = "Particle Accelerator"
	holder_type = /obj/machinery/particle_accelerator/control_box

/datum/wires/particle_acc/control_box/New()
	wires = list(
		WIRE_POWER,
		WIRE_STRENGTH, WIRE_POWER_LIMIT
	)
	add_duds(2)
	..()

/datum/wires/particle_acc/control_box/get_status()
	var/obj/machinery/particle_accelerator/control_box/C = holder
	. += ..()
	. += (C.active && C.assembled) ? "The firing light is on." : "The firing light is off."
	. += C.strength ? "The strength light is blinking." : "The strength light is off."
	. += C.strength_upper_limit == 2 ? "The strength limiter light is on." : "The strength limiter light is off."

/datum/wires/particle_acc/control_box/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/particle_accelerator/control_box/C = holder
	if(C.construction_state == 2)
		return TRUE
	return FALSE

/datum/wires/particle_acc/control_box/on_pulse(wire)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(wire)

		if(WIRE_POWER)
			C.toggle_power(usr)

		if(WIRE_STRENGTH)
			C.add_strength()

		if(WIRE_POWER_LIMIT)
			C.visible_message("[icon2html(C, viewers(get_turf(C)))]<b>[C]</b> makes a large whirring noise.")

/datum/wires/particle_acc/control_box/on_cut(wire, mend, source)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(wire)

		if(WIRE_POWER)
			if(C.active == !mend)
				C.toggle_power(usr)

		if(WIRE_POWER_LIMIT)
			C.strength_upper_limit = (mend ? 2 : 3)
			if(C.strength_upper_limit < C.strength)
				C.remove_strength()
