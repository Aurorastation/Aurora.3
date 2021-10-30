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
	title_suffix = "PMC"

	allowed_role_types = NT_ROLES

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

