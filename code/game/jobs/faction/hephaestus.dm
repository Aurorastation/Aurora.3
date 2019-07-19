/datum/faction/hephaestus_industries
	name = "Hephaestus Industries"
	description = "Hephaestus Industries, a sprawling and diverse mega-corporation focused on engineering and manufacturing on a massive scale, found their start as a conglomerate of several aerospace companies in the 22nd century. Initially funded by sales of new designs for warp technology, the company fell on hard times during the Second Great Depression in the late 23rd century. Receiving bailouts from SolGov and securing several crucial production contracts, they have slowly worked their way to become the dominant manufacturing mega-corporation in the Sol Alliance, pioneering interstellar logistics and construction on an awe-inspiring scale."
	//icon_file
	title_suffix = "Hepht"

	allowed_role_types = list(
		/datum/job/engineer = TRUE,
		/datum/job/atmos = TRUE,
		/datum/job/scientist = TRUE,
		/datum/job/roboticist = TRUE,
		/datum/job/mining = TRUE,
		/datum/job/cargo_tech = TRUE,
		/datum/job/representative = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug
	)

	titles_to_loadout = list(
		"Station Engineer" = /datum/outfit/job/engineer/hephaestus,
		"Atmospherics Technician" = /datum/outfit/job/atmos/hephaestus,
		"Scientist" = /datum/outfit/job/scientist/hephaestus,
		"Roboticist" = /datum/outfit/job/roboticist/hephaestus,
		"Miner" = /datum/outfit/job/mining/hephaestus,
		"Cargo Technician" = /datum/outfit/job/cargo_tech/hephaestus,
		"Corporate Liaison" = /datum/outfit/job/representative/hephaestus
	)

/datum/outfit/job/engineer/hephaestus
	name = "Station Engineer - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus

/datum/outfit/job/atmos/hephaestus
	name = "Atmospherics Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus

/datum/outfit/job/scientist/hephaestus
	name = "Scientist - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus

/datum/outfit/job/roboticist/hephaestus
	name = "Roboticist - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus

/datum/outfit/job/mining/hephaestus
	name = "Miner - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus

/datum/outfit/job/cargo_tech/hephaestus
	name = "Cargo Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus

/datum/outfit/job/representative/hephaestus
	name = "Corporate Liaison - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus
	head = null
	suit = null
	implants = null
