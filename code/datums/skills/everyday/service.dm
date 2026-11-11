/singleton/skill/bartending
	name = "Bartending"
	description = "Users of this skill can create mixed drinks of varying quality, which provide a long lasting morale bonus to anyone who consumes them. " \
		+ "This skill is activated by first mixing a drink in a Drink Mixer, then pressing Z to shake it. " \
		+ "Alternatively, drinks can be stirred with a spoon by clicking on a completed drink."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_SERVICE
	component_type = BARTENDING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "Drinks you produce have no effects.",
		SKILL_LEVEL_FAMILIAR = "Drinks you produce provide a +10 morale modifier that lasts for 2 hours.",
		SKILL_LEVEL_TRAINED = "Drinks you produce provide a +15 morale modifier that lasts for 2 hours.",
		SKILL_LEVEL_PROFESSIONAL = "Drinks you produce provide a +20 morale modifier that lasts for 2 hours."
	)

/singleton/skill/cooking
	name = "Cooking"
	description = "Users of this skill gain bonuses when harvesting parts from animals."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_SERVICE
	component_type = COOKING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from cooking.",
		SKILL_LEVEL_FAMILIAR = "You gain +1 product when butchering any animal",
		SKILL_LEVEL_TRAINED = "You gain +2 products when butchering any animal",
		SKILL_LEVEL_PROFESSIONAL = "You gain +3 products when butchering any animal"
	)

/singleton/skill/gardening
	name = "Gardening"
	description = "Users of this skill gain bonuses when harvesting grown plants."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_SERVICE
	component_type = GARDENING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers to gardening.",
		SKILL_LEVEL_FAMILIAR = \
			" - You gain +1 produce when harvesting plants.<br>" \
			+ " - You harvest plants 0.3333 seconds faster",
		SKILL_LEVEL_TRAINED = \
			" - You gain +2 produce when harvesting plants.<br>" \
			+ " - You harvest plants 0.6666 seconds faster",
		SKILL_LEVEL_PROFESSIONAL = \
			" - You gain +3 produce when harvesting plants.<br>" \
			+ " - You harvest plants 1 second faster."
	)

// Temporarily commented because this is a little too complicated to catch in the initial PR release.
// /singleton/skill/entertaining
// 	name = "Entertaining"
// 	description = "Entertainers are able to generate positive moodlets by playing instruments."
// 	maximum_level = SKILL_LEVEL_PROFESSIONAL
// 	category =  /singleton/skill_category/everyday
// 	subcategory = SKILL_SUBCATEGORY_SERVICE
// 	component_type = ENTERTAINING_SKILL_COMPONENT

/singleton/skill/carousing
	name = "Carousing"
	/// Alternate displayed name when configuring an IPC character.
	var/ipc_name = "Thermal Conditioning"
	description = "Represents a character's ability to resist drugs and alcohol. Higher ranks in this skill slightly improve the filtration effectiveness of the character's liver. " \
		+ "This does nothing for organic characters that don't have a liver."
	/// Alternate general description displayed when configuring an IPC character.
	var/ipc_description = "Represents a synthetic's thermal management optimization and heat-tolerance tuning. Higher ranks in this skill improve the efficiency of the chassis's cooling unit, reduce its power draw, and raise the safe operating temperature threshold before sprint safeties engage."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_PHYSICAL
	component_type = CAROUSING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers to drinking or doing drugs.",
		SKILL_LEVEL_FAMILIAR = "Your liver is 5% more effective at filtering drugs and alcohol.",
		SKILL_LEVEL_TRAINED = "Your liver is 10% more effective at filtering drugs and alcohol.",
		SKILL_LEVEL_PROFESSIONAL = "Your liver is 15% more effective at filtering drugs and alcohol."
	)
	/// Alternate skill level descriptions displayed when configuring an IPC character.
	var/alist/ipc_skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from Thermal Conditioning.",
		SKILL_LEVEL_FAMILIAR = "Your cooling unit is slightly better tuned for sustained operation.<br>" \
			+ " - Your cooling unit's passive temperature regulation rate is increased by 5%.<br>" \
			+ " - Your cooling unit's base power consumption is reduced by 5%.<br>" \
			+ " - Your maximum safe sprinting temperature threshold is increased by 10°C.",
		SKILL_LEVEL_TRAINED = "Your cooling unit is moderately better tuned for sustained operation.<br>" \
			+ " - Your cooling unit's passive temperature regulation rate is increased by 10%.<br>" \
			+ " - Your cooling unit's base power consumption is reduced by 10%.<br>" \
			+ " - Your maximum safe sprinting temperature threshold is increased by 20°C.",
		SKILL_LEVEL_PROFESSIONAL = "Your cooling unit is well tuned for sustained operation.<br>" \
			+ " - Your cooling unit's passive temperature regulation rate is increased by 15%.<br>" \
			+ " - Your cooling unit's base power consumption is reduced by 15%.<br>" \
			+ " - Your maximum safe sprinting temperature threshold is increased by 30°C."
	)
	/// Multiplier bonus to an IPC's cooling unit passive temperature change per rank above Unfamiliar.
	var/ipc_bonus_cooling_efficiency_per_rank = 0.05
	/// Multiplier reduction to an IPC's cooling unit base power consumption per rank above Unfamiliar.
	var/ipc_bonus_power_reduction_per_rank = 0.05
	/// Flat Kelvin/Celsius bonus to an IPC's cooling unit maximum safe sprinting temperature per rank above Unfamiliar.
	var/ipc_bonus_safe_temp_per_rank = 10

