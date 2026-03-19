#define FREEZER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/temperature/freezer
	name = "gas cooling system"
	desc = "Cools gas when connected to pipe network."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "freezer_0"
	density = 1
	anchored = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 5			// 5 Watts for thermostat related circuitry

	/// The constant temperature reservoir into which the freezer pumps heat. Probably the hull of the station or something.
	var/heatsink_temperature = T20C

	set_temperature = T20C
	var/cooling = 0

	component_types = list(
		/obj/item/circuitboard/unary_atmos/cooler,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator,
		/obj/item/stack/cable_coil{amount = 5}
	)

	gas_temperature_bad_bottom = null
	gas_temperature_bad_top = (T20C + 40)
	gas_temperature_average_bottom = (T0C - 20)
	gas_temperature_average_top = (T0C - 100)

//upgrading parts
/obj/machinery/atmospherics/unary/temperature/freezer/RefreshParts()
	..()
	var/cap_rating = 0
	var/manip_rating = 0
	var/bin_rating = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			cap_rating += P.rating
		else if(ismanipulator(P))
			manip_rating += P.rating
		else if(ismatterbin(P))
			bin_rating += P.rating

	power_rating = initial(power_rating) * cap_rating / 2			//more powerful
	heatsink_temperature = initial(heatsink_temperature) / ((manip_rating + bin_rating) / 2)	//more efficient
	air_contents.volume = max(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/temperature/freezer/should_modify_gas()
	return air_contents.temperature > set_temperature

/obj/machinery/atmospherics/unary/temperature/freezer/modify_gas()
	var/heat_transfer = min(air_contents.get_thermal_energy_change(set_temperature - 5), 0)

	//Assume the heat is being pumped into the hull which is fixed at heatsink_temperature
	//not /really/ proper thermodynamics but whatever
	var/cop = performance_multiplier * air_contents.temperature/heatsink_temperature	//heatpump coefficient of performance from thermodynamics -> power used = heat_transfer/cop
	heat_transfer = min(heat_transfer, cop * power_rating)	//limit heat transfer by available power

	air_contents.add_thermal_energy(heat_transfer)		//remove the heat
