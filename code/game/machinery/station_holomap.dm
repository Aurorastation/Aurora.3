/obj/machinery/station_map
	name = "station holomap"
	desc = "A virtual map of the surrounding station."
	icon = 'icons/obj/machines/stationmap.dmi'
	icon_state = "station_map"
	anchored = 1
	density = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 500

	light_color = "#64C864"
	light_power = 1
	light_range = 2
	gfi_layer_rotation = GFI_ROTATION_DEFDIR

	var/light_power_on = 1
	var/light_range_on = 2

	layer = 3.25	// Above windows.

	var/mob/watching_mob = null
	var/image/small_station_map = null
	var/image/floor_markings = null
	var/image/panel = null

	var/original_zLevel = 1	// zLevel on which the station map was initialized.
	var/bogus = TRUE		// set to 0 when you initialize the station map on a zLevel that has its own icon formatted for use by station holomaps.
	var/datum/station_holomap/holomap_datum

/obj/machinery/station_map/Destroy()
	SSholomap.station_holomaps -= src
	stopWatching()
	QDEL_NULL(holomap_datum)
	return ..()

/obj/machinery/station_map/Initialize()
	. = ..()
	holomap_datum = new()
	original_zLevel = loc.z
	SSholomap.station_holomaps += src
	flags |= ON_BORDER // Why? It doesn't help if its not density
	bogus = FALSE
	var/turf/T = get_turf(src)
	original_zLevel = T.z
	if(!("[HOLOMAP_EXTRA_STATIONMAP]_[original_zLevel]" in SSholomap.extra_minimaps))
		bogus = TRUE
		holomap_datum.initialize_holomap_bogus()
		update_icon()
		return

	holomap_datum.initialize_holomap(T, reinit = TRUE)

	small_station_map = image(SSholomap.extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[original_zLevel]"], dir = dir)
	small_station_map.layer = LIGHTING_LAYER + 0.1

	floor_markings = image('icons/obj/machines/stationmap.dmi', "decal_station_map")
	floor_markings.dir = src.dir
	floor_markings.layer = ON_TURF_LAYER
	update_icon()

/obj/machinery/station_map/attack_hand(var/mob/user)
	if(watching_mob && (watching_mob != user))
		to_chat(user, "<span class='warning'>Someone else is currently watching the holomap.</span>")
		return
	if(user.loc != loc)
		to_chat(user, "<span class='warning'>You need to stand in front of \the [src].</span>")
		return
	startWatching(user)

// Let people bump up against it to watch
/obj/machinery/station_map/CollidedWith(var/atom/movable/AM)
	if(!watching_mob && isliving(AM) && AM.loc == loc)
		startWatching(AM)

// In order to actually get CollidedWith() we need to block movement.  We're (visually) on a wall, so people
// couldn't really walk into us anyway.  But in reality we are on the turf in front of the wall, so bumping
// against where we seem is actually trying to *exit* our real loc
/obj/machinery/station_map/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	// log_debug("[src] (dir=[dir]) CheckExit([mover], [target])  get_dir() = [get_dir(target, loc)]")
	if(get_dir(target, loc) == dir) // Opposite of "normal" since we are visually in the next turf over
		return FALSE
	else
		return TRUE

/obj/machinery/station_map/proc/startWatching(var/mob/user)
	if(isliving(user) && anchored && !(stat & (NOPOWER|BROKEN)))
		if(user.client)
			holomap_datum.station_map.loc = global_hud.holomap  // Put the image on the holomap hud
			holomap_datum.station_map.alpha = 0 // Set to transparent so we can fade in
			animate(holomap_datum.station_map, alpha = 255, time = 5, easing = LINEAR_EASING)
			flick("station_map_activate", src)
			user.client.screen |= global_hud.holomap
			user.client.images |= holomap_datum.station_map

			watching_mob = user
			moved_event.register(watching_mob, src, /obj/machinery/station_map/proc/checkPosition)
			destroyed_event.register(watching_mob, src, /obj/machinery/station_map/proc/stopWatching)
			update_use_power(2)

			if(bogus)
				to_chat(user, "<span class='warning'>The holomap failed to initialize. This area of space cannot be mapped.</span>")
			else
				to_chat(user, "<span class='notice'>A hologram of the station appears before your eyes.</span>")

/obj/machinery/station_map/attack_ai(var/mob/living/silicon/robot/user)
	return // TODO - Implement for AI ~Leshana
	// user.station_holomap.toggleHolomap(user, isAI(user))

/obj/machinery/station_map/machinery_process()
	if((stat & (NOPOWER|BROKEN)) || !anchored)
		stopWatching()

/obj/machinery/station_map/proc/checkPosition()
	if(!watching_mob || (watching_mob.loc != loc) || (dir != watching_mob.dir))
		stopWatching()

/obj/machinery/station_map/proc/stopWatching()
	if(watching_mob)
		if(watching_mob.client)
			animate(holomap_datum.station_map, alpha = 0, time = 5, easing = LINEAR_EASING)
			var/mob/M = watching_mob
			addtimer(CALLBACK(src, .proc/clear_image, M, holomap_datum.station_map), 5, TIMER_CLIENT_TIME)//we give it time to fade out
		moved_event.unregister(watching_mob, src)
		destroyed_event.unregister(watching_mob, src)
	watching_mob = null
	update_use_power(1)

/obj/machinery/station_map/proc/clear_image(mob/M, image/I)
	if (M.client)
		M.client.images -= I

/obj/machinery/station_map/power_change()
	. = ..()
	update_icon()
	if(stat & NOPOWER)	// Maybe port /vg/'s autolights? Done manually for now.
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/station_map/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/station_map/update_icon()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "station_mapb"
	else if((stat & NOPOWER) || !anchored)
		icon_state = "station_map0"
	else
		icon_state = "station_map"

		if(bogus)
			holomap_datum.initialize_holomap_bogus()
		else
			small_station_map.icon = SSholomap.extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[original_zLevel]"]
			add_overlay(small_station_map)
			holomap_datum.initialize_holomap(get_turf(src))

	// Put the little "map" overlay down where it looks nice
	if(floor_markings)
		floor_markings.dir = src.dir
		floor_markings.pixel_x = -src.pixel_x
		floor_markings.pixel_y = -src.pixel_y
		add_overlay(floor_markings)

	if(panel_open)
		add_overlay("station_map-panel")
	else
		cut_overlay("station_map-panel")

/*/obj/machinery/station_map/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	return ..()*/	// Uncomment this if/when this is made constructable.

/obj/machinery/station_map/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(50))
				qdel(src)
			else
				set_broken()
		if(3)
			if (prob(25))
				set_broken()

