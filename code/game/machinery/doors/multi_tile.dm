//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	dir = EAST
	pixel_x = -32
	pixel_y = -32
	hatch_offset_x = -32
	hatch_offset_y = -32
	open_sound_powered = 'sound/machines/airlock/wide1o.ogg'
	close_sound_powered = 'sound/machines/airlock/wide1c.ogg'

	icon = 'icons/obj/doors/basic/double/generic/door.dmi'
	icon_state = "preview"
	frame_color_file = 'icons/obj/doors/basic/double/generic/frame_color.dmi'
	color_file = 'icons/obj/doors/basic/double/generic/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/double/generic/fill_color.dmi'
	glass_file = 'icons/obj/doors/basic/double/generic/fill_glass.dmi'
	fill_file = 'icons/obj/doors/basic/double/generic/fill_steel.dmi'
	bolts_file = 'icons/obj/doors/basic/double/generic/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/basic/double/generic/lights_deny.dmi'
	lights_file = 'icons/obj/doors/basic/double/generic/lights_green.dmi'
	panel_file = 'icons/obj/doors/basic/double/generic/panel.dmi'
	sparks_damaged_file = 'icons/obj/doors/basic/double/generic/sparks_damaged.dmi'
	sparks_broken_file = 'icons/obj/doors/basic/double/generic/sparks_broken.dmi'
	welded_file = 'icons/obj/doors/basic/double/generic/welded.dmi'
	emag_file = 'icons/obj/doors/basic/double/generic/emag.dmi'

/obj/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	if(hashatch)
		setup_hatch()

/obj/machinery/door/airlock/multi_tile/glass
	name = "glass airlock"
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
