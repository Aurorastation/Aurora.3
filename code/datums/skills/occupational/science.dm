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
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = XENOBOTANY_SKILL_COMPONENT

/singleton/skill/archaeology
	name = "Xenoarchaeology"
	description = "Xenoarchaeology is the study, excavation, and analysis of ancient alien relics, geological strata, and anomalous phenomena. " \
		+ "Ranks in this skill improve your speed and precision when excavating or mining, enhance the information gleaned from xenoarchaeological scanners and lab equipment, " \
		+ "and provide situational bonuses when handling anomalies, relics, mineral deposits, and expedition site traps."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_SCIENCE
	component_type = ARCHAOLOGY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no knowledge of Xenoarchaeology.",
		SKILL_LEVEL_FAMILIAR = "You have a passing experience with Xenoarchaeology and geology.<br>" \
			+ " - You excavate and measure rock faces, boulders, and asteroid soil 15% faster.<br>" \
			+ " - Examining mineral deposits reveals if something is buried within the rock strata.<br>" \
			+ " - You have a +15% chance to harvest bonus ore from mineral deposits, and a 40% chance (up from 15%) to preserve unexcavated artifact boulders when mining.<br>" \
			+ " - Delicate finds are 15% less likely to crumble without a suspension field, and strange rocks are less likely to crumble when struck.<br>" \
			+ " - You gain +5% passive Anomaly Protection and halve the chance of accidentally triggering touch artifacts when bumping them.<br>" \
			+ " - Examining excavated relics, mounds, and sarcophagi warns you of rigged power cells, buried mines, booby traps, and anomalous properties.<br>" \
			+ " - You disarm traps and defuse landmines faster (+25% landmine defusal chance), and have a chance to spot and avoid traps and tripwires when walking.",
		SKILL_LEVEL_TRAINED = "You have formal training and field experience in Xenoarchaeology.<br>" \
			+ " - Grants the <b>Survey for Traps</b> active ability, highlighting nearby landmines, tripwires, concealed punji traps, and booby-trapped sarcophagi on screen and uncovering hidden traps.<br>" \
			+ " - You excavate and measure rock faces, boulders, and asteroid soil 30% faster.<br>" \
			+ " - Precision picks automatically stop and warn you before over-excavating a buried find or collapsing a boulder.<br>" \
			+ " - You have a +30% chance to harvest bonus ore from mineral deposits, and a 65% chance to preserve unexcavated artifact boulders when mining.<br>" \
			+ " - Delicate finds are 40% less likely to crumble without a suspension field, and strange rocks never crumble when struck.<br>" \
			+ " - Depth scanners display the exact Suspension Field type required, and Alden-Saraspova counters indicate the direction to the nearest artifact with no distance noise.<br>" \
			+ " - The Anomaly Analyzer and Radiocarbon Spectrometer complete scans 25% faster when you initiate them.<br>" \
			+ " - You gain +10% passive Anomaly Protection and never accidentally trigger touch artifacts when bumping them bare-handed.<br>" \
			+ " - You have a high chance to spot and avoid traps and mines while moving, gain +50% landmine defusal chance (including defusing standstill mines beneath your own feet), safely unprime buried mines when digging open mounds, and disarm sarcophagus traps.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive experience and academic mastery in Xenoarchaeology.<br>" \
			+ " - <b>Survey for Traps</b> scans your full visual range on a shorter cooldown, highlights hazards for longer, and identifies each detected trap by type.<br>" \
			+ " - You excavate and measure rock faces, boulders, and asteroid soil 50% faster.<br>" \
			+ " - You automatically estimate exact excavation depth when examining or using precision picks on rock faces and boulders without needing a measuring tape.<br>" \
			+ " - You have a +45% chance to harvest bonus ore from mineral deposits, and a 90% chance to preserve unexcavated artifact boulders when mining.<br>" \
			+ " - Delicate finds are 65% less likely to crumble without a suspension field, and finds extracted within the clearance zone are always extracted cleanly.<br>" \
			+ " - Depth scanners reveal the true excavation depth of boulders and whether they contain an artifact.<br>" \
			+ " - The Anomaly Analyzer scans 50% faster, detects dormant secondary effects, and identifies exact activation stimuli.<br>" \
			+ " - The Radiocarbon Spectrometer scans 50% faster and suffers 50% less vacuum seal degradation.<br>" \
			+ " - You gain +15% passive Anomaly Protection, never trip on tripwires, have a 90% chance while walking (50% while running) to avoid stepping on traps or mines, and defuse landmines with 100% reliability.",
	)

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
	component_type = XENOBOTANY_SKILL_COMPONENT
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
