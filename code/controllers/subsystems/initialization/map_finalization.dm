// The area list is put together here, because some things need it early on. Turrets controls, for example.

/datum/controller/subsystem/finalize
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_MAPFINALIZE

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	global.uplink = new

	current_map.finalize_load()

	if(config.generate_asteroid)
		current_map.generate_asteroid()

	find_away_mission()
	// Generate the area list.
	resort_all_areas()
	..()

/proc/resort_all_areas()
	all_areas = list()
	for (var/area/A in world)
		all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)

/datum/controller/subsystem/finalize/proc/find_away_mission()
	var/dmm_suite/maploader =  new 
	var/list/away_maps = list()
	var/datum/away_map/M
	for (var/type in subtypesof(/datum/away_map))
		M = new type
		if (!M.path)
			log_ss("SSfinalize: Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue

		away_maps[M] = M
	var/datum/away_map/X = pick(away_maps)
	var/datum/away_map/map_used = X.path
	if(!maploader.load_map(file("maps/away/[map_used]/[map_used].dmm"), no_changeturf = TRUE))
		log_ss("SSfinalize: Map [map_used] failed to load!")
		return 0
	X.zloc = world.maxz
	X.handle_random_gen()
	message_admins("Away mission [map_used] has been loaded!")
	for(var/V in SSweather.existing_weather)
		var/datum/weather/WE = V
		if(WE.area_type != text2path("/area/away_mission/[map_used]/[map_used]_outside"))
			continue
		WE.target_z = world.maxz
		if(!(world.maxz in SSweather.eligible_zlevels))
			SSweather.make_z_eligible(world.maxz)
	return 1