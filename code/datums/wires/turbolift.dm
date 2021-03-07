/datum/wires/turoblift
	holder_type = /obj/machinery/turbolift_controller
	wire_count = 9
	random = TRUE

	var/hacking_idscan = FALSE
	var/hacking_safety = 0
	var/hacking_cabincall = FALSE
	var/hacking_hallcall = FALSE
	var/hacking_doorcontrol = FALSE


var/const/TURBOLIFT_WIRE_IDSCAN = 1
var/const/TURBOLIFT_WIRE_SAFETY = 2
var/const/TURBOLIFT_WIRE_CABINCALL = 4
var/const/TURBOLIFT_WIRE_HALLCALL = 8
var/const/TURBOLIFT_WIRE_FAKEPOWER1 = 16
var/const/TURBOLIFT_WIRE_FAKEPOWER2 = 32
var/const/TURBOLIFT_WIRE_DOORCONTROL = 64


/datum/wires/turoblift/CanUse(var/mob/living/L)
	var/obj/machinery/turbolift_controller/P = holder
	if(P.panel_open)
		return 1
	return 0

/datum/wires/turoblift/proc/shock(var/mob/M)
	spark(holder, 5, alldirs)
	electrocute_mob(M, get_area(holder), holder, 0.7)

/datum/wires/turoblift/GetInteractWindow()
	. += ..()
	var/list/text = list()
	text += "[(hacking_idscan ? "The 'IDSCAN' light is off." : "The 'IDSCAN' light is on.")]"
	if(!hacking_safety)
		text += "The 'SAFETY' light is on."
	else if(hacking_safety == 1)
		text += "The 'SAFETY' light is blinking."
	else if(hacking_safety == 2)
		text += "The 'SAFETY' light is off."
	text += "[(hacking_cabincall ? "The 'CABINCALL' light is off." : "The 'CABINCALL' light is on.")]"
	text += "[(hacking_hallcall ? "The 'HALLCALL' light is off." : "The 'HALLCALL' light is on.")]"
	text += "[(hacking_doorcontrol ? "The 'DOORCONTROL' light is off." : "The 'DOORCONTROL' light is on.")]"
	. += "<br>\n" + jointext(text, "<br>\n")

/datum/wires/turoblift/UpdateCut(var/index, var/mended)
	var/obj/structure/lift/panel/P = holder
	if(!P.lift)
		return
	switch(index)
		if(TURBOLIFT_WIRE_IDSCAN)
			hacking_idscan = !mended

		if(TURBOLIFT_WIRE_SAFETY)
			if(mended)
				hacking_safety = 0
			else
				hacking_safety = 2

		if(TURBOLIFT_WIRE_CABINCALL)
			hacking_cabincall = !mended

		if(TURBOLIFT_WIRE_HALLCALL)
			hacking_hallcall = !mended

		if(TURBOLIFT_WIRE_DOORCONTROL)
			hacking_doorcontrol = !mended

		if(TURBOLIFT_WIRE_FAKEPOWER1)
			shock(usr)

		if(TURBOLIFT_WIRE_FAKEPOWER2)
			shock(usr)

/datum/wires/turoblift/UpdatePulsed(var/index)
	var/obj/structure/lift/panel/P = holder
	if(!P.lift)
		return
	switch(index)
		if(TURBOLIFT_WIRE_SAFETY)
			if(hacking_safety == 0)
				hacking_safety = 1
			else if(hacking_safety == 1)
				hacking_safety = 0

		if(TURBOLIFT_WIRE_FAKEPOWER1)
			shock(usr)

		if(TURBOLIFT_WIRE_FAKEPOWER2)
			shock(usr)
