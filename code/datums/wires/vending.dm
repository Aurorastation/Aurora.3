#define CAT_HIDDEN 2   // Also in code/game/machinery/vending.dm

/datum/wires/vending
	holder_type = /obj/machinery/vending
	wire_count = 6

var/const/VENDING_WIRE_THROW = 1
var/const/VENDING_WIRE_CONTRABAND = 2
var/const/VENDING_WIRE_ELECTRIFY = 4
var/const/VENDING_WIRE_IDSCAN = 8
var/const/VENDING_WIRE_COOLING = 16
var/const/VENDING_WIRE_HEATING = 32

/datum/wires/vending/CanUse(var/mob/living/L)
	var/obj/machinery/vending/V = holder
	if(!istype(L, /mob/living/silicon))
		if(V.seconds_electrified)
			if(V.shock(L, 100))
				return 0
	if(V.panel_open)
		return 1
	return 0

/datum/wires/vending/GetInteractWindow()
	var/obj/machinery/vending/V = holder
	. += ..()
	. += "<BR>The orange light is [V.seconds_electrified ? "off" : "on"].<BR>"
	. += "The red light is [V.shoot_inventory ? "off" : "blinking"].<BR>"
	. += "The green light is [(V.categories & CAT_HIDDEN) ? "on" : "off"].<BR>"
	. += "The [V.scan_id ? "purple" : "yellow"] light is on.<BR>"
	. += "The cyan light is [V.temperature_setting == -1 ? "on" : "off"].<BR>"
	. += "The blue light is [V.temperature_setting == 1 ? "on" : "off"].<BR>"

/datum/wires/vending/UpdatePulsed(var/index)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			V.shoot_inventory = !V.shoot_inventory
		if(VENDING_WIRE_CONTRABAND)
			V.categories ^= CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			V.seconds_electrified = 30
		if(VENDING_WIRE_IDSCAN)
			V.scan_id = !V.scan_id
		if(VENDING_WIRE_COOLING)
			V.temperature_setting = V.temperature_setting != -1 ? -1 : 0
		if(VENDING_WIRE_HEATING)
			V.temperature_setting = V.temperature_setting != 1 ? 1 : 0

/datum/wires/vending/UpdateCut(var/index, var/mended)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			V.shoot_inventory = !mended
		if(VENDING_WIRE_CONTRABAND)
			V.categories &= ~CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			if(mended)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(VENDING_WIRE_IDSCAN)
			V.scan_id = 1
		if(VENDING_WIRE_COOLING)
			V.temperature_setting = mended && V.temperature_setting != 1 ? -1 : 0
		if(VENDING_WIRE_HEATING)
			V.temperature_setting = mended && V.temperature_setting != -1 ? 1 : 0
