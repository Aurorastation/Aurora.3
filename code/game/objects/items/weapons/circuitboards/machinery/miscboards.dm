#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Stuff that doesn't fit into any category goes here

/obj/item/weapon/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"

/obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("sleeper")
	desc = "The circuitboard for a sleeper."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/sleeper"
	board_type = "machine"
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/glass/beaker/large = 1)

/obj/item/weapon/circuitboard/advscanner
	name = T_BOARD("advanced scanner")
	desc = "The circuitboard for an advanced medical scanner."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/bodyscanner"
	board_type = "machine"
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1, // doesn't need as much stored power because it's not doing intensive processes like dialysis
							/obj/item/weapon/stock_parts/scanning_module = 2) // also doesn't have the console built in

/obj/item/weapon/circuitboard/advscanner_console
	name = T_BOARD("advanced scanner console")
	desc = "The circuitboard for an advanced medical scanner's console."
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/bodyscanner_console"
	board_type = "machine"
	req_components = list(/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/cooking
	name = T_BOARD("kitchen appliance")
	desc = "The circuitboard for many kitchen appliances. Not of much use."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "other"
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)