/datum/wires/vending
	holder_type = /obj/machinery/vending
	wire_count = 6

/datum/wires/vending/blueprint
	cares_about_holder = FALSE

var/const/VENDING_WIRE_CONTRABAND = 1
var/const/VENDING_WIRE_ELECTRIFY = 2
var/const/VENDING_WIRE_IDSCAN = 4
var/const/VENDING_WIRE_COOLING = 8
var/const/VENDING_WIRE_HEATING = 16

/datum/wires/vending/CanUse(var/mob/living/L)
	var/obj/machinery/vending/V = holder
	if(!issilicon(L) && V.electrified)
		if(V.shock(L, 100))
			return FALSE
	if(V.panel_open)
		return TRUE
	return FALSE

/datum/wires/vending/GetInteractWindow()
	var/obj/machinery/vending/V = holder
	. += ..()
	. += "<BR>The orange light is [V.electrified ? "off" : "on"].<BR>"
	. += "The green light is [(V.categories & CAT_HIDDEN) ? "on" : "off"].<BR>"
	. += "The [V.secure ? "purple" : "yellow"] light is on.<BR>"
	. += "The cyan light is [V.temperature_setting == -1 ? "on" : "off"].<BR>"
	. += "The blue light is [V.temperature_setting == 1 ? "on" : "off"].<BR>"

/datum/wires/vending/UpdatePulsed(var/index)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_CONTRABAND)
			V.categories ^= CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			V.electrified = 30
		if(VENDING_WIRE_IDSCAN)
			V.secure = !V.secure
		if(VENDING_WIRE_COOLING)
			V.temperature_setting = V.temperature_setting != -1 ? -1 : 0
		if(VENDING_WIRE_HEATING)
			V.temperature_setting = V.temperature_setting != 1 ? 1 : 0

/datum/wires/vending/UpdateCut(var/index, var/mended)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_CONTRABAND)
			V.categories &= ~CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			if(mended)
				V.electrified = FALSE
			else
				V.electrified = TRUE
		if(VENDING_WIRE_IDSCAN)
			V.secure = TRUE
		if(VENDING_WIRE_COOLING)
			V.temperature_setting = mended && V.temperature_setting != 1 ? -1 : 0
		if(VENDING_WIRE_HEATING)
			V.temperature_setting = mended && V.temperature_setting != -1 ? 1 : 0

/datum/wires/vending/get_wire_diagram(var/mob/user)
	var/dat = ""
	for(var/color in wires)
		dat += "<font color='[color]'>[capitalize(color)]</font>: [index_to_type(GetIndex(color))]<br>"

	var/datum/browser/wire_win = new(user, "vendingwires", "Vending Wires", 450, 500)
	wire_win.set_content(dat)
	wire_win.open()

/datum/wires/vending/proc/index_to_type(var/index)
	switch(index)
		if(1)
			return "Secondary Stock"
		if(2)
			return "Anti-tampering"
		if(4)
			return "ID Scan"
		if(8)
			return "Cooling"
		if(16)
			return "Heating"
