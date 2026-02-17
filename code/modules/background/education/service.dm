/singleton/education/mixing
	name = "Mixing License"
	description = "You paid for and successfully attained an Idris mixing license, making you officially a specialist in mixing cocktails, mocktails, and whatever else. \
					Time to mix drinks and save lives."
	jobs = list("Bartender")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	skills = list(
		/singleton/skill/bartending = SKILL_LEVEL_PROFESSIONAL,
	)

/singleton/education/cooking_degree
	name = "Culinary Arts Degree"
	description = "You obtained a degree in Culinary Arts, making you an artist at cooking. Pancakes, steaks, and cultural food - you've learnt about how to cook it all."
	jobs = list("Chef")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	skills = list(
		/singleton/skill/cooking = SKILL_LEVEL_PROFESSIONAL,
	)

/singleton/education/cooking_certification
	name = "Culinary Certification"
	description = "You obtained an Idris certification to work as a cook. You won't be as good as a professional chef, but you can pour your soul out into a good breakfast."
	jobs = list("Chef")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	skills = list(
		/singleton/skill/cooking = SKILL_LEVEL_TRAINED,
	)

/singleton/education/hydroponics_degree
	name = "Hydroponics Degree"
	description = "You obtained a degree to work as a hydroponicist or gardener. Your degree covered both manual and hydroponics gardening of just about every plant known to your species, \
					alongside plants that are more typical to other cultures in the Spur."
	jobs = list("Gardener")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	skills = list(
		/singleton/skill/gardening = SKILL_LEVEL_PROFESSIONAL,
	)

/singleton/education/hydroponics_certification
	name = "Hydroponics Certification"
	description = "You obtained an Idris certification to work as a hydroponicist or gardener. Although you might not be as much of an expert as someone with a Hydroponics degree, \
					you can still plant just about everything if you give it your all."
	jobs = list("Gardener")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	skills = list(
		/singleton/skill/gardening = SKILL_LEVEL_TRAINED,
	)
