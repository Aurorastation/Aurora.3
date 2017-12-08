#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	name = T_BOARD("hull shield generator")
	board_type = "machine"
	build_path = "/obj/machinery/shield_gen/external"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 5)

	name = T_BOARD("bubble shield generator")
	board_type = "machine"
	build_path = "/obj/machinery/shield_gen"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 5)

	name = T_BOARD("shield capacitor")
	board_type = "machine"
	build_path = "/obj/machinery/shield_capacitor"
	origin_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 5)
