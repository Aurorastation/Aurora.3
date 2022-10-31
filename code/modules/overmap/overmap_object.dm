/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	var/list/map_z = list()

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

/obj/effect/overmap/proc/signal_hit(var/list/hit_data)
	return

/obj/effect/overmap/Click(location, control, params)
	. = ..()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/client/C = H.client
		if(H.machine && istype(H.machine, /obj/machinery/computer/ship/targeting) && istype(C.eye, /obj/effect/overmap))
			var/obj/machinery/computer/ship/targeting/GS = H.machine
			if(GS.targeting)
				return
			var/my_sector = map_sectors["[H.z]"]
			if(istype(my_sector, /obj/effect/overmap/visitable))
				var/obj/effect/overmap/visitable/V = my_sector
				if(V != src && length(V.ship_weapons)) //no guns, no lockon
					if(!V.targeting)
						V.target(src, H.machine)
					else
						if(V.targeting == src)
							V.detarget(src, H.machine)
						else
							V.detarget(V.targeting, C)
							V.target(src, H.machine)
			GS.targeting = FALSE //Extra safety.

/obj/effect/overmap/visitable/proc/target(var/obj/effect/overmap/O, var/obj/machinery/computer/ship/C)
	C.targeting = TRUE
	usr.visible_message(SPAN_WARNING("[usr] starts calibrating the targeting systems, swiping around the holographic screen..."), SPAN_WARNING("You start calibrating the targeting systems, swiping around the screen as you focus..."))
	if(do_after(usr, 5 SECONDS))
		C.targeting = FALSE
		targeting = O
		O.targeted_overlay = icon('icons/obj/overmap_heads_up_display.dmi', "lock")
		O.add_overlay(O.targeted_overlay)
		if(!O.maptext)
			O.maptext = SMALL_FONTS(6, "[class] [designation]")
		else
			O.maptext += SMALL_FONTS(6, " [class] [designation]")
		O.maptext_y = 32
		O.maptext_x = -10
		O.maptext_width = 72
		O.maptext_height = 32
		playsound(C, 'sound/items/goggles_charge.ogg')
		C.visible_message(SPAN_DANGER("[usr] engages the targeting systems, acquiring a lock on the target!"))
		if(istype(O, /obj/effect/overmap/visitable/ship))
			var/obj/effect/overmap/visitable/ship/S = O
			for(var/obj/machinery/computer/ship/SH in S.consoles)
				if(istype(SH, /obj/machinery/computer/ship/sensors))
					playsound(SH, 'sound/effects/ship_weapons/locked_on.ogg')
					SH.visible_message(SPAN_DANGER("<font size=4>\The [SH] beeps alarmingly, signaling an enemy lock-on!</font>"))
	else
		C.targeting = FALSE

/obj/effect/overmap/visitable/proc/detarget(var/obj/effect/overmap/O,  var/obj/machinery/computer/C)
	playsound(C, 'sound/items/rfd_interrupt.ogg')
	if(O)
		O.cut_overlay(O.targeted_overlay)
		O.maptext = null
	targeting = null