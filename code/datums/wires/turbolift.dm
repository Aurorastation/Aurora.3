/datum/wires/turoblift
	holder_type = /obj/structure/lift/panel
	wire_count = 8

var/const/TURBOLIFT_WIRE_IDSCAN = 1
var/const/TURBOLIFT_WIRE_SAFETY = 2
var/const/TURBOLIFT_WIRE_INTCONTROL = 4
var/const/TURBOLIFT_WIRE_EXTCONTROL = 8


/datum/wires/turoblift/CanUse(var/mob/living/L)
	var/obj/structure/lift/panel/P = holder
	if(P.wiresexposed)
		return 1
	return 0

/datum/wires/turoblift/GetInteractWindow()
	var/obj/structure/lift/panel/P = holder
	. += ..()
	. += text("<br>\n[(P.lift?.hacking_idscan ? "The 'IDSCAN' light is on." : "The 'IDSCAN' light is off.")]<br>\n[(P.lift?.hacking_safety ? "The 'SAFETY' light is on." : "The 'SAFETY' light is off.")]<br>\n[(P.lift?.hacking_intcontrol ? "The 'INTCONTROL' light is on." : "The 'INTCONTROL' light is off.")]\n[(P.lift?.hacking_extcontrol ? "The 'EXTCONTROL' light is on." : "The 'EXTCONTROL' light is off.")]")

/datum/wires/turoblift/UpdateCut(var/index, var/mended)
	var/obj/structure/lift/panel/P = holder
	if(!P.lift)
		return
	switch(index)
		if(TURBOLIFT_WIRE_IDSCAN)
			P.lift.hacking_idscan = !mended

		if(TURBOLIFT_WIRE_SAFETY)
			if(mended)
				P.lift.hacking_safety = 0
			else
				P.lift.hacking_safety = 2

		if(TURBOLIFT_WIRE_INTCONTROL)
			P.lift.hacking_intcontrol = !mended

		if(TURBOLIFT_WIRE_EXTCONTROL)
			P.lift.hacking_extcontrol = !mended

/datum/wires/turoblift/UpdatePulsed(var/index)
	var/obj/structure/lift/panel/P = holder
	if(!P.lift)
		return
	switch(index)
		if(TURBOLIFT_WIRE_IDSCAN)
			P.lift.hacking_idscan = 1
			spawn(100)
				P.lift.hacking_idscan = 0

		if(TURBOLIFT_WIRE_SAFETY)
			if(P.lift.hacking_safety == 0)
				P.lift.hacking_safety = 1
			else if(P.lift.hacking_safety == 1)
				P.lift.hacking_safety = 0

		if(TURBOLIFT_WIRE_INTCONTROL)
			P.lift.hacking_intcontrol = 0
			spawn(100)
				P.lift.hacking_intcontrol = 1

		if(TURBOLIFT_WIRE_EXTCONTROL)
			P.lift.hacking_extcontrol = 0
			spawn(100)
				P.lift.hacking_extcontrol = 1
