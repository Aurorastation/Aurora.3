SUBSYSTEM_DEF(weather)
	name =       "Weather"
	wait =       15 SECONDS
	init_order = INIT_ORDER_WEATHER
	priority =   SS_PRIORITY_WEATHER
	flags =      SS_BACKGROUND

	var/list/weather_systems    = list()
	var/list/weather_by_z       = list()
	var/list/processing_systems

/datum/controller/subsystem/weather/stat_entry()
	..("all systems: [length(weather_systems)], processing systems: [length(processing_systems)]")

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	. = ..()
	for(var/obj/abstract/weather_system/weather as anything in weather_systems)
		weather.init_weather()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/weather/fire(resumed)

	if(!resumed)
		processing_systems = weather_systems.Copy()

	var/obj/abstract/weather_system/weather
	while(processing_systems.len)
		weather = processing_systems[processing_systems.len]
		processing_systems.len--
		if(QDELETED(weather) || !weather.weather_system)
			continue
		weather.tick()
		if(MC_TICK_CHECK)
			return

///Sets a weather state to use for a given z level/z level stack.
/datum/controller/subsystem/weather/proc/setup_weather_system(var/topmost_level, var/singleton/state/weather/initial_state)
	//First check and clear any existing weather system on the level
	var/obj/abstract/weather_system/WS = weather_by_z["[topmost_level]"]
	if(WS)
		unregister_weather_system(WS)
		qdel(WS)

	// Create the new weather system and let it register itself
	var/obj/abstract/weather_system/new_weather_system = new /obj/abstract/weather_system(locate(1, 1, text2num(topmost_level)), topmost_level, initial_state)
	return new_weather_system

///Registers a given weather system obj for getting updates by SSweather.
/datum/controller/subsystem/weather/proc/register_weather_system(var/obj/abstract/weather_system/WS)
	if(weather_by_z["[WS.z]"])
		CRASH("Trying to register another weather system on the same z-level([WS.z]) as an existing one!")
	weather_systems |= WS

	//Mark all affected z-levels
	var/list/affected = GetConnectedZlevels(WS.z)
	for(var/Z in affected)
		if(weather_by_z["[Z]"])
			CRASH("Trying to register another weather system on the same z-level([Z]) as an existing one!")
		weather_by_z["[Z]"] = WS
	SEND_SIGNAL(src, COMSIG_WEATHER_SYSTEM_REGISTERED, WS)

///Remove a weather systeam from the processing lists.
/datum/controller/subsystem/weather/proc/unregister_weather_system(var/obj/abstract/weather_system/WS)
	//Clear any and all references to our weather object
	var/was_registered = (WS in weather_systems)
	var/list/affected_zs = WS.affecting_zs || GetConnectedZlevels(WS.z)
	for(var/Z in affected_zs)
		if(weather_by_z["[Z]"] == WS)
			weather_by_z["[Z]"] = null
			was_registered = TRUE
	weather_systems -= WS
	processing_systems -= WS
	if(was_registered)
		SEND_SIGNAL(src, COMSIG_WEATHER_SYSTEM_UNREGISTERED, WS)
