/datum/wires/fabricator
	proper_name = "Fabricator"
	holder_type = /obj/machinery/fabricator

/datum/wires/fabricator/New(atom/holder)
	wires = list(
		WIRE_HACK, WIRE_DISABLE,
		WIRE_SHOCK
	)
	add_duds(2)
	..()

/datum/wires/fabricator/get_status()
	var/obj/machinery/fabricator/A = holder
	. = ..()
	. += "\The [A] [(A.fab_status_flags & FAB_DISABLED) ? "is dead quiet" : "has a soft electric whirr"]."
	. += "\The [A] [(A.fab_status_flags & FAB_SHOCKED) ? "is making sparking noises" : "is cycling normally"]."
	. += "\The [A] [(A.fab_status_flags & FAB_HACKED) ? "rarely" : "occasionally"] makes a beep boop noise."

/datum/wires/fabricator/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/fabricator/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

/datum/wires/fabricator/on_cut(wire, mend, source)
	var/obj/machinery/fabricator/A = holder
	switch(wire)
		if(WIRE_HACK)
			if(mend)
				A.fab_status_flags &= ~FAB_HACKED
			else
				A.fab_status_flags |= FAB_HACKED
		if(WIRE_SHOCK)
			if(mend)
				A.fab_status_flags &= ~FAB_SHOCKED
			else
				A.fab_status_flags |= FAB_SHOCKED
		if(WIRE_DISABLE)
			if(mend)
				A.fab_status_flags &= ~FAB_DISABLED
			else
				A.fab_status_flags |= FAB_DISABLED

/datum/wires/fabricator/on_pulse(wire)
	if(is_cut(wire))
		return
	var/obj/machinery/fabricator/A = holder
	switch(wire)
		if(WIRE_HACK)
			if(A.fab_status_flags & FAB_HACKED)
				A.fab_status_flags &= ~FAB_HACKED
			else
				A.fab_status_flags |= FAB_HACKED
			spawn(50)
				if(A && !is_cut(wire))
					A.fab_status_flags &= ~FAB_HACKED
					interact(usr)
		if(WIRE_SHOCK)
			if(A.fab_status_flags & FAB_SHOCKED)
				A.fab_status_flags &= ~FAB_SHOCKED
			else
				A.fab_status_flags |= FAB_SHOCKED
			spawn(50)
				if(A && !is_cut(wire))
					A.fab_status_flags &= ~FAB_SHOCKED
					interact(usr)
		if(WIRE_DISABLE)
			if(A.fab_status_flags & FAB_DISABLED)
				A.fab_status_flags &= ~FAB_DISABLED
			else
				A.fab_status_flags |= FAB_DISABLED
			spawn(50)
				if(A && !is_cut(wire))
					A.fab_status_flags &= ~FAB_DISABLED
					interact(usr)
