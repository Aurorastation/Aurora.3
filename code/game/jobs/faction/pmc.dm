/datum/faction/pmc
	name = "Private Military Contracting Group"
	description = {"<p>Essentially the security branch of the Eridani Federation
	Military, the EPMC is renowned for its brutal yet efficient and above all
	legal security functions across the known galaxy. Staying as close as possible
	to the famed Eridanian "Non Aggression Protocol" in which no one within should
	conspire to damage, take part in damaging or incite others to damage corporate
	interests. EPMCs tend to lean heavily towards giving fines to regulation breakers.
	However, when the need to suppress civil disorder appears hell hath no fury like
	that of an Eridian security contractor with a stun baton.
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

