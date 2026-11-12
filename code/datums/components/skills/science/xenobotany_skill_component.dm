/**
 * Component used for the Xenobotany skill.
 * Governs genetic extraction and splicing efficiency, plant gene mask decoding,
 * directed mutation and somatoray control, tissue sampling precision, plant analysis,
 * and handling of hazardous or spreading alien flora.
 */
/datum/component/skill/xenobotany
	/// +% bonus melee damage per skill level against living plant fauna (e.g. Pine Trees, Walking Mushrooms).
	var/bonus_damage_per_rank = 0.05
	/// +% bonus melee/unarmed damage per effective skill rank above Unfamiliar against spreading vines (/obj/effect/plant).
	var/vine_damage_bonus_per_rank = 0.25
	/// Reduction in sample damage multiplier per effective skill rank above Unfamiliar.
	var/sample_damage_reduction_per_rank = 0.25
	/// Bonus chance to divide a cutting into an extra seed packet at Professional rank.
	var/professional_bonus_seed_chance = 25
	/// Increase in species mutation chance per effective skill rank above Unfamiliar.
	var/species_mutation_bonus_per_rank = 10
	/// Increase in trait retention per effective skill rank above Unfamiliar when splicing biochemistry genes.
	var/trait_retention_bonus_per_rank = 0.05
	/// Bonus chance per effective skill rank above Unfamiliar to avoid flora hazards (stings, thorns, spores).
	var/hazard_avoid_bonus_per_rank = 50

/datum/component/skill/xenobotany/Initialize(level)
	. = ..()
	if(!parent)
		return

	RegisterSignal(parent, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS, PROC_REF(modify_butchering), override = TRUE)
	RegisterSignal(parent, COMSIG_PLANT_SAMPLER, PROC_REF(handle_plant_sampler), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_EXTRACT_GENE, PROC_REF(handle_extract_gene), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_APPLY_GENE, PROC_REF(handle_apply_gene), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_SOMATORAY, PROC_REF(handle_somatoray), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_INDUCE_MUTATION, PROC_REF(handle_induce_mutation), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_VINE_INTERACT, PROC_REF(handle_vine_interact), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_FLORA_HANDLING, PROC_REF(handle_flora_handling), override = TRUE)

/datum/component/skill/xenobotany/Destroy(force)
	if(!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_APPLY_HIT_EFFECT)
	UnregisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS)
	UnregisterSignal(parent, COMSIG_PLANT_SAMPLER)
	UnregisterSignal(parent, COMSIG_BOTANY_EXTRACT_GENE)
	UnregisterSignal(parent, COMSIG_BOTANY_APPLY_GENE)
	UnregisterSignal(parent, COMSIG_BOTANY_SOMATORAY)
	UnregisterSignal(parent, COMSIG_BOTANY_INDUCE_MUTATION)
	UnregisterSignal(parent, COMSIG_BOTANY_VINE_INTERACT)
	UnregisterSignal(parent, COMSIG_BOTANY_FLORA_HANDLING)
	return ..()

/// Increases melee damage against living plant fauna (e.g. Pine Trees, Walking Mushrooms, Killer Tomatoes).
/datum/component/skill/xenobotany/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return
	if(!istype(target) || target.ckey || !HAS_TRAIT(target, TRAIT_MC_PLANT))
		return

	if(prob(20))
		to_chat(owner, SPAN_NOTICE("Your attack exploits a structural weak spot in \the [target]'s fibrous anatomy!"))

	*power = *power * (1 + bonus_damage_per_rank * skill_level)

