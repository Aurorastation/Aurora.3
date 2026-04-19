/singleton/education/mixing
	name = "Mixologist"
	description = "You know everyone's favorite and how to make it. Whether you successfully passed the test for an Idris mixing license or have tended enough bars to have seen it all, \
		you are a specialist in mixing cocktails, mocktails, and whatever else. Time to mix drinks and save lives."
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
	name = "Culinary Artist"
	description = "You possibly obtained a degree in Culinary Arts or else you've survived enough kitchens to compete with the best. Pancakes, steaks, and cultural food - you've learnt about how to cook it all."
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
	name = "Culinary Background"
	description = "You either obtained an Idris certification to work as a cook, or you've been on dinner duty for a long enough time to get pretty good at it. \
		You won't be as good as a professional chef, but you can pour your soul out into a good breakfast."
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
	name = "Hydroponics Specialization"
	description = "You either obtained a degree to work as a hydroponicist or gardener or you have enough of a gift and the experience that you could do just as well. \
		Your background covered both manual and hydroponics gardening of just about every plant known to your species, alongside plants that are more typical to other cultures in the Spur."
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
	name = "Hydroponics Background"
	description = "You either obtained an Idris certification to work as a hydroponicist or gardener, or you have worked with enough plant life to hit the same mark. \
		Although you might not be as much of an expert as someone with a Hydroponics degree, you can still plant just about everything if you give it your all."
	jobs = list("Gardener")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	skills = list(
		/singleton/skill/gardening = SKILL_LEVEL_TRAINED,
	)
