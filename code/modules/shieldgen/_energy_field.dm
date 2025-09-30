// This is an abstracted energy field to cut down on processing thousands of shields per process tick.
/datum/energy_field
	/// The shield generator connected to this energy field.
	var/obj/machinery/shield_gen/shield_generator
	/// A gigantic ass fucking list of energy fields.
	var/list/field
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

/datum/energy_field/New(obj/machinery/shield_gen/shield_generator, list/shielded_turfs)
	if(!istype(shield_generator))
		log_debug("Energy field created without shield generator, deleting.")
		return INITIALIZE_HINT_QDEL

	if(!length(shielded_turfs))
		log_debug("Energy field created without a full shielded turf list, deleting.")
		return INITIALIZE_HINT_QDEL

	var/turf/T = get_turf(src)
	for(var/turf/O as anything in shielded_turfs - T)
		var/obj/effect/energy_field/E = new(O, src)
		field += E

/datum/energy_field/Destroy(force)
	for(var/obj/effect/energy_field/D as anything in field)
		field.Remove(D)
		D.loc = null
	return ..()

/**
 * This proc, called when a shield generator processes, makes the whole thing tick by updating strength and etc.
 */
/datum/energy_field/proc/handle_strength()
	if(length(field))
		time_since_fail++
		var/total_renwick_increase = 0 //the amount of renwicks that the generator can add this tick, over the entire field
		var/renwick_upkeep_per_field = max(field_strength * dissipation_rate, min_dissipation)


		var/target_renwick_increase = min(target_field_strength - field_strength, strengthen_rate) + renwick_upkeep_per_field //per field tile
		var/required_energy = length(field) * target_renwick_increase / energy_conversion_rate
		var/assumed_charge = shield_generator.assume_charge(required_energy)
		total_renwick_increase = assumed_charge * energy_conversion_rate

		var/renwick_increase_per_field = total_renwick_increase / length(field) //per field tile
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
 * Adds a bunch of UI data for TGUIs with relevant field data.
 */
/datum/energy_field/proc/add_field_ui_data(list/data)
	if(!istype(data))
		return

	data["average_field"] = round(field_strength, 0.01)
	data["progress_field"] = (target_field_strength ? round(100 * field_strength / target_field_strength, 0.1) : "NA")
	data["power_take"] = round(field.len * max(field_strength * dissipation_rate, min_dissipation) / energy_conversion_rate)
	data["shield_power"] = round(field.len * min(strengthen_rate, target_field_strength - field_strength) / energy_conversion_rate)
	data["strengthen_rate"] = (strengthen_rate * 10)
	data["max_strengthen_rate"] = (max_strengthen_rate * 10)
	data["target_field_strength"] = target_field_strength
	return data
