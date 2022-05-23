/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = {"<p>
	Considered the largest megacorporation within the Orion Spur, many will find themselves doing the biddings of NanoTrasen -- be it direct or indirect. Initially a biotechnical
	research company, it rapidly grew in size after the discovery of Phoron. The corporation's monopoly on the resource catapulted it into the limelight, where it has remained for the last
	forty-odd years. Its acceleration into the spotlight has prompted many prying eyes to uncover evidence of rather questionable actions, with rumours perpetuating that they've instigated
	wars on both Adhomai and Moghes in an attempt to exploit the species for a profit.  NanoTrasen's power has since begun to waver as their ability to supply Phoron dwindled -- resulting in
	their profit margins diminishing considerably. Whilst the corporation has attempted its best to hide its waning influence, the facade has begun to crumble with scrutinizing individuals
	being able to see its vulnerability.  Despite the effects of the Phoron Scarcity on the megacorporation, NanoTrasen has managed to secure itself as a crucial member of the newly-founded
	Stellar Corporate Conglomerate (SCC) with Miranda Trasen serving as the Acting Director of Operations -- which has managed to bolster the company and secure themselves as the dominant
	corporate presence within the Orion Spur.

	</p>
	<p>NanoTrasen employees can be in the following departments:

	<ul>
	<li><b>Service</b></li>
	<li><b>Medical</b></li>
	<li><b>Research</b></li>
	</ul></p>"}

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
