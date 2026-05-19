/*
	All of the combat skills in this file are meant to be presented to the players as a "Bonus" to certain aspects of combat. However,
	factually they are actually a penalty to combat skills for anyone not in Security. This lets us have better balancing levers against antags,
	giving non-security leeway in being allowed to fight antags since they will be mechanically far weaker than actual security. Players can then be encouraged,
	rather than discouraged from picking a rifle up off the floor to fight mercs, since they get hit with a huge accuracy penalty when using it for not being security.

	Players are much happier anyways if you tell them something provides a bonus if they invest in it, even if the baseline before the bonus was less than what they had before.
	A lot like the "Rested Experience Effect" in video game design.

	As a general rule of thumb, having rank 3 in a combat skill is equivalent to "Vanilla" stats. No penalties, no bonuses.
	Rank 1 and 2 give penalties to combat characteristics. Rank 4; which isn't accessible to crew and will come in a later PR via implants/modifiers,
	instead provides a bonus to combat characteristics. All 3 combat skills and their relevant checks are also influenced by the Morale component,
	which provides up to an equivalent +/- 0.5 ranks in combat skills depending on how much positive or negative morale has been accumulated.
																																				*/
/singleton/skill/unarmed_combat
	name = "Unarmed Combat"
	description = "Unarmed combat represents your training in hand-to-hand combat, or without a weapon. It also influences your ability to resist actions like disarms or martial arts. " \
		+ "Higher ranks in Unarmed Combat provide bonuses when attacking with your fists, as well as bonuses to defending against others unarmed attacks and disarms."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have rarely, if ever, fought someone in your life.<br>" \
			+ " - You are more likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are less likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are more likely to block your unarmed attacks.",
		SKILL_LEVEL_FAMILIAR = "You have some experience throwing punches. You are no stranger to a close-quarters fight, though anyone with real training is likely to overwhelm you.<br>" \
			+ " - You are slightly more likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are slightly less likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are slightly more likely to block your unarmed attacks.",
		SKILL_LEVEL_TRAINED = "You have been trained, whether by being in the military, taking close-quarters-combat classes or simply through experience, to both keep calm in a close-quarters fight and also fight well.<br>" \
			+ " - You suffer no maluses to your close-quarters combat. <br>" \
			+ " - You have no bonuses to unarmed fighting either.",
		SKILL_LEVEL_PROFESSIONAL = "You have had many years of martial arts experience. Probably having a Black Belt equivalent in one or more martial arts.<br>" \
			+ " - You are slightly less likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are slightly more likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are slightly less likely to block your unarmed attacks.",
	)
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	required = TRUE
	component_type = UNARMED_COMBAT_SKILL_COMPONENT

/// Currently just a simple percent modifier to melee weapon damage. -20% at rank 1, -10% at rank 2, 0% at rank 3, +10% at rank 4.
/singleton/skill/armed_combat
	name = "Armed Combat"
	description = "Armed Combat influences your effectiveness when fighting with any melee weapon. Having low ranks in this skill slightly decreases damage dealt with melee weapons, while higher ranks can slightly increase it."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	component_type = ARMED_COMBAT_SKILL_COMPONENT

/singleton/skill/firearms
	name = "Firearms"
	description = "Firearms represents your training in using all forms of ranged weapons. Having a high rank in in this skill provides bonuses to accuracy when shooting."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_RANGED
	required = TRUE
	component_type = FIREARMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no knowledge of how firearms work at all.<br>" \
			+ " - Firearms you shoot have a 60 degree spread-angle increase, making them very inaccurate.<br>" \
			+ " - You have a decent chance of failing to find the safety when attempting to switch it on or off.",
		SKILL_LEVEL_FAMILIAR = "You have fired a gun once or twice in your life, but are by no means fully trained. At least you know how to not shoot yourself in the foot or get scope-eye.<br>" \
			+ " - Firearms you shoot have a 30 degree spread-angle increase, making them somewhat less accurate.",
		SKILL_LEVEL_TRAINED = "You have both training and actual experience with firearms. Equivalent to a few years of experience in roles such as military, police, or armed security.<br>" \
			+ " - You suffer no maluses to firearms use. <br>" \
			+ " - You have no bonuses to firearms use either.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of experience with firearms, potentially even in actual combat. Retired special forces, police marksmen, and hardened mercenaries fall under this category.<br>" \
			+ " - Firearms you shoot have a 30 degree spread-angle decrease, making them somewhat more accurate. This generally doesn't apply to weapons fired in semi-auto, but will make burst and automatic fire more manageable." \
	)

// Temporarily commented because this is a little too complicated to catch in the initial release.
// /singleton/skill/leadership
// 	name = "Leadership"
// 	description = "Leadership skill grants access to a unique 'Inspire' action, which lets you say something inspiring and give the target a positive moodlet."
// 	category = /singleton/skill_category/combat
// 	subcategory = SKILL_SUBCATEGORY_SUPPORT
// 	required = TRUE
// 	component_type = LEADERSHIP_SKILL_COMPONENT

/singleton/skill/tenacity
	name = "Tenacity"
	description = "Tenacity represents a character's \"Will to Live\". It affects a character's ability to cling to life when in critical condition, effectively allowing them to live for a little bit longer before medics can reach them. " \
		+ "It does not affect a character's overall toughness and difficulty to take down in a fight, only how much time they have to be saved when they do go down. "
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_SUPPORT
	component_type = TENACITY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from Tenacity.",
		SKILL_LEVEL_FAMILIAR = "You take slightly longer to die while in critical condition.",
		SKILL_LEVEL_TRAINED = "You take a little bit longer to die while in critical condition.",
		SKILL_LEVEL_PROFESSIONAL = "You take longer to die while in critical condition."
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 1,
		SKILL_LEVEL_TRAINED = 2,
		SKILL_LEVEL_PROFESSIONAL = 4
	)