/singleton/skill/carousing/get_name(datum/preferences/pref)
	var/datum/species/species = GLOB.all_species[pref?.species]
	if(species && (species.flags & IS_MECHANICAL))
		return ipc_name
	return ..()

/singleton/skill/carousing/get_description(datum/preferences/pref)
	var/datum/species/species = GLOB.all_species[pref?.species]
	if(species && (species.flags & IS_MECHANICAL))
		return ipc_description
	return ..()

/singleton/skill/carousing/get_skill_level_descriptions(datum/preferences/pref)
	var/datum/species/species = GLOB.all_species[pref?.species]
	if(species && (species.flags & IS_MECHANICAL))
		return ipc_skill_level_descriptions
	return ..()

/singleton/skill/carousing/on_spawn(mob/owner, skill_level)
	if(!isipc(owner))
		return ..()

	var/mob/living/carbon/human/character = owner
	if(!istype(character))
		return

	var/obj/item/organ/internal/machine/cooling_unit/cooling_unit = character.internal_organs_by_name[BP_COOLING_UNIT]
	if(!istype(cooling_unit))
		return

	var/offset_skill = max(skill_level - 1, 0)
	var/singleton/synthetic_organ_preset/cooling_unit/preset = cooling_unit.current_preset
	var/base_temp_change = istype(preset) ? preset.passive_temp_change : initial(cooling_unit.passive_temp_change)
	var/base_power = istype(preset) ? preset.base_power_consumption : initial(cooling_unit.base_power_consumption)

	cooling_unit.passive_temp_change = base_temp_change * (1 + (ipc_bonus_cooling_efficiency_per_rank * offset_skill))
	cooling_unit.base_power_consumption = base_power * (1 - (ipc_bonus_power_reduction_per_rank * offset_skill))
	cooling_unit.maximum_safe_temperature = initial(cooling_unit.maximum_safe_temperature) + (ipc_bonus_safe_temp_per_rank * offset_skill)

/singleton/skill/ministry
	name = "Ministry"
	description = "Represents a characters training in religious counseling. Having ranks in this skill unlocks the \"Offer Blessing\" ability, which offers a small morale modifier to an adjacent character. " \
		+ "Additional ranks increase the morale modifier, which is empowered further if the recipient shares a religion with you."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_SERVICE
	component_type = MINISTRY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no training in religious counseling.",
		SKILL_LEVEL_FAMILIAR = "You gain the \"Offer Blessing\" ability, which provides a +3.333 morale bonus to a recipient that lasts for 2 hours.",
		SKILL_LEVEL_TRAINED = "You gain the \"Offer Blessing\" ability, which provides a +6.666 morale bonus to a recipient that lasts for 2 hours.",
		SKILL_LEVEL_PROFESSIONAL = "You gain the \"Offer Blessing\" ability, which provides a +10 morale bonus to a recipient that lasts for 2 hours."
	)

/singleton/skill/resolve
	name = "Resolve"
	description = "Represents a character's mental resilience, emotional stability, and ability to remain steadfast under stress. " \
		+ "Characters with greater Resolve receive a permanent passive bonus to their effective morale value. This can provide small bonuses to a variety of interactions. " \
		+ "This morale bonus can also act as a pool of resistance towards psychic damage. " \
		+ "This skill has no effect for species which do not interact with Morale."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_PHYSICAL
	component_type = null // No component, this skill is flexing the ECS hook in a different way entirely.
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from Resolve.",
		SKILL_LEVEL_FAMILIAR = "You have a passive permanent bonus of +3 morale points.",
		SKILL_LEVEL_TRAINED = "You have a passive permanent bonus of +6 morale points.",
		SKILL_LEVEL_PROFESSIONAL = "You have a passive permanent bonus of +9 morale points."
	)

/singleton/skill/resolve/on_spawn(mob/owner, skill_level)
	var/mob/living/carbon/character = astype(owner)
	if (!character || skill_level == SKILL_LEVEL_UNFAMILIAR || !character.species || !character.species.has_morale)
		return

	// Using LoadComponent here lets me defeat any possible race conditions coming out of character creation.
	// Uniquely among skills, this skill works by modifying a pre-existing component used by player characters, rather than adding its own.
	// If you're a contributor reading up on skills, consider this your tutorial on how to make a skill modify some statistic directly.
	var/datum/component/morale/morale_comp = character.LoadComponent(MORALE_COMPONENT)
	morale_comp.set_phi_value(morale_comp.get_phi_value() + (3 * (skill_level - 1)))

