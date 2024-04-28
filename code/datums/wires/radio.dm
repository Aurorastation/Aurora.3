/datum/wires/radio
	proper_name = "Radio"
	holder_type = /obj/item/device/radio

/datum/wires/radio/New()
	wires = list(
		WIRE_SIGNAL,
		WIRE_RECEIVE,
		WIRE_TRANSMIT
	)
	add_duds(1)
	..()

/datum/wires/radio/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/item/device/radio/R = holder
	if(R.b_stat)
		return TRUE
	return FALSE

/datum/wires/radio/on_pulse(wire)
	var/obj/item/device/radio/R = holder
	switch(wire)
		if(WIRE_SIGNAL)
			R.set_listening(!R.get_listening() && !is_cut(WIRE_RECEIVE))
			R.set_broadcasting(R.get_listening() && !is_cut(WIRE_TRANSMIT))

		if(WIRE_RECEIVE)
			R.set_listening(!R.get_listening() && !is_cut(WIRE_SIGNAL))

		if(WIRE_TRANSMIT)
			R.set_broadcasting(!R.get_broadcasting() && !is_cut(WIRE_SIGNAL))
	SSnanoui.update_uis(holder)

/datum/wires/radio/on_cut(wire, mend, source)
	var/obj/item/device/radio/R = holder
	switch(wire)
		if(WIRE_SIGNAL)
			R.set_listening(mend && !is_cut(WIRE_RECEIVE))
			R.set_broadcasting(mend && !is_cut(WIRE_TRANSMIT))

		if(WIRE_RECEIVE)
			R.set_listening(mend && !is_cut(WIRE_SIGNAL))

		if(WIRE_TRANSMIT)
			R.set_broadcasting(mend && !is_cut(WIRE_SIGNAL))
	SSnanoui.update_uis(holder)
