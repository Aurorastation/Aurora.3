/datum/faction/idris_incorporated
	name = "Idris Incorporated"
	description = "The Orion Spur’s largest interstellar banking conglomerate, Idris Incorporated is operated by the mysterious Idris family. Idris Incorporated’s influence can be found in nearly every corner of human space with their financing of nearly every type of business and enterprise. Their higher risk ventures have payment enforced by the infamous Idris Reclamation Units, shell IPCs sent to claim payment from negligent loan takers. In recent years, they have begun diversifying into more service-based industries."
	title_suffix = "Idris"

	allowed_role_types = list(
		/datum/job/officer = TRUE,
		/datum/job/bartender = TRUE,
		/datum/job/chef = TRUE,
		/datum/job/hydro = TRUE,
		/datum/job/cargo_tech = TRUE,
		/datum/job/representative = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/tajaran
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/idris,
		"Bartender" = /datum/outfit/job/bartender/idris,
		"Chef" = /datum/outfit/job/chef/idris,
		"Gardener" = /datum/outfit/job/hydro/idris,
		"Cargo Technician" = /datum/outfit/job/cargo_tech/idris,
		"Corporate Liaison" = /datum/outfit/job/representative/idris
	)

/datum/outfit/job/officer/idris
	name = "Security Officer - Idris"
	uniform = /obj/item/clothing/under/rank/security/idris

/datum/outfit/job/bartender/idris
	name = "Bartender - Idris"
	uniform = /obj/item/clothing/under/rank/idris

/datum/outfit/job/chef/idris
	name = "Chef - Idris"
	uniform = /obj/item/clothing/under/rank/idris

/datum/outfit/job/hydro/idris
	name = "Gardener - Idris"
	uniform = /obj/item/clothing/under/rank/idris

/datum/outfit/job/cargo_tech/idris
	name = "Cargo Technician - Idris"
	uniform = /obj/item/clothing/under/rank/idris

/datum/outfit/job/representative/idris
	name = "Corporate Liaison - Idris"
	uniform = /obj/item/clothing/under/rank/idris
	head = null
	suit = null