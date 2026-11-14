#define COOLING_UNIT_DEFAULT_THERMOSTAT_MAX 323.15
#define COOLING_UNIT_DEFAULT_MAX_SAFE_TEMP 423.15
/// A single exposed hit at or above this damage causes a major coolant spill.
#define COOLING_UNIT_NOTABLE_DAMAGE 12

#define COOLING_POWER_LOW "low"
#define COOLING_POWER_MEDIUM "medium"
#define COOLING_POWER_HIGH "high"

// Low power reduces cooling output and power draw by the same proportion.
// Medium power increases cooling speed without increasing the base power draw.
// High power trades efficiency for additional cooling speed.
#define COOLING_POWER_LOW_OUTPUT_MULTIPLIER 0.8
#define COOLING_POWER_LOW_DRAW_MULTIPLIER 0.8
#define COOLING_POWER_MEDIUM_OUTPUT_MULTIPLIER 1.5
#define COOLING_POWER_HIGH_OUTPUT_MULTIPLIER 2.2
#define COOLING_POWER_HIGH_DRAW_MULTIPLIER 3

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

	/// The maximum power consumed per second while cooling at the preset's base rate.
	var/base_power_consumption = 8
	/**
	 * The base cooling rate in degrees Kelvin per second. The selected power setting,
	 * atmosphere, clothing, and organ damage can all modify the effective rate.
	 */
	var/passive_temp_change = 2
	/// The temperature cutoff at which the cooling unit stops drawing power.
	var/thermostat = T20C
	/// The player-selected balance between cooling output, cutoff temperature, and power draw.
	var/power_setting = COOLING_POWER_LOW
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
	/// The amount of degrees kelvin (per second) of heat the cooling unit will generate if it is blocked by a space suit.
	var/spacesuited_heat_per_second = 5
	/// Whether breached plating and damaged internals produce cosmetic coolant leaks.
	var/leaks_coolant = FALSE

/obj/item/organ/internal/machine/cooling_unit/Initialize()
	. = ..()
	set_power_setting(power_setting)
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

/obj/item/organ/internal/machine/cooling_unit/take_internal_damage(amount, silent, forced_damage = FALSE)
	var/plating_was_intact = plating?.get_status() > 0
	var/internal_integrity_before = (wiring.get_status() + electronics.get_status()) / 2
	. = ..()
	if(!leaks_coolant || plating?.get_status() > 0)
		return

	if(plating_was_intact)
		spill_coolant(TRUE)
	else if(amount >= COOLING_UNIT_NOTABLE_DAMAGE)
		spill_coolant(TRUE)
	else if(((wiring.get_status() + electronics.get_status()) / 2) < internal_integrity_before)
		spill_coolant()

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
		// The UI displays the cutoff and current temperature in Celsius, while the
		// cooling logic and thermostat limits use Kelvin internally.
		data["thermostat"] = thermostat - 273.15
		data["power_setting"] = power_setting
		data["cooling_output"] = passive_temp_change * get_cooling_output_multiplier()
		data["bodytemperature"] = owner.bodytemperature - 273.15
		data["temperature_safety"] = temperature_safety
		// This is the rated maximum. Actual draw is reduced as the IPC approaches
		// its cutoff and can be lower when the power core lacks enough charge.
		data["estimated_power_consumption"] = get_maximum_power_draw()
		data["safety_burnt"] = safety_burnt
		data["locked_thermostat"] = locked_thermostat
	return data

