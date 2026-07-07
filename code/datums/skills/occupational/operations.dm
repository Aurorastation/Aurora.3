/singleton/skill/robotics
	name = "Robotics"
	description = "Governs the user's ability to perform surgical procedures on synthetics, as well as the complexity of what procedures can be performed. " \
		+ "A low rank in this skill causes surgery procedures to have a significantly higher chance to fail, while high ranks improve surgical chances. " \
		+ "The more advanced a surgery is, the greater the penalties will be from attempting it unskilled. " \
		+ "Having high ranks in this skill can also help offset the penalties from using non-ideal tools in surgery. " \
		+ "This does not affect \"surgeries\" performed on organics."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	component_type = ROBOTICS_SKILL_COMPONENT
	required = TRUE
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have zero training or experience with synthetics.<br>" \
			+ " - You suffer a large penalty to the chances of successfully performing any surgery on synthetics.",
		SKILL_LEVEL_FAMILIAR = "You have minimal training on the basics of synthetic repair and maintenance. This could be the level of a hobbyist, or someone currently pursuing a degree in robotics.<br>" \
			+ "You can perform the following procedures without penalties: <br>" \
			+ " - Opening or closing external maintenance panels to make superficial repairs.<br>" \
			+ " - Repairing basic damage with a welder or cables.<br>" \
			+ " - Repairing external damage to mechanical limbs.<br>" \
			+ " - Cutting someone out of a hardsuit.",
		SKILL_LEVEL_TRAINED = "You have years of formal training or experience on repairing and maintaining synthetics equivalent to a Bachelor's degree in Robotics.<br>" \
			+ "You can perform the following procedures without penalties:<br>" \
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
			+ "You can perform the following procedures without penalties:<br>" \
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
	uneducated_skill_cap = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "What's a mech?<br>" \
			+ " - You have a 10% chance to move in a wrong direction when controlling mechs.<br>" \
			+ " - It takes you 5 seconds to find the power switch when turning on a mech.",
		SKILL_LEVEL_FAMILIAR = "You have a license to pilot mechs, but are relatively inexperienced.<br>" \
			+ " - You have 0.5 second faster movement delays when Strafing, Reversing, or Turning a mech. This can never let you move faster than a mech's forward speed.",
		SKILL_LEVEL_TRAINED = "You have a decent amount of experience piloting mechs.<br>" \
			+ " - You have 1 second faster movement delays when Strafing, Reversing, or Turning a mech. This can never let you move faster than a mech's forward speed.",
		SKILL_LEVEL_PROFESSIONAL = "Look on the bright side kid, you get to keep all the money.<br>" \
			+ " - You have 1.5 second faster movement delays when Strafing, Reversing, or Turning a mech. This can never let you move faster than a mech's forward speed.",
	)
	required = TRUE
	component_type = PILOT_MECHS_SKILL_COMPONENT

/singleton/skill/conditioning
	name = "Conditioning"
	description = "Governs a character's ability to pick up, drag, and throw heavy objects, particularly crates and people. " \
		+ "By default, most characters can comfortably lift or drag 1.25x their body weight without penalty. " \
		+ "This includes determining how heavy a character you can fireman carry, and with how much slowdown. "
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from your Conditioning.",
		SKILL_LEVEL_FAMILIAR = "Your maximum Lift Capacity is increased by 25%",
		SKILL_LEVEL_TRAINED = "Your maximum Lift Capacity is increased by 50%",
		SKILL_LEVEL_PROFESSIONAL = "Your maximum Lift Capacity is increased by 75%"
	)
	component_type = CONDITIONING_SKILL_COMPONENT
