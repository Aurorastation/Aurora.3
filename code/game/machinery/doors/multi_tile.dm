//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	dir = EAST
	hatch_offset_x = 16
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	SetBounds()
	setup_hatch()
	update_icon()

/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()
	setup_hatch()
	update_icon()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/setup_hatch()

	if (overlays != null)
		hatch_image = image('icons/obj/doors/hatches.dmi', src, hatchstyle, closed_layer+0.1)
		hatch_image.color = hatch_colour
		switch(dir)
			if(EAST)
				hatch_image.pixel_x = hatch_offset_x
				hatch_image.pixel_y = hatch_offset_y
			if(WEST)
				hatch_image.transform = turn(hatch_image.transform, 180)
				hatch_image.pixel_x = hatch_offset_x
				hatch_image.pixel_y = hatch_offset_y
			if(NORTH)
				hatch_image.transform = turn(hatch_image.transform, -90)
				hatch_image.pixel_x = hatch_offset_y
				hatch_image.pixel_y = hatch_offset_x
			if(SOUTH)
				hatch_image.transform = turn(hatch_image.transform, 90)
				hatch_image.pixel_x = hatch_offset_y
				hatch_image.pixel_y = hatch_offset_x
		add_overlay(hatch_image)
	else
		spawn(10)//If overlays aren't initialised, wait a second and try again
			setup_hatch()