/obj/item/organ/internal/machine/cooling_unit/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "change_power_setting")
		if(locked_thermostat)
			to_chat(owner, SPAN_MACHINE_WARNING("You can't change the cooling power manually! It just returns an error!"))
			return FALSE

		var/new_power_setting = params["power_setting"]
		if(set_power_setting(new_power_setting))
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
	handle_coolant_leak(seconds_per_tick)

	var/datum/gas_mixture/ambient = T.return_air()
	// Too much heat is bad for the cooling unit.
	var/excess_temperature = owner.bodytemperature - species.heat_level_1
	if(excess_temperature > 0)
		var/damage_probability = min(excess_temperature * 0.5, 100)
		if(SPT_PROB(damage_probability, seconds_per_tick))
			var/heat_damage = max(excess_temperature * 0.01, 1)
			take_internal_damage(heat_damage * seconds_per_tick)

	// Start with the selected mode's ideal cooling, then reduce it according to
	// the cooler's environment and physical condition.
	var/temperature_change = passive_temp_change * get_cooling_output_multiplier() * seconds_per_tick
	if(owner.wear_suit)
		if(!spaceproof && istype(owner.wear_suit, /obj/item/clothing/suit/space))
			//cooling is going to SUCK if you have heat-regulating clothes
			temperature_change *= 0.5

	// Check if there is somehow no air, or if we are in an ambient without enough air to properly cool us.
	if((!ambient || (ambient && owner.calculate_affecting_pressure(XGM_PRESSURE(ambient)) < owner.species.warning_low_pressure)))
		if(!spaceproof)
			temperature_change *= 0
		else
			temperature_change = min(temperature_change * 3, 10) //give it a little boost to counteract temp gain in space

	if(is_broken())
		temperature_change *= 0.5 //uh oh
	else if(is_bruised())
		temperature_change *= 0.75

	// Now let's start cooling down!
	// No power, no party.
	var/obj/item/organ/internal/machine/power_core/cell = owner.internal_organs_by_name[BP_CELL]
	if(!istype(cell))
		return

	if(thermostat < owner.bodytemperature && temperature_change > 0)
		// Do not overshoot the cutoff. Drawing the same fraction of maximum power
		// as the fraction of this tick's cooling actually needed avoids paying the
		// full running cost when the IPC is already close to its target.
		var/actual_temperature_change = min(owner.bodytemperature - thermostat, temperature_change)
		var/cooling_fraction = actual_temperature_change / temperature_change
		var/requested_power = get_maximum_power_draw() * cooling_fraction * seconds_per_tick
		var/power_used = cell.use(requested_power)
		if(power_used > 0)
			// A nearly empty core provides proportional cooling instead of granting
			// the entire temperature change for a partial power payment.
			owner.bodytemperature -= actual_temperature_change * min(power_used / requested_power, 1)

/// Leaves coolant drips while a liquid cooler has exposed, damaged internals.
/obj/item/organ/internal/machine/cooling_unit/proc/handle_coolant_leak(seconds_per_tick)
	if(!leaks_coolant || !owner || plating.get_status() > 0)
		return

	var/internal_damage = 100 - ((wiring.get_status() + electronics.get_status()) / 2)
	if(internal_damage <= 0)
		return

	var/leak_probability = clamp(internal_damage * 0.5, 5, 25)
	if(SPT_PROB(leak_probability, seconds_per_tick))
		spill_coolant()

/// Creates a forensic-free coolant spill using the oil decal behavior.
/obj/item/organ/internal/machine/cooling_unit/proc/spill_coolant(burst = FALSE)
	if(!owner)
		return

	var/turf/T = get_turf(owner)
	if(!T)
		return

	if(burst)
		new /obj/effect/decal/cleanable/blood/oil/coolant(T)
		owner.visible_message(
			SPAN_WARNING("Coolant sprays from [owner]'s damaged chassis!"),
			SPAN_WARNING("Coolant sprays from your ruptured cooling unit!")
		)
		return

	if(locate(/obj/effect/decal/cleanable/blood/drip/oil/coolant) in T)
		return
	new /obj/effect/decal/cleanable/blood/drip/oil/coolant(T)

/// Returns the multiplier applied to the cooler's base cooling rate for the selected mode.
/// Each mode applies its own cooling rate multiplier to the cooler's base output.
/obj/item/organ/internal/machine/cooling_unit/proc/get_cooling_output_multiplier()
	switch(power_setting)
		if(COOLING_POWER_LOW)
			return COOLING_POWER_LOW_OUTPUT_MULTIPLIER
		if(COOLING_POWER_MEDIUM)
			return COOLING_POWER_MEDIUM_OUTPUT_MULTIPLIER
		if(COOLING_POWER_HIGH)
			return COOLING_POWER_HIGH_OUTPUT_MULTIPLIER
	return 1

