#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/holodeckcontrol
	name = T_BOARD("holodeck control console")
	build_path = /obj/machinery/computer/HolodeckControl
	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 2)
	var/last_to_emag
	var/linkedholodeck_area
	var/list/supported_programs
	var/list/restricted_programs

/obj/item/circuitboard/holodeckcontrol/construct(var/obj/machinery/computer/HolodeckControl/HC)
	if (..(HC))
		if(linkedholodeck_area)
			HC.linkedholodeck	= locate(linkedholodeck_area)
		if(last_to_emag)
			HC.last_to_emag		= last_to_emag
			HC.emagged 			= 1
			HC.safety_disabled	= 1

/obj/item/circuitboard/holodeckcontrol/deconstruct(var/obj/machinery/computer/HolodeckControl/HC)
	if (..(HC))
		linkedholodeck_area		= HC.linkedholodeck_area
		last_to_emag			= HC.last_to_emag
		HC.emergencyShutdown()