// TODO: Make these constructable.

// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/station_holomap
	var/image/station_map
	var/image/cursor
	var/image/legend

/datum/station_holomap/proc/initialize_holomap(turf/T, isAI = null, mob/user = null, reinit = FALSE)
	if(!station_map || reinit)
		station_map = image(SSholomap.extra_minimaps["[HOLOMAP_EXTRA_STATIONMAP]_[T.z]"])
	if(!cursor || reinit)
		cursor = image('icons/misc/holomap_markers.dmi', "you")
	if(!legend || reinit)
		legend = image('icons/effects/64x64.dmi', "legend")

	if(isAI)
		T = get_turf(user.client.eye)
	cursor.pixel_x = (T.x - 6 + HOLOMAP_PIXEL_OFFSET_X(T.z)) * PIXEL_MULTIPLIER
	cursor.pixel_y = (T.y - 6 + HOLOMAP_PIXEL_OFFSET_Y(T.z)) * PIXEL_MULTIPLIER

	legend.pixel_x = HOLOMAP_LEGEND_X(T.z)
	legend.pixel_y = HOLOMAP_LEGEND_Y(T.z)

	station_map.add_overlay(cursor)
	station_map.add_overlay(legend)

/datum/station_holomap/proc/initialize_holomap_bogus()
	station_map = image('icons/480x480.dmi', "stationmap")
	legend = image('icons/effects/64x64.dmi', "notfound")
	legend.pixel_x = 7 * WORLD_ICON_SIZE
	legend.pixel_y = 7 * WORLD_ICON_SIZE
	station_map.add_overlay(legend)
