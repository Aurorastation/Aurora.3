/datum/wires/autolathe
	holder_type = /obj/machinery/autolathe
	wire_count = 6

var/const/AUTOLATHE_HACK_WIRE = 1
var/const/AUTOLATHE_SHOCK_WIRE = 2
var/const/AUTOLATHE_DISABLE_WIRE = 4

/datum/wires/autolathe/GetInteractWindow()
	var/obj/machinery/autolathe/A = holder

	. += ..()
	. += "<BR>\The [A] [A.disabled ? "is dead quiet" : "has a soft electric whirr"]."
	. += "<BR>\The [A] [A.shocked ? "is making sparking noises" : "is cycling normally"]."
	. += "<BR>\The [A] [A.hacked ? "rarely" : "occasionally"] makes a beep boop noise.<BR>"

/datum/wires/autolathe/CanUse()
	var/obj/machinery/autolathe/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

/datum/wires/autolathe/UpdateCut(index, mended)
	var/obj/machinery/autolathe/A = holder
	switch(index)
		if(AUTOLATHE_HACK_WIRE)
			A.hacked = !mended
		if(AUTOLATHE_SHOCK_WIRE)
			A.shocked = !mended
		if(AUTOLATHE_DISABLE_WIRE)
			A.disabled = !mended

/datum/wires/autolathe/UpdatePulsed(index)
	if(IsIndexCut(index))
		return
	var/obj/machinery/autolathe/A = holder
	switch(index)
		if(AUTOLATHE_HACK_WIRE)
			A.hacked = !A.hacked
			spawn(50)
				if(A && !IsIndexCut(index))
					A.hacked = 0
					Interact(usr)
		if(AUTOLATHE_SHOCK_WIRE)
			A.shocked = !A.shocked
			spawn(50)
				if(A && !IsIndexCut(index))
					A.shocked = 0
					Interact(usr)
		if(AUTOLATHE_DISABLE_WIRE)
			A.disabled = !A.disabled
			spawn(50)
				if(A && !IsIndexCut(index))
					A.disabled = 0
					Interact(usr)
