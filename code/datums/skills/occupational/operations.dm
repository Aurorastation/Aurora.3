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
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_map = list(
		"Unlicensed" = "You don't know anything about this subject.",
		"Licensed Pilot" = "You have a license to pilot shuttles.",
		"Experienced Pilot" = "You have a decent amount of experience piloting spacecraft.",
		"Ace" = "Insert clever reference here, these dont even appear ingame..."
	)

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
	required = TRUE
