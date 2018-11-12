//Everything to do with reagents having temperature. Override reagent procs to make your own snowflake special reagent with mystical properties.
// https://www.aqua-calc.com/calculate/volume-to-weight/substance/
// https://www.engineeringtoolbox.com/specific-heat-fluids-d_151.html USE THE TABLE ON THE LEFT
// https://www.engineeringtoolbox.com/specific-heat-solids-d_154.html USE THE TABLE ON THE RIGHT
// http://www2.ucdsb.on.ca/tiss/stretton/database/specific_heat_capacity_table.html
// https://www.nuclear-power.net/radium-specific-heat-latent-heat-vaporization-fusion/

/datum/reagents/proc/get_thermal_energy()
	var/returning = 0
	for(var/datum/reagent/R in reagent_list)
		returning += R.get_thermal_energy()
	return returning

/datum/reagent/proc/get_thermal_energy()
	return thermal_energy

/datum/reagents/proc/get_heat_capacity()
	var/returning = 0
	for(var/datum/reagent/R in reagent_list)
		if(total_volume)
			returning += R.get_heat_capacity()
	return returning

/datum/reagent/proc/get_heat_capacity()
	return specific_heat * volume

/datum/reagents/proc/get_temperature()
	var/HC = get_heat_capacity()
	var/TE = get_thermal_energy()
	if(HC && TE)
		return TE / HC
	else
		return T0C + 20

/datum/reagent/proc/get_temperature()
	var/HC = get_heat_capacity()
	var/TE = get_thermal_energy()
	if(HC && TE)
		return TE / HC
	else
		return T0C + 20

/datum/reagents/proc/get_thermal_energy_change(var/old_temperature, var/new_temperature)
	return get_heat_capacity()*(max(new_temperature, TCMB) - old_temperature)

/datum/reagent/proc/get_thermal_energy_change(var/old_temperature, var/new_temperature)
	return get_heat_capacity()*(max(new_temperature, TCMB) - old_temperature)

/datum/reagent/proc/get_thermal_energy_per_unit()
	return get_thermal_energy() / volume

/datum/reagent/proc/add_thermal_energy(var/added_energy)
	thermal_energy = max(0,thermal_energy + added_energy)
	return added_energy

/datum/reagent/proc/set_thermal_energy(var/set_energy)
	return add_thermal_energy(-get_thermal_energy() + set_energy)

/datum/reagents/proc/set_thermal_energy(var/set_energy)
	return add_thermal_energy(-get_thermal_energy() + set_energy)

/datum/reagent/proc/set_temperature(var/new_temperature)
	return add_thermal_energy(-get_thermal_energy() + get_thermal_energy_change(0,new_temperature) )

/datum/reagents/proc/set_temperature(var/new_temperature)
	return add_thermal_energy(-get_thermal_energy() + get_thermal_energy_change(0,new_temperature) )

/datum/reagents/proc/equalize_thermal_energy()
	var/thermal_energy_to_add = get_thermal_energy()
	for(var/datum/reagent/R in reagent_list)
		R.add_thermal_energy(-R.get_thermal_energy() + (thermal_energy_to_add * (1/reagent_list.len)) )

/datum/reagents/proc/equalize_temperature()

	var/total_thermal_energy = 0
	var/total_heat_capacity = 0

	for(var/datum/reagent/R in reagent_list)
		total_thermal_energy += R.get_thermal_energy()
		total_heat_capacity += R.get_heat_capacity()

	for(var/datum/reagent/R in reagent_list)
		R.set_thermal_energy( total_thermal_energy * (R.get_heat_capacity()/total_heat_capacity) )

/datum/reagents/proc/add_thermal_energy(var/thermal_energy_to_add)
	var/total_energy_added = 0
	for(var/datum/reagent/R in reagent_list)
		total_energy_added += R.add_thermal_energy(thermal_energy_to_add * (1/reagent_list.len))

	return total_energy_added

/*
/datum/reagents/proc/add_thermal_energy(var/thermal_energy_to_add)

	if (total_volume == 0)
		return 0

	var/returning_energy_used = 0

	for(var/datum/reagent/R in reagent_list)
		var/local_thermal_energy = thermal_energy_to_add / reagent_list.len
		if (local_thermal_energy < 0)
			if (R.get_temperature() < TCMB)
				return 0
			var/thermal_energy_limit = -(R.get_temperature() - TCMB) * R.get_heat_capacity()	//ensure temperature does not go below TCMB
			local_thermal_energy = max( local_thermal_energy, thermal_energy_limit )	//thermal_energy and thermal_energy_limit are negative here.
		returning_energy_used += R.add_thermal_energy(local_thermal_energy)

	return returning_energy_used
*/

/datum/reagents/proc/has_all_temperatures(var/list/required_temperatures_min, var/list/required_temperatures_max)

	for(var/datum/reagent/current in reagent_list)

		var/current_temperature = current.get_temperature()

		if(current.id in required_temperatures_min) //The current temperature must be greater than this temperature
			var/required_temperature = required_temperatures_min[current.id]
			if(current_temperature < required_temperature) //Current temperature is less than the required temperature,
				return FALSE

		if(current.id in required_temperatures_max) //The current temperature must be less than this temperature.
			var/required_temperature = required_temperatures_max[current.id]
			if(current_temperature > required_temperature) //Current temperature is greater than the required temperature.
				return FALSE

	return TRUE