//Used for all kinds of weather, ex. lavaland ash storms.
var/datum/controller/subsystem/weather/SSweather

/datum/controller/subsystem/weather
	name = "Weather"
	flags = SS_BACKGROUND
	init_order = SS_INIT_BEFORE_MAPLOAD
	wait = 20
	var/list/processing = list()
	var/list/existing_weather = list()
	var/list/eligible_zlevels = list()

/datum/controller/subsystem/weather/New()
	NEW_SS_GLOBAL(SSweather)

/datum/controller/subsystem/weather/proc/run_weather(weather_name, Z)
	if(!weather_name)
		return "No weather Name found"
	for(var/V in existing_weather)
		var/datum/weather/W = V
		if(W.name == weather_name && W.target_z == Z)
			W.telegraph()

/datum/controller/subsystem/weather/proc/make_z_eligible(zlevel)
	eligible_zlevels += zlevel
	
/datum/controller/subsystem/weather/Initialize(start_timeofday)
	..()
	for(var/V in subtypesof(/datum/weather))
		new V //Weather's New() will handle adding stuff to the list

/datum/controller/subsystem/weather/fire()
	for(var/V in processing)
		var/datum/weather/W = V
		if(W.aesthetic)
			continue
		for(var/mob/living/L in mob_list)
			if(W.can_weather_act(L))
				W.weather_act(L)
	for(var/Z in eligible_zlevels)
		var/list/possible_weather_for_this_z = list()
		for(var/V in existing_weather)
			var/datum/weather/WE = V
			if(WE.target_z == Z && WE.probability) //Another check so that it doesn't run extra weather
				possible_weather_for_this_z[WE] = WE.probability
		var/datum/weather/W = pickweight(possible_weather_for_this_z)
		if(W)
			run_weather(W.name, Z)
			eligible_zlevels -= Z
			addtimer(CALLBACK(src, .proc/make_z_eligible, Z), rand(3000, 6000) + W.weather_duration_upper, TIMER_UNIQUE) //Around 5-10 minutes between weathers
