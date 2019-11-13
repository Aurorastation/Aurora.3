#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/unary_atmos
	board_type = "machine"
	var/machine_dir = SOUTH
	var/init_dirs = SOUTH

/obj/item/circuitboard/unary_atmos/attackby(obj/item/I as obj, mob/user as mob)
	if(I.isscrewdriver())
		machine_dir = turn(machine_dir, 90)
		init_dirs = machine_dir
		user.visible_message("<span class='notice'>\The [user] adjusts the jumper on the [src]'s port configuration pins.</span>", "<span class='notice'>You adjust the jumper on the port configuration pins. Now set to [dir2text(machine_dir)].</span>")
	return

/obj/item/circuitboard/unary_atmos/examine()
	..()
	to_chat(usr, "The jumper is connecting the [dir2text(machine_dir)] pins.")

/obj/item/circuitboard/unary_atmos/construct(var/obj/machinery/atmospherics/unary/U)
	//TODO: Move this stuff into the relevant constructor when pipe/construction.dm is cleaned up.
	U.dir = src.machine_dir
	U.initialize_directions = src.init_dirs
	U.atmos_init()
	U.build_network()
	if (U.node)
		U.node.atmos_init()
		U.node.build_network()

/obj/item/circuitboard/unary_atmos/heater
	name = T_BOARD("gas heating system")
	build_path = "/obj/machinery/atmospherics/unary/heater"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	req_components = list(
							"/obj/item/stack/cable_coil" = 5,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/capacitor" = 2)

/obj/item/circuitboard/unary_atmos/cooler
	name = T_BOARD("gas cooling system")
	build_path = "/obj/machinery/atmospherics/unary/freezer"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/capacitor" = 2,
							"/obj/item/stock_parts/manipulator" = 1)