/// Returns the selected mode's maximum power draw per second.
/// Low uses a fraction of the base draw, medium uses the base draw, and high multiplies it.
/obj/item/organ/internal/machine/cooling_unit/proc/get_maximum_power_draw()
	switch(power_setting)
		if(COOLING_POWER_LOW)
			return base_power_consumption * COOLING_POWER_LOW_DRAW_MULTIPLIER
		if(COOLING_POWER_HIGH)
			return base_power_consumption * COOLING_POWER_HIGH_DRAW_MULTIPLIER
	return base_power_consumption

/// Validates a TGUI-provided mode and derives its thermostat cutoff.
/// Low uses the warmest available cutoff, medium targets 20 C, and high uses the coldest available cutoff.
/obj/item/organ/internal/machine/cooling_unit/proc/set_power_setting(new_power_setting)
	if(!(new_power_setting in list(COOLING_POWER_LOW, COOLING_POWER_MEDIUM, COOLING_POWER_HIGH)))
		return FALSE

	power_setting = new_power_setting
	// Existing thermostat bounds are retained because organ damage can raise the
	// minimum temperature the cooler is physically capable of reaching.
	switch(power_setting)
		if(COOLING_POWER_LOW)
			thermostat = thermostat_max
		if(COOLING_POWER_MEDIUM)
			thermostat = clamp(T20C, thermostat_min, thermostat_max)
		if(COOLING_POWER_HIGH)
			thermostat = thermostat_min
	return TRUE

/obj/item/organ/internal/machine/cooling_unit/low_integrity_damage(integrity)
	if(get_integrity_damage_probability())
		to_chat(owner, SPAN_WARNING("Your temperature sensors pick up a spike in temperature."))
		owner.bodytemperature = min(owner.bodytemperature + 10, owner.species.heat_level_2)
	. = ..()

/obj/item/organ/internal/machine/cooling_unit/medium_integrity_damage(integrity)
	if(get_integrity_damage_probability() / 2)
		to_chat(owner, SPAN_WARNING("Your thermostat's temperature setting goes haywire!"))
		thermostat = rand(thermostat_min, thermostat_max)
		owner.bodytemperature = min(owner.bodytemperature + 20, owner.species.heat_level_2)

		if(prob(25) && !safety_burnt)
			to_chat(owner, SPAN_WARNING("Your temperature safeties burn out! They won't work anymore!"))
			safety_burnt = TRUE
	. = ..()

/obj/item/organ/internal/machine/cooling_unit/high_integrity_damage(integrity)
	if(get_integrity_damage_probability() / 3)
		if(spaceproof)
			playsound(owner, pick(SOUNDS_LASER_METAL), 50)
			to_chat(owner, SPAN_DANGER(FONT_LARGE("Your laminar cooling stratum has melted. Your cooling unit will not work in space anymore!")))
			spaceproof = FALSE
		else if(thermostat_min < (initial(thermostat_min) + 100))
			playsound(owner, pick(SOUNDS_LASER_METAL), 50)
			to_chat(owner, SPAN_DANGER(FONT_LARGE("Parts of your cooling unit melt away...!")))
			update_thermostat(thermostat_min + round(rand(10, 50)))
			owner.bodytemperature = min(owner.bodytemperature + 30, owner.species.heat_level_2)
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
#undef COOLING_UNIT_NOTABLE_DAMAGE
#undef COOLING_POWER_LOW
#undef COOLING_POWER_MEDIUM
#undef COOLING_POWER_HIGH
#undef COOLING_POWER_LOW_OUTPUT_MULTIPLIER
#undef COOLING_POWER_LOW_DRAW_MULTIPLIER
#undef COOLING_POWER_MEDIUM_OUTPUT_MULTIPLIER
#undef COOLING_POWER_HIGH_OUTPUT_MULTIPLIER
#undef COOLING_POWER_HIGH_DRAW_MULTIPLIER
