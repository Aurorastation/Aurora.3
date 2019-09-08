#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

//Stuff that doesn't fit into any category goes here

/obj/item/weapon/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"

/obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("Sleeper")
	desc = "The circuitboard for a sleeper."
	build_path = "/obj/machinery/sleeper"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 2,
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/weapon/reagent_containers/glass/beaker/large" = 1)

/obj/item/weapon/circuitboard/cryotube
	name = T_BOARD("Cryo Cell")
	desc = "The circuitboard for a cryo tube."
	build_path = "/obj/machinery/atmospherics/unary/cryo_cell"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 3)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/weapon/reagent_containers/glass/beaker/large" = 1)


/obj/item/weapon/circuitboard/bodyscanner
	name = T_BOARD("Body Scanner Machine")
	desc = "The circuitboard for a body scanner machine."
	build_path = "/obj/machinery/bodyscanner"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 1,
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/device/healthanalyzer" = 1)

/obj/item/weapon/circuitboard/bodyscannerconsole
	name = T_BOARD("Body Scanner Console")
	desc = "The circuitboard for a body scanner console."
	build_path = "/obj/machinery/body_scanconsole"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/requestconsole
	name = T_BOARD("Request Console")
	desc = "The circuitboard for a body scanner console."
	build_path = "/obj/machinery/requests_console"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/optable
	name = T_BOARD("Operation Table")
	desc = "The circuitboard for a operation table."
	build_path = "/obj/machinery/optable"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1)

/obj/item/weapon/circuitboard/optableadv
	name = T_BOARD("Advanced Operation Table")
	desc = "The circuitboard for a advanced operating table."
	build_path = "/obj/machinery/optable/lifesupport"
	origin_tech = list(TECH_BIO = 4, TECH_ENGINEERING = 5)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/capacitor" = 1,
							"/obj/item/device/healthanalyzer" = 1,
							"/obj/item/weapon/stock_parts/scanning_module/adv" = 1,
							"/obj/item/clothing/mask/breath/medical" = 1,
							"/obj/item/weapon/reagent_containers/glass/beaker/large" = 2)

/obj/item/weapon/circuitboard/smartfridge
	name = T_BOARD("Smart Fridge")
	desc = "The circuitboard for a smart fridge."
	build_path = "/obj/machinery/smartfridge"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 3)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/manipulator" = 3)


/obj/item/weapon/circuitboard/refiner
	name = T_BOARD("ore processor")
	desc = "The circuitboard for an ore processing machine."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "other" // change this to machine if you want it to be buildable
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 2)

/obj/item/weapon/circuitboard/cooking
	name = T_BOARD("kitchen appliance")
	desc = "The circuitboard for many kitchen appliances. Not of much use."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "other"
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)

/obj/item/weapon/circuitboard/holopad
	name = T_BOARD("Holopad")
	desc = "The circuitboard for a holopad."
	build_path = "/obj/machinery/hologram/holopad"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2)
	board_type = "machine" 
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 2,
							"/obj/item/weapon/stock_parts/scanning_module" = 1)

/obj/item/weapon/circuitboard/crystelpodconsole
	name = T_BOARD("Crystel Therapy Pod Console")
	desc = "The circuitboard for a crystel therapy pod console."
	build_path = "/obj/machinery/chakraconsole"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/capacitor" = 1)

/obj/item/weapon/circuitboard/crystelpod
	name = T_BOARD("Crystel Therapy Pod")
	desc = "The circuitboard for a crystel therapy pod."
	build_path = "/obj/machinery/chakrapod"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/capacitor" = 2)