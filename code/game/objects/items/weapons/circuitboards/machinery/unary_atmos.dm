/obj/item/circuitboard/unary_atmos
	board_type = BOARD_MACHINE
	var/machine_dir = SOUTH
	var/init_dirs = SOUTH

/obj/item/circuitboard/unary_atmos/construct(var/obj/machinery/atmospherics/unary/U)
	U.build(src)

/obj/item/circuitboard/unary_atmos/heater
	name = T_BOARD("gas heating system")
	build_path = /obj/machinery/atmospherics/unary/temperature/heater
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	req_components = list(
							"/obj/item/stack/cable_coil" = 5,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/capacitor" = 2)

/obj/item/circuitboard/unary_atmos/cooler
	name = T_BOARD("gas cooling system")
	build_path = /obj/machinery/atmospherics/unary/temperature/freezer
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/capacitor" = 2,
							"/obj/item/stock_parts/manipulator" = 1)
