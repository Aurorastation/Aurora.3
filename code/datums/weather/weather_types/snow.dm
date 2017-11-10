/datum/weather/snow
	name = "snow"
	desc = "Heavy snow that makes people cold."

	telegraph_message = "<span class='warning'>Snow starts to fall.</span>" //The message displayed in chat to foreshadow the weather's beginning
	telegraph_duration = 300 //In deciseconds, how long from the beginning of the telegraph until the weather begins
	telegraph_sound = "sound/effects/wind/wind_5_1.ogg" 
	telegraph_overlay = "snowfall_med"

	weather_message = "<span class='danger'>Snow starts falling extremely fast!</span>" //Displayed in chat once the weather begins in earnest
	weather_duration = 1200 //In deciseconds, how long the weather lasts once it begins
	weather_duration_lower = 1200 //See above - this is the lowest possible duration
	weather_duration_upper = 1500 //See above - this is the highest possible duration
	weather_sound = "sound/effects/weather/wind.ogg"
	weather_overlay = "snowfall_heavy"

	end_message = "<span class='danger'>The snow eases up.</span>" //Displayed once the wather is over
	end_duration = 300 //In deciseconds, how long the "wind-down" graphic will appear before vanishing entirely
	end_sound = "sound/effects/wind/wind_4_1.ogg" 
	end_overlay = "snowfall_light"

	area_type_s = "/area/away_mission/iceland/iceland_outside"
	area_type = /area/away_mission/iceland/iceland_outside
	target_z = 10

	immunity_type = "cold" //Used by mobs to prevent them from being affected by the weather

	probability = 100 //Percent chance to happen if there are other possible weathers on the z-level

/datum/weather/snow/weather_act(mob/living/L) //What effect does this weather have on the hapless mob?
	if(prob(30))
		L.bodytemperature -= rand(10,50)
		if(prob(5)) // cold protect (jackets) soon
			L <<"<span class = 'danger'>You feel extremely cold unprotected from the harsh snowfall!</span>"
	return
