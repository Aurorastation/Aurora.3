/singleton/education/mechanical_engineering
	name = "Mechanical Engineering"
	description = "You are at least 25 years of age, with either a Bachelor's degree in Mechanical Engineering, or otherwise have functionally equivalent working experience. \
		You specialize in constructing structural systems, lathing, and the more manual pleasures of engineering, such as welding and wrenching."
	jobs = list("Engineer")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_TRAINED,
		/singleton/skill/reactor_systems = SKILL_LEVEL_TRAINED
	)

/singleton/education/electrical_engineering
	name = "Electrical Engineering Background"
	description = "You are at least 25 years of age, with a Bachelor's degree in Electrical Engineering, or otherwise have functionally equivalent working experience. \
		You specialize in variable-voltage cabling, grid management, electronic hardware, and other electrical systems."
	jobs = list("Engineer")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_TRAINED,
		/singleton/skill/reactor_systems = SKILL_LEVEL_TRAINED
	)

/singleton/education/atmospherics_engineer
	name = "Atmospherics Systems Background"
	description = "You are at least 25 years of age, with a Bachelor's degree in Atmospherics Systems, or otherwise have functionally equivalent working experience. \
		You specialize in everything to do with atmospherics systems, whether that's the delivery of gases, usage of atmospherics machines, or simply how to use a pipe wrench."
	jobs = list("Atmospherics Technician")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/reactor_systems = SKILL_LEVEL_TRAINED
	)


/singleton/education/reactors_engineer
	name = "Reactor Systems Background"
	description = "You are at least 25 years of age, with a Bachelor's degree in Reactor Systems, or otherwise have functionally equivalent working experience. \
		You specialize in everything to do with a reactor's systems, whether you are looking at a Supermatter crystal, a fusion reactor, or a combustion chamber."
	jobs = list("Engineer")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_TRAINED,
		/singleton/skill/reactor_systems = SKILL_LEVEL_PROFESSIONAL
	)

/singleton/education/experienced_engineer
	name = "Engineering Certification"
	description = "You are at least 25 years of age. You may not have an Engineering degree or a specialized background, but you had enough fundamental experience for the Conglomerate to validate it instead \
		of a degree. You do not have the same specialization as your fellow Engineers with a degree, making up for it by being a jack of all trades. \
		You could probably fix a car, whereas they might not be able to."
	jobs = list("Engineer")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_TRAINED,
		/singleton/skill/reactor_systems = SKILL_LEVEL_TRAINED
	)
