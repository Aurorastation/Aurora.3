// Minimap generation system adapted from vorestation, adapted from /vg/.
// Seems to be much simpler/saner than /vg/'s implementation.

/var/datum/controller/subsystem/holomap/SSholomap

/datum/controller/subsystem/holomap
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = SS_INIT_HOLOMAP

	var/list/holo_minimaps = list()
	var/list/extra_minimaps = list()
	var/list/station_holomaps = list()

/datum/controller/subsystem/holomap/New()
	NEW_SS_GLOBAL(SSholomap)

/datum/controller/subsystem/holomap/Initialize()
	holo_minimaps.len = world.maxz
	for (var/z in 1 to world.maxz)
		holo_minimaps[z] = generateHoloMinimap(z)

	log_debug("SSholomap: [holo_minimaps.len] maps.")

	for (var/z in current_map.station_levels)
		generateStationMinimap(z)

	..()


// Generates the "base" holomap for one z-level, showing only the physical structure of walls and paths.
/datum/controller/subsystem/holomap/proc/generateHoloMinimap(zlevel = 1)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zlevel)
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zlevel)

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		CRASH("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		CRASH("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	var/list/rock_tcache = typecacheof(list(
		/turf/simulated/mineral,
		/turf/unsimulated/floor/asteroid,
		/turf/simulated/open
	))
	var/list/obstacle_tcache = typecacheof(list(
		/turf/simulated/wall,
		/turf/unsimulated/mineral,
		/turf/unsimulated/wall
	))
	var/list/path_tcache = typecacheof(list(
		/turf/simulated/floor,
		/turf/unsimulated/floor
	)) - typecacheof(/turf/unsimulated/floor/asteroid)

	var/turf/T
	var/area/A
	var/Ttype
	for (var/thing in Z_ALL_TURFS(zlevel))
		T = thing
		A = T.loc
		Ttype = T.type

		if (A.flags & HIDE_FROM_HOLOMAP)
			continue
		if (rock_tcache[Ttype])
			continue
		if (obstacle_tcache[Ttype] || (T.contents.len && locate(/obj/structure/grille, T)))
			canvas.DrawBox(HOLOMAP_OBSTACLE, T.x + offset_x, T.y + offset_y)
		else if(path_tcache[Ttype] || (T.contents.len && locate(/obj/structure/lattice/catwalk, T)))
			canvas.DrawBox(HOLOMAP_PATH, T.x + offset_x, T.y + offset_y)

		CHECK_TICK

	return canvas

/datum/controller/subsystem/holomap/proc/generateStationMinimap(zlevel)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zlevel)
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zlevel)

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		crash_with("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		crash_with("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	var/turf/T
	var/area/A
	for (var/thing in Z_ALL_TURFS(zlevel))
		T = thing
		A = T.loc
		if (A.holomap_color)
			canvas.DrawBox(A.holomap_color, T.x + offset_x, T.y + offset_y)

	// Save this nice area-colored canvas in case we want to layer it or something I guess
	extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[zlevel]"] = canvas

	var/icon/map_base = icon(holo_minimaps[zlevel])
	map_base.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)

	// Generate the full sized map by blending the base and areas onto the backdrop
	var/icon/big_map = icon(HOLOMAP_ICON, "stationmap")
	big_map.Blend(map_base, ICON_OVERLAY)
	big_map.Blend(canvas, ICON_OVERLAY)
	extra_minimaps["[HOLOMAP_EXTRA_STATIONMAP]_[zlevel]"] = big_map

	// Generate the "small" map (I presume for putting on wall map things?)
	var/icon/small_map = icon(HOLOMAP_ICON, "blank")
	small_map.Blend(map_base, ICON_OVERLAY)
	small_map.Blend(canvas, ICON_OVERLAY)
	small_map.Scale(WORLD_ICON_SIZE, WORLD_ICON_SIZE)

	// And rotate it in every direction of course!
	var/icon/actual_small_map = icon(small_map)
	actual_small_map.Insert(new_icon = small_map, dir = SOUTH)
	actual_small_map.Insert(new_icon = turn(small_map, 90), dir = WEST)
	actual_small_map.Insert(new_icon = turn(small_map, 180), dir = NORTH)
	actual_small_map.Insert(new_icon = turn(small_map, 270), dir = EAST)
	extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[zlevel]"] = actual_small_map
