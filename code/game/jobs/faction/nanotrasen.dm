/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = "The most powerful mega-corporation in the entirety of known space, NanoTrasen Corporation wields power and influence on par with some small nations. One of the youngest mega-corporations, founded in 2346 by Benjamin Trasen, they were propelled to greatness through aggressive business tactics and shark-like business deals. They became the corporate power they are today with their discovery of Phoron in the Romanovich Cloud in Tau Ceti in 2417, allowing for immense electricity generation and newer, and vastly superior, FTL travel. This relative monopoly on this crucial resource has firmly secured their position as the wealthiest and most influential mega-corporation in the Orion Spur"
	title_suffix = "NT"

	is_default = TRUE

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_DIONA,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_TAJARA_ZHAN,
			SPECIES_TAJARA_MSAI
		)
	)

/datum/faction/nano_trasen/New()
	..()

	allowed_role_types = list()

	for (var/datum/job/job in SSjobs.occupations)
		allowed_role_types += job.type

	// Really shitty hack until I get around to rewriting jobs a bit.
	var/list/disallowed_roles = list(/datum/job/consular, /datum/job/merchant)
	for(var/disallowed_role in disallowed_roles)
		allowed_role_types -= disallowed_role

/datum/faction/nano_trasen/get_corporate_objectives(var/mission_level)
	var/objective
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			objective = pick("Have [rand(1,4)] crewmember sign NT apprenticeship contracts",
						"Make sure that the station fullfils [rand(4,12)] cargo bounties",
						"Make sure that the station raises [rand(5000,12000)] credits by the end of the shift")
		if(REPRESENTATIVE_MISSION_MEDIUM)
			objective = pick("Have [rand(2,5)] crewmembers sign contract extensions",
						"Have [rand(2,5)] crewmembers buy Odin real estate",
						"[rand(3,10)] crewmember must buy Getmore products from the vendors")
		else
			objective = pick("Conduct and present a survey on crew morale and content",
						"Make sure that [rand(2,4)] complaints are solved on the station",
						"Have [rand(3,10)] crewmembers buy Getmore products from the vendors")

	return objective