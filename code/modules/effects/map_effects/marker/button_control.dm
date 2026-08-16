
ABSTRACT_TYPE(/obj/effect/map_effect/marker/button_control)

// ----------------------------

/obj/effect/map_effect/marker/button_control/window_tint
	name = "window tint button control marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_button_control_window_tint"

	/// If null, it will set the tag based on area.
	var/master_tag = null

/obj/effect/map_effect/marker/button_control/window_tint/Initialize(mapload, ...)
	..()
	if(!master_tag)
		master_tag = "window tint control marker with area tag: [get_area(src)]"
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/button_control/window_tint/LateInitialize()
	if(!master_tag)
		return

	for(var/thing in loc)
		var/obj/structure/machinery/button/switch/windowtint/button = thing
		if(istype(button))
			button.id = master_tag
			continue
		var/obj/structure/window/full/reinforced/polarized/window = thing
		if(istype(window))
			window.id = master_tag
			continue

// ----------------------------

/obj/effect/map_effect/marker/button_control/shutter
	name = "shutter button control marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_button_control_shutter"

	/// If null, it will set the tag based on area.
	var/master_tag = null

/obj/effect/map_effect/marker/button_control/shutter/Initialize(mapload, ...)
	..()
	if(!master_tag)
		master_tag = "shutter control marker with area tag: [get_area(src)]"
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/button_control/shutter/LateInitialize()
	if(!master_tag)
		return

	for(var/thing in loc)
		var/obj/structure/machinery/button/remote/blast_door/button = thing
		if(istype(button))
			button.id = master_tag
			continue
		var/obj/structure/machinery/door/blast/shutters/shutter = thing
		if(istype(shutter))
			shutter.id = master_tag
			continue

// ----------------------------

/obj/effect/map_effect/marker/button_control/blast_door
	name = "blast door button control marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_button_control_blast_door"

	/// If null, it will set the tag based on area.
	var/master_tag = null

/obj/effect/map_effect/marker/button_control/blast_door/Initialize(mapload, ...)
	..()
	if(!master_tag)
		master_tag = "blast door control marker with area tag: [get_area(src)]"
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/button_control/blast_door/LateInitialize()
	if(!master_tag)
		return

	for(var/thing in loc)
		var/obj/structure/machinery/button/remote/blast_door/button = thing
		if(istype(button))
			button.id = master_tag
			continue
		var/obj/structure/machinery/door/blast/regular/shutter = thing
		if(istype(shutter))
			shutter.id = master_tag
			continue

// ----------------------------
