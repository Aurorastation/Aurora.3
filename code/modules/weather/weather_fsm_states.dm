/singleton/state/weather

	abstract_type = /singleton/state/weather

	var/name =         "Undefined"
	var/descriptor =   "The weather is undefined."

	var/cosmetic_message_chance = 5
	var/list/cosmetic_messages
	var/list/protected_messages
	var/cosmetic_span_class = "notice"

	var/icon = 'icons/effects/weather.dmi'
	var/icon_state

	var/alpha =        210
	var/minimum_time = 2 MINUTES
	var/maximum_time = 10 MINUTES
	var/is_liquid =    FALSE
	var/is_ice =       FALSE

	var/list/ambient_sounds
	var/list/ambient_indoors_sounds

/singleton/state/weather/entered_state(datum/holder)
	. = ..()

	var/obj/abstract/weather_system/weather = holder
	weather.next_weather_transition = world.time + rand(minimum_time, maximum_time)
	weather.mob_shown_weather.Cut()
	weather.icon = icon
	weather.icon_state = icon_state
	weather.alpha = alpha

	if(is_liquid && weather.water_material)
		var/material/mat = SSmaterials.get_material_by_name(weather.water_material)
		weather.color = mat.icon_colour
	else if(is_ice && weather.ice_material)
		var/material/mat = SSmaterials.get_material_by_name(weather.ice_material)
		weather.color = mat.icon_colour
	else
		weather.color = COLOR_WHITE

/singleton/state/weather/proc/tick(var/obj/abstract/weather_system/weather)
	return

/singleton/state/weather/proc/handle_roofed_effects(var/mob/living/M, var/obj/abstract/weather_system/weather)
	return

/singleton/state/weather/proc/handle_protected_effects(var/mob/living/M, var/obj/abstract/weather_system/weather, var/obj/item/protected_by)
	if(prob(cosmetic_message_chance))
		if(protected_by && length(protected_messages))
			if(protected_by.loc == M)
				to_chat(M, "<span class='[cosmetic_span_class]'>[replacetext(pick(protected_messages), "$ITEM$", "your [protected_by.name]")]</span>")
			else
				to_chat(M, "<span class='[cosmetic_span_class]'>[replacetext(pick(protected_messages), "$ITEM$", "\the [protected_by]")]</span>")
		else if(length(cosmetic_messages))
			to_chat(M, "<span class='[cosmetic_span_class]'>[pick(cosmetic_messages)]</span>")

/singleton/state/weather/proc/handle_exposure_effects(var/mob/living/M, var/obj/abstract/weather_system/weather)
	handle_protected_effects(M, weather)

/singleton/state/weather/proc/handle_exposure(var/mob/living/M, var/exposure, var/obj/abstract/weather_system/weather)

	// Send strings if we're outside.
	if(M.is_outside() && M.client)
		if(!weather.show_weather(M))
			weather.show_wind(M)

	if(exposure != WEATHER_IGNORE && weather.set_cooldown(M))
		if(exposure == WEATHER_EXPOSED)
			handle_exposure_effects(M, weather)
		else if(exposure == WEATHER_ROOFED)
			handle_roofed_effects(M, weather)
		else if(exposure == WEATHER_PROTECTED)
			var/list/protected_by = M.get_weather_protection()
			if(LAZYLEN(protected_by))
				handle_protected_effects(M, weather, pick(protected_by))

/singleton/state/weather/proc/show_to(var/mob/living/M, var/obj/abstract/weather_system/weather)
	to_chat(M, descriptor)

/singleton/state/weather/calm
	name = "Calm"
	icon_state = "blank"
	descriptor = "The weather is calm."
	transitions = list(
		/singleton/state_transition/weather/snow,
		/singleton/state_transition/weather/rain
	)

/singleton/state/weather/snow
	name = "Light Snow"
	icon_state = "snowfall_light"
	descriptor = "It is snowing gently."
	is_ice = TRUE
	transitions = list(
		/singleton/state_transition/weather/calm,
		/singleton/state_transition/weather/rain,
		/singleton/state_transition/weather/snow_medium
	)
	ambient_sounds =     list('sound/effects/weather/snow.ogg')
	protected_messages = list("Snowflakes collect atop $ITEM$.")
	cosmetic_messages =  list(
		"Snowflakes fall slowly around you.",
		"Flakes of snow drift gently past."
	)

/singleton/state/weather/snow/medium
	name =  "Snow"
	icon_state = "snowfall_med"
	descriptor = "It is snowing."
	transitions = list(
		/singleton/state_transition/weather/snow,
		/singleton/state_transition/weather/snow_heavy
	)

/singleton/state/weather/snow/heavy
	name =  "Heavy Snow"
	icon_state = "snowfall_heavy"
	descriptor = "It is snowing heavily."
	transitions =       list(/singleton/state_transition/weather/snow_medium)
	cosmetic_messages = list(
		"Gusting snow obscures your vision.",
		"Thick flurries of snow swirl around you."
	)
	cosmetic_span_class = "warning"

