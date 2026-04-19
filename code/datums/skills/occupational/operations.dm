/singleton/skill/robotics
	name = "Robotics"
	description = "Governs the user's ability to perform surgical procedures on synthetics, as well as the complexity of what procedures can be performed."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	component_type = ROBOTICS_SKILL_COMPONENT
	required = TRUE
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have zero training or experience with synthetics.<br>" \
			+ " - You cannot perform any surgical procedures on synthetics.",
		SKILL_LEVEL_FAMILIAR = "You have minimal training on the basics of synthetic repair and maintenance. This could be the level of a hobbyist, or someone currently pursuing a degree in robotics.<br>" \
			+ "You can perform the following procedures: <br>" \
			+ " - Opening or closing external maintenance panels to make superficial repairs.<br>" \
			+ " - Repairing basic damage with a welder or cables.<br>" \
			+ " - Repairing external damage to mechanical limbs.<br>" \
			+ " - Cutting someone out of a hardsuit.",
		SKILL_LEVEL_TRAINED = "You have years of formal training or experience on repairing and maintaining synthetics equivalent to a Bachelor's degree in Robotics.<br>" \
			+ "You can perform the following procedures:<br>" \
			+ " - Opening or closing external maintenance panels to make superficial repairs.<br>" \
			+ " - Repairing basic damage with a welder or cables.<br>" \
			+ " - Repairing external damage to mechanical limbs.<br>" \
			+ " - Cutting someone out of a hardsuit." \
			+ " - Fully opening or closing mechanical parts to access internal systems, allowing repairs to any amount of damage.<br>" \
			+ " - Repairing, removing, or adding mechanical organs.<br>" \
			+ " - Facial Reconstructions performed on Shell IPCs.<br>" \
			+ " - Attaching mechanical limbs (including to organics).<br>" \
			+ " - Re-attach (organic) limbs. Robotic limbs require the Robotics skill instead.<br>" \
			+ " - Perform all forms of internal repairs to IPCs.<br>" \
			+ " - Prepare an MMI for cyborgification.",
		SKILL_LEVEL_PROFESSIONAL = "Not currently implemented, functions exactly as per Trained.<br>" \
			+ "You can perform the following procedures:<br>" \
			+ " - Opening or closing external maintenance panels to make superficial repairs.<br>" \
			+ " - Repairing basic damage with a welder or cables.<br>" \
			+ " - Repairing external damage to mechanical limbs.<br>" \
			+ " - Cutting someone out of a hardsuit." \
			+ " - Fully opening or closing mechanical parts to access internal systems, allowing repairs to any amount of damage.<br>" \
			+ " - Repairing, removing, or adding mechanical organs.<br>" \
			+ " - Facial Reconstructions performed on Shell IPCs.<br>" \
			+ " - Attaching mechanical limbs (including to organics).<br>" \
			+ " - Re-attach (organic) limbs. Robotic limbs require the Robotics skill instead.<br>" \
			+ " - Perform all forms of internal repairs to IPCs.<br>" \
			+ " - Prepare an MMI for cyborgification."
	)

/singleton/skill/pilot_spacecraft
	name = "Pilot: Spacecraft"
	description = "Governs the user's ability to pilot spacecraft of any size, and is required to do so in the first place."
	maximum_level = SKILL_LEVEL_FAMILIAR
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_map = list(
		"Unlicensed",
		"Licensed Pilot"
	)
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You are incapable of piloting spacecraft.",
		SKILL_LEVEL_FAMILIAR = "You are capable of piloting spacecraft."
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 6
	)
	required = TRUE
	component_type = PILOT_SPACECRAFT_SKILL_COMPONENT

/singleton/skill/pilot_mechs
	name = "Pilot: Exosuits"
	description = "Governs the user's ability to pilot mechs of any kind."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
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
	component_type = PILOT_MECHS_SKILL_COMPONENT
