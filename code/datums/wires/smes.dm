/datum/wires/smes
	proper_name = "SMES"
	holder_type = /obj/machinery/power/smes/buildable

/datum/wires/smes/New()
	wires = list(
		WIRE_RCON,
		WIRE_INPUT,
		WIRE_OUTPUT,
		WIRE_GROUNDING,
		WIRE_FAILSAFES
	)
	add_duds(1)
	..()

/datum/wires/smes/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/power/smes/buildable/S = holder
	if(S.open_hatch)
		return TRUE
	return FALSE

/datum/wires/smes/get_status()
	var/obj/machinery/power/smes/buildable/S = holder
	. += ..()
	. += "The green light is [(S.input_cut || S.input_pulsed || S.output_cut || S.output_pulsed) ? "off" : "on"]."
	. += "The red light is [(S.safeties_enabled || S.grounding) ? "off" : "blinking"]."
	. += "The blue light is [S.RCon ? "on" : "off"]."

/datum/wires/smes/on_cut(wire, mend, source)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(wire)
		if(WIRE_RCON)
			S.RCon = mend
		if(WIRE_INPUT)
			S.input_cut = !mend
		if(WIRE_OUTPUT)
			S.output_cut = !mend
		if(WIRE_GROUNDING)
			S.grounding = mend
		if(WIRE_FAILSAFES)
			S.safeties_enabled = mend


/datum/wires/smes/on_pulse(wire)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(wire)
		if(WIRE_RCON)
			if(S.RCon)
				S.RCon = 0
				addtimer(CALLBACK(S, TYPE_PROC_REF(/obj/machinery/power/smes/buildable, reset_rcon)), 10)
		if(WIRE_INPUT)
			S.toggle_input()
		if(WIRE_OUTPUT)
			S.toggle_output()
		if(WIRE_GROUNDING)
			S.grounding = 0
		if(WIRE_FAILSAFES)
			if(S.safeties_enabled)
				S.safeties_enabled = 0
				addtimer(CALLBACK(S, TYPE_PROC_REF(/obj/machinery/power/smes/buildable, reset_safeties)), 10)

/obj/machinery/power/smes/buildable/proc/reset_safeties()
	safeties_enabled = TRUE

/obj/machinery/power/smes/buildable/proc/reset_rcon()
	RCon = TRUE
