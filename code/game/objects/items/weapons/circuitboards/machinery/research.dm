#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

obj/item/circuitboard/rdserver
	name = T_BOARD("R&D server")
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/stock_parts/scanning_module" = 1)

obj/item/circuitboard/rdtechprocessor
	name = T_BOARD("R&D tech processor")
	build_path = /obj/machinery/r_n_d/tech_processor
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/stock_parts/scanning_module" = 2
	)

/obj/item/circuitboard/destructive_analyzer
	name = T_BOARD("destructive analyzer")
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	board_type = "machine"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							"/obj/item/stock_parts/scanning_module" = 1,
							"/obj/item/stock_parts/manipulator" = 1,
							"/obj/item/stock_parts/micro_laser" = 1)

/obj/item/circuitboard/autolathe
	name = T_BOARD("autolathe")
	build_path = /obj/machinery/autolathe
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							"/obj/item/stock_parts/matter_bin" = 3,
							"/obj/item/stock_parts/manipulator" = 1,
							"/obj/item/stock_parts/console_screen" = 1)

/obj/item/circuitboard/protolathe
	name = T_BOARD("protolathe")
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							"/obj/item/stock_parts/matter_bin" = 2,
							"/obj/item/stock_parts/manipulator" = 2,
							"/obj/item/reagent_containers/glass/beaker" = 2)


/obj/item/circuitboard/circuit_imprinter
	name = T_BOARD("circuit imprinter")
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/manipulator" = 1,
							"/obj/item/reagent_containers/glass/beaker" = 2)

/obj/item/circuitboard/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							"/obj/item/stock_parts/matter_bin" = 2,
							"/obj/item/stock_parts/manipulator" = 1,
							"/obj/item/stock_parts/micro_laser" = 1,
							"/obj/item/stock_parts/console_screen" = 1)

/obj/item/circuitboard/telesci_pad
	name = T_BOARD("telepad")
	build_path = /obj/machinery/telepad
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BLUESPACE = 4)
	req_components = list(
							"/obj/item/bluespace_crystal" = 2,
							"/obj/item/stock_parts/capacitor" = 1,
							"/obj/item/stack/cable_coil" = 1,
							"/obj/item/stock_parts/console_screen" = 1)

obj/item/circuitboard/ntnet_relay
	name = "Circuit board (NTNet Quantum Relay)"
	build_path = /obj/machinery/ntnet_relay
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 15)
