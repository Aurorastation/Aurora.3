/singleton/skill/unarmed_combat
	name = "Unarmed Combat"
	description = "Unarmed combat represents your training in hand-to-hand combat, or without a weapon."
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

/singleton/skill/unarmed_combat/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(UNARMED_COMBAT_SKILL_COMPONENT, skill_level)

/singleton/skill/armed_combat
	name = "Armed Combat"
	description = "zomboid time"
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE

/singleton/skill/firearms
	name = "Firearms"
	description = "using guns. split this into close arms/longarms/special arms?"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_RANGED
	required = TRUE

/singleton/skill/firearms/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(FIREARMS_SKILL_COMPONENT, skill_level)

/singleton/skill/leadership
	name = "Leadership"
	description = "Leadership skill grants access to a unique 'Inspire' action, which lets you say something inspiring and give the target a positive moodlet."
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_SUPPORT
	required = TRUE
