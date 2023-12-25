/datum/wires/autolathe
	proper_name = "Autolathe"
	holder_type = /obj/machinery/autolathe

/datum/wires/autolathe/New(atom/holder)
	wires = list(
		WIRE_HACK, WIRE_DISABLE,
		WIRE_SHOCK
	)
	add_duds(2)
	..()

/datum/wires/autolathe/get_status()
	var/obj/machinery/autolathe/A = holder
	. = ..()
	. += "\The [A] [A.disabled ? "is dead quiet" : "has a soft electric whirr"]."
	. += "\The [A] [A.shocked ? "is making sparking noises" : "is cycling normally"]."
	. += "\The [A] [A.hacked ? "rarely" : "occasionally"] makes a beep boop noise."

/datum/wires/autolathe/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/autolathe/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

/datum/wires/autolathe/on_cut(wire, mend, source)
	var/obj/machinery/autolathe/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.hacked = !mend
		if(WIRE_SHOCK)
			A.shocked = !mend
		if(WIRE_DISABLE)
			A.disabled = !mend

/datum/wires/autolathe/on_pulse(wire)
	if(is_cut(wire))
		return
	var/obj/machinery/autolathe/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.hacked = !A.hacked
			spawn(50)
				if(A && !is_cut(wire))
					A.hacked = 0
					interact(usr)
		if(WIRE_SHOCK)
			A.shocked = !A.shocked
			spawn(50)
				if(A && !is_cut(wire))
					A.shocked = 0
					interact(usr)
		if(WIRE_DISABLE)
			A.disabled = !A.disabled
			spawn(50)
				if(A && !is_cut(wire))
					A.disabled = 0
					interact(usr)
