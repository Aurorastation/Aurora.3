/singleton/education/surgical_degree
	name = "MD, Surgery Track"
	description = "You are 30 years of age or older, with an applicable MD from accredited school and you have completed 2 years of residency at an \
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

/singleton/education/physician_degree
	name = "MD, Physician Track"
	description = "You are at least 30 years of age, with an applicable MD from an accredited school and you have completed 2 years of residency at an \
					accredited hospital or clinic."
	jobs = list("Physician")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/surgery = SKILL_LEVEL_TRAINED,
		/singleton/skill/medicine = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)

/singleton/education/pharmacist_degree
	name = "Doctor of Pharmacy"
	description = "You are at least 25 years of age, with an applicable Masters from an accredited school, along with 2 years of residency at an \
					accredited hospital or clinic."
	jobs = list("Pharmacist")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)

/singleton/education/psychologist_degree
	name = "Psychology PhD"
	description = "You are at least 30 years of age, with a PhD from an accredited university in an applicable field."
	jobs = list("Psychologist")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/pharmacology = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)

/singleton/education/paramedic
	name = "Paramedic Certification"
	description = "You are at least 18 years of age, with a Paramedic certification."
	jobs = list("Paramedic")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)
	skills = list(
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)
