/obj/abstract/weather_marker
	name = "Weather Marker"
	var/weather_type

/obj/abstract/weather_marker/Initialize()
	. = ..()
	if(!ispath(weather_type))
		log_debug("Invalid weather type mapped in at [x] [y] [z]!")
		return INITIALIZE_HINT_QDEL
