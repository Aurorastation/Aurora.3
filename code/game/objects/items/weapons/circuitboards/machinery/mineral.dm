#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/refiner
	name = T_BOARD("industrial smelter")
	desc = "The circuitboard for an industrial smelter."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/mineral/processing_unit"
	board_type = "machine" // change this to machine if you want it to be buildable
	req_components = list(
							"/obj/item/stock_parts/capacitor" = 2,
							"/obj/item/stock_parts/scanning_module" = 1,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/micro_laser" = 2)

/obj/item/circuitboard/refinerconsole
	name = T_BOARD("ore redemption console")
	desc = "The circuitboard for an ore redemption console."
	origin_tech = list(TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/mineralconsole/processing_unit"
	board_type = "machine" // change this to machine if you want it to be buildable
	req_components = list(
							"/obj/item/stack/material/glass" = 2,
							"/obj/item/stock_parts/scanning_module" = 1)

/obj/item/circuitboard/stacker
	name = T_BOARD("stacking machine")
	desc = "The circuitboard for a stacking machine."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/mineral/stacking_machine"
	board_type = "machine" // change this to machine if you want it to be buildable
	req_components = list(
							"/obj/item/stock_parts/capacitor" = 2,
							"/obj/item/stock_parts/scanning_module" = 1,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/micro_laser" = 2)

/obj/item/circuitboard/stackerconsole
	name = T_BOARD("stacking machine console")
	desc = "The circuitboard for a stacking machine console."
	origin_tech = list(TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/mineralconsole/stacking_unit"
	board_type = "machine" // change this to machine if you want it to be buildable
	req_components = list(
							"/obj/item/stack/material/glass" = 2,
							"/obj/item/stock_parts/scanning_module" = 1)

/obj/item/circuitboard/unloader
	name = T_BOARD("unloading machine")
	desc = "The circuitboard for an unloading machine."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = "/obj/machinery/mineral/unloading_machine"
	board_type = "machine" // change this to machine if you want it to be buildable
	req_components = list(
							"/obj/item/stock_parts/capacitor" = 2,
							"/obj/item/stock_parts/scanning_module" = 1,
							"/obj/item/stock_parts/matter_bin" = 1,
							"/obj/item/stock_parts/micro_laser" = 2)