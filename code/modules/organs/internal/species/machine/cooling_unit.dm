/obj/item/organ/internal/machine/cooling_unit
	name = "air cooling unit"
	desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature and prevents the chassis from overheating."
	organ_tag = BP_COOLING_UNIT
	parent_organ = BP_CHEST
	possible_modifications = list("Air Cooling", "Liquid Cooling", "Passive Cooling")
	organ_presets = list(
		ORGAN_PREF_AIRCOOLED = /singleton/synthetic_organ_preset/cooling_unit/air,
		ORGAN_PREF_LIQUIDCOOLED = /singleton/synthetic_organ_preset/cooling_unit/liquid,
		ORGAN_PREF_PASSIVECOOLED = /singleton/synthetic_organ_preset/cooling_unit/passive
	)
	default_preset = ORGAN_PREF_AIRCOOLED
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

	/// Can this cooling unit work in space?
	var/spaceproof = FALSE

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

	if(isspaceturf(T) && !spaceproof)
		// Uh oh! No cooling here...
		owner.bodytemperature =  max(owner.bodytemperature + passive_temp_change, 500)
	else
		var/datum/gas_mixture/ambient = T.return_air()
		if(!ambient) //huh?
			owner.bodytemperature =  max(owner.bodytemperature + passive_temp_change, 500)
			return

		// Too much heat is bad for the cooling unit.
		if(owner.bodytemperature > initial(thermostat_max) * 1.5)
			if(prob(owner.bodytemperature / 100))
				take_internal_damage(owner.bodytemperature / 200)

		var/temperature_change = passive_temp_change
		if(thermostat < owner.bodytemperature)
			if((owner.bodytemperature - temperature_change) < thermostat)
				temperature_change = owner.bodytemperature - thermostat
			owner.bodytemperature = max(owner.bodytemperature - temperature_change, thermostat)
		else
			if((owner.bodytemperature + temperature_change) > thermostat)
				temperature_change = thermostat - owner.bodytemperature
			owner.bodytemperature = min(owner.bodytemperature + temperature_change, thermostat)

/obj/item/organ/internal/machine/cooling_unit/low_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(10 + (100 - integrity) / 100))
		to_chat(owner, SPAN_WARNING("Your temperature sensors pick up a spike in temperature."))
		owner.bodytemperature += 10

/obj/item/organ/internal/machine/cooling_unit/medium_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(5 + (100 - integrity) / 100))
		to_chat(owner, SPAN_WARNING("Your thermostat's temperature setting goes haywire!"))
		thermostat = rand(thermostat_min, thermostat_max)

/obj/item/organ/internal/machine/cooling_unit/high_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(1 + (100 - integrity) / 100))
		if(spaceproof)
			playsound(owner, pick(SOUNDS_LASER_METAL), 50)
			to_chat(owner, SPAN_DANGER(FONT_LARGE("Your sensors notify you that part of your cooling unit has melted - it will not work in space anymore!")))
			spaceproof = FALSE

		if(thermostat_min < (initial(thermostat_min) + 100))
			to_chat(owner, SPAN_DANGER(FONT_LARGE("Part of your cooling unit melts away...!")))
			update_thermostat(thermostat_min + round(rand(10, 50)))

/obj/item/organ/internal/machine/cooling_unit/proc/update_thermostat(new_thermostat_min, new_thermostat_max)
	if(new_thermostat_min)
		thermostat_min = new_thermostat_min
		if(thermostat < new_thermostat_min)
			thermostat = new_thermostat_min

		if(thermostat_max < new_thermostat_max)
			thermostat_max = new_thermostat_min

	if(new_thermostat_max)
		thermostat_max = new_thermostat_max
		if(new_thermostat_max < thermostat_min)
			thermostat_min = new_thermostat_max

/obj/item/organ/internal/machine/cooling_unit/xion
	spaceproof = TRUE
	organ_presets = list(
		ORGAN_PREF_AIRCOOLED = /singleton/synthetic_organ_preset/cooling_unit/air_xion,
		ORGAN_PREF_LIQUIDCOOLED = /singleton/synthetic_organ_preset/cooling_unit/liquid_xion,
		ORGAN_PREF_PASSIVECOOLED = /singleton/synthetic_organ_preset/cooling_unit/passive_xion
	)


/obj/item/organ/internal/machine/cooling_unit/zenghu
	organ_presets = list(
		ORGAN_PREF_AIRCOOLED = /singleton/synthetic_organ_preset/cooling_unit/air_zenghu,
		ORGAN_PREF_LIQUIDCOOLED = /singleton/synthetic_organ_preset/cooling_unit/liquid_zenghu,
		ORGAN_PREF_PASSIVECOOLED = /singleton/synthetic_organ_preset/cooling_unit/passive_zenghu
	)
