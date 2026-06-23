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
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_OPERATIONS
	skill_level_map = list(
		"Unlicensed",
		"Shuttle Pilot",
		"Class II Pilot",
		"Class IV Pilot"
	)
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You are inexperienced and mostly incapable of piloting spacecraft, but may attempt piloting shuttles in emergencies.<br>" \
		+ "- There is only a <b>70%</b> chance you will be able to view the consoles after several seconds waiting.<br>" \
		+ "- Accelerations and Slows take <b>2</b> seconds to peform.<br>" \
		+ "  - Additional 65% chance to accelerate further.<br>" \
		+ "  - Additional 60% and <b>70%</b> chances to slow further.<br>" \
		+ "- Turns take <b>3</b> seconds to perform and have a <b>60%</b> chance to continue in the given direction.<br>" \
		+ "- Rolls have a 60% chance to move north/south, and a <b>70%</b> chance afterwards to go further in it.",
		SKILL_LEVEL_FAMILIAR = "You are capable of piloting shuttlecraft.<br>" \
		+ "- You may attempt piloting ships a level higher with mild penalties:<br>" \
		+ "- Accelerations and Slows take <b>1</b> second to perform.<br>" \
		+ "  - Additional 65% chance to accelerate further.<br>" \
		+ "  - Additional 60% chance to slow further.<br>" \
		+ "- Turns take <b>1</b> second to perform.<br>" \
		+ "- Rolls have a 60% chance to move north/south.",
		SKILL_LEVEL_TRAINED = "You are capable of piloting up to Class II ships, which are often unable to land or dock.<br>" \
		+ "- Class II includes all other ships movable on the overmap...with one major exception.<br>" \
		+ "- You may attempt piloting a level higher with notable penalties similar to Unfamiliar:<br>" \
		+ "- Accelerations and Slows take <b>2</b> seconds to perform.<br>" \
		+ "  - Additional <b>65%</b> chance to accelerate more AND a <b>70%</b> chance to accelerate even further.<br>" \
		+ "  - Additional <b>60%</b> chance to slow further.<br>" \
		+ "- Turns take <b>3 seconds</b> to perform and a have a <b>60%</b> chance to continue in the given direction, PLUS another <b>70%</b> chance to continue again.<br>" \
		+ "- Rolls have a <b>60%</b> chance to move north/south, and a <b>70%</b> chance afterwards to go further in it.",
		SKILL_LEVEL_PROFESSIONAL = "You are capable of piloting up to Class IV ships, the highest, rarest, and most complex category, where the SCCV Horizon falls under.<br>" \
		+ "- The SCCV Horizon is the only Class IV ship normally.<br>" \
		+ "- Your expert navigational training lets you deduce the current overmap coordinate from examining space with help intent."
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 4,
		SKILL_LEVEL_TRAINED = 8,
		SKILL_LEVEL_PROFESSIONAL = 10
	)
	required = TRUE
	antag_level = SKILL_LEVEL_PROFESSIONAL //So antags are always able to do Horizon/ship hijack gimmicks
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
