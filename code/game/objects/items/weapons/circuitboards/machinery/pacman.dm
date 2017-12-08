#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	name = T_BOARD("PACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,

	name = T_BOARD("SUPERPACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman/super"
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)

	name = T_BOARD("MRSPACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman/mrs"
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
