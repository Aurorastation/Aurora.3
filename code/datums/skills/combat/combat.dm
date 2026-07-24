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
	maximum_level = SKILL_LEVEL_TRAINED
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have rarely, if ever, fought someone in your life.<br>" \
			+ " - You are 4% more likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are 4% less likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are 4% more likely to block your unarmed attacks.",
		SKILL_LEVEL_FAMILIAR = "You have some experience throwing punches. You are no stranger to a close-quarters fight, though anyone with real training is likely to overwhelm you.<br>" \
			+ " - You are 2% more likely to miss when attempting to punch anywhere not the torso.<br>" \
			+ " - You are 2% less likely to block unarmed attacks that you are aware of.<br>" \
			+ " - Enemies are 2% more likely to block your unarmed attacks.",
		SKILL_LEVEL_TRAINED = "You have been trained, whether by being in the military, taking close-quarters-combat classes or simply through experience, to both keep calm in a close-quarters fight and also fight well.<br>" \
			+ " - You suffer no maluses to your close-quarters combat. <br>" \
			+ " - You have no bonuses to unarmed fighting either."
	)
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	required = TRUE
	component_type = UNARMED_COMBAT_SKILL_COMPONENT

/// Currently just a simple percent modifier to melee weapon damage. -20% at rank 1, -10% at rank 2, 0% at rank 3, +10% at rank 4.
/singleton/skill/armed_combat
	name = "Armed Combat"
	description = "Armed Combat influences your effectiveness when fighting with any melee weapon. Having low ranks in this skill slightly decreases damage dealt with melee weapons, while higher ranks can slightly increase it."
	maximum_level = SKILL_LEVEL_TRAINED
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	component_type = ARMED_COMBAT_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no training or experience with armed combat.<br>" \
			+ " - Your melee attacks deal 20% less damage.",
		SKILL_LEVEL_FAMILIAR = "You some experience with armed fighting.<br>" \
			+ " - Your melee attacks deal 10% less damage.",
		SKILL_LEVEL_TRAINED = "You have both training and actual experience with armed combat, equivalent to several years of armed martial arts instruction.<br>" \
			+ " - Your melee attacks have no damage modifier from this skill." \
	)

/singleton/skill/firearms
	name = "Firearms"
	description = "Firearms represents your training in using all forms of ranged weapons. Having a high rank in in this skill provides bonuses to accuracy when shooting."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_RANGED
	required = TRUE
	component_type = FIREARMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little-to-no knowledge of how firearms work at all, and need to stabilize or practice for accuracy.<br>" \
			+ " - Firearms you shoot have a <b>60 degree</b> spread-angle increase, making them very inaccurate.<br>" \
			+ " - Firearms you shoot count as <b>1 tile further</b> from the target.<br>" \
			+ " - You staying still for <b>1.5 seconds</b> after entering a tile with a gun in your active hand stabilizes it for one penalty-free shot.<br>" \
			+ " - You steady yourself after every <b>five shots</b>, making the next non-stabilized one penalty-free.<br>" \
			+ " - You have a <b>30% chance</b> of fumbling to find and switch the safety, toggle firing mode, or use a scope (<b>which can also hurt your eye</b>)." \
			+ " - You're warmed up for <b>10 minutes</b> after firing 18 shots, gaining a 30% chance of firing penalty-free and +3 morale points. This can stack a second time for no fumbling, a 40% chance, double the duration, and <b>+4</b> morale points.<br>",
		SKILL_LEVEL_FAMILIAR = "You have fired a gun once or twice in your life, but are by no means fully trained. At least you know how to not shoot yourself in the foot or get scope-eye.<br>" \
			+ " - Firearms you shoot have a <b>30 degree</b> spread-angle increase, making them somewhat less accurate.<br>" \
			+ " - Firearms you shoot count as <b>0.5 tiles further</b> from the target.<br>" \
			+ " - You staying still for <b>1.25 seconds</b> after entering a tile with a gun in your active hand stabilizes it for one penalty-free shot.<br>" \
			+ " - You steady yourself after every <b>three shots</b>, making the next non-stabilized one penalty-free.<br>" \
			+ " - You have a <b>15% chance</b> of fumbling to find and switch the safety, toggle firing mode, or use a scope.<br>" \
			+ " - You're warmed up for <b>15 minutes</b> after firing 18 shots, gaining a <b>30% chance</b> of firing penalty-free and +3 morale points. This can stack a second time for a <b>40% chance</b>, double the duration, and <b>+5</b> morale points.<br>",
		SKILL_LEVEL_TRAINED = "You have both training and actual experience with firearms. Equivalent to a few years of experience in roles such as military, police, or armed security.<br>" \
			+ " - You suffer no skill penalties to firearms use and have no need to stabilize or steady shots.<br>" \
			+ " - You're warmed up for <b>20 minutes</b> after firing 18 shots, gaining +3 morale points. This can stack a second time for double the duration and <b>+6</b> morale points.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of experience with firearms, potentially even in actual combat. Retired special forces, police marksmen, and hardened mercenaries fall under this category.<br>" \
			+ " - Firearms you shoot have a <b>30 degree</b> spread-angle <i>decrease</i>, making them somewhat more accurate. This generally doesn't apply to weapons fired in semi-auto, but will make burst and automatic fire more manageable.<br>" \
			+ " - Firearms you shoot count as <b>0.5 tiles closer</b> to the target.<br>" \
			+ " - You staying still for <b>1 second</b> after entering a tile with a gun in your active hand stabilizes it for one shot with boosted accuracy, equivalent to being <b>1 tile closer</b>.<br>" \
			+ " - You're warmed up for <b>25 minutes</b> after firing 18 shots, gaining a <b>30% chance</b> of firing with boosted accuracy and +3 morale points. This can stack a second time for a <b>40% chance</b>, double the duration, and <b>+7</b> morale points."
	)

