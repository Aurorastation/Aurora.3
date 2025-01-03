/datum/wires/smartfridge
	proper_name = "SmartFridge"
	holder_type = /obj/machinery/smartfridge

/datum/wires/smartfridge/New()
	wires = list(
		WIRE_THROW,
		WIRE_SHOCK,
		WIRE_IDSCAN,
		WIRE_COOLING,
		WIRE_HEATING
	)
	add_duds(1)
	..()

/datum/wires/smartfridge/secure
	random = 1

/datum/wires/smartfridge/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/smartfridge/S = holder
	if(S.panel_open)
		return TRUE
	return FALSE

/datum/wires/smartfridge/get_status()
	var/obj/machinery/smartfridge/S = holder
	. += ..()
	. += "The orange light is [S.seconds_electrified ? "off" : "on"]."
	. += "The red light is [S.shoot_inventory ? "off" : "blinking"]."
	. += "A [S.scan_id ? "purple" : "yellow"] light is on."
	. += "The cyan light is [S.cooling ? "on" : "off"]."
	. += "The blue light is [S.heating ? "on" : "off"]."

/datum/wires/smartfridge/on_pulse(wire, user)
	var/obj/machinery/smartfridge/S = holder
	switch(wire)
		if(WIRE_THROW)
			S.shoot_inventory = !S.shoot_inventory
		if(WIRE_SHOCK)
			if(ismob(user))
				S.shock(user, 100)
			S.seconds_electrified = 30
		if(WIRE_IDSCAN)
			S.scan_id = !S.scan_id
		if(WIRE_COOLING)
			S.cooling = !S.cooling
			S.heating = FALSE
		if(WIRE_HEATING)
			S.heating = !S.cooling
			S.cooling = FALSE

/datum/wires/smartfridge/on_cut(wire, mend, source)
	var/obj/machinery/smartfridge/S = holder
	switch(wire)
		if(WIRE_THROW)
			S.shoot_inventory = !mend
		if(WIRE_SHOCK)
			if(mend)
				S.seconds_electrified = 0
			else
				S.seconds_electrified = -1
		if(WIRE_IDSCAN)
			S.scan_id = 1
		if(WIRE_COOLING)
			S.cooling = mend
			S.heating = FALSE
		if(WIRE_HEATING)
			S.heating = mend
			S.cooling = FALSE


