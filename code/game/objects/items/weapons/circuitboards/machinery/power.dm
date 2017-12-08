#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	name = T_BOARD("superconductive magnetic energy storage")
	build_path = "/obj/machinery/power/smes/buildable"
	board_type = "machine"
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)

	name = T_BOARD("battery rack PSU")
	build_path = "/obj/machinery/power/smes/batteryrack"
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)

	name = T_BOARD("makeshift PSU")
	desc = "An APC circuit repurposed into some power storage device controller"
	build_path = "/obj/machinery/power/smes/batteryrack/makeshift"
	board_type = "machine"
