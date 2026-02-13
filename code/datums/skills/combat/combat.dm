/singleton/skill/unarmed_combat
	name = "Unarmed Combat"
	description = "Unarmed combat represents your training in hand-to-hand combat, or without a weapon."
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have rarely, if ever, fought someone in your life. You are likely to crack under pressure, not land punches, and are physically \
								a pushover in a real fight. Being shoved, grabbed, or moved is likely to be very dangerous for you.",
		SKILL_LEVEL_FAMILIAR = "You have some experience throwing punches. You are no stranger to a close-quarters fight, though anyone with real training is likely to \
								overwhelm you. You are not as likely to miss punches, and you are physically less likely to suffer being shoved, grabbed, or moved.",
		SKILL_LEVEL_TRAINED = "You have been trained, whether by being in the military, taking close-quarters-combat classes or simply through experience, to both keep \
							calm in a close-quarters fight and also fight well. You suffer no maluses to your close-quarters combat.",
	)
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE

/singleton/skill/armed_combat
	name = "Armed Combat"
	description = "zomboid time"
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE

/singleton/skill/firearms
	name = "Firearms"
	description = "using guns. split this into close arms/longarms/special arms?"
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_RANGED
	required = TRUE

/singleton/skill/firearms/on_spawn(var/mob/owner, var/level)
	if (!owner)
		return

	owner.AddComponent(FIREARMS_SKILL_COMPONENT, level)
