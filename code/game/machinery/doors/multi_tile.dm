//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	dir = EAST
	hatch_offset_x = 16
	hatch_colour = "#d2d2d2"
	open_sound_powered = 'sound/machines/airlock/wide1o.ogg'
	close_sound_powered = 'sound/machines/airlock/wide1c.ogg'

/obj/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	if(hashatch)
		setup_hatch()

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile


/obj/machinery/door/airlock/multi_tile/setup_hatch()
	if(overlays != null)
		hatch_image = null
		hatch_image = image('icons/obj/doors/hatches.dmi', src, hatchstyle, closed_layer+0.1)
		hatch_image.color = hatch_colour
		hatch_image.transform = turn(hatch_image.transform, 90)
		// reset any rotation and transformation applied
		switch(dir)
			if(EAST, WEST)
				hatch_image.pixel_x = hatch_offset_x
				hatch_image.pixel_y = hatch_offset_y
			if(NORTH, SOUTH)
				hatch_image.pixel_x = hatch_offset_y
				hatch_image.pixel_y = hatch_offset_x
		add_overlay(hatch_image)

/obj/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/doors/DoorHazard2x1.dmi'
	width = 2
	hatch_offset_x = 16
	dir = EAST
	enable_smart_generation = FALSE

	open_sound = 'sound/machines/firewideopen.ogg'
	close_sound = 'sound/machines/firewideclose.ogg'

/obj/machinery/door/firedoor/multi_tile/Initialize()
	. = ..()
	if(hashatch)
		setup_hatch()

/obj/machinery/door/firedoor/multi_tile/setup_hatch()
	if(overlays != null)
		hatch_image = null
		hatch_image = image('icons/obj/doors/hatches.dmi', src, hatchstyle, closed_layer+0.1)
		hatch_image.color = hatch_colour
		hatch_image.transform = turn(hatch_image.transform, 90)
		// reset any rotation and transformation applied
		switch(dir)
			if(EAST, WEST)
				hatch_image.pixel_x = hatch_offset_x
				hatch_image.pixel_y = hatch_offset_y
			if(NORTH, SOUTH)
				hatch_image.pixel_x = hatch_offset_y
				hatch_image.pixel_y = hatch_offset_x
		if(density)
			add_overlay(hatch_image)
