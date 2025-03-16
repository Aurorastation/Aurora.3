/datum/wires/suit_storage_unit
	proper_name = "Suit Storage Unit"
	holder_type = /obj/machinery/suit_cycler

/datum/wires/suit_storage_unit/New()
	wires = list(
		WIRE_SAFETY,
		WIRE_SHOCK,
		WIRE_LOCKDOWN
	)
	add_duds(1)
	..()

/datum/wires/suit_storage_unit/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/suit_cycler/S = holder
	if(S.panel_open)
		return TRUE
	return FALSE

/datum/wires/suit_storage_unit/get_status()
	var/obj/machinery/suit_cycler/S = holder
	. += ..()
	. += "The orange light is [S.electrified ? "off" : "on"]."
	. += "The red light is [S.safeties ? "off" : "blinking"]."
	. += "The yellow light is [S.locked ? "on" : "off"]."

/datum/wires/suit_storage_unit/on_pulse(wire, user)
	var/obj/machinery/suit_cycler/S = holder
	switch(wire)
		if(WIRE_SAFETY)
			S.safeties = !S.safeties
		if(WIRE_SHOCK)
			if(ismob(user))
				S.shock(user, 50)
			S.electrified = 30
		if(WIRE_LOCKDOWN)
			S.locked = !S.locked

/datum/wires/suit_storage_unit/on_cut(wire, mend, source)
	var/obj/machinery/suit_cycler/S = holder
	switch(wire)
		if(WIRE_SAFETY)
			S.safeties = mend
		if(WIRE_SHOCK)
			S.locked = mend
		if(WIRE_LOCKDOWN)
			if(mend)
				S.electrified = 0
			else
				S.electrified = -1
