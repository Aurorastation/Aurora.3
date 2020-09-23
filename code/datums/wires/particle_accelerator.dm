/datum/wires/particle_acc/control_box
	wire_count = 4
	holder_type = /obj/machinery/particle_accelerator/control_box

var/const/PARTICLE_TOGGLE_WIRE = 1 // Toggles whether the PA is on or not.
var/const/PARTICLE_STRENGTH_WIRE = 2 // Determines the strength of the PA.
var/const/PARTICLE_LIMIT_POWER_WIRE = 4 // Determines how strong the PA can be.

/datum/wires/particle_acc/control_box/GetInteractWindow()
	var/obj/machinery/particle_accelerator/control_box/C = holder
	. += ..()
	. += text("<br>\n[]<br>\n[]<br>\n[]",
	((C.active && C.assembled) ? "The firing light is on." : "The firing light is off."),
	(C.strength ? "The strength light is blinking." : "The strength light is off."),
	(C.strength_upper_limit == 2 ? "The strength limiter light is on." : "The strength limiter light is off."))

/datum/wires/particle_acc/control_box/CanUse(var/mob/living/L)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	if(C.construction_state == 2)
		return 1
	return 0

/datum/wires/particle_acc/control_box/UpdatePulsed(var/index)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(index)

		if(PARTICLE_TOGGLE_WIRE)
			C.toggle_power(usr)

		if(PARTICLE_STRENGTH_WIRE)
			C.add_strength()

		if(PARTICLE_LIMIT_POWER_WIRE)
			C.visible_message("[icon2html(C, viewers(get_turf(C)))]<b>[C]</b> makes a large whirring noise.")

/datum/wires/particle_acc/control_box/UpdateCut(var/index, var/mended)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(index)

		if(PARTICLE_TOGGLE_WIRE)
			if(C.active == !mended)
				C.toggle_power(usr)

		if(PARTICLE_LIMIT_POWER_WIRE)
			C.strength_upper_limit = (mended ? 2 : 3)
			if(C.strength_upper_limit < C.strength)
				C.remove_strength()
