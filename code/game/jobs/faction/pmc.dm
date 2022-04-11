/datum/faction/pmc
	name = "Private Military Contracting Group"
	description = {"<p>
	A coalition of security and medical contractors in service of the Stellar Corporate Conglomerate. The Private Military Contracting Group is one of the elements born from
	the necessity of protecting an ever-growing corporate empire. Gathering mercenaries from all across the spur, the PMCG deploys a diverse force to anywhere they are needed; from mere
	office buildings to outposts in the Corporate Reconstruction Zone. As the megacorporations expand, these contractors follow to secure their holdings.
	Unlike the other members of the Corporate Conglomerate, the Private Military Contracting Group has few employees of its own. Only some liaisons and bureaucrats work behind the scenes to
	hire and manage the contractors. The rest of its members are in fact part of several organizations contracted to supply the PMCG.
	</p>
	<p>Private Military Contracting Group employees can be in the following departments:
	<ul>
	<li><b>Security</b>
	<li><b>Medical</b>
	</ul></p>
	"}
	title_suffix = "Pmcg"

	allowed_role_types = PMC_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/machine
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_DIONA,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_UNATHI
		)
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/pmc,
		"Warden" = /datum/outfit/job/warden/pmc,
		"Security Cadet" = /datum/outfit/job/intern_sec/pmc,
		"Investigator" =/datum/outfit/job/forensics/pmc,
		"Physician" = /datum/outfit/job/doctor/pmc,
		"Surgeon" = /datum/outfit/job/doctor/surgeon/pmc,
		"Pharmacist" = /datum/outfit/job/pharmacist/pmc,
		"Psychiatrist" = /datum/outfit/job/psychiatrist/pmc,
		"Psychologist" = /datum/outfit/job/psychiatrist/pmc,
		"First Responder" = /datum/outfit/job/med_tech/pmc,
		"Medical Intern" = /datum/outfit/job/intern_med/pmc,
		"Corporate Liaison" = /datum/outfit/job/representative/pmc
	)

/datum/outfit/job/officer/pmc
	name = "Security Officer - PMC"

	uniform = /obj/item/clothing/under/rank/security/pmc
	id = /obj/item/card/id/pmc

/datum/outfit/job/warden/pmc
	name = "Warden - PMC"

	head = /obj/item/clothing/head/warden/pmc
	uniform = /obj/item/clothing/under/rank/warden/pmc
	id = /obj/item/card/id/pmc

/datum/outfit/job/intern_sec/pmc
	name = "Security Cadet - PMC"

	uniform = /obj/item/clothing/under/rank/cadet/pmc
	suit = null
	id = /obj/item/card/id/pmc

/datum/outfit/job/forensics/pmc
	name = "Investigator - PMC"

	uniform = /obj/item/clothing/under/det/pmc
	suit = /obj/item/clothing/suit/storage/det_jacket/pmc
	id = /obj/item/card/id/pmc

/datum/outfit/job/doctor/pmc
	name = "Physician - PMC"

	uniform = /obj/item/clothing/under/rank/medical/pmc
	suit = null
	id = /obj/item/card/id/pmc

/datum/outfit/job/doctor/surgeon/pmc
	name = "Surgeon - PMC"

	uniform = /obj/item/clothing/under/rank/medical/surgeon/pmc
	head = /obj/item/clothing/head/surgery/pmc
	suit = null
	id = /obj/item/card/id/pmc

/datum/outfit/job/pharmacist/pmc
	name = "Pharmacist - PMC"

	uniform = /obj/item/clothing/under/rank/pharmacist/pmc
	suit = null
	id = /obj/item/card/id/pmc

/datum/outfit/job/psychiatrist/pmc
	name = "Psychiatrist - PMC"

	uniform = /obj/item/clothing/under/rank/psych/pmc
	id = /obj/item/card/id/pmc

/datum/outfit/job/med_tech/pmc
	name = "First Responder - PMC"

	head = /obj/item/clothing/head/softcap/medical/pmc
	uniform = /obj/item/clothing/under/rank/medical/first_responder/pmc
	id = /obj/item/card/id/pmc

/datum/outfit/job/intern_med/pmc
	name = "Medical Intern - PMC"

	uniform = /obj/item/clothing/under/rank/medical/intern/pmc
	id = /obj/item/card/id/pmc

/datum/outfit/job/representative/pmc
	name = "PMC Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/security/eridani/alt
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/pmc