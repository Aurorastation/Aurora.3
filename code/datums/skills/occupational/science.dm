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
	description = "Xenobiology is the study of the research and cataloguing of alien lifeforms. It is necessary not only for the proper detailing of \
		alien creatures, but also for their processing, such as with slimes. " \
		+ "Having this skill at least at the \"Trained\" rank is required to extract cores from slimes. " \
		+ "Ranks in this skill also provide small situational bonuses when interacting with aliens in general."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBOTANY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no knowledge of Xenobiology",
		SKILL_LEVEL_FAMILIAR = "You have a passing experience with Xenobiology.<br>" \
			+ " - You can recognize what a few wires do in xenobiological sciences hardware by sight.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 10% more damage.<br>" \
			+ " - You harvest one additional part when butchering Xenofauna.<br>" \
			+ " - You are +2.5% more likely to succeed when performing surgery on a patient that is a different species than your own.<br>" \
			+ " - You can perform surgeries 5% faster on a patient that is a different species than your own.",
		SKILL_LEVEL_TRAINED = "You have a moderate experience with Xenobiology.<br>" \
			+ " - You can recognize what several wires do in xenobiological sciences hardware by sight.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 15% more damage.<br>" \
			+ " - You harvest two additional parts when butchering Xenofauna.<br>" \
			+ " - You are +5% more likely to succeed when performing surgery on a patient that is a different species than your own. <br>" \
			+ " - You can perform surgeries 10% faster on a patient that is a different species than your own.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive experience with Xenobiology.<br>" \
			+ " - You can recognize what many wires do in xenobiological sciences hardware by sight.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 20% more damage.<br>" \
			+ " - You harvest three additional parts when butchering Xenofauna.<br>" \
			+ " - You are +7.5% more likely to succeed when performing surgery on a patient that is a different species than your own.<br>" \
			+ " - You can perform surgeries 15% faster on a patient that is a different species than your own.",
	)
