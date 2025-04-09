/obj/item/organ/internal/machine/cooling_unit
	name = "air cooling unit"
	desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature and prevents the chassis from overheating."
	organ_tag = BP_COOLING_UNIT
	parent_organ = BP_CHEST
	possible_modifications = list("Air Cooling", "Liquid Cooling", "Passive Cooling")

	action_button_name = "Regulate Thermostat"

	/// The passive temperature change. Basically, cooling units counteract an IPC's passive temperature gain. But the IPC's temperature goes to get itself fucked if the cooling unit dies.
	/// Remember, can be negative or positive. Depends on what we're trying to stabilize towards.
	var/passive_temp_change = 2

	/// The temperature that this cooling unit tries to regulate towards.
	var/thermostat = T20C

	/// The minimum value the thermostat can reach. 0C.
	var/thermostat_min = T0C

	/// The maximum value the thermostat can reach. 50C.
	var/thermostat_max = 323.15

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

		else
			name = "air cooling unit"
			desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature and prevents the chassis from overheating."

			passive_temp_change = 2
			plating.max_health = 50
			plating.health = 50

/obj/item/organ/internal/machine/cooling_unit/attack_self(var/mob/user)
	. = ..()
	if(owner.last_special > world.time)
		return

	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return

	ui_interact(user)

/obj/item/organ/internal/machine/cooling_unit/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CoolingUnitThermostat", "Cooling Unit Regulation", 400, 600)
		ui.open()

/obj/item/organ/internal/machine/cooling_unit/ui_data(mob/user)
	var/list/data = list()
	// K = C + 273.15 | C = K – 273.15
	// we want to pass celsius for readability,
	// the average american can't figure out celsius, let alone kelvin
	data["broken"] = is_broken()
	data["thermostat"] = thermostat - 273.15
	data["thermostat_min"] = thermostat_min - 273.15
	data["thermostat_max"] = thermostat_max - 273.15
	data["passive_temp_change"] = passive_temp_change
	data["bodytemperature"] = owner.bodytemperature - 273.15
	return data

/obj/item/organ/internal/machine/cooling_unit/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "change_thermostat")
		var/new_thermostat = params["change_thermostat"]
		// remember we are getting passed celsius here
		new_thermostat += 273.15
		if(new_thermostat >= thermostat_min && new_thermostat <= thermostat_max)
			thermostat = new_thermostat

/obj/item/organ/internal/machine/cooling_unit/process(seconds_per_tick)
	. = ..()
	if(!owner)
		return

	// Cooling units try to counteract external temperature by stabilizing towards ambient temperature.
	var/turf/T = get_turf(owner)
	if(!T)
		// Some odd scenarios can cause there to be no turf. Like getting teleported into the game from lobby.
		return

	if(isspaceturf(T))
		// Uh oh! No cooling here...
		owner.bodytemperature =  max(owner.bodytemperature + passive_temp_change, 500)
	else
		var/datum/gas_mixture/ambient = T.return_air()
		if(!ambient) //huh?
			owner.bodytemperature =  max(owner.bodytemperature + passive_temp_change, 500)
			return

		if(thermostat < owner.bodytemperature)
			owner.bodytemperature = max(owner.bodytemperature - passive_temp_change, thermostat)
		else
			owner.bodytemperature = min(owner.bodytemperature + passive_temp_change, thermostat)

/obj/item/organ/internal/machine/cooling_unit/low_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(integrity))
		to_chat(owner, SPAN_WARNING("Your temperature sensors pick up a spike in temperature."))
		owner.bodytemperature += 10
