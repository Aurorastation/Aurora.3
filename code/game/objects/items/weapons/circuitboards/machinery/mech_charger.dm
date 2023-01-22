#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/mech_charger
	name = T_BOARD("mech charger")
	build_path = /obj/machinery/mech_charger
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	req_components = list(
		"/obj/item/stock_parts/capacitor" = 2,
		"/obj/item/stock_parts/scanning_module" = 1,
		"/obj/item/stock_parts/manipulator" = 2
	)

/obj/item/circuitboard/mech_charger/hephaestus
	name = T_BOARD("hephaestus mech charger")
	build_path = /obj/machinery/mech_charger/hephaestus
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 3)
	req_components = list(
		"/obj/item/stock_parts/capacitor" = 3,
		"/obj/item/stock_parts/scanning_module" = 2,
		"/obj/item/stock_parts/manipulator" = 3
	)