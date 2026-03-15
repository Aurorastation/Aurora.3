/singleton/skill/unarmed_combat
	name = "Unarmed Combat"
	description = "Unarmed combat represents your training in hand-to-hand combat, or without a weapon. It also influences your ability to resist actions like disarms or martial arts."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	skill_level_map = list(
		"Untrained",
		"Dabbling",
		"Trained",
		"Black Belt"
	)
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have rarely, if ever, fought someone in your life.<br>" \
			+ " - You are 10% more likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are 10% less likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are 10% more likely to block your unarmed attacks.",
		SKILL_LEVEL_FAMILIAR = "You have some experience throwing punches. You are no stranger to a close-quarters fight, though anyone with real training is likely to overwhelm you.<br>" \
			+ " - You are 5% more likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are 5% less likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are 5% more likely to block your unarmed attacks.",
		SKILL_LEVEL_TRAINED = "You have been trained, whether by being in the military, taking close-quarters-combat classes or simply through experience, to both keep calm in a close-quarters fight and also fight well.<br>" \
			+ " - You suffer no maluses to your close-quarters combat. <br>" \
			+ " - You have no bonuses to unarmed fighting either.",
		SKILL_LEVEL_PROFESSIONAL = "You have had many years of martial arts experience. Probably having a Black Belt equivalent in one or more martial arts.<br>" \
			+ " - You are 5% less likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are 5% more likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are 5% less likely to block your unarmed attacks.",
	)
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	required = TRUE
	component_type = UNARMED_COMBAT_SKILL_COMPONENT

/singleton/skill/armed_combat
	name = "Armed Combat"
	description = "Armed Combat influences your effectiveness when fighting with any melee weapon."
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	component_type = ARMED_COMBAT_SKILL_COMPONENT

/singleton/skill/firearms
	name = "Firearms"
	description = "Firearms influences your ability to handle firearms"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_RANGED
	required = TRUE
	component_type = FIREARMS_SKILL_COMPONENT
	skill_level_map = list(
		"Untrained",
		"Dabbling",
		"Trained",
		"Gunslinger"
	)
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no knowledge of how firearms work at all.<br>" \
			+ " - You have a 1% chance to shoot yourself in the foot when using a firearm.<br>" \
			+ " - Firearms you shoot have a 30 degree spread-angle increase, making them very inaccurate.<br>" \
			+ " - You have a decent chance of failing to find the safety when attempting to switch it on or off.",
		SKILL_LEVEL_FAMILIAR = "You have fired a gun once or twice in your life, but are by no means fully trained. At least you know how to not shoot yourself in the foot or get scope-eye.<br>" \
			+ " - Firearms you shoot have a 15 degree spread-angle increase, making them somewhat less accurate.",
		SKILL_LEVEL_TRAINED = "You have both training and actual experience with firearms. Equivalent to a few years of experience in roles such as military, police, or armed security.<br>" \
			+ " - You suffer no maluses to firearms use. <br>" \
			+ " - You have no bonuses to firearms use either.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of experience with firearms, potentially even in actual combat. Retired special forces, police marksmen, and hardened mercenaries fall under this category.<br>" \
			+ " - Firearms you shoot have a 15 degree spread-angle decrease, making them somewhat more accurate. This generally doesn't apply to weapons fired in semi-auto, but will make burst and automatic fire more manageable." \
	)

// Temporarily commented because this is a little too complicated to catch in the initial release.
// /singleton/skill/leadership
// 	name = "Leadership"
// 	description = "Leadership skill grants access to a unique 'Inspire' action, which lets you say something inspiring and give the target a positive moodlet."
// 	category = /singleton/skill_category/combat
// 	subcategory = SKILL_SUBCATEGORY_SUPPORT
// 	required = TRUE
// 	component_type = LEADERSHIP_SKILL_COMPONENT