/// Increases butchering yield when harvesting parts from living plant fauna.
/datum/component/skill/xenobotany/proc/modify_butchering(owner, mob/living/simple_animal/target, base_meat_amount, butchering_bonus)
	SIGNAL_HANDLER
	if(!HAS_TRAIT(target, TRAIT_MC_PLANT) || skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	to_chat(owner, SPAN_NOTICE("Your familiarity with \the [target]'s botanical anatomy lets you harvest more intact parts."))
	var/skill_difference = skill_level - SKILL_LEVEL_UNFAMILIAR
	*base_meat_amount = *base_meat_amount + skill_difference
	if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*butchering_bonus = *butchering_bonus + skill_difference

/// Reduces tissue sampling damage and sample exhaustion chance, preserves wild flora, and grants a bonus cutting chance at Professional.
/datum/component/skill/xenobotany/proc/handle_plant_sampler(mob/user, datum/seed/plant, sample_damage, exhaust_chance, bonus_seed_chance, wild_destroy_chance)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/effective_skill = skill_level - SKILL_LEVEL_UNFAMILIAR
	if(!isnull(sample_damage))
		*sample_damage = max(1, round(*sample_damage * max(0.2, 1 - sample_damage_reduction_per_rank * effective_skill)))

	if(!isnull(exhaust_chance))
		// Scales down existing exhaust chance by 1/3 per rank above Unfamiliar (reaching 0% at Professional).
		*exhaust_chance = max(0, round(*exhaust_chance * (1 - (effective_skill / 3))))

	if(!isnull(wild_destroy_chance))
		*wild_destroy_chance = 0

	if(!isnull(bonus_seed_chance) && skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*bonus_seed_chance = *bonus_seed_chance + professional_bonus_seed_chance

/// Reduces genetic degradation increase when extracting a gene in the lysis-isolation centrifuge.
/datum/component/skill/xenobotany/proc/handle_extract_gene(mob/user, obj/structure/machinery/botany/extractor/machine, degradation_increase)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR || isnull(degradation_increase))
		return

	switch(skill_level)
		if(SKILL_LEVEL_FAMILIAR)
			*degradation_increase = max(5, round(*degradation_increase * 0.85))
		if(SKILL_LEVEL_TRAINED)
			*degradation_increase = max(5, round(*degradation_increase * 0.65))
		if(SKILL_LEVEL_PROFESSIONAL)
			*degradation_increase = max(5, round(*degradation_increase * 0.45))

/// Reduces splicing failure chance, genetic modification decay accumulation, and yield/endurance/gas penalties when splicing biochemistry genes.
/datum/component/skill/xenobotany/proc/handle_apply_gene(mob/user, datum/seed/plant, fail_chance, decay_increase, trait_retention, gas_retention)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/effective_skill = skill_level - SKILL_LEVEL_UNFAMILIAR
	if(!isnull(fail_chance))
		switch(skill_level)
			if(SKILL_LEVEL_FAMILIAR)
				*fail_chance = max(0, *fail_chance - 10)
			if(SKILL_LEVEL_TRAINED)
				*fail_chance = max(0, round(*fail_chance * 0.75) - 10)
			if(SKILL_LEVEL_PROFESSIONAL)
				*fail_chance = max(0, round(*fail_chance * 0.5) - 15)

	if(!isnull(decay_increase))
		*decay_increase = max(1, *decay_increase - effective_skill)

	if(!isnull(trait_retention))
		*trait_retention = min(1.0, *trait_retention + trait_retention_bonus_per_rank * effective_skill)

	if(!isnull(gas_retention))
		switch(skill_level)
			if(SKILL_LEVEL_FAMILIAR)
				*gas_retention = min(1.0, *gas_retention + 0.05)
			if(SKILL_LEVEL_TRAINED)
				*gas_retention = min(1.0, *gas_retention + 0.10)
			if(SKILL_LEVEL_PROFESSIONAL)
				*gas_retention = 1.0

/// Improves floral somatoray activation probability and yield beam boost on hydroponics trays.
/datum/component/skill/xenobotany/proc/handle_somatoray(mob/firer, obj/structure/machinery/portable_atmospherics/hydroponics/tray, proc_chance, yield_boost)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	if(!isnull(proc_chance))
		switch(skill_level)
			if(SKILL_LEVEL_FAMILIAR)
				*proc_chance = *proc_chance + 10
			if(SKILL_LEVEL_TRAINED)
				*proc_chance = *proc_chance + 25
			if(SKILL_LEVEL_PROFESSIONAL)
				*proc_chance = *proc_chance + 40

	if(!isnull(yield_boost))
		if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
			*yield_boost = *yield_boost + rand(1, 2)
		else if(skill_level >= SKILL_LEVEL_TRAINED)
			*yield_boost = *yield_boost + 1

/// Improves species mutation chance, prevents plant cancer (case 0), and biases trait mutations toward beneficial shifts.
/datum/component/skill/xenobotany/proc/handle_induce_mutation(mob/user, datum/seed/plant, species_mut_chance, min_mutation_case, mutation_bias)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/effective_skill = skill_level - SKILL_LEVEL_UNFAMILIAR
	if(!isnull(species_mut_chance))
		*species_mut_chance = *species_mut_chance + species_mutation_bonus_per_rank * effective_skill

	if(!isnull(min_mutation_case) && skill_level >= SKILL_LEVEL_FAMILIAR)
		*min_mutation_case = max(*min_mutation_case, 1)

	if(!isnull(mutation_bias) && skill_level >= SKILL_LEVEL_TRAINED)
		*mutation_bias = *mutation_bias + (skill_level - SKILL_LEVEL_FAMILIAR)

/// Increases damage against spreading vines and improves unbuckling and entanglement evasion chances.
/datum/component/skill/xenobotany/proc/handle_vine_interact(mob/user, obj/effect/plant/vine, damage, escape_chance, evade_chance)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/effective_skill = skill_level - SKILL_LEVEL_UNFAMILIAR
	if(!isnull(damage))
		*damage = *damage * (1 + vine_damage_bonus_per_rank * effective_skill)

	if(!isnull(escape_chance))
		switch(skill_level)
			if(SKILL_LEVEL_FAMILIAR)
				*escape_chance = min(100, *escape_chance + 15)
			if(SKILL_LEVEL_TRAINED)
				*escape_chance = min(100, *escape_chance + 35)
			if(SKILL_LEVEL_PROFESSIONAL)
				*escape_chance = 100

	if(!isnull(evade_chance))
		switch(skill_level)
			if(SKILL_LEVEL_FAMILIAR)
				*evade_chance = min(100, *evade_chance + 35)
			if(SKILL_LEVEL_TRAINED)
				*evade_chance = min(100, *evade_chance + 70)
			if(SKILL_LEVEL_PROFESSIONAL)
				*evade_chance = 100

/// Increases chance to avoid flora hazards (stings, thorns, spore bursts) and salvage wild seed packets.
/datum/component/skill/xenobotany/proc/handle_flora_handling(mob/user, datum/seed/plant, hazard_avoid_chance, salvage_seed_chance)
	SIGNAL_HANDLER
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/effective_skill = skill_level - SKILL_LEVEL_UNFAMILIAR
	if(!isnull(hazard_avoid_chance))
		*hazard_avoid_chance = min(100, *hazard_avoid_chance + hazard_avoid_bonus_per_rank * effective_skill)

	if(!isnull(salvage_seed_chance) && skill_level >= SKILL_LEVEL_TRAINED)
		*salvage_seed_chance = min(100, *salvage_seed_chance + 50 * (skill_level - SKILL_LEVEL_FAMILIAR))

/**
 * Returns TRUE if the user's Xenobotany skill allows them to decode the given obfuscated plant gene tag.
 * Trained decodes foundational/agronomic loci; Professional decodes all 12 loci.
 */
/proc/can_decode_plant_gene(mob/user, gene_tag)
	if(!user || !gene_tag)
		return FALSE
	var/botany_skill = GET_SKILL_LEVEL(user, XENOBOTANY_SKILL_COMPONENT)
	if(botany_skill >= SKILL_LEVEL_PROFESSIONAL)
		return TRUE
	if(botany_skill >= SKILL_LEVEL_TRAINED)
		var/static/list/trained_decodable_genes = list(
			GENE_PIGMENT,
			GENE_ENVIRONMENT,
			GENE_HARDINESS,
			GENE_VIGOUR,
			GENE_DIET,
			GENE_METABOLISM
		)
		return (gene_tag in trained_decodable_genes)
	return FALSE

/**
 * Formats an obfuscated plant gene hex mask, appending its true gene tag if the user can decode it.
 */
/proc/format_plant_gene_mask(mob/user, gene_tag, gene_mask = null)
	if(!gene_mask && SSplants)
		gene_mask = SSplants.get_gene_mask(gene_tag)
	if(can_decode_plant_gene(user, gene_tag))
		return "[gene_mask] ([gene_tag])"
	return "[gene_mask]"
