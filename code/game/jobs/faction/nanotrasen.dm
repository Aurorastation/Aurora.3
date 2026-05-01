/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = {"
	Considered the largest megacorporation within the Orion Spur, many will find themselves doing the biddings of NanoTrasen.<br>
	Initially a biotechnical research company, it rapidly grew in size after the discovery of phoron.
	NanoTrasen's continued monopoly on the resource catapulted it into the limelight, where it has remained for the last forty-odd years.<br><br>
	During the Phoron Scarcity, NanoTrasen's power has since begun to waver, resulting in their profit margins diminishing considerably.
	Nonetheless, NanoTrasen has managed to secure itself as a crucial member of the newly-founded Stellar Corporate Conglomerate
	allowing themselves to remain as a dominant corporate presence within the Orion Spur.
	"}
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_SCIENCE, DEPARTMENT_SERVICE)
	title_suffix = "NT"
	wiki_page = "NanoTrasen_Corporation"

	ui_priority = -1

	is_default = TRUE

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN,
			SPECIES_TAJARA_MSAI
		)
	)

	titles_to_loadout = list(
		"Off-Duty Crew Member" = /obj/outfit/job/visitor/nanotrasen
	)


	allowed_role_types = NT_ROLES

/datum/faction/nano_trasen/get_corporate_objectives(var/mission_level)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			return pick("Obtain 2000 moles of gaseous Phoron or 20x Phoron Crystals for shipping to NanoTrasen Corporation.",
						"Identify and report SCC command staff who are overtly favouring their origin state or company (IE. displaying origin state/corporation iconography) in breach of Conglomerate ideals",
						"Identify and report any acts of inter-SCC conflict or espionage")
		if(REPRESENTATIVE_MISSION_MEDIUM)
			return pick("Have any crew member enroll onto a paid NanoTrasen Academy online learning course",
						"Have a NanoTrasen employee sign a contract extension",
						"Evaluate crew opinions on GetMore Corporation products available on the [station_name()]",
						"Ensure Hazel! Limited positronics are compliant with brand standards",
						"Evaluate crew opinions on Ingi Usang Entertainment Company products and brands")
		else
			return pick("Conduct a survey on NanoTrasen Corporation employee morale",
						"Identify and resolve a complaint of a NanoTrasen Corporation employee",
						"Emphasise the importance of phoronic technologies aboard the [station_name()] and around the Orion Spur")

/obj/outfit/job/visitor/nanotrasen
	name = "Off-Duty Crew Member - NanoTrasen"

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt
