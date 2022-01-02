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

	titles_to_loadout = list(
		"Bartender" = /datum/outfit/job/bartender/nt,
		"Chef" = /datum/outfit/job/chef/nt,
		"Gardener" = /datum/outfit/job/hydro/nt,
		"Janitor" = /datum/outfit/job/janitor/nt,
		"Librarian" = /datum/outfit/job/librarian/nt,
		"Service Manager" = /datum/outfit/job/service_manager/nt,
		"Physician" = /datum/outfit/job/doctor/nt,
		"Surgeon" = /datum/outfit/job/doctor/surgeon/nt,
		"Pharmacist" = /datum/outfit/job/pharmacist/nt,
		"Psychiatrist" = /datum/outfit/job/psychiatrist/nt,
		"Psychologist" = /datum/outfit/job/psychiatrist/nt,
		"First Responder" = /datum/outfit/job/med_tech/nt,
		"Medical Intern" = /datum/outfit/job/intern_med/nt,
		"Xenobiologist" = /datum/outfit/job/scientist/nt,
		"Xenobotanist" = /datum/outfit/job/scientist/nt,
		"Xenobiologist" = /datum/outfit/job/scientist/nt,
		"Xenobotanist" = /datum/outfit/job/scientist/nt,
		"Lab Assistant" = /datum/outfit/job/intern_sci/nt,
		"Xenoarcheologist"= /datum/outfit/job/scientist/xenoarcheologist/nt
	)

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

/datum/outfit/job/doctor/nt
	name = "Physician - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/medical/nt
	suit = null

/datum/outfit/job/doctor/surgeon/nt
	name = "Surgeon - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/medical/surgeon/nt
	suit = null

/datum/outfit/job/pharmacist/nt
	name = "Pharmacist - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/pharmacist/nt
	suit = null

/datum/outfit/job/psychiatrist/nt
	name = "Psychiatrist - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/psych/nt
	suit = null

/datum/outfit/job/med_tech/nt
	name = "First Responder - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/medical/first_responder/nt
	suit = null

/datum/outfit/job/intern_med/nt
	name = "Medical Intern - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/medical/intern/nt

/datum/outfit/job/scientist/nt
	name = "Scientist - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/scientist/nt
	suit = null

/datum/outfit/job/scientist/xenoarcheologist/nt
	name = "Xenoarcheologist - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/xenoarcheologist/nt
	suit = null

/datum/outfit/job/intern_sci/nt
	name = "Lab Assistant - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/scientist/intern/nt
	suit = null

/datum/outfit/job/bartender/nt
	name = "Bartender - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/bartender/nt
	head = /obj/item/clothing/head/bartender/nt
	id = /obj/item/card/id/idris

/datum/outfit/job/chef/nt
	name = "Chef - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/chef/nt
	suit = null

/datum/outfit/job/hydro/nt
	name = "Gardener - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/chef/nt
	head = /obj/item/clothing/head/bandana/hydro/nt
	suit = null

/datum/outfit/job/janitor/nt
	name = "Janitor - NanoTrasen"

	uniform = /obj/item/clothing/under/rank/janitor/nt
	head = /obj/item/clothing/head/softcap/janitor/nt
	suit = null

/datum/outfit/job/librarian/nt
	name = "Librarian - NanoTrasen"

	uniform = /obj/item/clothing/under/librarian/nt

/datum/outfit/job/service_manager/nt
	name = "Service Manager - NanoTrasen"
	jobtype = /datum/job/service_manager

	uniform = /obj/item/clothing/under/rank/service_manager/nt
	head = /obj/item/clothing/head/service_manager/nt
	suit = /obj/item/clothing/suit/storage/service_manager/nt