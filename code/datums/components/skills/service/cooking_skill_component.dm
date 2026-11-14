/datum/component/skill/cooking

/datum/component/skill/cooking/Initialize(level)
	. = ..()
	RegisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS, PROC_REF(modify_butchering), override = TRUE)

/datum/component/skill/cooking/Destroy(force)
	UnregisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS)
	return ..()

/datum/component/skill/cooking/proc/modify_butchering(owner, mob/living/simple_animal/target, base_meat_amount, butchering_bonus)
	SIGNAL_HANDLER
	if (skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	to_chat(owner, SPAN_NOTICE("Your skill with cooking lets you harvest more parts."))
	var/skill_difference = skill_level - SKILL_LEVEL_UNFAMILIAR
	*base_meat_amount = *base_meat_amount + skill_difference
	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*butchering_bonus = *butchering_bonus + skill_difference

/**
 * Applies the effects of the Cooking skill to a freshly prepared food item.
 * The cooking level is passed in directly rather than the skill component itself, because food is cooked
 * asynchronously by appliances, and the cook may no longer exist (or may have walked away) by the time it finishes.
 *
 * * food - The food item that was prepared. Only non-drink food (snacks) is affected.
 * * skill_level - The Cooking skill level of the character who prepared the food.
 */
/proc/apply_cooking_skill_to_food(obj/item/reagent_containers/food/snacks/food, skill_level)
	if (!istype(food) || QDELETED(food) || istype(food, /obj/item/reagent_containers/food/snacks/badrecipe))
		return
	if (!skill_level || skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	var/moodlet_value = COOKING_MOODLET_VALUE_PER_RANK * skill_level
	var/food_quality = rand(1, 20) + 3 * skill_level
	food.AddComponent(/datum/component/food_moodlet_provider, moodlet_value, FALSE, food_quality)

/datum/moodlet/cooked_meal
	moodlet_descriptor = SPAN_GOOD("Ate a skillfully prepared meal.")
	initial_descriptor = SPAN_GOOD("You have gained a morale modifier from eating a skillfully prepared meal.")

/datum/component/food_moodlet_provider
	/// The morale boosting value of the moodlet this food will provide.
	var/moodlet_value = 0

	/// Whether the FoodMoodletProvider is allowed to overwrite stronger moodlets with weaker moodlets.
	var/overwrite_moodlet = FALSE

	/// The randomized quality roll of this food, used to determine its name prefix.
	var/food_quality

	/// The quality prefix this component added to the food's name, so that it can be cleanly removed later.
	var/quality_prefix

/datum/component/food_moodlet_provider/Initialize(value = 5.0, overwrite = FALSE, quality)
	. = ..()
	if (!parent)
		return

	moodlet_value = value
	overwrite_moodlet = overwrite
	food_quality = quality
	RegisterSignal(parent, COMSIG_FOOD_EATEN, PROC_REF(handle_eaten), override = TRUE)

	if (!isatom(parent))
		return

	switch (food_quality)
		if (-INFINITY to 5)
			quality_prefix = "bland "
		if (5 to 10)
			quality_prefix = "passable "
		if (10 to 15)
			quality_prefix = "well-prepared "
		if (15 to 20)
			quality_prefix = "delicious "
		if (20 to INFINITY)
			quality_prefix = "exquisite "

	var/atom/owner = parent
	owner.name = quality_prefix + owner.name

/datum/component/food_moodlet_provider/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_FOOD_EATEN)
	// Food names get modified by further cooking (e.g. "fried"), so strip only our prefix rather than restoring an old name.
	if (quality_prefix && isatom(parent))
		var/atom/owner = parent
		var/prefix_position = findtext(owner.name, quality_prefix)
		if (prefix_position)
			owner.name = copytext(owner.name, 1, prefix_position) + copytext(owner.name, prefix_position + length(quality_prefix))

	return ..()

/// Copies this component onto another food item, such as the slices of a sliced pizza.
/datum/component/food_moodlet_provider/proc/copy_to(atom/target)
	if (!target)
		return
	target.AddComponent(/datum/component/food_moodlet_provider, moodlet_value, overwrite_moodlet, food_quality)

/datum/component/food_moodlet_provider/proc/handle_eaten(obj/item/reagent_containers/food/owner, mob/eater, mob/feeder)
	SIGNAL_HANDLER
	if (QDELING(src) || !eater)
		return

	var/datum/component/morale/morale_comp = eater.GetComponent(MORALE_COMPONENT)
	if (!morale_comp)
		return

	var/datum/moodlet/existing_moodlet = locate(/datum/moodlet/cooked_meal) in morale_comp.moodlets
	if (!overwrite_moodlet && existing_moodlet?.get_morale_modifier() > moodlet_value)
		// Return if they already have a better meal moodlet.
		return

	var/datum/moodlet/new_moodlet = morale_comp.load_moodlet(/datum/moodlet/cooked_meal, moodlet_value)
	new_moodlet.refresh_moodlet() // Reset the duration when they eat it.
