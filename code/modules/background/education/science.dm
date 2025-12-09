/singleton/education/research_and_development
	name = "Research & Development Degree"
	description = "You are at least 30 years of age, with a PhD in an applicable field for Research and Development. This may range from a Firearms Engineering degree \
					to a Bluespace Engineering degree or even Aerospace Engineering. Space is the limit for your research."
	jobs = list("Scientist")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/research = SKILL_LEVEL_PROFESSIONAL
	)

/singleton/education/robotics_masters
	name = "Robotics Master's"
	description = "You are at least 25 years of age, with a Master's in Robotics. Your specialization is in building and repairing IPCs and other smaller robots, though \
					you are also capable of building exoskeletons and mechs. You're also proficient with some more basic engineering skills, though you prefer the \
					theoretical aspect and robots in general."
	jobs = list("Roboticist")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/research = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/robotics = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_FAMILIAR,
	)

/singleton/education/mechatronics_masters
	name = "Mechatronics Master's"
	description = "You are at least 25 years of age, with a Master's in Mechatronics. Your specialization is with building large human-sized exoskeletons and mechs, though \
					you've also learnt how to repair IPCs and simpler robots as well. You're more proficient with the mechanical aspects of engineering as well."
	jobs = list("Roboticist")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/research = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/robotics = SKILL_LEVEL_TRAINED,
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_PROFESSIONAL
	)

/singleton/education/xenobotany_degree
	name = "Xenobotany Degree"
	description = "You are at least 30 years of age, with a PhD in Xenobotany. Your specialization is with discovering, sequencing, and creating alien flora... though \
					you can also grow some potatoes in your spare time."
	jobs = list("Xenobotanist")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/research = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/gardening = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/xenobotany = SKILL_LEVEL_PROFESSIONAL
	)


/singleton/education/xenobiology_degree
	name = "Xenobiology Degree"
	description = "You are at least 30 years of age, with a PhD in Xenobiology. Your specialization is with discovering and cataloguing alien animals."
	jobs = list("Xenobiologist")
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/research = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/xenobiology = SKILL_LEVEL_PROFESSIONAL
	)
