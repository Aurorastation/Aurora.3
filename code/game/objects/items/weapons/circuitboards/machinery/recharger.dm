/obj/item/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/structure/machinery/recharger
	board_type = BOARD_MACHINE
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list("/obj/item/stock_parts/capacitor" = 2)

/obj/item/circuitboard/recharger/wall
	name = T_BOARD("wall recharger")
	build_path = /obj/structure/machinery/recharger/wall
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	req_components = list("/obj/item/stock_parts/capacitor" = 3)
