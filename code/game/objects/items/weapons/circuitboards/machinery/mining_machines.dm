/obj/item/circuitboard/refiner
	name = T_BOARD("ore processor")
	desc = "The circuitboard for an ore processing machine."
	build_path = /obj/machinery/mineral/processing_unit
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
		"/obj/item/stock_parts/capacitor" = 2,
		"/obj/item/stock_parts/scanning_module" = 1,
		"/obj/item/stock_parts/matter_bin" = 1,
		"/obj/item/stock_parts/micro_laser" = 2
		)

/obj/item/circuitboard/redemption_console
	name = T_BOARD("ore redemption console")
	desc = "The circuitboard for an ore redemption console."
	build_path = /obj/machinery/mineral/processing_unit_console
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
		"/obj/item/stock_parts/scanning_module" = 1,
		"/obj/item/stock_parts/console_screen" = 1
		)

/obj/item/circuitboard/redemption_console/construct(obj/machinery/M)
	. = ..()
	switch(M.dir)
		if(NORTH)
			M.pixel_y = 32
		if(EAST)
			M.pixel_x = 32
		if(WEST)
			M.pixel_x = -32
		if(SOUTH)
			M.pixel_y = -32

/obj/item/circuitboard/unloading_machine
	name = T_BOARD("unloading machine")
	desc = "The circuitboard for an unloading machine."
	build_path = /obj/machinery/mineral/unloading_machine
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
		"/obj/item/stock_parts/manipulator" = 2
		)

/obj/item/circuitboard/stacking_machine
	name = T_BOARD("stacking machine")
	desc = "The circuitboard for a stacking machine."
	build_path = /obj/machinery/mineral/stacking_machine
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
		"/obj/item/stock_parts/manipulator" = 2
		)

/obj/item/circuitboard/stacking_console
	name = T_BOARD("stacking machine console")
	desc = "The circuitboard for an stacking machine console."
	build_path = /obj/machinery/mineral/stacking_unit_console
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	board_type = "machine"
	req_components = list(
		"/obj/item/stock_parts/scanning_module" = 1,
		"/obj/item/stock_parts/console_screen" = 1
		)

/obj/item/circuitboard/stacking_console/construct(obj/machinery/M)
	. = ..()
	switch(M.dir)
		if(NORTH)
			M.pixel_y = 32
		if(EAST)
			M.pixel_x = 32
		if(WEST)
			M.pixel_x = -32
		if(SOUTH)
			M.pixel_y = -32