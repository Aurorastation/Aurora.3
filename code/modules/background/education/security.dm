/singleton/education/forensics_degree
	name = "Forensics Science Degree"
	description = "You are 25 years of age or older, with a degree in Forensics Science. You specialize in the medical procedures required to understand why someone died."
	jobs = list("Investigator")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/anatomy = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/forensics = SKILL_LEVEL_PROFESSIONAL
	)

/singleton/education/protagonist
	name = "Protagonist Degree"
	description = "you are the protagonist of aurora"
	skills = list(
		/singleton/skill/unarmed_combat = SKILL_LEVEL_TRAINED,
		/singleton/skill/armed_combat = SKILL_LEVEL_TRAINED,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED
	)
