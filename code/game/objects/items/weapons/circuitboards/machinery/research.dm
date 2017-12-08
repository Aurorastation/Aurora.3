#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

	name = T_BOARD("R&D server")
	build_path = "/obj/machinery/r_n_d/server"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,

	name = T_BOARD("destructive analyzer")
	build_path = "/obj/machinery/r_n_d/destructive_analyzer"
	board_type = "machine"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(

	name = T_BOARD("autolathe")
	build_path = "/obj/machinery/autolathe"
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(

	name = T_BOARD("protolathe")
	build_path = "/obj/machinery/r_n_d/protolathe"
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(


	name = T_BOARD("circuit imprinter")
	build_path = "/obj/machinery/r_n_d/circuit_imprinter"
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(

	name = "Circuit board (Exosuit Fabricator)"
	build_path = "/obj/machinery/mecha_part_fabricator"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(

	name = T_BOARD("telepad")
	build_path = "/obj/machinery/telepad"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BLUESPACE = 4)
	req_components = list(
							"/obj/item/bluespace_crystal" = 2,
							"/obj/item/stack/cable_coil" = 1,

	name = "Circuit board (NTNet Quantum Relay)"
	build_path = "/obj/machinery/ntnet_relay"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 15)
