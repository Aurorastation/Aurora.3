#define COOLING_UNIT_DEFAULT_THERMOSTAT_MAX 323.15
#define COOLING_UNIT_DEFAULT_MAX_SAFE_TEMP 423.15

/obj/item/organ/internal/machine/cooling_unit
	name = "air cooling unit"
	desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature and prevents the chassis from overheating."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_fans"
	organ_tag = BP_COOLING_UNIT
	parent_organ = BP_CHEST
	possible_modifications = list("Air Cooling", "Liquid Cooling", "Passive Cooling")
	organ_presets = list(
		ORGAN_PREF_AIRCOOLED = /singleton/synthetic_organ_preset/cooling_unit/air,
		ORGAN_PREF_LIQUIDCOOLED = /singleton/synthetic_organ_preset/cooling_unit/liquid,
		ORGAN_PREF_PASSIVECOOLED = /singleton/synthetic_organ_preset/cooling_unit/passive
	)
	default_preset = /singleton/synthetic_organ_preset/cooling_unit/air
	action_button_name = "Regulate Thermostat"

	max_damage = 70
	relative_size = 50

	/// The power consumed when we are cooling down.
	var/base_power_consumption = 8
	/// The passive temperature change. Basically, cooling units counteract an IPC's passive temperature gain. But the IPC's temperature goes to get itself fucked if the cooling unit dies.
	/// Remember, can be negative or positive. Depends on what we're trying to stabilize towards.
	var/passive_temp_change = 2
	/// The temperature that this cooling unit tries to regulate towards.
	var/thermostat = T20C
	/// The minimum value the thermostat can reach. 0C.
	var/thermostat_min = T0C
	/// The maximum value the thermostat can reach. 50C.
	var/thermostat_max = COOLING_UNIT_DEFAULT_THERMOSTAT_MAX
	/// Can this cooling unit work in space?
	var/spaceproof = FALSE
	/// The temperature at which this cooling unit will disable running if safeties are on.
	var/maximum_safe_temperature = COOLING_UNIT_DEFAULT_MAX_SAFE_TEMP
	/// If the safeties that automatically disable sprinting when bodytemperature exceeds safe limits are disabled or not.
	var/temperature_safety = TRUE
	/// If the safety has been burnt and thus will not engage.
	var/safety_burnt = FALSE
	/// If the thermostat is locked and thus cannot be changed. Used for spooky effects, like the high integrity damage in the positronic brain.
	var/locked_thermostat = FALSE

/obj/item/organ/internal/machine/cooling_unit/Initialize()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_IPC_HAS_SPRINTED, PROC_REF(handle_safeties))

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
	var/broken = is_broken()
	data["broken"] = broken
	if(!broken)
		data["thermostat"] = thermostat - 273.15
		data["thermostat_min"] = thermostat_min - 273.15
		data["thermostat_max"] = thermostat_max - 273.15
		data["passive_temp_change"] = passive_temp_change
		data["bodytemperature"] = owner.bodytemperature - 273.15
		data["temperature_safety"] = temperature_safety

		var/estimated_power_consumption = base_power_consumption
		var/integrity = get_integrity()
		if(integrity < IPC_INTEGRITY_THRESHOLD_MEDIUM)
			estimated_power_consumption = rand(-50, 100 + (100 - integrity))

		if(thermostat < initial(thermostat))
			estimated_power_consumption = ((initial(thermostat) - thermostat) + T0C) * 0.1
		else if(thermostat > initial(thermostat))
			// higher thermostat = less power usage
			estimated_power_consumption = -(thermostat_max / thermostat)

		data["estimated_power_consumption"] = max(0, base_power_consumption + estimated_power_consumption)
		data["safety_burnt"] = safety_burnt
	return data

/obj/item/organ/internal/machine/cooling_unit/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "change_thermostat")
		if(locked_thermostat)
			to_chat(owner, SPAN_MACHINE_WARNING("You can't change the thermostat manually! It just returns an error!"))
			return FALSE

		var/new_thermostat = params["change_thermostat"]
		// remember we are getting passed celsius here
		new_thermostat += 273.15
		if(new_thermostat >= thermostat_min && new_thermostat <= thermostat_max)
			thermostat = new_thermostat
		. = TRUE

	if(action == "temperature_safety")
		if(safety_burnt)
			return

		temperature_safety = !temperature_safety
		to_chat(usr, temperature_safety ? SPAN_NOTICE("You re-enable your temperature safety.") : SPAN_WARNING("You disable your temperature safety!"))
		. = TRUE

