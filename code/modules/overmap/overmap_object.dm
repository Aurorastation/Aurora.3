/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	var/list/map_z = list()

	var/sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_IN_SPACE

	var/known = 1		//shows up on nav computers automatically
	var/scannable       //if set to TRUE will show up on ship sensors for detailed scans

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	return desc

/obj/effect/overmap/Initialize()
	. = ..()
	if(!current_map.use_overmap)
		return INITIALIZE_HINT_QDEL
	
	if(known)
		layer = EFFECTS_ABOVE_LIGHTING_LAYER
		for(var/obj/machinery/computer/ship/helm/H in SSmachinery.machinery)
			H.get_known_sectors()
	update_icon()

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1, x = 0, y = 0) 
