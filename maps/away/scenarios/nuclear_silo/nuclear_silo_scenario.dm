/singleton/scenario/nuclear_silo
	name = "Arctic Valley"
	desc = "A small wooden village within a valley in an arctic environment, entirely unlabelled on starcharts. Scans indicate \
			there may be more under the surface. As the SCCV Horizon is the closest vessel within range, it has been dispatched to make contact."
	scenario_site_id = "nuclear_silo"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/nuclear_silo

	roles = list(
		/singleton/role/nuclear_silo_crew/upper/villager,
		/singleton/role/nuclear_silo_crew/upper/villager_business_owner,
		/singleton/role/nuclear_silo_crew/lower/silo_resident,
		/singleton/role/nuclear_silo_crew/lower/silo_engineer,
		/singleton/role/nuclear_silo_crew/lower/silo_doctor,
		/singleton/role/nuclear_silo_crew/lower/silo_researcher,
		/singleton/role/nuclear_silo_crew/lower/silo_guard,
		/singleton/role/nuclear_silo_crew/lower/silo_base_commander,
		/singleton/role/nuclear_silo_crew/lower/silo_military_attache,
	)
	default_outfit = /obj/outfit/admin/generic/nuclear_silo_crew
	actor_accesses = list(/datum/access/nuclear_missile_silo_access, /datum/access/nuclear_missile_silo_access_high)
	radio_frequency_name = "Arctic Valley"

	base_area = /area/nuclear_silo

/singleton/scenario_announcements/nuclear_silo
	horizon_announcement_title = "SCC Vessel Sensor Relay Network"
	horizon_unrestrict_landing_message = "SCCV Horizon, an SCC scouting vessel detected a hitherto uncontacted community within a small arctic valley on an \
	exoplanet within your current sector. All current starcharts indicate that this planet does not exist. Several hundred lifesigns have been detected on \
	the surface, collected in scattered communities. The community within an arctic valley seems to have the most hospitable environment for landing, and \
	as such you have been authorized to land and make contact with this group. You are what makes this chainlink unbreakable."

	offship_announcement_message = "A small unlabelled arctic exoplanet has been located within the sector. Sapient lifesigns are detected. The coordinates \
	have been registered on the flight deck."

/singleton/role/nuclear_silo_crew/upper/villager
	name = "Arctic Valley Villager"
	desc = "You are a villager who lives in a small town in an arctic valley. You may or may not be aware of the nuclear silo below you, \
			and could be anything from a hunter, to a farmer in better months, to a craftsman. You are equipped with cold weather clothing."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/upper/villager

/singleton/role/nuclear_silo_crew/upper/villager_business_owner
	name = "Arctic Valley Business Owner"
	desc = "You are a villager in the small town, and also run some kind of business. Perhaps you're the towns doctor, barkeep or shopkeeper. \
			You have a suit, some money and a titchy pistol at your disposal."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/upper/villager_business_owner

/singleton/role/nuclear_silo_crew/lower/silo_resident
	name = "Nuclear Silo Resident"
	desc = "You work and live in the nuclear silo bunker. Perhaps you're an engineer or doctor off duty, or perhaps you're the chef or the janitor. \
			You are equipped with some basic clothing."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/silo_resident

/singleton/role/nuclear_silo_crew/lower/silo_engineer
	name = "Nuclear Silo Engineer"
	desc = "You work and live in the nuclear silo bunker. You are on-duty as an engineer, and are tasked with managing the power and oxygen recycling \
			systems, to keep the lights on and everyone breathing. You are equipped with some tools, and more can be found in your storage room."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/silo_engineer

/singleton/role/nuclear_silo_crew/lower/silo_doctor
	name = "Nuclear Silo Doctor"
	desc = "You work and live in the nuclear silo bunker. You are on-duty as a doctor, and are tasked with making sure people do not succumb to the \
			dangers of the job. Patch holes, mix chemicals and perform surgeries. You are equipped with medicines and supplies, and more can be found in \
			your storage room."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/silo_doctor

/singleton/role/nuclear_silo_crew/lower/silo_researcher
	name = "Nuclear Silo Researcher"
	desc = "You work and live in the nuclear silo bunker. You are on-duty as a researcher, and are tasked with monitoring the nuclear missile. \
		You are equipped with a labcoat and clerical supplies."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_researcher

/singleton/role/nuclear_silo_crew/lower/silo_guard
	name = "Nuclear Silo Guard"
	desc = "You work and live in the nuclear silo bunker. You are on-duty as a security guard, and are tasked with shooting anyone who tries to get in. \
		Your job may entail shooting intruders, throwing rowdy silo residents in the communal cell to cool off, or distributing guns to your fellow \
		residents. You are equipped with an empty holster and some basic security gear, and more can be found in the armoury."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_guard

/singleton/role/nuclear_silo_crew/lower/silo_base_commander
	name = "Nuclear Silo Base Commander"
	desc = "You command the nuclear silo bunker. You may be an agent for your government, a rebel or an independent, as decided by the storyteller. \
		You are tasked with talking to people and smoothing out disagreements. Matters of security or military interest are handled by the attache. \
		You are equipped with a fine suit and a loaded revolver. Pray your negotation skills are enough to not use it."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_base_commander

/singleton/role/nuclear_silo_crew/lower/silo_military_attache
	name = "Nuclear Silo Military Attache"
	desc = "You are the military attache attached to the nuclear silo bunker. You may be an agent for your government, a rebel or an independent, as \
	decided by the storyteller. You are tasked with handling matters of security or military interest. Matters of diplomacy are handled by the \
	base commander. You are equipped with military fatigues and a jacket, and your bedroom contains a gun and armour."
	outfit = /obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_military_attache
