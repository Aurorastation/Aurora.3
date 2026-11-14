/datum/component/skill/gardening
	var/bonus_yield_per_rank = 1
	var/harvest_speedup_per_rank = 0.333 SECONDS

/datum/component/skill/gardening/Initialize(level)
	. = ..()
	if(!parent)
		return

	RegisterSignal(parent, COMSIG_PLANT_HARVESTER, PROC_REF(modify_yield), override = TRUE)
	RegisterSignal(parent, COMSIG_PLANT_PRODUCT_HARVESTED, PROC_REF(mark_produce_quality), override = TRUE)

/datum/component/skill/gardening/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_PLANT_HARVESTER)
	UnregisterSignal(parent, COMSIG_PLANT_PRODUCT_HARVESTED)
	return ..()

/datum/component/skill/gardening/proc/modify_yield(owner, datum/seed/plant, total_yield, cancelled, doafter)
	SIGNAL_HANDLER
	*total_yield = *total_yield + bonus_yield_per_rank * (skill_level - 1)
	*doafter = *doafter - harvest_speedup_per_rank * (skill_level - 1)

/// Marks edible produce harvested by a skilled gardener, so that it can improve the quality of meals cooked with it.
/datum/component/skill/gardening/proc/mark_produce_quality(owner, atom/movable/product, datum/seed/plant)
	SIGNAL_HANDLER
	if (skill_level <= SKILL_LEVEL_UNFAMILIAR || !istype(product, /obj/item/reagent_containers/food/snacks))
		return

	product.AddComponent(/datum/component/grown_produce_quality, skill_level)

/**
 * Attached to produce harvested by a character with the Gardening skill.
 * When this produce is used as an ingredient in a cooking appliance, it improves the quality of the resulting meal.
 * See get_grown_quality_bonus() and apply_cooking_skill_to_food().
 */
/datum/component/grown_produce_quality
	/// The Gardening skill level of the character who harvested this produce.
	var/gardener_skill_level = SKILL_LEVEL_UNFAMILIAR

	/// The text this component appended to the produce's description, so that it can be cleanly removed later.
	var/desc_suffix

/datum/component/grown_produce_quality/Initialize(skill_level = SKILL_LEVEL_UNFAMILIAR)
	. = ..()
	if (!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	gardener_skill_level = skill_level

	switch (gardener_skill_level)
		if (SKILL_LEVEL_FAMILIAR)
			desc_suffix = " It looks well-tended."
		if (SKILL_LEVEL_TRAINED)
			desc_suffix = " It looks carefully cultivated and ripe."
		if (SKILL_LEVEL_PROFESSIONAL to INFINITY)
			desc_suffix = " It looks like a prize-winning specimen, grown with expert care."

	if (desc_suffix)
		var/atom/owner = parent
		owner.desc += desc_suffix

/datum/component/grown_produce_quality/Destroy()
	if (desc_suffix && isatom(parent))
		var/atom/owner = parent
		var/suffix_position = findtext(owner.desc, desc_suffix)
		if (suffix_position)
			owner.desc = copytext(owner.desc, 1, suffix_position) + copytext(owner.desc, suffix_position + length(desc_suffix))

	return ..()

/**
 * Returns the average Gardening rank bonus (skill level above Unfamiliar) across a set of cooking ingredients.
 * Ingredients that weren't grown by a skilled gardener count as zero, so a dish made entirely of
 * expertly grown produce gets the full bonus, while a single expertly grown garnish only contributes a little.
 *
 * * ingredients - The contents of a cooking container. Only food items are considered as ingredients.
 */
/proc/get_grown_quality_bonus(list/ingredients)
	var/ingredient_count = 0
	var/total_bonus = 0
	for (var/obj/item/reagent_containers/food/snacks/ingredient in ingredients)
		ingredient_count++
		var/datum/component/grown_produce_quality/produce_quality = ingredient.GetComponent(/datum/component/grown_produce_quality)
		if (produce_quality)
			total_bonus += produce_quality.gardener_skill_level - SKILL_LEVEL_UNFAMILIAR

	if (!ingredient_count)
		return 0
	return total_bonus / ingredient_count
