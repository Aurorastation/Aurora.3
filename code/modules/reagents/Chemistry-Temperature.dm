//Everything to do with reagents having temperature. Override reagent procs to make your own snowflake special reagent with mystical properties.
// https://www.aqua-calc.com/calculate/volume-to-weight/substance/
// https://www.engineeringtoolbox.com/specific-heat-fluids-d_151.html USE THE TABLE ON THE LEFT
// https://www.engineeringtoolbox.com/specific-heat-solids-d_154.html USE THE TABLE ON THE RIGHT
// http://www2.ucdsb.on.ca/tiss/stretton/database/specific_heat_capacity_table.html
// https://www.nuclear-power.net/radium-specific-heat-latent-heat-vaporization-fusion/

/datum/reagents/proc/get_thermal_energy()
	return thermal_energy

/decl/reagent/proc/get_thermal_fraction(var/datum/reagents/holder)
	return get_heat_capacity(holder)/holder.get_heat_capacity()

/decl/reagent/proc/get_thermal_energy(var/datum/reagents/holder)
	if(REAGENT_DATA(holder, type) && LAZYACCESS(holder.reagent_data[type], "last_thermal_energy"))
		return holder.reagent_data[type]["last_thermal_energy"]
	return (holder.thermal_energy * get_thermal_fraction(holder))

/decl/reagent/proc/set_thermal_energy(amount, var/datum/reagents/holder)
	if(!holder.reagent_data)
		LAZYINITLIST(holder.reagent_data)
	if(!REAGENT_DATA(holder, type))
		LAZYINITLIST(holder.reagent_data[type])
	LAZYSET(holder.reagent_data[type], "last_thermal_energy", amount) // on_heat_change() is called in equalize_temperature()
	holder.equalize_temperature()

/decl/reagent/proc/add_thermal_energy(amount, var/datum/reagents/holder)
	set_thermal_energy(get_thermal_energy(holder) + amount, holder)

/decl/reagent/proc/set_temperature(temperature, var/datum/reagents/holder)
	set_thermal_energy(temperature * get_heat_capacity(holder), holder)

/decl/reagent/proc/get_temperature(var/datum/reagents/holder)
	var/TE = get_thermal_energy(holder)
	var/HC = get_heat_capacity(holder)
	return (TE && HC) ? TE/HC : T20C

/datum/reagents/proc/get_heat_capacity()
	. = 0
	for(var/_R in reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		if(total_volume)
			. += R.get_heat_capacity(src)

/decl/reagent/proc/get_heat_capacity(var/datum/reagents/holder)
	return specific_heat * REAGENT_VOLUME(holder, type)

/datum/reagents/proc/get_temperature()
	var/HC = get_heat_capacity()
	var/TE = thermal_energy
	if(HC && TE)
		return TE / HC
	else
		return T20C

/datum/reagents/proc/get_thermal_energy_change(old_temperature, new_temperature)
	return get_heat_capacity()*(max(new_temperature, TCMB) - old_temperature)

/datum/reagents/proc/set_thermal_energy(set_energy, safety = FALSE)
	return add_thermal_energy(-thermal_energy + set_energy, safety)

/datum/reagents/proc/set_temperature(new_temperature, safety = FALSE)
	return add_thermal_energy(-thermal_energy + get_thermal_energy_change(0,new_temperature), safety )

/datum/reagents/proc/equalize_temperature()
	. = FALSE
	var/total_separate_energy = 0

	for(var/_R in reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		total_separate_energy += R.get_thermal_energy(src)
	for(var/_R in reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		var/delta = (total_separate_energy - R.get_thermal_energy(src)) * R.get_thermal_fraction(src)
		if(round(delta, 1))
			R.on_heat_change(delta, src)
			. = TRUE
		if(LAZYACCESS(reagent_data, _R))
			LAZYREMOVE(reagent_data[_R], "last_thermal_energy") // we've cleared it, uncache it
	thermal_energy = total_separate_energy

/datum/reagents/proc/add_thermal_energy(thermal_energy_to_add, safety = FALSE)
	thermal_energy_to_add = max(-thermal_energy, thermal_energy_to_add)
	var/total_heat_capacity = get_heat_capacity()

	for(var/_R in reagent_data)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		var/energy_per_reagent = thermal_energy_to_add * (R.get_heat_capacity(src)/total_heat_capacity)
		if(!safety)
			R.on_heat_change(energy_per_reagent, src)
	thermal_energy += thermal_energy_to_add

/datum/reagents/proc/has_all_temperatures(var/list/required_temperatures_min, var/list/required_temperatures_max)
	var/holder_temperature = get_temperature()
	for(var/_current in reagent_data)
		var/decl/reagent/current = decls_repository.get_decl(_current)
		var/current_temperature = holder_temperature
		if((REAGENT_DATA(src, _current) && LAZYACCESS(reagent_data[_current], "last_thermal_energy")))
			current_temperature = reagent_data[_current]["last_thermal_energy"]/current.get_heat_capacity(src)

		if(current.type in required_temperatures_min) //The current temperature must be greater than this temperature
			var/required_temperature = required_temperatures_min[current.type]
			if(current_temperature < required_temperature) //Current temperature is less than the required temperature,
				return FALSE

		if(current.type in required_temperatures_max) //The current temperature must be less than this temperature.
			var/required_temperature = required_temperatures_max[current.type]
			if(current_temperature > required_temperature) //Current temperature is greater than the required temperature.
				return FALSE

	return TRUE

/decl/reagent/proc/on_heat_change(energy_change, var/datum/reagents/holder)
	return // stub for heat effects
