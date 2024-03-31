/singleton/education/surgical_degree
	name = "Surgery MD"
	description = "You are 30 years of age or older, with applicable MD from accredited school and a completed 2 years of Residency at an \
					accredited hospital or clinic."
	jobs = list("Surgeon")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/surgery = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)

