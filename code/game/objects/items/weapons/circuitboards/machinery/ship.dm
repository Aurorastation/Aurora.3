//Thrusters
/obj/item/circuitboard/unary_atmos/engine
	name = T_BOARD("gas thruster")
	icon_state = "mcontroller"
	build_path = /obj/machinery/atmospherics/unary/engine
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list(
		"/obj/item/stack/cable_coil" = 30,
		"/obj/item/pipe" = 2)

/obj/item/circuitboard/unary_atmos/engine/scc_shuttle
	build_path = /obj/machinery/atmospherics/unary/engine/scc_shuttle

/obj/item/circuitboard/unary_atmos/engine/scc_ship
	build_path = /obj/machinery/atmospherics/unary/engine/scc_ship_engine

/obj/item/circuitboard/engine/ion
	name = T_BOARD("ion propulsion device")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/ion_engine
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	req_components = list(
		"/obj/item/stack/cable_coil" = 2,
		"/obj/item/stock_parts/matter_bin" = 1,
		"/obj/item/stock_parts/capacitor" = 2)

/obj/item/circuitboard/engine/maneuvering
	name = T_BOARD("pulse-maneuvering device")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/maneuvering_engine
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	req_components = list(
		"/obj/item/stack/cable_coil" = 2,
		"/obj/item/stock_parts/matter_bin" = 1,
		"/obj/item/stock_parts/capacitor" = 2
	)

//IFF Beacon
/obj/item/circuitboard/iff_beacon
	name = T_BOARD("IFF transponder")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/iff_beacon
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
		"/obj/item/stack/cable_coil" = 2,
		"/obj/item/stock_parts/subspace/transmitter" = 1,
		"/obj/item/stock_parts/capacitor" = 2
	)

//Sensors
/obj/item/circuitboard/shipsensors
	name = T_BOARD("sensor suite")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/shipsensors
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 5, TECH_BLUESPACE = 3)
	req_components = list(
		"/obj/item/stock_parts/subspace/ansible" = 1,
		"/obj/item/stock_parts/subspace/filter" = 1,
		"/obj/item/stock_parts/subspace/treatment" = 1,
		"/obj/item/stock_parts/subspace/analyzer" = 1,
		"/obj/item/stock_parts/scanning_module" = 2,
		"/obj/item/stock_parts/manipulator" = 3
	)

/obj/item/circuitboard/shipsensors/weak
	name = T_BOARD("low-power sensor suite")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/shipsensors/weak
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 1)
	req_components = list(
		"/obj/item/stock_parts/subspace/ansible" = 1,
		"/obj/item/stock_parts/subspace/filter" = 1,
		"/obj/item/stock_parts/subspace/treatment" = 1,
		"/obj/item/stock_parts/scanning_module" = 1,
		"/obj/item/stock_parts/manipulator" = 3
	)

/obj/item/circuitboard/shipsensors/weak/scc
	build_path = /obj/machinery/shipsensors/weak/scc_shuttle

/obj/item/circuitboard/shipsensors/strong
	name = T_BOARD("high-power sensor suite")
	build_path = /obj/machinery/shipsensors/strong
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 8, TECH_BLUESPACE = 5)
	req_components = list(
		"/obj/item/stock_parts/subspace/ansible" = 1,
		"/obj/item/stock_parts/subspace/filter" = 1,
		"/obj/item/stock_parts/subspace/treatment" = 1,
		"/obj/item/stock_parts/subspace/analyzer" = 1,
		"/obj/item/stock_parts/manipulator/pico" = 3,
		"/obj/item/stock_parts/scanning_module/phasic" = 1,
		"/obj/item/stack/cable_coil" = 30
	)

/obj/item/circuitboard/shipsensors/strong/scc
	build_path = /obj/machinery/shipsensors/strong/scc_shuttle

/obj/item/circuitboard/shipsensors/venator
	name = T_BOARD("venator-class quantum sensor array")
	build_path = /obj/machinery/shipsensors/strong/venator
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 10, TECH_BLUESPACE = 8, TECH_PHORON = 4)
	req_components = list(
		"/obj/item/stock_parts/subspace/ansible" = 1,
		"/obj/item/stock_parts/subspace/filter" = 1,
		"/obj/item/stock_parts/subspace/treatment" = 1,
		"/obj/item/stock_parts/subspace/analyzer" = 1,
		"/obj/item/stock_parts/subspace/amplifier" = 1,
		"/obj/item/stock_parts/manipulator/pico" = 4,
		"/obj/item/stock_parts/scanning_module/phasic" = 3,
		"/obj/item/stack/cable_coil" = 30,
		"/obj/item/bluespace_crystal" = 1
	)

/obj/item/circuitboard/shipsensors/relay
	name = T_BOARD("S-24 Beacon sensor array")
	build_path = /obj/machinery/shipsensors/strong/relay
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 8, TECH_BLUESPACE = 5)
	req_components = list(
		"/obj/item/stock_parts/subspace/ansible" = 1,
		"/obj/item/stock_parts/subspace/filter" = 1,
		"/obj/item/stock_parts/subspace/treatment" = 1,
		"/obj/item/stock_parts/subspace/analyzer" = 1,
		"/obj/item/stock_parts/manipulator" = 6,
		"/obj/item/stock_parts/scanning_module" = 3,
		"/obj/item/stack/cable_coil" = 30
	)
