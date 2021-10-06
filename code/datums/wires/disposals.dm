/datum/wires/disposal
	random = TRUE
	holder_type = /obj/machinery/disposal
	wire_count = 3

var/const/DISPOSAL_WIRE_FLUSH = 1

/datum/wires/disposal/GetInteractWindow()
	. = ..()

	var/obj/machinery/disposal/D = holder
	. += "<br>\nThe light indicator inserted within the flush handle is [D.can_flush ? "on" : "off"]."
	return .

/datum/wires/disposal/UpdateCut(var/index, var/mended)
	var/obj/machinery/disposal/D = holder
	switch(index)
		if(DISPOSAL_WIRE_FLUSH)
			if(!mended)
				D.can_flush = FALSE
				D.visible_message(SPAN_WARNING("\The [D] whines loudly."), range = 3)
			else
				D.can_flush = TRUE
				D.visible_message(SPAN_NOTICE("\The [D] hums soothingly."), range = 3)

/datum/wires/disposal/UpdatePulsed(var/index)
	var/obj/machinery/disposal/D = holder
	switch(index)
		if(DISPOSAL_WIRE_FLUSH)
			if(D.air_contents.return_pressure() >= (700 + ONE_ATMOSPHERE) || !D.uses_air)
				D.flush()

/datum/wires/disposal/CanUse(var/mob/living/L)
	var/obj/machinery/disposal/D = holder
	if(D.mode <= 0)
		return TRUE
	return FALSE