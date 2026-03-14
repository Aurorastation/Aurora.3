/singleton/education/forensics_degree
	name = "Forensics Science Degree"
	description = "You are 25 years of age or older, with a degree in Forensics Science. You specialize in the medical procedures required to understand why someone died. " \
		+ "While not necessarily a medical degree, there's not much difference in suturing a body whether or not its approaching room temperature."
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

/singleton/education/military_basic
	name = "Military Training"
	description = "You have finished at least one full contract of military service. Alternatively, this could be equivalent experience from mercenary work."
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/unarmed_combat = SKILL_LEVEL_TRAINED,
		/singleton/skill/armed_combat = SKILL_LEVEL_TRAINED,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED
	)

/singleton/education/military_corpsman
	name = "Corpsman Training"
	description = "After completing basic military training, you received advanced individual training in battlefield medicine. " \
		+ "Your combat skills are not as sharp as others, but you made up for it by knowing how to keep your comrades in arms from bleeding out on the battlefield. " \
		+ "A character with this training is NOT legally considered a medical doctor. You're on the hook for manslaughter if you attempt and fail to save them yourself instead of taking them to a real doctor."
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/* Significantly worse combat skills than other security educations, though not so bad they'll footgun themselves.
			Alternatively, this is a plausible though less specialized alternative for paramedic training, as is common in real life. */
		/singleton/skill/armed_combat = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR, /* Only enough to repair an artery. */
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR
	)

/singleton/education/military_marksman
	name = "Marksman Training"
	description = "You were selected for sniper school during \"Basic\". " \
		+ "Your skills with firearms are unmatched. Unfortunately your other combat skills are rustier."
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/unarmed_combat = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_PROFESSIONAL
	)

/singleton/education/police_academy
	name = "Police Academy Graduate"
	description = "You are a police academy graduate. Your combat skills are not as stringent as actual military service, though this is made up for with more generalized training suitable for a first-responder."
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/unarmed_combat = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED,
		/singleton/skill/forensics = SKILL_LEVEL_FAMILIAR, /* Very basic crime investigation skills. */
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR /* Police are also trained in basic first aid. */
	)

/singleton/education/military_aviator
	name = "Combat Aviator"
	description = "You have formal training in piloting military spacecraft, along with a fast tracked form of basic training."
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/pilot_spacecraft = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED
	)

/singleton/education/military_tanker
	name = "Mech Tanker"
	description = "You are a graduate of the spur's modern day equivalent to Tanker School, and can call yourself a Mech-warrior."
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/pilot_mechs = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED, /* Actually needed for firing mech guns oddly enough. */
		/singleton/skill/armed_combat = SKILL_LEVEL_FAMILIAR
	)
