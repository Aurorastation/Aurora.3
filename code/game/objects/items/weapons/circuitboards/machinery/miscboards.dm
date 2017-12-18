#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

//Stuff that doesn't fit into any category goes here

/obj/item/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"

/obj/item/circuitboard/sleeper
	name = T_BOARD("sleeper")
	desc = "The circuitboard for a sleeper."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "other" // change this to machine if you want it to be buildable
	req_components = list(
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/scanning_module = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/reagent_containers/glass/beaker/large = 1)

/obj/item/circuitboard/refiner
	name = T_BOARD("ore processor")
	desc = "The circuitboard for an ore processing machine."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "other" // change this to machine if you want it to be buildable
	req_components = list(
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/cooking
	name = T_BOARD("kitchen appliance")
	desc = "The circuitboard for many kitchen appliances. Not of much use."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "other"
	req_components = list(
							/obj/item/stock_parts/capacitor = 3,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/matter_bin = 2)