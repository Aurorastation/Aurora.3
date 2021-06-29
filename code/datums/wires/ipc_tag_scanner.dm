/datum/wires/tag_scanner
	random = TRUE
	holder_type = /obj/item/ipc_tag_scanner
	wire_count = 4

var/const/TAG_WIRE_DUMMY_ONE = 1
var/const/TAG_WIRE_POWER = 2
var/const/TAG_WIRE_DUMMY_TWO = 4
var/const/TAG_WIRE_HACK = 8

/datum/wires/tag_scanner/GetInteractWindow()
	. = ..()

	var/obj/item/ipc_tag_scanner/S = holder
	. += text("<br>\n[(S.powered ? "The scanlight is steady." : "The scanlight is strobing.")]")
	. += text("<br>\n[(S.hacked ? "The scanlight is red." : "The scanlight is purple.")]")
	return .

/datum/wires/tag_scanner/UpdateCut(var/index, var/mended)
	var/obj/item/ipc_tag_scanner/S = holder
	switch(index)
		if(TAG_WIRE_POWER)
			if(!mended)
				S.powered = FALSE
				S.visible_message(SPAN_WARNING("\The [S] whines loudly."), range = 3)
			else
				S.powered = TRUE
				S.visible_message(SPAN_NOTICE("\The [S] hums soothingly."), range = 3)

		if(TAG_WIRE_HACK)
			if(!mended)
				S.hacked = TRUE
				S.visible_message(SPAN_WARNING("\The [S] starts beeping incessantly."), range = 3)
			else
				S.hacked = FALSE
				S.visible_message(SPAN_NOTICE("\The [S] hums soothingly."), range = 3)


/datum/wires/tag_scanner/UpdatePulsed(var/index)
	var/obj/item/ipc_tag_scanner/S = holder
	switch(index)
		if(TAG_WIRE_POWER)
			S.visible_message(SPAN_WARNING("\icon[S] <b>[capitalize_first_letters(S.name)]</b> beeps, \"BOOWEEEP!\""))

		if(TAG_WIRE_HACK)
			S.visible_message(SPAN_WARNING("\icon[S] <b>[capitalize_first_letters(S.name)]</b> beeps, \"BEEYUUP!\""))

/datum/wires/tag_scanner/CanUse(var/mob/living/L)
	var/obj/item/ipc_tag_scanner/S = holder
	if(S.wires_exposed)
		return TRUE
	return FALSE
