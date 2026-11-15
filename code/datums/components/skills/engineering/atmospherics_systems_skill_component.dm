/**
 * Component used for the Atmospherics Systems skill.
 * Governs pipework and pipe wrench mastery, tactile/visual diagnostics of pipes/canisters/tanks,
 * Gas Analyzer readouts, canister/regulator handling, complex atmospherics machinery configuration,
 * and breach/fire control efficiency (inflatable barriers, vent welding, fire extinguishers).
 */
/datum/component/skill/atmospherics_systems

/**
 * Helper to get a user's Atmospherics Systems skill level, defaulting to SKILL_LEVEL_TRAINED
 * if the mob does not use the skill system (e.g. ghosts, silicons without skill components).
 */
/proc/get_atmospherics_skill(mob/user)
	if(!istype(user))
		return SKILL_LEVEL_TRAINED
	var/level = GET_SKILL_LEVEL(user, ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT)
	if(!level)
		return SKILL_LEVEL_TRAINED
	return level

/**
 * Returns the user's Atmospherics Systems ranks above Unfamiliar (0 for Unfamiliar, up to 3 for Professional).
 */
/proc/get_effective_atmospherics_skill(mob/user)
	return max(0, get_atmospherics_skill(user) - SKILL_LEVEL_UNFAMILIAR)

/**
 * Returns the tool delay (in deciseconds) for fastening a pipe or pipe meter.
 */
/proc/get_pipe_fasten_delay(mob/user, obj/item/tool)
	var/effective_skill = get_effective_atmospherics_skill(user)
	var/base_delay = 30 - (10 * effective_skill)
	return istype(tool, /obj/item/pipewrench) ? max(0, base_delay) : max(5, base_delay + 5)

/**
 * Returns the tool delay (in deciseconds) for converting a pipe's shape or layer with a pipe wrench.
 */
/proc/get_pipe_convert_delay(mob/user)
	var/effective_skill = get_effective_atmospherics_skill(user)
	return max(0, round(20 * (1 - (effective_skill / 3))))

/**
 * Returns the tool delay (in deciseconds) for unfastening a pipe, meter, or inline atmospherics device.
 */
/proc/get_pipe_unfasten_delay(mob/user, exerted = FALSE)
	var/effective_skill = get_effective_atmospherics_skill(user)
	if(exerted)
		return max(30, 105 - (25 * effective_skill))
	return max(15, 60 - (15 * effective_skill))

/**
 * Shared helper for unfastening pipes and inline atmospherics devices with a wrench or pipe wrench.
 * Handles pressure exertion checks, pipe wrench support across all devices, and skill-based speed scaling.
 */
/obj/structure/machinery/atmospherics/proc/attempt_unfasten(obj/item/attacking_item, mob/user, internal_pressure_override = null)
	if(attacking_item.tool_behaviour != TOOL_WRENCH && !istype(attacking_item, /obj/item/pipewrench))
		return FALSE
	if(!loc)
		return FALSE

	var/int_pressure = 0
	if(!isnull(internal_pressure_override))
		int_pressure = internal_pressure_override
	else
		var/datum/gas_mixture/int_air = return_air()
		int_pressure = SAFE_XGM_PRESSURE(int_air)

	var/datum/gas_mixture/env_air = loc.return_air()
	var/env_pressure = SAFE_XGM_PRESSURE(env_air)
	var/skill = get_atmospherics_skill(user)
	var/exerted = ((int_pressure - env_pressure) > PRESSURE_EXERTED)

	if(exerted)
		if(!istype(attacking_item, /obj/item/pipewrench))
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
			add_fingerprint(user)
			return FALSE
		if(skill <= SKILL_LEVEL_UNFAMILIAR)
			to_chat(user, SPAN_WARNING("The internal pressure of \the [src] is too high—you don't know how to safely bleed the fitting without blowing it off!"))
			add_fingerprint(user)
			return FALSE

		to_chat(user, SPAN_WARNING("You brace \the [src] with your pipe wrench against the internal pressure..."))

	var/unfasten_delay = get_pipe_unfasten_delay(user, exerted)
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, unfasten_delay, volume = 50))
		if(QDELETED(src) || !loc)
			return FALSE
		return TRUE
	return FALSE

/**
 * Returns the tool delay (in deciseconds) for connecting or disconnecting portable atmospherics to a connector port.
 */
/proc/get_portable_connect_delay(mob/user)
	var/effective_skill = get_effective_atmospherics_skill(user)
	return max(0, round(25 * (1 - (effective_skill / 3))))

/**
 * Returns the tool delay (in deciseconds) for welding or unwelding a vent or scrubber.
 */
