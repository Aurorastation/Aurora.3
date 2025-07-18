/obj/item/organ/internal/machine/reactor
	name = "electrical power supply unit"
	desc = "An electrical power supply system for a synthetic. It feeds from external sources."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "motor"
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
	/// Used only in the bioreactor to contain nutrient to process into energy.
	var/datum/reagents/bio_reagents

/obj/item/organ/internal/machine/reactor/Destroy()
	if(bio_reagents)
		QDEL_NULL(bio_reagents)
	return ..()

/obj/item/organ/internal/machine/reactor/process(seconds_per_tick)
	..()
	if(!owner)
		return

	var/obj/item/organ/internal/machine/power_core/cell = owner.internal_organs_by_name[BP_CELL]
	if(!cell)
		return

	if(power_supply_type & POWER_SUPPLY_SOLAR)
		var/turf/T = get_turf(src)
		if(T)
			var/power_generation = min(T.get_uv_lumcount(100, 200), base_power_generation)
			generate_power(power_generation)

	if(power_supply_type & POWER_SUPPLY_BIOLOGICAL)
		var/nutriment_amount = REAGENT_VOLUME(bio_reagents, /singleton/reagent/nutriment)
		if(nutriment_amount)
			var/reagents_to_process = min(rand(0.1, 0.3), nutriment_amount)
			bio_reagents.remove_reagent(/singleton/reagent/nutriment, reagents_to_process)
			generate_power(reagents_to_process * 1000)

/obj/item/organ/internal/machine/reactor/proc/generate_power(amount)
	var/obj/item/organ/internal/machine/power_core/cell = owner.internal_organs_by_name[BP_CELL]
	if(!istype(cell))
		return

	if(is_broken())
		return

	amount *= (get_integrity() / 100)

	. = cell.give(amount)
	last_power_generated = .
	total_power_generated += .

/obj/item/organ/internal/machine/reactor/high_integrity_damage(integrity)
	if(prob(get_integrity_damage_probability()))
		if(base_power_generation)
			to_chat(owner, SPAN_DANGER("Some capacitors in your [src] stop responding!"))
			base_power_generation *= 0.75
		else if(external_charge_multiplier)
			to_chat(owner, SPAN_DANGER("The traces in your [src] melt!"))
			base_power_generation *= 0.75
	. = ..()

/obj/item/organ/internal/machine/reactor/get_diagnostics_info()
	. = "Last Power Generated: [round(last_power_generated, 1)] W | Total Power Generated: [round(total_power_generated, 1)] W"

	if(power_supply_type & POWER_SUPPLY_BIOLOGICAL)
		var/nutriment_amount = REAGENT_VOLUME(bio_reagents, /singleton/reagent/nutriment)
		. += "| Processing Biomass: [nutriment_amount ? round(nutriment_amount, 1) : 0]u"
