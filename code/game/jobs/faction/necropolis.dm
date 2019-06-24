/datum/faction/necropolis_industries
	name = "Necropolis Industries"
	description = "The largest weapons producer in human space, Necropolis Industries initially found their place with the invention of a militarized RIG suit for use in the Interstellar War. With many extraordinarily weapons contracts thanks to SolGov, as well as acquisitions of other major armaments companies, Necropolis Industries weapons can be found in the hands of nearly every military force across the Orion Spur. They are prominently associated with the Empire of Dominia, and are at the forefront of genetic modification technology."
	title_suffix = "Necrp"

	allowed_role_types = list(
		/datum/job/officer = TRUE,
		/datum/job/warden = TRUE,
		/datum/job/doctor = TRUE,
		/datum/job/pharmacist  = TRUE,
		/datum/job/scientist = TRUE,
		/datum/job/roboticist = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/necropolis,
		"Warden" = /datum/outfit/job/warden/necropolis,
		"Medical Doctor" = /datum/outfit/job/doctor/necropolis,
		"Pharmacist" = /datum/outfit/job/pharmacist/necropolis,
		"Medical Doctor" = /datum/outfit/job/doctor/necropolis,
		"Scientist" = /datum/outfit/job/scientist/necropolis,
		"Roboticist" = /datum/outfit/job/roboticist/necropolis
	)

/datum/outfit/job/officer/necropolis
	name = "Security Officer - Necropolis"
	uniform = /obj/item/clothing/under/rank/security/necropolis

/datum/outfit/job/warden/necropolis
	name = "Warden - Necropolis"
	uniform = /obj/item/clothing/under/rank/security/necropolis

/datum/outfit/job/doctor/necropolis
	name = "Medical Doctor - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis

/datum/outfit/job/pharmacist/necropolis
	name = "Pharmacist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis

/datum/outfit/job/pharmacist/necropolis
	name = "Pharmacist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis

/datum/outfit/job/scientist/necropolis
	name = "Scientist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis

/datum/outfit/job/roboticist/necropolis
	name = "Roboticist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis
