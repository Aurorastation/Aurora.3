/singleton/flooring/glass
	name = "glass floor"
	desc = "A clear, load-bearing glass panel in a metal frame."
	icon = 'icons/turf/flooring/glass.dmi'
	icon_base = "glass-0"
	descriptor = "glass panel"
	build_type = /obj/item/stack/material/glass
	build_time = 3 SECONDS
	covers_open_space = TRUE
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK

/singleton/flooring/glass/accepts_build_material(obj/item/stack/material_stack)
	return istype(material_stack, build_type) && material_stack.stacktype == build_type

/singleton/flooring/glass/get_base_icon_state(turf/simulated/floor/floor)
	var/junction = 0
	var/turf/simulated/floor/neighbor
	CALCULATE_NEIGHBORS(floor, junction, neighbor, istype(neighbor) && neighbor.flooring == src)
	return "glass-[junction]"

/singleton/flooring/glass/on_install(turf/simulated/floor/floor)
	ADD_TRAIT(floor, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_FLOORING)
	floor.enable_zmimic()

/singleton/flooring/glass/on_remove(turf/simulated/floor/floor)
	REMOVE_TRAIT(floor, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_FLOORING)
	floor.disable_zmimic()

/singleton/flooring/glass/get_zmimic_backdrop(turf/simulated/floor/floor)
	if(istype(SSatlas.current_map, /datum/map/sccv_horizon) && is_station_level(floor.z) && istype(floor.loc, /area/horizon) && !istype(floor.loc, /area/horizon/exterior))
		var/static/mutable_appearance/plating = mutable_appearance('icons/turf/flooring/plating.dmi', "plating", TURF_LAYER, OPEN_SPACE_PLANE_END)
		return plating

/turf/simulated/floor/glass
	name = "glass floor"
	icon = 'icons/turf/flooring/glass.dmi'
	icon_state = "glass-0"
	initial_flooring = /singleton/flooring/glass