/obj/item/organ/internal/machine/cooling_unit/process(seconds_per_tick)
	. = ..()
	if(!owner)
		return

	// Cooling units try to counteract external temperature by stabilizing towards ambient temperature.
	var/turf/T = get_turf(owner)
	if(!T)
		// Some odd scenarios can cause there to be no turf. Like getting teleported into the game from lobby.
		return

	var/datum/gas_mixture/ambient = T.return_air()
	// Too much heat is bad for the cooling unit.
	if(owner.bodytemperature > species.heat_level_1)
		if(prob(owner.bodytemperature * 0.1))
			take_internal_damage(owner.bodytemperature * 0.01)

	var/temperature_change = passive_temp_change
	if(owner.wear_suit)
		if(!spaceproof && istype(owner.wear_suit, /obj/item/clothing/suit/space))
			//cooling is going to SUCK if you have heat-regulating clothes
			if(owner.bodytemperature < species.heat_level_3)
				owner.bodytemperature += 5
				temperature_change *= 0.1

	// Check if there is somehow no air, or if we are in an ambient without enough air to properly cool us.
	if((!ambient || (ambient && owner.calculate_affecting_pressure(ambient.return_pressure()) < owner.species.warning_low_pressure)) && !spaceproof)
		temperature_change *= 0
		return

	// Now let's start cooling down!
	// No power, no party.
	var/obj/item/organ/internal/machine/power_core/cell = owner.internal_organs_by_name[BP_CELL]
	if(!istype(cell))
		return

	// The lower our thermostat setting, the more power we consume.
	var/extra_power_consumption = 0
	if(thermostat < initial(thermostat))
		extra_power_consumption = ((initial(thermostat) - thermostat) + T0C) * 0.1
	else if(thermostat > initial(thermostat))
		// higher thermostat = less power usage
		extra_power_consumption = -(thermostat_max / thermostat)

	if(thermostat < owner.bodytemperature)
		if((owner.bodytemperature - temperature_change) < thermostat)
			temperature_change = owner.bodytemperature - thermostat
		owner.bodytemperature = max(owner.bodytemperature - temperature_change, thermostat)
		cell.use(max(0, base_power_consumption + extra_power_consumption))
	else
		if((owner.bodytemperature + temperature_change) > thermostat)
			temperature_change = thermostat - owner.bodytemperature
		owner.bodytemperature = min(owner.bodytemperature + temperature_change, thermostat)

/obj/item/organ/internal/machine/cooling_unit/low_integrity_damage(integrity)
	if(get_integrity_damage_probability() / 2)
		to_chat(owner, SPAN_WARNING("Your temperature sensors pick up a spike in temperature."))
		owner.bodytemperature += 10
	. = ..()

/obj/item/organ/internal/machine/cooling_unit/medium_integrity_damage(integrity)
	if(get_integrity_damage_probability() / 3)
		to_chat(owner, SPAN_WARNING("Your thermostat's temperature setting goes haywire!"))
		thermostat = rand(thermostat_min, thermostat_max)

		if(prob(25) && !safety_burnt)
			to_chat(owner, SPAN_WARNING("Your temperature safeties burn out! They won't work anymore!"))
			safety_burnt = TRUE
	. = ..()

/obj/item/organ/internal/machine/cooling_unit/high_integrity_damage(integrity)
	if(get_integrity_damage_probability() / 5)
		if(spaceproof)
			playsound(owner, pick(SOUNDS_LASER_METAL), 50)
			to_chat(owner, SPAN_DANGER(FONT_LARGE("Your laminar cooling stratum has melted. Your cooling unit will not work in space anymore!")))
			spaceproof = FALSE
		else if(thermostat_min < (initial(thermostat_min) + 100))
			to_chat(owner, SPAN_DANGER(FONT_LARGE("Parts of your cooling unit melt away...!")))
			update_thermostat(thermostat_min + round(rand(10, 50)))
	. = ..()

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

/obj/item/organ/internal/machine/cooling_unit/proc/handle_safeties()
	if(!owner)
		return

	if((owner.bodytemperature > maximum_safe_temperature) && temperature_safety && !safety_burnt)
		to_chat(owner, SPAN_DANGER("Your temperature safeties engage and stop you from running further!"))
		owner.balloon_alert(owner, "safeties engaged")
		owner.m_intent = M_WALK
		owner.hud_used.move_intent.update_move_icon(owner)

/obj/item/organ/internal/machine/cooling_unit/xion
	spaceproof = TRUE
	organ_presets = list(
		ORGAN_PREF_AIRCOOLED = /singleton/synthetic_organ_preset/cooling_unit/air_xion,
		ORGAN_PREF_LIQUIDCOOLED = /singleton/synthetic_organ_preset/cooling_unit/liquid_xion,
		ORGAN_PREF_PASSIVECOOLED = /singleton/synthetic_organ_preset/cooling_unit/passive_xion
	)
	default_preset = /singleton/synthetic_organ_preset/cooling_unit/air_xion

/obj/item/organ/internal/machine/cooling_unit/zenghu
	organ_presets = list(
		ORGAN_PREF_AIRCOOLED = /singleton/synthetic_organ_preset/cooling_unit/air_zenghu,
		ORGAN_PREF_LIQUIDCOOLED = /singleton/synthetic_organ_preset/cooling_unit/liquid_zenghu,
		ORGAN_PREF_PASSIVECOOLED = /singleton/synthetic_organ_preset/cooling_unit/passive_zenghu
	)
	default_preset = /singleton/synthetic_organ_preset/cooling_unit/air_zenghu

#undef COOLING_UNIT_DEFAULT_THERMOSTAT_MAX
#undef COOLING_UNIT_DEFAULT_MAX_SAFE_TEMP
