#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/circuitboard/biogenerator
	name = T_BOARD("biogenerator")
	build_path = /obj/machinery/biogenerator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2)
	req_components = list(
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/manipulator" = 1)

/obj/item/circuitboard/biogenerator/small
	name = T_BOARD("small biogenerator")
	build_path = /obj/machinery/biogenerator/small