/singleton/skill/leadership
	name = "Leadership"
	description = "Leadership represents a characters skill with inspiring others. Having ranks in this skill grants access to the \"Deliver Speech\" action. Which can be used to give a morale modifier either in an area, or to a single person. " \
		+ "Additional ranks increase the morale modifier provided."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_SUPPORT
	component_type = LEADERSHIP_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no skill with motivational speeches.",
		SKILL_LEVEL_FAMILIAR = "You gain the \"Deliver Speech\" ability, which provides a bonus of +3.333 morale points to recipients that lasts for 15 minutes.",
		SKILL_LEVEL_TRAINED = "You gain the \"Deliver Speech\" ability, which provides a bonus of +6.666 morale points to recipients that lasts for 15 minutes.",
		SKILL_LEVEL_PROFESSIONAL = "You gain the \"Deliver Speech\" ability, which provides a bonus of +10 morale points to recipients that lasts for 15 minutes."
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 1,
		SKILL_LEVEL_TRAINED = 2,
		SKILL_LEVEL_PROFESSIONAL = 4
	)

/singleton/skill/tenacity
	name = "Tenacity"
	description = "Tenacity represents a character's \"Will to Live\". It affects a character's ability to cling to life when in critical condition, effectively allowing them to live for a little bit longer before medics can reach them. " \
		+ "It does not affect a character's overall toughness and difficulty to take down in a fight, only how much time they have to be saved when they do go down.<br>" \
		+ "This skill does nothing for characters that do not have a heart."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_SUPPORT
	component_type = TENACITY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from Tenacity.",
		SKILL_LEVEL_FAMILIAR = "You take slightly longer to die while in critical condition.<br>" \
			+ " - Your 'minimum heart efficiency' when in asystole is increased by 10%.<br>" \
			+ " - Your blood volume is counted as being +1.25% higher for the purpose of dying thresholds.<br>" \
			+ " - Your heart is 5% more effective at pumping blood.<br>" \
			+ " - You bleed out 7.5% slower from (non-arterial) wounds.<br>" \
			+ " - You bleed out 3.75% slower from severed arteries.",
		SKILL_LEVEL_TRAINED = "You take a little bit longer to die while in critical condition. <br>" \
			+ " - Your 'minimum heart efficiency' when in asystole is increased by 20%.<br>" \
			+ " - Your blood volume is counted as being +2.5% higher for the purpose of dying thresholds.<br>" \
			+ " - Your heart is 10% more effective at pumping blood.<br>" \
			+ " - You bleed out 15% slower from (non-arterial) wounds.<br>" \
			+ " - You bleed out 7.5% slower from severed arteries.",
		SKILL_LEVEL_PROFESSIONAL = "You take longer to die while in critical condition.<br>"\
			+ " - Your 'minimum heart efficiency' when in asystole is increased by 30%.<br>" \
			+ " - Your blood volume is counted as being +3.75% higher for the purpose of dying thresholds.<br>" \
			+ " - Your heart is 15% more effective at pumping blood.<br>" \
			+ " - You bleed out 22.5% slower from (non-arterial) wounds.<br>" \
			+ " - You bleed out 11.25% slower from severed arteries.",
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 1,
		SKILL_LEVEL_TRAINED = 2,
		SKILL_LEVEL_PROFESSIONAL = 4
	)
