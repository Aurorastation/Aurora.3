#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/circuitboard/portgen
	name = T_BOARD("portable generator")
	build_path = /obj/machinery/power/portgen/basic
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	req_components = list(
		"/obj/item/stock_parts/matter_bin" = 1,
		"/obj/item/stock_parts/micro_laser" = 1,
		"/obj/item/stack/cable_coil" = 2,
		"/obj/item/stock_parts/capacitor" = 1
	)

/obj/item/circuitboard/portgen/advanced
	name = T_BOARD("advanced portable generator")
	build_path = /obj/machinery/power/portgen/basic/advanced
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)

/obj/item/circuitboard/portgen/super
	name = T_BOARD("super portable generator")
	build_path = /obj/machinery/power/portgen/basic/super
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)

/obj/item/circuitboard/portgen/fusion
	name = T_BOARD("minature fusion reactor")
	build_path = /obj/machinery/power/portgen/basic/fusion
	origin_tech = list(TECH_DATA = 5, TECH_POWER = 7, TECH_ENGINEERING = 7)