/proc/get_vent_weld_delay(mob/user)
	var/effective_skill = get_effective_atmospherics_skill(user)
	return max(5, 35 - (10 * effective_skill))

/**
 * Applies regulator dial imprecision for Unfamiliar users when setting pressure targets on canisters, pumps, or tanks.
 */
/proc/apply_atmos_pressure_precision(mob/user, target_val, min_val, max_val)
	if(!isnum(target_val))
		return min_val
	var/max_jitter_pct = max(0, (SKILL_LEVEL_FAMILIAR - get_atmospherics_skill(user)) * 8)
	if(max_jitter_pct > 0 && target_val > min_val)
		var/jitter = target_val * (rand(-max_jitter_pct, max_jitter_pct) / 100)
		target_val = round(target_val + jitter, 5)
	return clamp(target_val, min_val, max_val)

/**
 * Applies a brief configuration delay for Unfamiliar and Familiar users when reconfiguring complex atmospherics machinery
 * (Omni Filters, Omni Mixers, Gas Heaters/Coolers, Oxygen Regenerators, and Air Alarm custom TLV thresholds).
 */
/proc/check_atmos_machine_config(mob/user, atom/machinery)
	if(!istype(user) || issilicon(user) || isghost(user))
		return TRUE
	var/skill = get_atmospherics_skill(user)
	var/config_delay = max(0, (SKILL_LEVEL_TRAINED - skill) * 15)
	if(!config_delay)
		return TRUE

	if(skill <= SKILL_LEVEL_UNFAMILIAR)
		to_chat(user, SPAN_WARNING("You take a moment to puzzle over \the [machinery]'s atmospheric controls..."))
	else
		to_chat(user, SPAN_NOTICE("You carefully adjust \the [machinery]'s atmospheric parameters..."))

	if(!do_after(user, config_delay, machinery, DO_DEFAULT | DO_USER_UNIQUE_ACT))
		return FALSE
	return TRUE

/**
 * Returns the deployment delay (in deciseconds) for an inflatable barrier dispenser.
 */
/proc/get_inflatable_deploy_delay(mob/user)
	var/effective_skill = get_effective_atmospherics_skill(user)
	return max(10, 40 - (10 * effective_skill))

/**
 * Returns the deflation time (in deciseconds) when manually deflating an inflatable wall or door.
 */
/proc/get_inflatable_deflate_delay(mob/user)
	if(!user)
		return 2.6 SECONDS
	var/effective_skill = get_effective_atmospherics_skill(user)
	return max(0.8 SECONDS, (3.5 SECONDS) - (0.9 SECONDS * effective_skill))

/**
 * Returns the spray cooldown (in deciseconds) for a fire extinguisher.
 */
/proc/get_extinguisher_cooldown(mob/user)
	var/effective_skill = get_effective_atmospherics_skill(user)
	return max(10, 25 - (5 * effective_skill))

/**
 * Returns the reagent consumption multiplier for a fire extinguisher spray (15% reduction per rank above Unfamiliar).
 */
/proc/get_extinguisher_consumption_mult(mob/user)
	var/effective_skill = get_effective_atmospherics_skill(user)
	return clamp(1 - (0.15 * effective_skill), 0.55, 1)

/**
 * Checks whether a gas ID is a common everyday atmospheric gas recognizable by an Unfamiliar user on a Gas Analyzer.
 */
/proc/is_basic_atmospheric_gas(gas_id)
	var/static/list/basic_gases = list(
		GAS_OXYGEN,
		GAS_NITROGEN,
		GAS_CO2,
		GAS_WATERVAPOR
	)
	return (gas_id in basic_gases)

/**
 * Returns formatted hazard/property tags for a gas ID on a Gas Analyzer for Trained+ users.
 */
/proc/get_gas_hazard_tags(gas_id)
	var/list/tags = list()
	var/flags = gas_data.flags[gas_id]
	if(flags & XGM_GAS_FUEL)
		tags += "FLAMMABLE"
	if(flags & XGM_GAS_OXIDIZER)
		tags += "OXIDIZER"
	if((flags & XGM_GAS_CONTAMINANT) || (gas_id in list(GAS_SULFUR, GAS_NO2, GAS_TRITIUM)))
		tags += "TOXIC"
	if(gas_id == GAS_N2O)
		tags += "ANESTHETIC"
	if(flags & XGM_GAS_FUSION_FUEL)
		tags += "FUSION FUEL"
	if(!length(tags))
		return ""
	return " <b>\[[jointext(tags, ", ")]\]</b>"

/**
 * Returns tactile and acoustic diagnostic feedback when examining a pipe within 1 tile.
 */
