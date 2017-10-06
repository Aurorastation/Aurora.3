// Minimap generation system adapted from vorestation, adapted from /vg/.
// Seems to be much simpler/saner than /vg/'s implementation.

// Turfs that will be colored as HOLOMAP_ROCK
#define IS_ROCK(tile) (istype(tile, /turf/simulated/mineral) || istype(tile, /turf/simulated/floor/asteroid) || isopenturf(tile))

// Turfs that will be colored as HOLOMAP_OBSTACLE
#define IS_OBSTACLE(tile) ((!istype(tile, /turf/space) && istype(tile.loc, /area/mine/unexplored)) \
					|| istype(tile, /turf/simulated/wall) \
					|| istype(tile, /turf/unsimulated/mineral) \
					|| (istype(tile, /turf/unsimulated/wall)) \
					|| (locate(/obj/structure/grille) in tile))

// Turfs that will be colored as HOLOMAP_PATH
#define IS_PATH(tile) ((istype(tile, /turf/simulated/floor) && !istype(tile, /turf/simulated/floor/asteroid)) \
					|| istype(tile, /turf/unsimulated/floor) \
					|| (locate(/obj/structure/lattice/catwalk) in tile))

/var/datum/controller/subsystem/minimap/SSminimap

/datum/controller/subsystem/minimap
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = SS_INIT_HOLOMAP

	var/list/holo_minimaps = list()
	var/list/extra_minimaps = list()
	var/list/station_holomaps = list()

/datum/controller/subsystem/minimap/New()
	NEW_SS_GLOBAL(SSminimap)

/datum/controller/subsystem/minimap/Initialize()
	holo_minimaps.len = world.maxz
	for (var/z in 1 to world.maxz)
		holo_minimaps[z] = generateHoloMinimap(z)

	log_debug("SSminimap: [holo_minimaps.len] maps.")

	for (var/z in current_map.station_levels)
		generateStationMinimap(z)

	..()


// Generates the "base" holomap for one z-level, showing only the physical structure of walls and paths.
/datum/controller/subsystem/minimap/proc/generateHoloMinimap(zlevel = 1)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zlevel)
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zlevel)

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		crash_with("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		crash_with("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	for(var/x = 1 to world.maxx)
		for(var/y = 1 to world.maxy)
			var/turf/tile = locate(x, y, zlevel)
			var/area/A
			if(tile)
				A = tile.loc
				if (A.flags & HIDE_FROM_HOLOMAP)
					continue
				if(IS_ROCK(tile))
					continue
				if(IS_OBSTACLE(tile))
					canvas.DrawBox(HOLOMAP_OBSTACLE, x + offset_x, y + offset_y)
				else if(IS_PATH(tile))
					canvas.DrawBox(HOLOMAP_PATH, x + offset_x, y + offset_y)

		CHECK_TICK
	return canvas

/datum/controller/subsystem/minimap/proc/generateStationMinimap(zlevel)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zlevel)
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zlevel)

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		crash_with("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		crash_with("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	for(var/x = 1 to world.maxx)
		for(var/y = 1 to world.maxy)
			var/turf/tile = locate(x, y, zlevel)
			if(tile && tile.loc)
				var/area/areaToPaint = tile.loc
				if(areaToPaint.holomap_color)
					canvas.DrawBox(areaToPaint.holomap_color, x + offset_x, y + offset_y)

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
