//Everything to do with reagents having temperature. Override reagent procs to make your own snowflake special reagent with mystical properties.
// https://www.aqua-calc.com/calculate/volume-to-weight/substance/
// https://www.engineeringtoolbox.com/specific-heat-fluids-d_151.html USE THE TABLE ON THE LEFT
// https://www.engineeringtoolbox.com/specific-heat-solids-d_154.html USE THE TABLE ON THE RIGHT
// http://www2.ucdsb.on.ca/tiss/stretton/database/specific_heat_capacity_table.html
// https://www.nuclear-power.net/radium-specific-heat-latent-heat-vaporization-fusion/

/singleton/reagent/proc/get_thermal_fraction(var/datum/reagents/holder)
	return get_heat_capacity(holder)/holder.get_heat_capacity()

/singleton/reagent/proc/get_thermal_energy(var/datum/reagents/holder)
	return (holder.thermal_energy * get_thermal_fraction(holder))

/singleton/reagent/proc/set_thermal_energy(amount, var/datum/reagents/holder, safety = FALSE)
	var/delta = amount / get_thermal_fraction(holder) - holder.thermal_energy
	if(!round(delta, 1))
		return
	holder.add_thermal_energy(delta, safety) // this handles on_heat_change for us

/singleton/reagent/proc/add_thermal_energy(amount, var/datum/reagents/holder, safety = FALSE)
	holder.add_thermal_energy(amount, safety)

/singleton/reagent/proc/set_temperature(temperature, var/datum/reagents/holder, safety = FALSE)
	set_thermal_energy(temperature * get_heat_capacity(holder), holder, safety = safety)

/datum/reagents/proc/get_heat_capacity()
	. = 0
	for(var/_R in reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		. += R.get_heat_capacity(src)

/singleton/reagent/proc/get_heat_capacity(var/datum/reagents/holder)
	return src.specific_heat * REAGENT_VOLUME(holder, src.type)

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
	return set_thermal_energy(get_thermal_energy_change(0,new_temperature), safety)

/datum/reagents/proc/add_thermal_energy(thermal_energy_to_add, safety = FALSE)
	thermal_energy_to_add = max(-thermal_energy, thermal_energy_to_add)
	var/total_heat_capacity = get_heat_capacity()

	for(var/_R in reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		var/energy_per_reagent = thermal_energy_to_add * (R.get_heat_capacity(src)/total_heat_capacity)
		if(!safety)
			R.on_heat_change(energy_per_reagent, src)
	thermal_energy += thermal_energy_to_add

/singleton/reagent/proc/on_heat_change(energy_change, var/datum/reagents/holder)
	return // stub for heat effects
