#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/crusher
	name = T_BOARD("crusher")
	build_path = "/obj/machinery/crusher_base"
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 1, TECH_MAGNET = 1, TECH_MATERIALS = 3)
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 4,
							"/obj/item/weapon/stock_parts/manipulator" = 3,
							"/obj/item/weapon/reagent_containers/glass/beaker" = 3)