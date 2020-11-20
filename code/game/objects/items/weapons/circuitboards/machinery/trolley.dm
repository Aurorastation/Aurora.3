#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/circuitboard/cargo_trolley
	name = T_BOARD("cargo trolley")
	build_path = /obj/vehicle/train/cargo/trolley
	board_type = BOARD_MACHINE
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
		"/obj/item/stack/cable_coil" = 15,
		"/obj/item/stock_parts/capacitor" = 1
		)