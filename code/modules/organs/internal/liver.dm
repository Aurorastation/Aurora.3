/obj/item/organ/internal/liver
	name = "liver"
	desc = "If it stops working, should it be called the die-er?"
	icon_state = "liver"
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	robotic_name = "toxin filter"
	toxin_type = CE_HEPATOTOXIC
	min_bruised_damage = 25
	min_broken_damage = 55

	max_damage = 70
	relative_size = 60

	/// The base "efficiency" of a liver.
	var/base_filter_strength = 1

	/// The base "Filter effect" rating of a liver, used for calculating whether or not drinking alcohol causes lethal damage.
	var/base_filter_effect = 3

	/// How much dylovene contributes to "filter effect".
	var/filter_effect_from_dylovene = 1

	/**
	 * How much toxin damage per second a liver-haver takes if they combine alcohol with a non-functional liver.
	 * This gets multiplied by the inverse absolute average deviation from base filter effect.
	 */
	var/lethal_booze_dps = 1

	/// How much a liver being in its "bruised" state modifies its efficiency.
	var/intox_filter_bruised = 0.462

	/// How much a liver being in its "broken" state modifies its efficiency.
	var/intox_filter_broken = 0.198

	/// How much a liver being robotic modifies its efficiency. TODO: Remove this after reworking the organ selector to make robotic organs actually different entities.
	var/intox_filter_robotic = 1.1

	/// The base rate at which this liver processes Dylovene into "Toxin healing" per second.
	var/base_toxin_healing_rate = 6

	/// The upper limit of how much toxin a liver can contain before its efficiency tanks dramatically.
	var/toxin_critical_mass = 60

	/// How much toxin volume above the toxin critical mass contributes to the filter effect.
	var/filter_effect_from_critical_toxin = 2

	/// Modifier on how efficiently this liver eliminates booze.
	var/booze_filtering_modifier = 0.03

	/// How much the liver being bruised contributes to filter effect.
	var/filter_effect_from_bruise = 1

	/// How much the liver being broken contributes to filter effect.
	var/filter_effect_from_broken = 2

	/// Modifier on how efficiently this liver eliminates booze while blackout drunk.
	var/blackout_booze_filtering_modifier = 0.015

	/// Message to play in chat to a liver-haver when they have an infection.
	var/infection_level_one_warning = "Your skin itches."

	/// A largely undamaged healthy liver will gradually heal itself over time by this amount per second
	var/liver_regeneration_normal = 6

	/// A "bruised"(lightly damaged) liver will gradually heal itself by this amount per second.
	var/liver_regeneration_bruised = 4

	/// A liver that is "broken" will heal itself by this amount per second. By default, this is no regeneration.
	var/liver_regeneration_broken = 0

/obj/item/organ/internal/liver/process(seconds_per_tick)

	..()

	if(!owner)
		return

	if(germ_level > INFECTION_LEVEL_ONE)
		owner.notify_message(SPAN_WARNING(infection_level_one_warning), 2 MINUTES)
	if(germ_level > INFECTION_LEVEL_TWO && prob(1))
		spawn owner.delayed_vomit()

	// Get the effectiveness of the liver.
	var/filter_effect = base_filter_effect

	// Copy the base filter variables, so that we aren't modifying the original values.
	var/filter_strength = base_filter_strength
	var/toxin_healing_rate = base_toxin_healing_rate

	// Optionally allow signal repliers to cancel liver filtration. Antifreeze could be a fun one.
	var/canceled = FALSE

	// Check if any components on the user wish to mess with liver filtration.
	SEND_SIGNAL(owner, COMSIG_LIVER_FILTER_EVENT, &filter_effect, &filter_strength, &toxin_healing_rate, &canceled)
	if(canceled)
		return

	//Detox can heal small amounts of damage
	if(damage < max_damage && !owner.chem_effects[CE_TOXIN])
		heal_damage(toxin_healing_rate * seconds_per_tick * owner.chem_effects[CE_ANTITOXIN])

	if(is_bruised())
		filter_strength *= intox_filter_bruised // Defaulted to 0.462
		filter_effect -= filter_effect_from_bruise
	if(is_broken())
		filter_strength *= intox_filter_broken // Defaulted to 0.198
		filter_effect -= filter_effect_from_broken
	if(BP_IS_ROBOTIC(src))
		filter_strength *= intox_filter_robotic // Defaulted to 1.1

	if(owner.intoxication > 0)
		handle_alcohol_poisoning(filter_effect, filter_strength, seconds_per_tick)

	if(!is_damaged())
		return
	if(toxin_type in owner.chem_effects)
		// Hepatoxic(liver damaging) chems start dealing lethal damage to the patient once the liver is broken.
		owner.adjustToxLoss(max(0, (owner.chem_effects[toxin_type] - filter_strength)) * seconds_per_tick) // as actual organ damage is handled elsewhere

