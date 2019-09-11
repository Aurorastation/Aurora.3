/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = "The most powerful mega-corporation in the entirety of known space, NanoTrasen Corporation wields power and influence on par with some small nations. One of the youngest mega-corporations, founded in 2346 by Benjamin Trasen, they were propelled to greatness through aggressive business tactics and shark-like business deals. They became the corporate power they are today with their discovery of Phoron in the Romanovich Cloud in Tau Ceti in 2417, allowing for immense electricity generation and newer, and vastly superior, FTL travel. This relative monopoly on this crucial resource has firmly secured their position as the wealthiest and most influential mega-corporation in the Orion Spur"
	title_suffix = "NT"

	is_default = TRUE

/datum/faction/nano_trasen/New()
	..()

	allowed_role_types = list()

	for (var/datum/job/job in SSjobs.occupations)
		allowed_role_types += job.type

	// Really shitty hack until I get around to rewriting jobs a bit.
	allowed_role_types -= /datum/job/merchant

/datum/faction/nano_trasen/get_corporate_objectives(var/mission_level)
	var/objective
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			objective = pick("Have [rand(1,4)] crewmember sign NT apprenticeship contracts",
						"Make sure that the station fullfils [rand(4,12)] cargo bounties",
						"Provide [rand(1,3)] reports on artifacts and their effects",
						"Make sure at least [rand(5-50)] Phoron crystals are exported to NTCC Odin",
						"Make sure that the station raises [rand(5000,12000)] credits by the end of the shift")
		if(REPRESENTATIVE_MISSION_MEDIUM)
			objective = pick("Have [rand(2,5)] crewmembers sign contract extensions",
						"Have [rand(2,5)] crewmembers buy Odin real estate",
						"Provide a list of researched techlogies to the NTCC Odin at the end of the shift",
						"Make sure [rand(2,5)] more Getmore vending machines are installed")
		else

			objective = pick("Conduct and present a survey on crew morale and satisfaction",
						"Make sure that [rand(2,4)] complaints are resolved on the station",
						"Provide a presentation for heads of staff regarding workplace efficiency",
						"Conduct and present a survey on Getmore products and ideas to expand them",
						"Have [rand(3,7)] crewmembers provide written recommendations of Getmore Products for advertisers")

	return objective