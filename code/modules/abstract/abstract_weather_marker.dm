/obj/abstract/weather_marker
	name = "Weather Marker"
	/// The weather type we want. This needs to be a weather singleton type, such as /singleton/state/weather/rain/storm.
	/// These should be used for forcing weather in an away site or an event map.
	var/weather_type

/obj/abstract/weather_marker/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/weather_marker/LateInitialize()
	. = ..()
	if(!ispath(weather_type))
		log_debug("Invalid weather type mapped in at [x] [y] [z]!")
		return INITIALIZE_HINT_QDEL
	SSweather.setup_weather_system(z, weather_type)
