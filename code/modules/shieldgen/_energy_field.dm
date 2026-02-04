// This is an abstracted energy field to cut down on processing thousands of shields per process tick.
/datum/energy_field
	/// A gigantic ass fucking list of energy fields.
	var/list/field = list()
	/// The actual strength of the field.
	var/field_strength = 0
	/// Current strengthening rate of a single field.
	var/strengthen_rate = 0.2
	/// Maximum rate by which an energy field can be strengthened.
	var/max_strengthen_rate = 0.5
	/// The percentage of the shield strength that needs to be replaced each second
	var/dissipation_rate = 0.030
	/// An energy field will dissipate by at least this rate in renwicks per field tile (otherwise field would never dissipate completely as dissipation is a percentage)
	var/min_dissipation = 0.01
	/// Our target field strength.
	var/target_field_strength = 10
	/// The maximum field strength we can go to.
	var/max_field_strength = 10
	/// The time passed since the last "fail", AKA losing charge faster than you can replenish it.
	var/time_since_fail = 100
	/// How many renwicks per watt.
	var/energy_conversion_rate = 0.0002
	/// If the field is strong, then the energy field objects will turn dense.
	var/strong_field = FALSE

/datum/energy_field/Destroy(force)
	clear_field()
	return ..()

/**
 * This proc, called when a shield generator processes, makes the whole thing tick by updating strength and etc.
 * @assumed_charge: the charge that is given to this energy field. You have to get the required energy first, if you want a balanced field.
 */
/datum/energy_field/proc/handle_strength(assumed_charge = 0)
	if(length(field))
		time_since_fail++
		//the amount of renwicks that the generator can add this tick, over the entire field
		var/total_renwick_increase = assumed_charge * energy_conversion_rate

		var/renwick_increase_per_field = total_renwick_increase / length(field) //per field tile
		var/renwick_upkeep_per_field = max(field_strength * dissipation_rate, min_dissipation)
		var/amount_to_strengthen = renwick_increase_per_field - renwick_upkeep_per_field
		field_strength = min(field_strength + amount_to_strengthen, max_field_strength)

		if(field_strength < 1)
			if(strong_field)
				strong_field = FALSE
				SEND_SIGNAL(src, COMSIG_SHIELDS_UPDATE_STRENGTH_STATUS)
			time_since_fail = 0
		else
			if(!strong_field)
				strong_field = TRUE
				SEND_SIGNAL(src, COMSIG_SHIELDS_UPDATE_STRENGTH_STATUS)
	else
		field_strength = 0

/**
 * Returns the required energy upkeep for the field.
 */
/datum/energy_field/proc/get_required_energy()
	var/required_energy = 0
	if(length(field))
		var/renwick_upkeep_per_field = max(field_strength * dissipation_rate, min_dissipation)
		var/target_renwick_increase = min(target_field_strength - field_strength, strengthen_rate) + renwick_upkeep_per_field //per field tile
		required_energy = length(field) * target_renwick_increase / energy_conversion_rate
	return required_energy

/**
 * Clears the field of active field objects.
 */
/datum/energy_field/proc/clear_field()
	field_strength = 0
	strong_field = FALSE
	for(var/obj/effect/energy_field/D as anything in field)
		field.Remove(D)
		qdel(D)

/**
 * Sets the shielded turfs of the energy field.
 */
/datum/energy_field/proc/set_shielded_turfs(list/shielded_turfs)
	if(length(shielded_turfs))
		for(var/turf/T in shielded_turfs)
			var/obj/effect/energy_field/F = new(T, src)
			field += F

/**
 * Removes the field from the managed list and deletes it. Called by shield diffusion.
 */
/datum/energy_field/proc/remove_individual_field(var/obj/effect/energy_field/field_to_remove)
	field.Remove(field_to_remove)
	qdel(field_to_remove)

/**
 * Adds a bunch of UI data for TGUIs with relevant field data.
 */
/datum/energy_field/proc/add_field_ui_data(list/data)
	if(!istype(data))
		return

	data["average_field"] = round(field_strength, 0.01)
	data["progress_field"] = (target_field_strength ? round(100 * field_strength / target_field_strength, 0.1) : "NA")
	data["power_take"] = round(length(field) * max(field_strength * dissipation_rate, min_dissipation) / energy_conversion_rate)
	data["shield_power"] = round(length(field) * min(strengthen_rate, target_field_strength - field_strength) / energy_conversion_rate)
	data["strengthen_rate"] = (strengthen_rate * 10)
	data["max_strengthen_rate"] = (max_strengthen_rate * 10)
	data["target_field_strength"] = target_field_strength
	return data