/singleton/state/weather/rain
	name =  "Light Rain"
	icon_state = "rain"
	descriptor = "It is raining gently."
	cosmetic_span_class = "notice"
	is_liquid = TRUE
	transitions = list(
		/singleton/state_transition/weather/calm,
		/singleton/state_transition/weather/storm
	)
	ambient_sounds =         list('sound/effects/weather/rain.ogg')
	ambient_indoors_sounds = list('sound/effects/weather/rain_indoors.ogg')
	cosmetic_messages =      list("Raindrops patter against you.")
	protected_messages =     list("Raindrops patter against $ITEM$.")
	var/list/roof_messages = list("Rain patters against the roof.")

/singleton/state/weather/rain/handle_roofed_effects(var/mob/living/M, var/obj/abstract/weather_system/weather)
	if(length(roof_messages) && prob(cosmetic_message_chance))
		to_chat(M, "<span class='[cosmetic_span_class]'>[pick(roof_messages)]</span>")

/singleton/state/weather/rain/storm
	name =  "Heavy Rain"
	icon_state = "storm"
	descriptor = "It is raining heavily."
	cosmetic_span_class = "warning"
	transitions = list(
		/singleton/state_transition/weather/rain,
		/singleton/state_transition/weather/hail
	)
	cosmetic_messages =  list("Torrential rain thunders down around you.")
	protected_messages = list("Torrential rain thunders against $ITEM$.")
	roof_messages =      list("Torrential rain thunders against the roof.")
	ambient_sounds =     list('sound/effects/weather/rain_heavy.ogg')

/singleton/state/weather/rain/storm/tick(var/obj/abstract/weather_system/weather)
	..()
	if(prob(0.5))
		weather.lightning_strike()

/singleton/state/weather/rain/hail
	name =  "Hail"
	icon_state = "hail"
	descriptor = "It is hailing."
	cosmetic_span_class = "danger"
	is_liquid = FALSE
	is_ice = TRUE
	transitions =            list(/singleton/state_transition/weather/storm)
	cosmetic_messages =      list("Hail patters around you.")
	protected_messages =     list("Hail patters against $ITEM$.")
	roof_messages =          list("Hail clatters on the roof.")
	ambient_sounds =         list('sound/effects/weather/rain.ogg')
	ambient_indoors_sounds = list('sound/effects/weather/hail_indoors.ogg')

/singleton/state/weather/rain/hail/handle_exposure_effects(var/mob/living/M, var/obj/abstract/weather_system/weather)
	to_chat(M, SPAN_DANGER("You are pelted by a shower of hail!"))
	M.adjustBruteLoss(rand(1,3))

/singleton/state/weather/ash
	name =  "Ash"
	icon_state = "ashfall_light"
	descriptor = "A rain of ash falls from the sky."
	cosmetic_span_class = "warning"
	cosmetic_messages = list("Drifts of ash fall from the sky.")


//planet weathers

//snow planet - only snow or calm

/singleton/state/weather/calm/snow_planet
	transitions = list(/singleton/state_transition/weather/snow/snow_planet)

/singleton/state/weather/snow/snow_planet
	transitions = list(
		/singleton/state_transition/weather/calm/snow_planet,
		/singleton/state_transition/weather/snow_medium/snow_planet
	)

/singleton/state/weather/snow/medium/snow_planet
	transitions = list(
		/singleton/state_transition/weather/snow/snow_planet,
		/singleton/state_transition/weather/snow_heavy/snow_planet
	)

/singleton/state/weather/snow/heavy/snow_planet
	transitions = list(/singleton/state_transition/weather/snow_medium/snow_planet)

//jungle planets - only calm or rain

/singleton/state/weather/calm/jungle_planet
	transitions = list(/singleton/state_transition/weather/rain/jungle_planet)

/singleton/state/weather/rain/jungle_planet
	transitions = list(
		/singleton/state_transition/weather/calm/jungle_planet,
		/singleton/state_transition/weather/storm/jungle_planet
	)

/singleton/state/weather/rain/storm/jungle_planet
	transitions = list(/singleton/state_transition/weather/rain/jungle_planet)

//lava planets - only calm or ash

/singleton/state/weather/calm/lava_planet
	transitions = list(/singleton/state_transition/weather/ash/lava_planet)

/singleton/state/weather/ash/lava_planet
	transitions = list(/singleton/state_transition/weather/calm/lava_planet)

//arctic planet - only calm or hail

/singleton/state/weather/calm/arctic_planet
	transitions = list(/singleton/state_transition/weather/hail/arctic_planet)

/singleton/state/weather/rain/hail/arctic_planet
	transitions = list(/singleton/state_transition/weather/calm/arctic_planet)
