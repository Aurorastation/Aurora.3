/datum/faction/hephaestus_industries
	name = "Stellar Corporate Conglomerate"
	description = {"<p>The greatest power of them all</p>"}
	title_suffix = "SCC"

	allowed_role_types = COMMAND_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug,
		/datum/species/tajaran,
		/datum/species/diona
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR
		)
	)
