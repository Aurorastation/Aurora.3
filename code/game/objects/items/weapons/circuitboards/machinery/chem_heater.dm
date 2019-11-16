#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/chem_heater
	name = T_BOARD("chem heater")
	build_path = "/obj/machinery/chem_heater"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_BIO = 2)
	req_components = list(
		"/obj/item/stock_parts/manipulator" = 3
	)