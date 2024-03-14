//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	dir = EAST
	pixel_x = -32
	pixel_y = -32
	airlock_type = "Multi-Tile"
	assembly_type = /obj/structure/door_assembly/multi_tile
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

	var/list/vision_blockers

/obj/machinery/door/airlock/multi_tile/Initialize(mapload, d, populate_components, obj/structure/door_assembly/DA)
	. = ..()
	if(visible && !glass)
		for(var/turf/turf in locs)
			var/obj/effect/turf_vision_blocker/vision_blocker = new /obj/effect/turf_vision_blocker(turf)
			LAZYADD(vision_blockers, vision_blocker)

/obj/machinery/door/airlock/multi_tile/Destroy()
	QDEL_LIST(vision_blockers)
	return ..()

/obj/machinery/door/airlock/multi_tile/set_opacity(var/new_opacity)
	. = ..()
	for(var/obj/effect/turf_vision_blocker/vision_blocker in vision_blockers)
		vision_blocker.set_opacity(new_opacity)

/obj/machinery/door/airlock/multi_tile/glass
	name = "glass airlock"
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/flipped
	width = 2
	dir = EAST
	pixel_x = 0
	pixel_y = -32
	door_color = COLOR_GRAY15
	airlock_type = "Multi-Tile"
	open_sound_powered = 'sound/machines/airlock/wide1o.ogg'
	close_sound_powered = 'sound/machines/airlock/wide1c.ogg'

	icon = 'icons/obj/doors/basic/double/generic/flipped/door.dmi'
	icon_state = "preview"
	frame_color_file = 'icons/obj/doors/basic/double/generic/flipped/frame_color.dmi'
	color_file = 'icons/obj/doors/basic/double/generic/flipped/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/double/generic/flipped/fill_color.dmi'
	glass_file = 'icons/obj/doors/basic/double/generic/flipped/fill_glass.dmi'
	fill_file = 'icons/obj/doors/basic/double/generic/flipped/fill_steel.dmi'
	bolts_file = 'icons/obj/doors/basic/double/generic/flipped/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/basic/double/generic/flipped/lights_deny.dmi'
	lights_file = 'icons/obj/doors/basic/double/generic/flipped/lights_green.dmi'
	panel_file = 'icons/obj/doors/basic/double/generic/flipped/panel.dmi'
	sparks_damaged_file = 'icons/obj/doors/basic/double/generic/flipped/sparks_damaged.dmi'
	sparks_broken_file = 'icons/obj/doors/basic/double/generic/flipped/sparks_broken.dmi'
	welded_file = 'icons/obj/doors/basic/double/generic/flipped/welded.dmi'
	emag_file = 'icons/obj/doors/basic/double/generic/flipped/emag.dmi'

/obj/machinery/door/airlock/multi_tile/flipped/glass
	name = "glass airlock"
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/doors/DoorHazard2x1.dmi'
	width = 2
	dir = EAST
	enable_smart_generation = FALSE

	open_sound = 'sound/machines/firewideopen.ogg'
	close_sound = 'sound/machines/firewideclose.ogg'

	var/list/vision_blockers

/obj/machinery/door/firedoor/multi_tile/Initialize(mapload)
	. = ..()
	if(visible && !glass)
		for(var/turf/turf in locs)
			var/obj/effect/turf_vision_blocker/vision_blocker = new /obj/effect/turf_vision_blocker(turf)
			LAZYADD(vision_blockers, vision_blocker)

/obj/machinery/door/firedoor/multi_tile/Destroy()
	QDEL_LIST(vision_blockers)
	return ..()

/obj/machinery/door/firedoor/multi_tile/set_opacity(var/new_opacity)
	. = ..()
	for(var/obj/effect/turf_vision_blocker/vision_blocker in vision_blockers)
		vision_blocker.set_opacity(new_opacity)


/obj/effect/turf_vision_blocker
	name = "turf vision blocker"
	opacity = FALSE