/proc/get_pipe_atmos_feedback(obj/structure/machinery/atmospherics/pipe/P, mob/user)
	. = list()
	if(!istype(P) || !istype(user))
		return
	var/skill = get_atmospherics_skill(user)
	if(skill <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/datum/gas_mixture/int_air = P.return_air()
	var/pressure = SAFE_XGM_PRESSURE(int_air)
	var/temp_k = int_air ? int_air.temperature : T20C
	var/temp_c = temp_k - T0C
	var/env_pressure = SAFE_XGM_PRESSURE(P.loc?.return_air())
	var/pressure_diff = max(0, pressure - env_pressure)
	var/exerted = (pressure_diff > PRESSURE_EXERTED)

	if(skill == SKILL_LEVEL_FAMILIAR)
		var/temp_feel = "at ambient temperature"
		if(pressure > 1)
			switch(temp_c)
				if(-INFINITY to -20)
					temp_feel = "freezing cold to the touch"
				if(-20 to 10)
					temp_feel = "chilly to the touch"
				if(10 to 40)
					temp_feel = "at room temperature"
				if(40 to 100)
					temp_feel = "warm to the touch"
				else
					temp_feel = "scalding hot"

		var/flow_feel = "hollow and silent"
		if(pressure >= P.alert_pressure)
			flow_feel = SPAN_DANGER("groaning dangerously under extreme internal pressure")
		else if(pressure >= 500)
			flow_feel = "vibrating strongly with high-pressure gas"
		else if(pressure >= 10)
			flow_feel = "humming steadily with gas"

		. += SPAN_NOTICE("\The [P] feels [temp_feel] and sounds [flow_feel].")
		return

	if(skill == SKILL_LEVEL_TRAINED)
		var/pressure_bracket = "Empty (<10 kPa)"
		if(pressure >= P.alert_pressure)
			pressure_bracket = SPAN_DANGER("Critical / Near Fatigue (>= [round(P.alert_pressure)] kPa)")
		else if(pressure >= 2500)
			pressure_bracket = "Very High (2500+ kPa)"
		else if(pressure >= 500)
			pressure_bracket = "High (500–2500 kPa)"
		else if(pressure >= 100)
			pressure_bracket = "Nominal (100–500 kPa)"
		else if(pressure >= 10)
			pressure_bracket = "Low (10–100 kPa)"

		var/temp_bracket = "Ambient (10–40°C)"
		if(pressure <= 1)
			temp_bracket = "N/A (Vacuum)"
		else if(temp_c < -50)
			temp_bracket = "Cryogenic (< -50°C)"
		else if(temp_c < 10)
			temp_bracket = "Cold (-50 to 10°C)"
		else if(temp_c <= 40)
			temp_bracket = "Nominal (10 to 40°C)"
		else if(temp_c <= 150)
			temp_bracket = "Hot (40 to 150°C)"
		else
			temp_bracket = SPAN_WARNING("Extreme Heat (> 150°C)")

		. += SPAN_NOTICE("Estimated line pressure: <b>[pressure_bracket]</b> | Temperature: <b>[temp_bracket]</b>.[exerted ? " (Requires a <b>pipe wrench</b> to unfasten)" : ""]")
		return

	// Professional (4): ~Exact tactile/acoustic estimate + structural fatigue warning
	var/est_pressure = (pressure < 25) ? round(pressure, 1) : round(pressure, 25)
	var/est_temp = (pressure > 1) ? "[round(temp_c, 5)]°C" : "N/A (Vacuum)"
	. += SPAN_NOTICE("Estimated line pressure: <b>~[est_pressure] kPa</b> | Temperature: <b>~[est_temp]</b>.[exerted ? " (Exerted: requires a <b>pipe wrench</b>)" : ""]")
	if(pressure_diff >= P.alert_pressure)
		. += SPAN_DANGER("\The [P] is exceeding its fatigue threshold ([round(P.alert_pressure)] kPa differential) and is at immediate risk of bursting!")
	else if(pressure_diff >= P.alert_pressure * 0.8)
		. += SPAN_WARNING("\The [P] is approaching its structural fatigue limit ([round(P.alert_pressure)] kPa differential).")

/**
 * Returns gauge and thermal diagnostic feedback when examining a canister or portable atmospherics unit within 1 tile.
 */
/proc/get_portable_atmos_feedback(obj/structure/machinery/portable_atmospherics/PA, mob/user)
	. = list()
	if(!istype(PA) || PA.destroyed || !istype(user))
		return
	var/skill = get_atmospherics_skill(user)
	if(skill <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/pressure = SAFE_XGM_PRESSURE(PA.air_contents)
	var/temp_c = PA.air_contents ? (PA.air_contents.temperature - T0C) : 20

	if(skill == SKILL_LEVEL_FAMILIAR)
		var/gauge_desc = "Empty"
		if(pressure >= 4500)
			gauge_desc = "Full / Very High"
		else if(pressure >= 1500)
			gauge_desc = "High"
		else if(pressure >= ONE_ATMOSPHERE)
			gauge_desc = "Moderate"
		else if(pressure >= 10)
			gauge_desc = "Low"
		. += SPAN_NOTICE("Its analog pressure gauge reads: <b>[gauge_desc]</b>.")
	else if(skill == SKILL_LEVEL_TRAINED)
		. += SPAN_NOTICE("Its analog gauge reads approximately <b>[round(pressure, 10)] kPa</b> at <b>[round(temp_c, 5)]°C</b>.")
	else
		. += SPAN_NOTICE("Its pressure gauge reads <b>[round(pressure, 0.1)] kPa</b> at <b>[round(temp_c, 0.1)]°C</b> ([round(PA.air_contents?.total_moles, 0.1)] moles).")

	if(istype(PA, /obj/structure/machinery/portable_atmospherics/canister))
		var/obj/structure/machinery/portable_atmospherics/canister/C = PA
		if(C.valve_open)
			. += SPAN_WARNING("Its release valve is currently <b>OPEN</b> (set to [round(C.release_pressure, 1)] kPa)!")

/**
 * Returns gauge and regulator feedback when examining a handheld gas tank within 1 tile.
 */
/proc/get_tank_atmos_feedback(obj/item/tank/T, mob/user)
	. = list()
	if(!istype(T) || !T.air_contents || !istype(user))
		return
	var/skill = get_atmospherics_skill(user)
	if(skill <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/pressure = SAFE_XGM_PRESSURE(T.air_contents)
	if(skill == SKILL_LEVEL_FAMILIAR)
		var/gauge_desc = "Empty"
		if(pressure > TANK_IDEAL_PRESSURE)
			gauge_desc = "Overpressurized"
		else if(pressure >= TANK_IDEAL_PRESSURE * 0.75)
			gauge_desc = "Full"
		else if(pressure >= ONE_ATMOSPHERE * 2)
			gauge_desc = "Partially Full"
		else if(pressure > 10)
			gauge_desc = "Low"
		. += SPAN_NOTICE("The tank's pressure gauge indicates it is <b>[gauge_desc]</b>.")
	else if(skill == SKILL_LEVEL_TRAINED)
		. += SPAN_NOTICE("The tank's gauge reads <b>~[round(pressure, 5)] kPa</b> (regulator set to <b>[round(T.distribute_pressure, 1)] kPa</b>).")
	else
		. += SPAN_NOTICE("The tank's gauge reads <b>[round(pressure, 0.1)] kPa</b> (regulator set to <b>[round(T.distribute_pressure, 0.1)] kPa</b>).")
		if(pressure >= TANK_LEAK_PRESSURE * 0.85)
			. += SPAN_DANGER("The tank casing is dangerously overpressurized and near its leak threshold ([round(TANK_LEAK_PRESSURE)] kPa)!")

/**
 * Attempts to negate a low-pressure / vacuum lung rupture based on the character's Atmospherics Systems skill.
 * Chance to negate: 0% (Unfamiliar), 25% (Familiar), 50% (Trained), 100% (Professional).
 * Once negated, marks the lungs as exhaled for the duration of the low-pressure exposure until a normal breath is taken.
 */
/proc/try_negate_vacuum_lung_rupture(mob/living/carbon/human/H, obj/item/organ/internal/lungs/L)
	if(!istype(H))
		return FALSE
	if(!L && H.species?.breathing_organ)
		L = H.internal_organs_by_name[H.species.breathing_organ]
	if(istype(L) && L.low_pressure_exhaled)
		return TRUE

	var/skill = GET_SKILL_LEVEL(H, ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT) || SKILL_LEVEL_UNFAMILIAR
	var/effective_skill = max(0, skill - SKILL_LEVEL_UNFAMILIAR)
	var/negate_chance = effective_skill ? min(100, 25 * (2 ** (effective_skill - 1))) : 0

	if(negate_chance > 0 && prob(negate_chance))
		if(istype(L))
			L.low_pressure_exhaled = TRUE
			L.rupture_imminent = FALSE
		to_chat(H, FONT_LARGE(SPAN_NOTICE("Your atmospherics training kicks in, and you reflexively exhale to protect your lungs from rupturing!")))
		return TRUE

	return FALSE


