/datum/wires/disposal
	proper_name = "Disposals"
	random = TRUE
	holder_type = /obj/machinery/disposal

/datum/wires/disposal/New(atom/holder)
	wires = list(
		WIRE_FLUSH
	)
	add_duds(3)
	..()

/datum/wires/disposal/get_status()
	var/obj/machinery/disposal/D = holder
	. = ..()
	. += "<br>\nThe light indicator inserted within the flush handle is [D.can_flush ? "on" : "off"]."

/datum/wires/disposal/on_cut(wire, mend, source)
	var/obj/machinery/disposal/D = holder
	switch(wire)
		if(WIRE_FLUSH)
			if(!mend)
				D.can_flush = FALSE
				D.visible_message(SPAN_WARNING("\The [D] whines loudly."), range = 3)
			else
				D.can_flush = TRUE
				D.visible_message(SPAN_NOTICE("\The [D] hums soothingly."), range = 3)

/datum/wires/disposal/on_pulse(wire)
	var/obj/machinery/disposal/D = holder
	switch(wire)
		if(WIRE_FLUSH)
			if(D.air_contents.return_pressure() >= (700 + ONE_ATMOSPHERE) || !D.uses_air)
				D.flush()

/datum/wires/disposal/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/disposal/D = holder
	if(D.mode <= 0)
		return TRUE
	return FALSE
