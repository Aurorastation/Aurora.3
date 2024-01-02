/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap/overmap_effects.dmi'
	icon_state = "object"
	color = "#fffffe"
	mouse_opacity = MOUSE_OPACITY_ICON

//RP fluff details to appear on scan readouts for any object we want to include these details with
	var/scanimage = "no_data.png"
	var/designer = "Unknown" 							//The shipyard or designer of the object if applicable
	var/volume = "Unestimated" 							//Length height width of the object in tiles ingame
	var/weapons = "Not apparent"						//The expected armament or scale of armament that the design comes with if applicable. Can vary in visibility for obvious reasons
	var/sizeclass = "Unknown"							//The class of the design if applicable. Not a prefix. Should be things like battlestations or corvettes
	var/shiptype = "Unknown"							//The designated purpose of the design. Should briefly describe whether it's a combatant or study vessel for example

	var/alignment = "Unknown"							//For landing sites. Allows the crew to know if they're landing somewhere bad or not

	var/generic_object = TRUE //Used to give basic scan descriptions of every generic overmap object that excludes noteworthy locations, ships and exoplanets
	var/static_vessel = FALSE //Used to expand scan details for visible space stations
	var/landing_site = FALSE //Used for unique landing sites that occupy the same overmap tile as another - for example, the implementation of Point Verdant and Konyang

	layer = OVERMAP_SECTOR_LAYER

	var/list/map_z = list()

	var/known = 0		//shows up on nav computers automatically
	var/scannable       //if set to TRUE will show up on ship sensors for detailed scans
	var/unknown_id                      // A unique identifier used when this entity is scanned. Assigned in Initialize().
	var/requires_contact = TRUE //whether or not the effect must be identified by ship sensors before being seen.
	var/instant_contact  = FALSE //do we instantly identify ourselves to any ship in sensors range?
	var/sensor_range_override = FALSE //When true, this overmap object will be scanned with range instead of view.

	var/sensor_visibility = 10	 //how likely it is to increase identification process each scan.
	var/vessel_mass = 10000             // metric tonnes, very rough number, affects acceleration provided by engines

	var/image/targeted_overlay

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	if(static_vessel == TRUE)
		. += "<hr>"
		. += "<br><center><large><b>Scan Details</b></large>"
		. += "<br><large><b>[name]</b></large></center>"
		. += "<br><small><b>Estimated Mass:</b> [vessel_mass]"
		. += "<br><b>Projected Volume:</b> [volume]"
		. += "<hr>"
		. += "<br><center><b>Native Database Specifications</b>"
		. += "<br><img src = [scanimage]></center>"
		. += "<br><small><b>Manufacturer:</b> [designer]"
		. += "<br><b>Class Designation:</b> [sizeclass]"
		. += "<br><b>Weapons Estimation:</b> [weapons]</small>"
		. += "<hr>"
		. += "<br><center><b>Native Database Notes</b></center>"
		. += "<br><small>[desc]</small>"
	if(landing_site == TRUE)
		. += "<hr>"
		. += "<br><center><large><b>Designated Landing Zone Details</b></large>"
		. += "<br><large><b>[name]</b></large></center>"
		. += "<hr>"
		. += "<br><center><b>Native Database Specifications</b>"
		. += "<br><img src = [scanimage]></center>"
		. += "<br><small><b>Governing Body:</b> [alignment]"
		. += "<hr>"
		. += "<br><center><b>Native Database Notes</b></center>"
		. += "<br><small>[desc]</small>"
	else if(generic_object == TRUE)
		return desc

/// Returns the direction the overmap object is moving in, rather than just the way it's facing
/obj/effect/overmap/proc/get_heading()
	return dir

/obj/effect/overmap/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 1
	var/high_edge = current_map.overmap_size - 1

	var/heading = get_heading()

	if((heading & WEST) && x == low_edge)
		nx = high_edge
	else if((heading & EAST) && x == high_edge)
		nx = low_edge
	if((heading & SOUTH)  && y == low_edge)
		ny = high_edge
	else if((heading & NORTH) && y == high_edge)
		ny = low_edge
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/effect/overmap/Initialize()
	. = ..()
	if(!current_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(known)
		layer = EFFECTS_ABOVE_LIGHTING_LAYER
		for(var/obj/machinery/computer/ship/helm/H in SSmachinery.machinery)
			H.get_known_sectors()
	update_icon()

	if(requires_contact)
		set_invisibility(INVISIBILITY_OVERMAP)// Effects that require identification have their images cast to the client via sensors.

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

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
			if(!istype(GS.linked.loc, /turf/unsimulated/map))
				to_chat(H, SPAN_WARNING("The safeties won't let you target while you're not on the Overmap!"))
				return
			var/my_sector = GLOB.map_sectors["[H.z]"]
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

/obj/effect/overmap/MouseEntered(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		params = replacetext(params, "shift=1;", "") // tooltip doesn't appear unless this is stripped
		var/description = get_tooltip_description()
		openToolTip(usr, src, params, name, description)

/obj/effect/overmap/proc/get_tooltip_description()
	if(!desc)
		return ""
	var/description = "<ul>"
	description += "<li>[desc]</li>"
	description += "</ul>"
	return description

/obj/effect/overmap/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/effect/overmap/visitable/proc/target(var/obj/effect/overmap/O, var/obj/machinery/computer/ship/C)
	C.targeting = TRUE
	usr.visible_message(SPAN_WARNING("[usr] starts calibrating the targeting systems, swiping around the holographic screen..."), SPAN_WARNING("You start calibrating the targeting systems, swiping around the screen as you focus..."))
	if(do_after(usr, 5 SECONDS))
		C.targeting = FALSE
		targeting = O
		O.targeted_overlay = icon('icons/obj/overmap/overmap_effects.dmi', "lock")
		O.add_overlay(O.targeted_overlay)
		if(designation && class && !obfuscated)
			if(!O.maptext)
				O.maptext = SMALL_FONTS(6, "[class] [designation]")
			else
				O.maptext += SMALL_FONTS(6, " [class] [designation]")
		else
			if(!O.maptext)
				O.maptext = SMALL_FONTS(6, "[capitalize_first_letters(name)]")
			else
				O.maptext = SMALL_FONTS(6, " [capitalize_first_letters(name)]")
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
	if(C)
		playsound(C, 'sound/items/rfd_interrupt.ogg')
	if(O)
		O.cut_overlay(O.targeted_overlay)
		O.maptext = null
	targeting = null
