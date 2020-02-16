/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round
	var/static/dmm_suite/maploader = new

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/bounds = maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE)
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()

	for(var/L in block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])))


		var/turf/B = L
		if (!B.initialized)
			atoms += B

		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(B) && !B.lighting_overlay)
			new /atom/movable/lighting_overlay(B)

		for(var/thing in B)
			if(istype(thing, /obj/structure/cable))
				cables += thing

			var/atom/movable/AM = thing
			if (!AM.initialized)
				atoms += AM

	SSatoms.InitializeAtoms(atoms)
	SSmachinery.setup_template_powernets(cables)

/datum/map_template/proc/load_new_z()
	var/x = round(world.maxx/2)
	var/y = round(world.maxy/2)

	var/list/bounds = maploader.load_map(file(mappath), x, y, no_changeturf = TRUE)
	if(!bounds)
		return FALSE

	smooth_zlevel(world.maxz)
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

	var/list/bounds = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE)
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
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))
