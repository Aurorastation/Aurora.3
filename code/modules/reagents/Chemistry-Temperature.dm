//Everything to do with reagents having temperature. Override reagent procs to make your own snowflake special reagent with mystical properties.

/datum/reagents/proc/get_heat_capacity() //Stolen from /tg/code
	var/returning = 0
	for(var/datum/reagent/R in reagent_list)
		if(total_volume)
			returning += R.get_heat_capacity() * (R.volume / total_volume)
	return returning

/datum/reagent/proc/get_heat_capacity()
	return specific_heat

//Adds or removes thermal energy. Returns the actual thermal energy change, as in the case of removing energy we can't go below TCMB.
/datum/reagents/proc/add_thermal_energy(var/thermal_energy_to_add)

	if (total_volume == 0)
		return 0

	for(var/datum/reagent/R in reagent_list)
		var/local_thermal_energy = thermal_energy_to_add / reagent_list.len
		if (local_thermal_energy < 0)
			if (R.get_temperature() < TCMB)
				return 0
			var/thermal_energy_limit = -(R.get_temperature() - TCMB) * R.get_heat_capacity()	//ensure temperature does not go below TCMB
			local_thermal_energy = max( local_thermal_energy, thermal_energy_limit )	//thermal_energy and thermal_energy_limit are negative here.
		R.add_thermal_energy(local_thermal_energy)

/datum/reagent/proc/add_thermal_energy(var/added_energy)
	thermal_energy += added_energy

/datum/reagents/proc/get_thermal_energy()
	var/returning = 0
	for(var/datum/reagent/R in reagent_list)
		returning += R.get_thermal_energy()
	return returning

/datum/reagent/proc/get_thermal_energy()
	return thermal_energy

/datum/reagent/proc/get_temperature()
	var/HC = get_heat_capacity()
	if(HC)
		return get_thermal_energy() / (HC * volume)
	else
		return T0C + 20

/datum/reagents/proc/get_temperature()
	var/HC = get_heat_capacity()
	if(HC)
		return get_thermal_energy() / (HC * total_volume)
	else
		return T0C + 20

//Returns the thermal energy change required to get to a new temperature
/datum/reagent/proc/get_thermal_energy_change(var/new_temperature)
	return get_heat_capacity()*(max(new_temperature, 0) - get_temperature())*volume

/datum/reagents/proc/get_thermal_energy_change(var/new_temperature)
	return get_heat_capacity()*(max(new_temperature, 0) - get_temperature())*total_volume

/datum/reagents/proc/equalize_thermal_energy()
	var/thermal_energy_to_add = get_thermal_energy()
	for(var/datum/reagent/R in reagent_list)
		R.add_thermal_energy(thermal_energy_to_add - R.get_thermal_energy())