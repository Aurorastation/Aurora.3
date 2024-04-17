/singleton/state_transition/weather
	abstract_type = /singleton/state_transition/weather
	var/likelihood_weighting = 100

/singleton/state_transition/weather/is_open(datum/holder)
	var/obj/abstract/weather_system/weather = holder
	return weather.supports_weather_state(target)

/singleton/state_transition/weather/calm
	target = /singleton/state/weather/calm
	likelihood_weighting = 50

/singleton/state_transition/weather/snow
	target = /singleton/state/weather/snow

/singleton/state_transition/weather/rain
	target = /singleton/state/weather/rain

/singleton/state_transition/weather/snow_medium
	target = /singleton/state/weather/snow/medium

/singleton/state_transition/weather/snow_heavy
	target = /singleton/state/weather/snow/heavy
	likelihood_weighting = 20

/singleton/state_transition/weather/storm
	target = /singleton/state/weather/rain/storm

/singleton/state_transition/weather/hail
	target = /singleton/state/weather/rain/hail
	likelihood_weighting = 20

//weather for planets

//snow planets

/singleton/state_transition/weather/calm/snow_planet
	target = /singleton/state/weather/calm/snow_planet

/singleton/state_transition/weather/snow/snow_planet
	target = /singleton/state/weather/snow/snow_planet

/singleton/state_transition/weather/snow_medium/snow_planet
	target = /singleton/state/weather/snow/medium/snow_planet

/singleton/state_transition/weather/snow_heavy/snow_planet
	target = /singleton/state/weather/snow/heavy/snow_planet

//jungle planets planets

/singleton/state_transition/weather/calm/jungle_planet
	target = /singleton/state/weather/calm/jungle_planet

/singleton/state_transition/weather/rain/jungle_planet
	target = /singleton/state/weather/rain/jungle_planet

/singleton/state_transition/weather/storm/jungle_planet
	target = /singleton/state/weather/rain/storm/jungle_planet

//lava planets

/singleton/state_transition/weather/calm/lava_planet
	target = /singleton/state/weather/calm/lava_planet

/singleton/state_transition/weather/ash/lava_planet
	target = /singleton/state/weather/ash/lava_planet

//arctic planets

/singleton/state_transition/weather/calm/arctic_planet
	target = /singleton/state/weather/calm/lava_planet

/singleton/state_transition/weather/hail/arctic_planet
	target = /singleton/state/weather/rain/hail/arctic_planet
