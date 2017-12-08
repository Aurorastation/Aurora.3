#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	name = T_BOARD("clone pod")
	build_path = "/obj/machinery/clonepod"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,

	name = T_BOARD("cloning scanner")
	build_path = "/obj/machinery/dna_scannernew"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2)
