/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	var/list/map_z = list()

	var/sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_IN_SPACE

	var/known = 0		//shows up on nav computers automatically
	var/scannable       //if set to TRUE will show up on ship sensors for detailed scans
	var/image/targeted_overlay

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

/obj/effect/overmap/Click(location, control, params)
	. = ..()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/client/C = H.client
		if(istype(C.eye, /obj/effect/overmap) && istype(H.machine, /obj/machinery/computer/ship/helm))
			var/my_sector = map_sectors["[H.z]"]
			if(istype(my_sector, /obj/effect/overmap/visitable))
				var/obj/effect/overmap/visitable/V = my_sector
				if(V != src)
					if(!V.targeting)
						V.target(src)
					else
						if(V.targeting == src)
							V.detarget(src)
						else
							V.detarget(V.targeting)
							V.target(src)

/obj/effect/overmap/visitable/proc/target(var/obj/effect/overmap/O)
	targeting = O
	O.targeted_overlay = icon('icons/obj/overmap_heads_up_display.dmi', "lock")
	O.add_overlay(O.targeted_overlay)
	O.maptext = SMALL_FONTS(6, "[class] [designation]")
	O.maptext_y = 32
	O.maptext_x = -10
	O.maptext_width = 72
	O.maptext_height = 32

/obj/effect/overmap/visitable/proc/detarget(var/obj/effect/overmap/O)
	O.cut_overlay(targeted_overlay)
	O.maptext = null
	targeting = null