/datum/wires/tag_scanner
	proper_name = "IPC Tag Scanner"
	random = TRUE
	holder_type = /obj/item/ipc_tag_scanner

/datum/wires/tag_scanner/New()
	wires = list(
		WIRE_POWER, WIRE_HACK
	)
	add_duds(4)
	..()

/datum/wires/tag_scanner/get_status()
	var/obj/item/ipc_tag_scanner/S = holder
	. = ..()
	. += "[(S.powered ? "The scanlight is steady." : "The scanlight is strobing.")]"
	. += "[(S.hacked ? "The scanlight is red." : "The scanlight is purple.")]"
	return .

/datum/wires/tag_scanner/on_cut(wire, mend, source)
	var/obj/item/ipc_tag_scanner/S = holder
	switch(wire)
		if(WIRE_POWER)
			if(!mend)
				S.powered = FALSE
				S.visible_message(SPAN_WARNING("\The [S] whines loudly."), range = 3)
			else
				S.powered = TRUE
				S.visible_message(SPAN_NOTICE("\The [S] hums soothingly."), range = 3)

		if(WIRE_HACK)
			if(!mend)
				S.hacked = TRUE
				S.visible_message(SPAN_WARNING("\The [S] starts beeping incessantly."), range = 3)
			else
				S.hacked = FALSE
				S.visible_message(SPAN_NOTICE("\The [S] hums soothingly."), range = 3)


/datum/wires/tag_scanner/on_pulse(wire)
	var/obj/item/ipc_tag_scanner/S = holder
	switch(wire)
		if(WIRE_POWER)
			S.visible_message(SPAN_WARNING("[icon2html(S, viewers(get_turf(S)))] <b>[capitalize_first_letters(S.name)]</b> beeps, \"BOOWEEEP!\""))

		if(WIRE_HACK)
			S.visible_message(SPAN_WARNING("[icon2html(S, viewers(get_turf(S)))] <b>[capitalize_first_letters(S.name)]</b> beeps, \"BEEYUUP!\""))

/datum/wires/tag_scanner/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/item/ipc_tag_scanner/S = holder
	if(S.wires_exposed)
		return TRUE
	return FALSE
