#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

	name = T_BOARD("bluespacerelay")
	build_path = "/obj/machinery/bluespacerelay"
	board_type = "machine"
	origin_tech = list(TECH_BLUESPACE = 2, TECH_DATA = 2)
	req_components = list(
							"/obj/item/stack/cable_coil" = 30,
						  )
