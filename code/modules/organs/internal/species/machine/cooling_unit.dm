/obj/item/organ/internal/machine/cooling_unit
	name = "air cooling unit"
	desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature and prevents the chassis from overheating."
	organ_tag = BP_COOLING_UNIT
	parent_organ = BP_CHEST
	possible_modifications = list("Air Cooling", "Liquid Cooling", "Passive Cooling")

	/// The passive temperature change. Basically, cooling units counteract an IPC's passive temperature gain. But the IPC's temperature goes to get itself fucked if the cooling unit dies.
	/// Remember, can be negative or positive. Depends on what we're trying to stabilize towards.
	var/passive_temp_change = 2

/**
 * Called when prefs are synced to the organ to set the proper cooling type.
 * By default, this is an air cooled organ. No pref = air cooled unit.
 * TODOMATT: make this work with acting/changer.
 */
/obj/item/organ/internal/machine/cooling_unit/proc/set_cooling_type(cooling_type)
	switch(cooling_type)
		if(ORGAN_PREF_LIQUIDCOOLED)
			name = "liquid-cooling pump and radiator array"
			desc = "An extremely complex set of cooling pipes that transport coolant throughout a synthetic's body. The most efficient type of cooling, but also the most vulnerable."

			passive_temp_change = 3
			plating.max_health = 20
			plating.health = 20

		if(ORGAN_PREF_PASSIVECOOLED)
			name = "passive radiator block array"
			desc = "A simplistic, but efficient block of large cooling fins, which cool down a synthetic's body enough to make it work. Quite cheap, but durable."

			passive_temp_change = 1
			plating.max_health = 120
			plating.health = 120

/obj/item/organ/internal/machine/cooling_unit/process(seconds_per_tick)
	. = ..()
	if(!owner)
		return

	// Cooling units try to counteract external temperature by stabilizing towards ambient temperature.
	var/turf/T = get_turf(owner)
	if(isspaceturf(T))
		// Uh oh! No cooling here...
		owner.bodytemperature =  max(owner.bodytemperature + passive_temp_change, 500)
	else
		var/datum/gas_mixture/ambient = T.return_air()
		if(!ambient) //huh?
			owner.bodytemperature =  max(owner.bodytemperature + passive_temp_change, 500)
			return

		var/ambient_temperature = ambient.temperature
		if(ambient_temperature < owner.bodytemperature)
			owner.bodytemperature = max(owner.bodytemperature - passive_temp_change, ambient_temperature)
		else
			owner.bodytemperature = max(owner.bodytemperature + passive_temp_change, ambient_temperature)

/obj/item/organ/internal/machine/cooling_unit/low_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(integrity))
		to_chat(owner, SPAN_WARNING("Your temperature sensors pick up a spike in temperature."))
		owner.bodytemperature += 10
