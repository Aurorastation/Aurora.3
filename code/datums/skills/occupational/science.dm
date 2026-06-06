/singleton/skill/research
	name = "Research"
	description = "The Research skill governs your ability to conduct scientific research, iterate on designs in R&D and unlock the secrets of the universe. Currently only implemented for modular lasers. "
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = RESEARCH_SKILL_COMPONENT

/singleton/skill/xenobotany
	name = "Xenobotany"
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBOTANY_SKILL_COMPONENT

/singleton/skill/archaeology
	name = "Xenoarchaeology"
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = ARCHAOLOGY_SKILL_COMPONENT

/singleton/skill/xenobiology
	name = "Xenobiology"
	description = "Xenobiology is the study of the research and cataloguing of alien lifeforms. This skill governs a character's familiarity with many kinds of Xenofauna." \
		+ "It is necessary not only for the proper detailing of alien creatures, but also for their processing, such as with slimes. " \
		+ "Having this skill at least at the \"Trained\" rank is required to extract cores from slimes."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBOTANY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no knowledge of Xenobiology",
		SKILL_LEVEL_FAMILIAR = "You have a passing experience with Xenobiology.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 10% more damage.<br>" \
			+ " - You harvest one additional part when butchering Xenofauna.",
		SKILL_LEVEL_TRAINED = "You have a moderate experience with Xenobiology.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 15% more damage.<br>" \
			+ " - You harvest two additional parts when butchering Xenofauna.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive experience with Xenobiology.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 20% more damage.<br>" \
			+ " - You harvest three additional parts when butchering Xenofauna.",
	)
