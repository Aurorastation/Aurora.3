/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = {"<p>
	Considered the largest megacorporation within the Orion Spur, many will find themselves doing the biddings of NanoTrasen.
	Initially a biotechnical research company, it rapidly grew in size after the discovery of phoron.
	NanoTrasen's continued monopoly on the resource catapulted it into the limelight, where it has remained for the last forty-odd years.
	During the Phoron Scarcity, NanoTrasen's power has since begun to waver, resulting in their profit margins diminishing considerably.
	Nonetheless, NanoTrasen has managed to secure itself as a crucial member of the newly-founded Stellar Corporate Conglomerate
	allowing themselves to remain as a dominant corporate presence within the Orion Spur.
	</p>"}
	departments = {"Medical<br>Science<br>Service"}
	title_suffix = "NT"

	is_default = TRUE

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN,
			SPECIES_TAJARA_MSAI
		)
	)


	allowed_role_types = NT_ROLES

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
