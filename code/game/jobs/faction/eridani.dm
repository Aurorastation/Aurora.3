/datum/faction/eridani_pmc
	name = "Eridani Private Military Contractors"
	description = {"Essentially the security branch of the Eridani Federation Military, the EPMC is renowned for its brutal yet efficient and above all legal security functions across the known galaxy. Staying as close as possible to the famed Eridanian "Non Aggression Protocol" in which no one within should conspire to damage, take part in damaging or incite others to damage corporate interests. EPMCs tend to lean heavily towards giving fines to regulation breakers. However, when the need to suppress civil disorder appears hell hath no fury like that of an Eridian security contractor with a stun baton."}
	title_suffix = "EPMC"

	allowed_role_types = list(
		/datum/job/officer = TRUE,
		/datum/job/warden = TRUE,
		/datum/job/forensics = TRUE,
		/datum/job/paramedic = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/bug
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/eridani,
		"Warden" = /datum/outfit/job/warden/eridani,
		"Forensic Technician" = /datum/outfit/job/forensics/eridani,
		"Paramedic" = /datum/outfit/job/paramedic/eridani
	)

/datum/outfit/job/officer/eridani
	uniform = /obj/item/clothing/under/rank/security/eridani

/datum/outfit/job/warden/eridani
	uniform = /obj/item/clothing/under/rank/security/eridani

/datum/outfit/job/forensics/eridani
	uniform = /obj/item/clothing/under/rank/security/eridani

/datum/outfit/job/paramedic/eridani
	uniform = /obj/item/clothing/under/rank/security/eridani/alt