/// Liver damage + alcohol = bad time.
/obj/item/organ/internal/liver/proc/handle_alcohol_poisoning(var/filter_effect, var/filter_strength, var/seconds_per_tick)
	// Robotic organs filter better but don't get benefits from dylovene for filtering.
	if(BP_IS_ROBOTIC(src)) // TODO: Just make robot livers have a base filter_effect of 4.
		filter_effect += 1
	else if(owner.chem_effects[CE_ANTITOXIN])
		filter_effect += filter_effect_from_dylovene
	if(getToxLoss() >= toxin_critical_mass) //Too many toxins to process. Abort, abort.
		filter_effect -= filter_effect_from_critical_toxin
	if(filter_effect < base_filter_effect)
		// Take the inverse absolute average deviation from the base filter effect.
		var/booze_damage_factor = base_filter_effect / abs(filter_effect - base_filter_effect)

		// And then multiply it by our tickrate and desired DPS, to get toxin damage every tick.
		// Previously this was hardcoded to always fail at 0 or less filter effect, now it arbitrarily doesn't matter if filter effect goes into negatives.
		// You now take further scaling damage the lower you go into negatives. This also is no longer limited to integers.
		owner.adjustToxLoss(lethal_booze_dps * booze_damage_factor * seconds_per_tick)

	var/bac = owner.get_blood_alcohol()
	var/res = owner.species ? owner.species.ethanol_resistance : 1
	var/blackout_effects = (bac >= INTOX_BLACKOUT * res) ? blackout_booze_filtering_modifier : booze_filtering_modifier

	owner.intoxication -= min(owner.intoxication, filter_strength * (filter_effect / base_filter_effect) * blackout_effects * seconds_per_tick)

	if(!owner.intoxication)
		owner.handle_intoxication()

/obj/item/organ/internal/liver/handle_regeneration(seconds_per_tick)
	if(!..() || owner.total_radiation || damage <= 0 || (owner.get_blood_alcohol() > INTOX_BLACKOUT))
		return FALSE
	// This can't be a switch statement because these aren't constants. I tried.
	if(liver_regeneration_normal && damage < min_bruised_damage)
		heal_damage(liver_regeneration_normal * seconds_per_tick)
		return TRUE
	if(liver_regeneration_bruised && damage < min_broken_damage)
		heal_damage(liver_regeneration_bruised * seconds_per_tick)
		return TRUE
	if(liver_regeneration_broken) // A default "standard" liver returns false here, since it has a regeneration rate of 0 when broken.
		heal_damage(liver_regeneration_broken * seconds_per_tick)
		return TRUE
	return FALSE

/obj/item/organ/internal/liver/boosted_liver
	name = "boosted liver"
	desc = "Designed primarily for diplomats or Galateans abroad, the boosted liver improves toxin filtering, giving a resistance to toxin damage. As a consequence, it makes it impossible for the user to get drunk."
	//icon = 'icons/obj/organs/bioaugs.dmi'
	//icon_state = "boosted_liver"
	base_filter_strength = 1.5
	base_filter_effect = 5
	toxin_critical_mass = 90
	booze_filtering_modifier = 0.5 // "Impossible to get drunk", this should make it impossible. :)
	blackout_booze_filtering_modifier = 0.25

/obj/item/organ/internal/liver/alien_liver
	name = "anomalous mercurial flesh"
	desc = "A slab of flesh made seemingly from mercury, yet with a recognizably organic shape. It is soft to the touch, pliable like skin, yet is as tough as steel."
	icon = 'icons/obj/organs/bioaugs.dmi'
	icon_state = "alien_liver"
	max_damage = 200
	min_bruised_damage = 150
	min_broken_damage = 175

/obj/item/organ/internal/liver/alien_liver/Initialize()
	. = ..()
	base_filter_strength *= rand(0.5, 2)
	base_filter_effect *= rand(0.5, 2)
	// That negative bound is intentional.
	// A negative filter effect value means dylovene will decrease the liver effectiveness.
	filter_effect_from_dylovene *= rand(-2, 2)
	intox_filter_bruised *= rand(0.5, 2)
	intox_filter_broken *= rand(0.5, 2)
	base_toxin_healing_rate *= rand(0.5, 2)
	toxin_critical_mass *= rand(0.5, 2)
	filter_effect_from_critical_toxin *= rand(0.5, 2)
	booze_filtering_modifier *= rand(0, 10)
	filter_effect_from_bruise *= rand(0.5, 2)
	filter_effect_from_broken *= rand(0.5, 2)
	blackout_booze_filtering_modifier *= rand(0, 10)
	infection_level_one_warning = "Uncountable tiny metal scarabs dig into your flesh."
	liver_regeneration_normal *= rand(0, 2)
	liver_regeneration_bruised *= rand(0, 2)
	liver_regeneration_broken = rand(0, 12)
