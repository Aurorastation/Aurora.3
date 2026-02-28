//TODO: Put this under a common parent type with freezers to cut down on the copypasta
#define HEATER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/temperature/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "heater_0"

/obj/machinery/atmospherics/unary/temperature/heater/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "heats up the gas of the pipe it is connected to. It uses massive amounts of electricity while on."

/obj/machinery/atmospherics/unary/temperature/heater/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>matter bins</b> will increase maximum temperature setting and the volume of air it can heat at once."
	. += "Upgraded <b>capacitors</b> will increase maximum power setting and maximum temperature setting."

/obj/machinery/atmospherics/unary/temperature/heater/should_modify_gas()
	return air_contents.temperature < set_temperature

/obj/machinery/atmospherics/unary/temperature/heater/modify_gas()
	// amount of heat needed to heat air_contents to set_temperature + 5
	var/heat_transfer = max(air_contents.get_thermal_energy_change(set_temperature + 5), 0)
	heat_transfer = min(heat_transfer, performance_multiplier * power_rating) // don't overshoot
	air_contents.add_thermal_energy(heat_transfer)

//upgrading parts
/obj/machinery/atmospherics/unary/temperature/heater/RefreshParts()
	..()
	var/cap_rating = 0
	var/bin_rating = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			cap_rating += P.rating
		else if(ismatterbin(P))
			bin_rating += P.rating

	max_power_rating = initial(max_power_rating) * cap_rating / 2
	max_temperature = max(initial(max_temperature) - T20C, 0) * ((bin_rating * 4 + cap_rating) / 5) + T20C
	air_contents.volume = max(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)
