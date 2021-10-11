/datum/faction/zavodskoi_interstellar
	name = "Zavodskoi Interstellar"
	description = {"<p>
	The largest weapons producer in human space, Zavodskoi Interstellar initially
	found its place with the invention of a militarized voidsuit for use in the Interstellar War.
	With many extraordinarily weapons contracts thanks to the Sol Alliance, as well as acquisitions of
	other major armaments companies, Zavodskoi weapons can be found in the hands of nearly every
	military force across the Orion Spur. They are the main corporation found in the Empire of
	Dominia, and are at the forefront of weapons development technology.
	</p>
	<p>Zavodskoi Interstellar employees can be in the following departments:
	<ul>
	<li><b>Security</b>
	<li><b>Research</b>
	<li><b>Engineering</b>
	</ul></p>"}"}

	title_suffix = "Zavod"

	allowed_role_types = ZAVOD_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/unathi,
		/datum/species/diona,
		/datum/species/machine
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_IPC,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_SHELL,
			SPECIES_UNATHI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN
		)
	)

