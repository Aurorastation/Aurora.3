/datum/faction/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	description = {"<p>
	Zeng-Hu Pharmaceuticals, born of a merger of two major biotech companies on
	Earth in 2032, was the first to successfully develop cryogenics in the 21st
	century for the purposes of space travel. This development, crucial to
	interstellar colonization, helped propel them to their current position as the
	largest pharmaceutical and medical corporation in the Orion Spur. In more recent
	years, they were also the first mega-corporation to partner with the newly-discovered
	Skrell, working closely with this alien species to pioneer cloning, a once
	controversial field that is now more accepted today.
	</p>
	<p>Zeng-Hu Pharmaceuticals employees can be in the following departments:
	<ul>
	<li><b>Science</b>
	<li><b>Medical</b>
	</ul></p>"}


	title_suffix = "Zeng"

	allowed_role_types = HEPH_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_e = TRUE,
		/datum/species/diona
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_UNATHI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR
		)
	)

