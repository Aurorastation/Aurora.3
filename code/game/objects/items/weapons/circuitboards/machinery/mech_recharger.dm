#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	name = T_BOARD("mech recharger")
	build_path = "/obj/machinery/mech_recharger"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	req_components = list(
