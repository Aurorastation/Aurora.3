/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/levels = 0
	var/list/map_files = list()
	var/loaded = 0 // Times loaded this round
	var/static/dmm_suite/maploader = new

/datum/map_template/proc/preload_size(list/files)
	var/bounds = list(
		MAP_MINX = INFINITY,
		MAP_MINY = INFINITY,
		MAP_MINZ = INFINITY,
		MAP_MAXX = -INFINITY,
		MAP_MAXY = -INFINITY,
		MAP_MAXZ = -INFINITY
	)
	levels = 0
	for (var/thing in files)
		var/this_bounds = maploader.load_map(thing, 1, 1, 1, cropMap = FALSE, measureOnly = TRUE)
		if (this_bounds)
			bounds = dmms_expand_bounds(bounds, this_bounds)
			levels += (this_bounds[MAP_MAXZ] - this_bounds[MAP_MINZ]) + 1

	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular and begin at 1,1,1
		height = bounds[MAP_MAXY]

	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()

	for(var/L in block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])))
		var/turf/B = L
		atoms += B
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A

	for (var/zlevel in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
		SSlighting.setup_zlevel(zlevel)

	SSatlas.setup_multiz()
	SSatoms.InitializeAtoms(atoms)
	SSmachinery.setup_template_powernets(cables)

/datum/map_template/proc/load_new_z()
	var/x = round(world.maxx/2)
	var/y = round(world.maxy/2)

	var/bounds = list(
		MAP_MINX = INFINITY,
		MAP_MINY = INFINITY,
		MAP_MINZ = INFINITY,
		MAP_MAXX = -INFINITY,
		MAP_MAXY = -INFINITY,
		MAP_MAXZ = -INFINITY
	)

	for (var/map in map_files)
		var/list/this_bounds = maploader.load_map(map, x, y)
		if (!this_bounds)
			log_debug("ERROR: Failed to load '[map]'!")
		else
			bounds = dmms_expand_bounds(bounds, this_bounds)

	for (var/z in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
		smooth_zlevel(z)

	resort_all_areas()

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/bounds = list(
		MAP_MINX = INFINITY,
		MAP_MINY = INFINITY,
		MAP_MINZ = INFINITY,
		MAP_MAXX = -INFINITY,
		MAP_MAXY = -INFINITY,
		MAP_MAXZ = -INFINITY
	)

	for (var/map in map_files)
		var/list/this_bounds = maploader.load_map(map, T.x, T.y, T.z, cropMap=TRUE)
		if (!this_bounds)
			log_debug("ERROR: Failed to load '[map]'!")
		else
			bounds = dmms_expand_bounds(bounds, this_bounds)

	if(!bounds)
		return
	
	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z + (height - 1)))
