// The area list is put together here, because some things need it early on. Turrets controls, for example.
#define MAP_AWAY 1
#define MAP_XENOARCH 2

/datum/controller/subsystem/finalize
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_MAPFINALIZE
	var/dmm_suite/maploader
	var/list/away_maps
	var/list/xeno_maps

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	global.uplink = new

	current_map.finalize_load()

	if(config.generate_asteroid)
		current_map.generate_asteroid()

	get_missions()
	// Generate the area list.
	resort_all_areas()
	..()

/proc/resort_all_areas()
	all_areas = list()
	for (var/area/A in world)
		all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)

/datum/controller/subsystem/finalize/proc/get_missions()
	maploader =  new 
	away_maps = list()
	xeno_maps = list()
	var/datum/away_map/M
	for (var/type in subtypesof(/datum/away_map))
		M = new type
		if (!M.path)
			log_ss("SSfinalize: Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue
		if(M.type_of_map == MAP_AWAY)
			away_maps[M] = M
		else if(M.type_of_map == MAP_XENOARCH)
			xeno_maps[M] = M
		else
			log_ss("SSfinalize: Map [M.name] ([M.type]) has a bad type, discarding.")
			qdel(M)
			continue
	if(config.awaymissions && prob(config.awaymissionsprob))
		load_map(away_maps)
	load_map(xeno_maps)

/datum/controller/subsystem/finalize/proc/load_map(var/list/maps, var/weather = 1)
	if(!maps)
		return
	var/datum/away_map/X = pick(maps)
	var/datum/away_map/map_used = X.path
	if(!maploader.load_map(file("maps/away/[map_used]/[map_used].dmm"), no_changeturf = TRUE))
		log_ss("SSfinalize: Map [map_used] failed to load!")
		return
	X.zloc = world.maxz
	X.handle_random_gen()
	message_admins("Away mission [map_used] has been loaded!")
	//if(X.type_of_map == MAP_XENOARCH)
		//xeno_map = X
	if(weather)
		for(var/V in SSweather.existing_weather)
			var/datum/weather/WE = V
			if(WE.area_type != text2path("/area/away_mission/[map_used]/[map_used]_outside"))
				continue
			WE.target_z = world.maxz
			if(!(world.maxz in SSweather.eligible_zlevels))
				SSweather.make_z_eligible(world.maxz)
	return 1