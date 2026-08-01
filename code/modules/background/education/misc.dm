/singleton/education/finance
	name = "Finance Background"
	description = "You are at least 21 years of age. You possibly graduated in a field related to finance, whether that is Business Management or something else. Otherwise, you likely found your knack in the ordinary course of life such that you have comparable expertise.\
		You can count very well, and you have a statistician's eye - especially for credits."
	minimum_character_age = list(
		SPECIES_HUMAN = 21,
		SPECIES_TAJARA = 21,
		SPECIES_TAJARA_MSAI = 21,
		SPECIES_TAJARA_ZHAN = 21,
		SPECIES_UNATHI = 21,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

/singleton/education/arts
	name = "Humanities Background"
	description = "You are at least 21 years of age. You possibly graduated in a field related to the humanities, whether that is music, arts, linguistics, or a bachelor's in \
		psychology. Otherwise, your life has provided ample opportunity for these pursuits such that you have comparable expertise. You are likely very well-read on foreign cultures and on the human mind."
	minimum_character_age = list(
		SPECIES_HUMAN = 21,
		SPECIES_TAJARA = 21,
		SPECIES_TAJARA_MSAI = 21,
		SPECIES_TAJARA_ZHAN = 21,
		SPECIES_UNATHI = 21,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

/singleton/education/flight_academy
	name = "Flight Academy"
	description = "You are at least 25 years of age, with the best navigation training the Spur can offer, vessel handiness in a pinch, and the know-how for reining in or assuring passengers for the voyage."
	jobs = list("Bridge Crew", "Executive Officer", "Captain")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/pilot_spacecraft = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_FAMILIAR, //To make a machine frame for ship consoles in emergencies
		/singleton/skill/leadership = SKILL_LEVEL_TRAINED
	)

/singleton/education/fleet_training
	name = "Fleet Training"
	description = "You are at least 25 years of age, with the most extensive navigation training possible and military discipline to back it up. You're a steady shot in emergencies \
	and, damn it-- You. Go. Down. With. The. Ship."
	jobs = list("Bridge Crew", "Executive Officer", "Captain")
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)
	skills = list(
		/singleton/skill/pilot_spacecraft = SKILL_LEVEL_PROFESSIONAL,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED,
		/singleton/skill/tenacity = SKILL_LEVEL_TRAINED
	)

/singleton/education/expeditionary_trade
	name = "Expeditionary Trade"
	description = "You've developed trade skills for a career of expeditions. You are at home in a shuttle piloting to and from for an average day's work. You can even hit a shot or tend to \
	wounds when things eventually get unsafe."
	jobs = list("Shaft Miner", "Xenoarchaeologist", "Xenobiologist", "Xenobotanist", "Operations Manager", "Research Director")
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
		)
	skills = list(
		/singleton/skill/pilot_spacecraft = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR
	)
