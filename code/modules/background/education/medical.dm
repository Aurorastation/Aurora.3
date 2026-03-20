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
		/singleton/skill/pharmacology = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)

/singleton/education/psychologist_degree
	name = "Doctor of Psychology"
	description = "You are at least 30 years of age, with at least a doctorate from an accredited university in an applicable field. " \
		+ "This is more of a research degree that has medical applications, as opposed to a true medical degree. " \
		+ "As such, it is only tangentially involved with actual medicine. A character with only this education is not legally considered a licensed doctor." \
		+ "You are however qualified to perform psychological evaluations on behalf of the SCC, as well as perform psychotherapy."
	jobs = list("Psychologist")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/* Uncomment this block after finishing the Leadership skill. Psychologists should be able to give people morale bonuses as a mechanic.
		/singleton/skill/leadership = SKILL_LEVEL_TRAINED,
		*/
		/singleton/skill/pharmacology = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/anatomy = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/research = SKILL_LEVEL_TRAINED
	)

/singleton/education/psychiatrist_degree
	name = "MD, Psychiatry Track"
	description = "You are at least 30 years of age, with an applicable MD from an accredited school and you have completed 2 years of residency at an \
					accredited hospital or clinic. Unlike Psychology, this is an actual medical degree, and a character with this education is considered a licensed doctor."
	jobs = list("Psychiatrist")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED,
		/singleton/skill/pharmacology = SKILL_LEVEL_TRAINED
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
		/* Can perform only the most basic surgeries up to arterial bleeds. */
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED
	)
