// Minimap generation system adapted from vorestation, adapted from /vg/.
// Seems to be much simpler/saner than /vg/'s implementation.

SUBSYSTEM_DEF(holomap)
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = SS_INIT_HOLOMAP

	/// List of images of minimaps, for every z-level, initialized at round start.
	/// This is the "base" minimap, shows only the physical structure of walls and paths, and respects `HIDE_FROM_HOLOMAP`.
	/// Key of list is the `z` of the z-level, value is the `/icon/`.
	/// Every image is 255x255px.
	var/list/minimaps = list()

	/// Same as `minimaps`, but images are base64 encoded.
	var/list/minimaps_base64 = list()

	/// Same as `minimaps_base64`, but the map is colored with `holomap_color` of the `/area/`
	var/list/minimaps_area_colored_base64 = list()

	/// Same as `minimaps_base64`, but does not discriminate between walls and paths.
	var/list/minimaps_scan_base64 = list()

	/// List of all `/obj/effect/landmark/minimap_poi`.
	var/list/obj/effect/landmark/minimap_poi/pois = list()


	/*#############################################
		Typecaches used for map icon generation
	#############################################*/
	var/static/list/mineral_wall_tcache = typecacheof(list(
		/turf/simulated/mineral,
		/turf/unsimulated/mineral,
	))
	var/static/list/mineral_floor_tcache = typecacheof(list(
		/turf/simulated/floor/exoplanet/asteroid,
		/turf/simulated/mineral,
		/turf/simulated/floor/exoplanet,
	))
	var/static/list/hull_tcache = typecacheof(list(
		/turf/simulated/wall,
		/turf/simulated/floor,
		/turf/unsimulated/wall,
		/turf/unsimulated/floor,
	))

	var/static/list/rock_tcache = typecacheof(list(
		/turf/simulated/mineral,
		/turf/simulated/floor/exoplanet/asteroid,
		/turf/simulated/open
	))
	var/static/list/obstacle_tcache = typecacheof(list(
		/turf/simulated/wall,
		/turf/unsimulated/mineral,
		/turf/unsimulated/wall
	))
	var/static/list/path_tcache = typecacheof(list(
		/turf/simulated/floor,
		/turf/unsimulated/floor
	)) - typecacheof(/turf/simulated/floor/exoplanet/asteroid)

/datum/controller/subsystem/holomap/Initialize()
	generate_all_minimaps()
	LOG_DEBUG("SSholomap: [minimaps.len] maps.")

	return SS_INIT_SUCCESS

/datum/controller/subsystem/holomap/proc/generate_all_minimaps()
	minimaps.len = world.maxz
	minimaps_base64.len = world.maxz
	minimaps_area_colored_base64.len = world.maxz
	minimaps_scan_base64.len = world.maxz

	for (var/z in 1 to world.maxz)
		generate_minimap(z)
		generate_minimap_area_colored(z)
		generate_minimap_scan(z)
		CHECK_TICK

/datum/controller/subsystem/holomap/proc/generate_minimap(zlevel = 1)
	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon('icons/255x255.dmi', "blank")
	if(world.maxx > canvas.Width())
		CRASH("Minimap for z=[zlevel] : world.maxx ([world.maxx]) must be <= [canvas.Width()]")
	if(world.maxy > canvas.Height())
		CRASH("Minimap for z=[zlevel] : world.maxy ([world.maxy]) must be <= [canvas.Height()]")

	for(var/turf/T as anything in Z_TURFS(zlevel))
		var/area/A = T.loc
		var/Ttype = T.type

		if (A.area_flags & AREA_FLAG_HIDE_FROM_HOLOMAP)
			continue
		if (rock_tcache[Ttype])
			continue
		if (obstacle_tcache[Ttype] || (length(T.contents) && locate(/obj/structure/grille, T)))
			canvas.DrawBox(HOLOMAP_OBSTACLE + "DD", T.x, T.y)
		else if(path_tcache[Ttype] || (length(T.contents) && locate(/obj/structure/lattice/catwalk, T)))
			canvas.DrawBox(HOLOMAP_PATH + "DD", T.x, T.y)

	minimaps[zlevel] = canvas
	minimaps_base64[zlevel] = icon2base64(canvas)

/datum/controller/subsystem/holomap/proc/generate_minimap_area_colored(zlevel)
	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon('icons/255x255.dmi', "blank")
	if(world.maxx > canvas.Width())
		crash_with("Minimap for z=[zlevel] : world.maxx ([world.maxx]) must be <= [canvas.Width()]")
	if(world.maxy > canvas.Height())
		crash_with("Minimap for z=[zlevel] : world.maxy ([world.maxy]) must be <= [canvas.Height()]")

	for (var/turf/T as anything in Z_TURFS(zlevel))
		var/area/A = T.loc

		if (A.area_flags & AREA_FLAG_HIDE_FROM_HOLOMAP)
			continue
		if (A.holomap_color)
			canvas.DrawBox(A.holomap_color + "99", T.x, T.y)

	var/icon/map_base = icon(minimaps[zlevel])

	// Generate the full sized map by blending the base and areas onto the backdrop
	var/icon/big_map = icon('icons/255x255.dmi', "blank")
	big_map.Blend(map_base, ICON_OVERLAY)
	big_map.Blend(canvas, ICON_OVERLAY)
	minimaps_area_colored_base64[zlevel] = icon2base64(big_map)

/datum/controller/subsystem/holomap/proc/generate_minimap_scan(zlevel = 1)
	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon('icons/255x255.dmi', "blank")
	if(world.maxx > canvas.Width())
		CRASH("Minimap for z=[zlevel] : world.maxx ([world.maxx]) must be <= [canvas.Width()]")
	if(world.maxy > canvas.Height())
		CRASH("Minimap for z=[zlevel] : world.maxy ([world.maxy]) must be <= [canvas.Height()]")

	for(var/turf/T as anything in Z_TURFS(zlevel))
		var/Ttype = T.type

		if (mineral_wall_tcache[Ttype])
			canvas.DrawBox(HOLOMAP_MINERAL_WALL, T.x, T.y)
		else if (mineral_floor_tcache[Ttype])
			canvas.DrawBox(HOLOMAP_MINERAL_FLOOR, T.x, T.y)
		else if(hull_tcache[Ttype])
			canvas.DrawBox(HOLOMAP_OBSTACLE, T.x, T.y)

	minimaps_scan_base64[zlevel] = icon2base64(canvas)
