#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	name = T_BOARD("cyborg recharging station")
	build_path = "/obj/machinery/recharge_station"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 5,
