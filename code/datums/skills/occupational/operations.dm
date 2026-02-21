/singleton/skill/robotics
	name = "Robotics"
	description = "Skill for the machinist"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS

/singleton/skill/pilot_spacecraft
	name = "Pilot: Spacecraft"
	description = "Skill for piloting space ships."
	maximum_level = SKILL_LEVEL_FAMILIAR
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_map = list(
		"Unlicensed" = "You don't know anything about this subject.",
		"Licensed Pilot" = "You have a license to pilot shuttles."
	)
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You are incapable of piloting spacecraft.",
		SKILL_LEVEL_FAMILIAR = "You are capable of piloting spacecraft."
	)
	required = TRUE

/singleton/skill/pilot_spacecraft/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(PILOT_SPACECRAFT_SKILL_COMPONENT, skill_level)

/singleton/skill/pilot_mechs
	name = "Pilot: Exosuits"
	description = "Skill for piloting exosuits."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_map = list(
		"Unlicensed" = "What's a mech?",
		"Licensed Pilot" = "You have a license to pilot mechs, but are relatively inexperienced.",
		"Experienced Pilot" = "You have a decent amount of experience piloting mechs.",
		"Mechwarrior" = "Look on the bright side kid, you get to keep all the money."
	)
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "What's a mech?<br>" \
			+ " - You have a 10% chance to move in a wrong direction when controlling mechs.<br>" \
			+ " - Mech handling characteristics such as strafing and reverse speeds are significantly worse for you.<br>" \
			+ " - It takes you awhile to find the power switch in a mech.",
		SKILL_LEVEL_FAMILIAR = "You have a license to pilot mechs, but are relatively inexperienced.<br>" \
			+ " - You have a small penalty to mech handling characteristics, such as slightly slower strafe and reverse speeds.",
		SKILL_LEVEL_TRAINED = "You have a decent amount of experience piloting mechs.<br>" \
			+ " - You have no penalties or bonuses for piloting mechs.",
		SKILL_LEVEL_PROFESSIONAL = "Look on the bright side kid, you get to keep all the money.<br>" \
			+ " - You have a small bonus to mech handling characteristics. Turning, Strafing, and Reverse speeds are all improved when piloting mechs. Forward speeds are still unchanged."
	)
	required = TRUE

/singleton/skill/pilot_mechs/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(PILOT_MECHS_SKILL_COMPONENT, skill_level)
