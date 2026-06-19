/singleton/skill/research
	name = "Research"
	description = "The Research skill governs your ability to conduct scientific research, iterate on designs in R&D and unlock the secrets of the universe. Currently only implemented for modular lasers. "
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	required = TRUE
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
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBOTANY_SKILL_COMPONENT
	required = TRUE
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from this skill.",
		SKILL_LEVEL_FAMILIAR = "You have a very small bonus to both success rate and surgery speed when performing surgeries on aliens in general.",
		SKILL_LEVEL_TRAINED = "You have a small bonus to both success rate and surgery speed when performing surgeries on aliens in general.",
		SKILL_LEVEL_PROFESSIONAL = "You have a moderate bonus to both success rate and surgery speed when performing surgeries on aliens in general."
	)
