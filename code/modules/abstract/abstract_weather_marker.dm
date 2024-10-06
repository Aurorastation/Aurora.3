/obj/abstract/weather_marker
	name = "Weather Marker"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "weather_marker"

	/// The weather type we want. This needs to be a weather singleton type, such as /singleton/state/weather/rain/storm.
	/// These should be used for forcing weather in an away site or an event map.
	var/weather_type

	/// Whether this weather system supports having watery weather
	var/has_water_weather = FALSE

	/// Whether this weather system supports having icy weather
	var/has_icy_weather = FALSE

/obj/abstract/weather_marker/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/weather_marker/LateInitialize()
	. = ..()
	if(!ispath(weather_type))
		log_debug("Invalid weather type mapped in at [x] [y] [z]!")
		return INITIALIZE_HINT_QDEL
	var/obj/abstract/weather_system/new_weather_system = SSweather.setup_weather_system(z, weather_type)
	new_weather_system.has_water_weather = has_water_weather
	new_weather_system.has_icy_weather = has_icy_weather
