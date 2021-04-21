/datum/wires/secure_closet
	holder_type = /obj/structure/closet/secure_closet
	wire_count = 6

/datum/wires/secure_closet/scrambled
	random = TRUE

var/const/CLOSET_HACK_WIRE = 1 // toggles the lock if pulsed, breaks if cut
var/const/CLOSET_BREAK_WIRE = 2 // breaks the lock if pulsed or cut, less stealthy

/datum/wires/secure_closet/GetInteractWindow()
	var/obj/structure/closet/secure_closet/SC = holder

	. += ..()
	. += "<BR>The lock is [SC.broken ? "[SPAN_BAD("broken")]" : SC.locked ? "[SPAN_BAD("locked")]" : "[SPAN_GOOD("unlocked")]"]."

/datum/wires/secure_closet/CanUse()
	var/obj/structure/closet/secure_closet/SC = holder
	if(SC.crowbarred)
		return TRUE
	return FALSE

/datum/wires/secure_closet/UpdateCut(index, mended)
	var/obj/structure/closet/secure_closet/SC = holder
	switch(index)
		if(CLOSET_HACK_WIRE, CLOSET_BREAK_WIRE)
			if(!SC.broken)
				SC.broken = TRUE
				SC.locked = FALSE
				SC.update_icon()
		else
			var/mob/living/carbon/C = usr
			if(istype(C) && C.can_electrocute("hand"))
				C.electrocute_act(15, SC, 1, usr.hand ? BP_L_HAND : BP_R_HAND, FALSE)

/datum/wires/secure_closet/UpdatePulsed(index)
	if(IsIndexCut(index))
		return
	var/obj/structure/closet/secure_closet/SC = holder
	switch(index)
		if(CLOSET_HACK_WIRE)
			SC.locked = !SC.locked
			SC.update_icon()
		if(CLOSET_BREAK_WIRE)
			if(!SC.broken)
				SC.broken = TRUE
				SC.locked = FALSE
				SC.update_icon()
		else
			var/mob/living/carbon/C = usr
			if(istype(C) && C.can_electrocute("hand"))
				C.electrocute_act(15, SC, 1, usr.hand ? BP_L_HAND : BP_R_HAND, FALSE)