/datum/wires/vending
	proper_name = "Vending Machine"
	holder_type = /obj/machinery/vending

/datum/wires/vending/New()
	wires = list(
		WIRE_THROW,
		WIRE_CONTRABAND,
		WIRE_SHOCK,
		WIRE_IDSCAN,
		WIRE_COOLING,
		WIRE_HEATING
	)
	..()

/datum/wires/vending/blueprint
	cares_about_holder = FALSE

/datum/wires/vending/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/vending/V = holder
	if(V.panel_open)
		return TRUE
	return FALSE

/datum/wires/vending/get_status()
	var/obj/machinery/vending/V = holder
	. += ..()
	. += "The orange light is [V.seconds_electrified ? "off" : "on"]."
	. += "The red light is [V.shoot_inventory ? "off" : "blinking"]."
	. += "The green light is [(V.categories & CAT_HIDDEN) ? "on" : "off"]."
	. += "The [V.scan_id ? "purple" : "yellow"] light is on."
	. += "The cyan light is [V.temperature_setting == -1 ? "on" : "off"]."
	. += "The blue light is [V.temperature_setting == 1 ? "on" : "off"]."

/datum/wires/vending/on_pulse(wire, user)
	var/obj/machinery/vending/V = holder
	switch(wire)
		if(WIRE_THROW)
			V.shoot_inventory = !V.shoot_inventory
		if(WIRE_CONTRABAND)
			V.categories ^= CAT_HIDDEN
		if(WIRE_SHOCK)
			if(ismob(user))
				V.shock(user, 50)
			V.seconds_electrified = 30
		if(WIRE_IDSCAN)
			V.scan_id = !V.scan_id
		if(WIRE_COOLING)
			V.temperature_setting = V.temperature_setting != -1 ? -1 : 0
		if(WIRE_HEATING)
			V.temperature_setting = V.temperature_setting != 1 ? 1 : 0

/datum/wires/vending/on_cut(wire, mend, source)
	var/obj/machinery/vending/V = holder
	switch(wire)
		if(WIRE_THROW)
			V.shoot_inventory = !mend
		if(WIRE_CONTRABAND)
			V.categories &= ~CAT_HIDDEN
		if(WIRE_SHOCK)
			if(mend)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(WIRE_IDSCAN)
			V.scan_id = 1
		if(WIRE_COOLING)
			V.temperature_setting = mend && V.temperature_setting != 1 ? -1 : 0
		if(WIRE_HEATING)
			V.temperature_setting = mend && V.temperature_setting != -1 ? 1 : 0

/datum/wires/vending/get_wire_diagram(var/mob/user)
	var/dat = ""
	for(var/color in colors)
		if(is_dud_color(color))
			continue
		dat += "<font color='[color]'>[capitalize(color)]</font>: [get_wire(color)]<br>"

	var/datum/browser/wire_win = new(user, "vendingwires", "Vending Wires", 450, 500)
	wire_win.set_content(dat)
	wire_win.open()
