/singleton/skill/bartending
	name = "Bartending"
	description = "Users of this skill can create mixed drinks of varying quality, which provide a long lasting morale bonus to anyone who consumes them. This skill is activated by first mixing a drink in a Drink Mixer, then pressing Z to shake it."
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
	description = "Currently unimplemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/everyday
	subcategory = SKILL_SUBCATEGORY_SERVICE
	component_type = COOKING_SKILL_COMPONENT

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
