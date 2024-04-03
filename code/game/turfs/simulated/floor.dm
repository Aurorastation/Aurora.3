/turf/simulated/floor
	name = "plating"
	desc = "The naked hull."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	is_outside = OUTSIDE_AREA

	// Damage to flooring.
	var/broken
	var/burnt
	var/broken_overlay
	var/burned_overlay

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/singleton/flooring/flooring
	var/mineral = DEFAULT_WALL_MATERIAL

	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0

/turf/simulated/floor/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(flooring)
		var/list/can_remove_with = list()
		if(flooring.flags & TURF_REMOVE_CROWBAR)
			can_remove_with += "crowbars"
		if(flooring.flags & TURF_IS_FRAGILE)
			can_remove_with += SPAN_WARNING("crowbars")
		if(flooring.flags & TURF_REMOVE_SCREWDRIVER)
			can_remove_with += "screwdrivers"
		if(flooring.flags & TURF_REMOVE_SHOVEL)
			can_remove_with += "shovels"
		if(flooring.flags & TURF_REMOVE_WRENCH)
			can_remove_with += "wrenches"
		if(flooring.flags & TURF_REMOVE_WELDER)
			can_remove_with += "welding tools"
		if(length(can_remove_with))
			. += SPAN_NOTICE("\The [src] can be removed with: [english_list(can_remove_with)].")

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/Initialize(mapload, var/floortype)
	. = ..()
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(GET_SINGLETON(floortype), mapload)

/turf/simulated/floor/proc/set_flooring(singleton/flooring/newflooring, mapload)
	if (!mapload)
		make_plating(defer_icon_update = 1)
	flooring = newflooring
	if (mapload)
		queue_icon_update()
	else
		queue_icon_update(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	cut_overlays()

	if(islist(decals))
		decals.Cut()
		decals = null

	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state
	color = base_color

	if(flooring)
		flooring.on_remove()
		if(flooring.build_type && place_product)
			new flooring.build_type(src)
		flooring = null

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null
	levelupdate()

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && src.flooring)
	if(flooring)
		layer = TURF_LAYER
	else
		layer = PLATING_LAYER

/turf/simulated/floor/is_floor()
	return TRUE

/turf/simulated/floor/reset_color()
	if(flooring)
		color = flooring.color
	else
		..()

/turf/simulated/floor/shuttle_ceiling
	name = "hull plating"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced_light"
