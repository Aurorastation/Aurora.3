/obj/abstract/weather_marker
	name = "Weather Marker"
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

/obj/abstract/weather_marker/konyang
	name = "Point Verdant Weather"
	weather_type = /singleton/state/weather/rain/storm
