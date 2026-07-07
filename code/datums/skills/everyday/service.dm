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
		SKILL_LEVEL_FAMILIAR = "You gain the \"Offer Blessing\" ability, which provides a +3.333 morale bonus to a recipient that lasts for 2 hours.",
		SKILL_LEVEL_TRAINED = "You gain the \"Offer Blessing\" ability, which provides a +6.666 morale bonus to a recipient that lasts for 2 hours.",
		SKILL_LEVEL_PROFESSIONAL = "You gain the \"Offer Blessing\" ability, which provides a +10 morale bonus to a recipient that lasts for 2 hours."
	)
