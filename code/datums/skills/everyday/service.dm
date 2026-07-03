/singleton/skill/bartending
	name = "Bartending"
	description = "Users of this skill can create mixed drinks of varying quality, which provide a long lasting morale bonus to anyone who consumes them. This skill is activated by first mixing a drink in a Drink Mixer, then pressing Z to shake it. Alternatively, drinks can be stirred with a spoon by clicking on a completed drink."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_SERVICE
	component_type = BARTENDING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "Drinks you produce have no effects.",
		SKILL_LEVEL_FAMILIAR = "Drinks you produce are slightly higher quality.",
		SKILL_LEVEL_TRAINED = "Drinks you produce are of moderately higher quality.",
		SKILL_LEVEL_PROFESSIONAL = "Drinks you produce are of a significantly higher quality."
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
		SKILL_LEVEL_FAMILIAR = "You gain +1 produce when harvesting plants",
		SKILL_LEVEL_TRAINED = "You gain +2 produce when harvesting plants",
		SKILL_LEVEL_PROFESSIONAL = "You gain +3 produce when harvesting plants"
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
	description = "Represents a character's ability to resist drugs and alcohol. Higher ranks in this skill slightly improve the filtration effectiveness of the character's liver. " \
		+ "This does nothing for characters that don't have a liver."
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
		SKILL_LEVEL_FAMILIAR = "You gain the \"Offer Blessing\" ability, which provides a small morale bonus to a recipient.",
		SKILL_LEVEL_TRAINED = "You gain the \"Offer Blessing\" ability, which provides a modest morale bonus to a recipient.",
		SKILL_LEVEL_PROFESSIONAL = "You gain the \"Offer Blessing\" ability, which provides a moderate morale bonus to a recipient."
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
		SKILL_LEVEL_FAMILIAR = "You have a passive permanent bonus of +5 morale points.",
		SKILL_LEVEL_TRAINED = "You have a passive permanent bonus of +10 morale points.",
		SKILL_LEVEL_PROFESSIONAL = "You have a passive permanent bonus of +15 morale points."
	)

/singleton/skill/resolve/on_spawn(mob/owner, skill_level)
	var/mob/living/carbon/character = astype(owner)
	if (!character || skill_level == SKILL_LEVEL_UNFAMILIAR || !character.species || !character.species.has_morale)
		return

	// Using LoadComponent here lets me defeat any possible race conditions coming out of character creation.
	// Uniquely among skills, this skill works by modifying a pre-existing component used by player characters, rather than adding its own.
	// If you're a contributor reading up on skills, consider this your tutorial on how to make a skill modify some statistic directly.
	var/datum/component/morale/morale_comp = character.LoadComponent(MORALE_COMPONENT)
	morale_comp.set_phi_value(morale_comp.get_phi_value() + (5 * skill_level))

