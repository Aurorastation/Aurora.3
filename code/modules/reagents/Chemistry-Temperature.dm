//Everything to do with reagents having temperature. Override reagent procs to make your own snowflake special reagent with mystical properties.
// https://www.aqua-calc.com/calculate/volume-to-weight/substance/
// https://www.engineeringtoolbox.com/specific-heat-fluids-d_151.html USE THE TABLE ON THE LEFT
// https://www.engineeringtoolbox.com/specific-heat-solids-d_154.html USE THE TABLE ON THE RIGHT
// http://www2.ucdsb.on.ca/tiss/stretton/database/specific_heat_capacity_table.html
// https://www.nuclear-power.net/radium-specific-heat-latent-heat-vaporization-fusion/

/datum/reagents/proc/get_thermal_energy()
	var/returning = 0
	for(var/_R in reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		returning += R.get_thermal_energy()
	return returning

/decl/reagent/proc/get_thermal_energy(var/datum/reagents/holder)
	var/list/data = REAGENT_DATA(holder, type)
	return LAZYACCESS(data, "thermal_energy")

/datum/reagents/proc/get_heat_capacity()
	var/returning = 0
	for(var/_R in reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		if(total_volume)
			returning += R.get_heat_capacity(src)
	return returning

/decl/reagent/proc/get_heat_capacity(var/datum/reagents/holder)
	return specific_heat * REAGENT_VOLUME(holder, type)

/datum/reagents/proc/get_temperature()
	var/HC = get_heat_capacity()
	var/TE = get_thermal_energy()
	if(HC && TE)
		return TE / HC
	else
		return T0C + 20

/decl/reagent/proc/get_temperature(var/datum/reagents/holder)
	var/HC = get_heat_capacity(holder)
	var/TE = get_thermal_energy(holder)
	if(HC && TE)
		return TE / HC
	else
		return T0C + 20

/datum/reagents/proc/get_thermal_energy_change(var/old_temperature, var/new_temperature)
	return get_heat_capacity()*(max(new_temperature, TCMB) - old_temperature)

/decl/reagent/proc/get_thermal_energy_change(var/old_temperature, var/new_temperature, var/datum/reagents/holder)
	return get_heat_capacity(holder)*(max(new_temperature, TCMB) - old_temperature)

/decl/reagent/proc/add_thermal_energy(var/added_energy, var/datum/reagents/holder)
	LAZYSET(REAGENT_DATA(holder, type), "thermal_energy", max(0,thermal_energy + added_energy))
	return added_energy

/decl/reagent/proc/set_thermal_energy(var/set_energy, var/datum/reagents/holder)
	return add_thermal_energy(-get_thermal_energy(holder) + set_energy)

/decl/reagent/proc/set_thermal_energy_safe(var/set_energy, var/datum/reagents/holder) // This stops nitroglycerin from exploding
	LAZYSET(REAGENT_DATA(holder, type), "thermal_energy", set_energy)
	return 0

/datum/reagents/proc/set_thermal_energy(var/set_energy)
	return add_thermal_energy(-get_thermal_energy() + set_energy)

/decl/reagent/proc/set_temperature(var/new_temperature, var/datum/reagents/holder)
	return add_thermal_energy(-get_thermal_energy(holder) + get_thermal_energy_change(0,new_temperature, holder), holder )

/datum/reagents/proc/set_temperature(var/new_temperature)
	return add_thermal_energy(-get_thermal_energy() + get_thermal_energy_change(0,new_temperature) )

/datum/reagents/proc/equalize_temperature()

	var/total_thermal_energy = 0
	var/total_heat_capacity = 0
	var/was_changed = FALSE

	for(var/_R in reagent_data)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		total_thermal_energy += R.get_thermal_energy(src)
		total_heat_capacity += R.get_heat_capacity(src)

	for(var/_R in reagent_data)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		var/old_thermal_energy = R.get_thermal_energy(src)
		var/new_thermal_energy = total_thermal_energy * (R.get_heat_capacity(src)/total_heat_capacity)
		if(round(old_thermal_energy,1) != round(new_thermal_energy,1))
			R.set_thermal_energy( new_thermal_energy, src )
			was_changed = TRUE

	return was_changed

/datum/reagents/proc/add_thermal_energy(var/thermal_energy_to_add)

	var/total_energy_added = 0
	var/total_heat_capacity = 0

	for(var/_R in reagent_data)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		total_heat_capacity += R.get_heat_capacity(src)

	for(var/_R in reagent_data)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		total_energy_added += R.add_thermal_energy(thermal_energy_to_add * (R.get_heat_capacity()/total_heat_capacity), src )

	return total_energy_added

/datum/reagents/proc/has_all_temperatures(var/list/required_temperatures_min, var/list/required_temperatures_max)

	for(var/_current in reagent_data)
		var/decl/reagent/current = decls_repository.get_decl(_current)

		var/current_temperature = current.get_temperature(src)

		if(current.type in required_temperatures_min) //The current temperature must be greater than this temperature
			var/required_temperature = required_temperatures_min[current.type]
			if(current_temperature < required_temperature) //Current temperature is less than the required temperature,
				return FALSE

		if(current.type in required_temperatures_max) //The current temperature must be less than this temperature.
			var/required_temperature = required_temperatures_max[current.type]
			if(current_temperature > required_temperature) //Current temperature is greater than the required temperature.
				return FALSE

	return TRUE
