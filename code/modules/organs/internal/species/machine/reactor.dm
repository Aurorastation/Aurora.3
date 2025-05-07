/obj/item/organ/internal/machine/reactor
	name = "electrical power supply unit"
	desc = "An electrical power supply system for a synthetic. It feeds from external sources."
	organ_tag = BP_REACTOR
	parent_organ = BP_CHEST
	possible_modifications = list(
		"Electric",
		"Kinetic",
		"Biological",
		"Solar"
	)
	organ_presets = list(
		ORGAN_PREF_ELECTRICPOWER = /singleton/synthetic_organ_preset/reactor/electric,
		ORGAN_PREF_KINETICPOWER = /singleton/synthetic_organ_preset/reactor/kinetic,
		ORGAN_PREF_BIOPOWER = /singleton/synthetic_organ_preset/reactor/biological,
		ORGAN_PREF_SOLARPOWER = /singleton/synthetic_organ_preset/reactor/solar,
	)
	default_preset = /singleton/synthetic_organ_preset/reactor/electric

	/// What kind of power supply this is. Bitfield.
	var/power_supply_type = POWER_SUPPLY_ELECTRIC
	/// Base power generation for active power supplies.
	var/base_power_generation = 0
	/// The multiplier for power gained by charging from external sources like an IPC or a cyborg charger.
	var/external_charge_multiplier = 1.3
	/// The last amount of power generated. Used in get_diagnostics_info().
	var/last_power_generated = 0
	/// The total amount of power generated. Used in get_diagnostics_info().
	var/total_power_generated = 0

/obj/item/organ/internal/machine/reactor/process(seconds_per_tick)
	..()
	if(!owner)
		return

	var/obj/item/organ/internal/machine/cell/cell = owner.internal_organs_by_name[BP_CELL]
	if(!cell)
		return

	if(power_supply_type & POWER_SUPPLY_SOLAR)
		var/turf/T = get_turf(src)
		if(T)
			var/power_generation = min(T.get_uv_lumcount(100, 200), base_power_generation)
			generate_power(power_generation)

/obj/item/organ/internal/machine/reactor/proc/generate_power(amount)
	var/obj/item/organ/internal/machine/cell/cell = owner.internal_organs_by_name[BP_CELL]
	if(!istype(cell))
		return

	. = cell.give(amount)
	last_power_generated = .
	total_power_generated += .

/obj/item/organ/internal/machine/reactor/get_diagnostics_info()
	return "Last Power Generated: [last_power_generated] W | Total Power Generated: [total_power_generated] W"
