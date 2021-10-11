/datum/faction/pmc
	name = "Eridani Private Military Contractors"
	description = {"<p>Essentially the security branch of the Eridani Federation
	Military, the EPMC is renowned for its brutal yet efficient and above all
	legal security functions across the known galaxy. Staying as close as possible
	to the famed Eridanian "Non Aggression Protocol" in which no one within should
	conspire to damage, take part in damaging or incite others to damage corporate
	interests. EPMCs tend to lean heavily towards giving fines to regulation breakers.
	However, when the need to suppress civil disorder appears hell hath no fury like
	that of an Eridian security contractor with a stun baton.
	</p>
	<p>Some character examples are:
	<ul>
	<li><b>Eridanian Private Military Contractor</b>: You are the law, civil disorder
	damages the bottom line. Everyone knew what they signed up for when they chose
	to be employed with NanoTrasen thus rule breakers are violating the NAP which
	you cannot abide. That being said you're here to make a profit and stuffing
	someone in a cell is a waste of human resources - think of the money lost in
	time! Abhorrent! The best thing to do is fine perpetrators and set them back
	to work. Remember, your fine quota still applies, you don't want to miss out on
	your bonus because you didn't hit target. After all, it is a substantial bonus.</li>
	</ul></p>"}
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

