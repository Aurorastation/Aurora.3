/singleton/skill/research
	name = "Research"
	description = "The Research skill governs your ability to conduct scientific research, iterate on designs in R&D and unlock the secrets of the universe. Currently only implemented for modular lasers. "
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = RESEARCH_SKILL_COMPONENT

/singleton/skill/xenobotany
	name = "Xenobotany"
	description = "Xenobotany is the scientific study, genetic sequencing, and directed modification of alien and domestic flora. " \
		+ "Ranks in this skill improve your efficiency with genetic extraction and bioballistic splicing machinery, decode obfuscated plant gene masks, " \
		+ "bias plant mutations and floral somatorays toward favorable traits, enhance Plant Analyzer and field inspection readouts, " \
		+ "and allow you to safely sample and combat hazardous or invasive flora."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBOTANY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no knowledge of Xenobotany.",
		SKILL_LEVEL_FAMILIAR = "You have a passing experience with Xenobotany.<br>" \
			+ " - You cause less genetic degradation in the Lysis-Isolation Centrifuge and suffer lower failure chances and decay in the Bioballistic Delivery System.<br>" \
			+ " - You can calibrate the Floral Somatoray's targeted gene selector, and your somatoray shots have a 30% chance (up from 20%) to take effect.<br>" \
			+ " - Mutations you induce via somatorays or mutagenic reagents never cause withering plant cancer and have a 25% chance (up from 15%) to trigger subspecies shifts.<br>" \
			+ " - Taking tissue samples from trays, vines, or wild exoplanet flora deals less damage to the plant and preserves wild flora.<br>" \
			+ " - Plant Analyzers can scan wild exoplanet flora and spreading vines, displaying exact numerical tolerance profiles and live tray diagnostics.<br>" \
			+ " - Examining trays, seed packets, produce, and wild flora reveals exact health, toxin/weed/pest levels, potency, genetic decay, and hazard warnings.<br>" \
			+ " - You have a 50% chance to avoid stings, thorns, and spore releases when handling or harvesting hazardous plants, a 35% chance to evade lashing vine tendrils, +15% chance to free entangled victims, +25% damage against spreading vines, and +10% melee damage against hostile plant fauna.",
		SKILL_LEVEL_TRAINED = "You have formal training and laboratory experience in Xenobotany.<br>" \
			+ " - You decode the 6 foundational/agronomic gene masks (Pigment, Environment, Hardiness, Vigour, Diet, and Metabolism) in the Centrifuge, Bioballistic Editor, Floral Somatoray, and on flora data disks.<br>" \
			+ " - You further reduce Centrifuge degradation, Bioballistic splicing failure/decay, and the Yield/Endurance penalty when splicing Biochemistry genes.<br>" \
			+ " - Your Floral Somatoray shots have a 45% chance to take effect, yield rays grant greater bonus yield, and mutations you induce bias trait rolls positively with a 35% subspecies shift chance.<br>" \
			+ " - Plant Analyzers reveal the full Genetic Chemical Synthesis Profile of unplanted seeds and growing plants, exact gas consumption/exudation types, and specific mutant subspecies names.<br>" \
			+ " - Examining seed packets reveals Potency, Yield, Endurance, Maturation/Production, and genetic hazard warnings by sight.<br>" \
			+ " - Harvesting wild exoplanet flora has a 50% chance to salvage a viable seed packet alongside the produce.<br>" \
			+ " - You safely handle stinging/thorny produce barehanded, harvest sporous plants and dispatch walking mushrooms without triggering spore clouds, step over thorny vines, have a 70% chance to evade lashing vine tendrils, +35% chance to free entangled victims, +50% damage against spreading vines, and +15% melee damage against hostile plant fauna.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive experience and academic mastery in Xenobotany.<br>" \
			+ " - You automatically decode all 12 obfuscated plant gene masks across all xenobotany machinery, disks, and tools, and examining flora data disks reveals their exact encoded trait values.<br>" \
			+ " - You suffer minimal genome degradation in the Centrifuge and Bioballistic Editor, and suffer zero Yield, Endurance, or gas output loss when splicing Biochemistry genes.<br>" \
			+ " - Your Floral Somatoray shots have a 60% chance to take effect, and mutations you induce strongly bias traits upward with a 45% subspecies shift chance.<br>" \
			+ " - Plant Analyzers append a complete Decoded Gene Locus Reference table that can be printed for the laboratory, and examining produce or wild flora identifies the exact chemicals they contain.<br>" \
			+ " - Taking tissue samples never exhausts a plant and has a 25% chance to divide the cutting into a second bonus seed packet; harvesting wild exoplanet flora always salvages a seed packet.<br>" \
			+ " - You never get entangled by hostile vines while mobile, always succeed at freeing victims from vines on the first attempt, deal +75% damage against spreading vines, and deal +20% melee damage against hostile plant fauna.",
	)

/singleton/skill/archaeology
	name = "Xenoarchaeology"
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = ARCHAOLOGY_SKILL_COMPONENT

/singleton/skill/xenobiology
	name = "Xenobiology"
	description = "Xenobiology is the study of the research and cataloguing of alien lifeforms. It is necessary not only for the proper detailing of \
		alien creatures, but also for their processing, such as with slimes. " \
		+ "Having this skill at least at the \"Trained\" rank is required to extract cores from slimes. " \
		+ "Ranks in this skill also provide small situational bonuses when interacting with aliens in general."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBIOLOGY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no knowledge of Xenobiology",
		SKILL_LEVEL_FAMILIAR = "You have a passing experience with Xenobiology.<br>" \
			+ " - You can recognize what a few wires do in xenobiological sciences hardware by sight.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 10% more damage.<br>" \
			+ " - You harvest one additional part when butchering Xenofauna.<br>" \
			+ " - You are +2.5% more likely to succeed when performing surgery on a patient that is a different species than your own.<br>" \
			+ " - You can perform surgeries 5% faster on a patient that is a different species than your own.",
		SKILL_LEVEL_TRAINED = "You have a moderate experience with Xenobiology.<br>" \
			+ " - You can recognize what several wires do in xenobiological sciences hardware by sight.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 15% more damage.<br>" \
			+ " - You harvest two additional parts when butchering Xenofauna.<br>" \
			+ " - You are +5% more likely to succeed when performing surgery on a patient that is a different species than your own. <br>" \
			+ " - You can perform surgeries 10% faster on a patient that is a different species than your own.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive experience with Xenobiology.<br>" \
			+ " - You can recognize what many wires do in xenobiological sciences hardware by sight.<br>" \
			+ " - Your melee attacks made against Xenofauna such as Space Carp deal 20% more damage.<br>" \
			+ " - You harvest three additional parts when butchering Xenofauna.<br>" \
			+ " - You are +7.5% more likely to succeed when performing surgery on a patient that is a different species than your own.<br>" \
			+ " - You can perform surgeries 15% faster on a patient that is a different species than your own.",
	)
