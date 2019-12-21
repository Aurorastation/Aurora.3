/datum/faction/eridani_pmc
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
	title_suffix = "EPMC"

	allowed_role_types = list(
		/datum/job/officer,
		/datum/job/warden,
		/datum/job/forensics,
		/datum/job/paramedic,
		/datum/job/representative
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/bug,
		/datum/species/machine
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/eridani,
		"Warden" = /datum/outfit/job/warden/eridani,
		"Forensic Technician" = /datum/outfit/job/forensics/eridani,
		"Crime Scene Investigator" = /datum/outfit/job/forensics/eridani,
		"Paramedic" = /datum/outfit/job/paramedic/eridani,
		"Emergency Medical Technician" = /datum/outfit/job/paramedic/eridani,
		"Corporate Liaison" = /datum/outfit/job/representative/eridani
	)

/datum/outfit/job/officer/eridani
	name = "Security Officer - Eridani"
	uniform = /obj/item/clothing/under/rank/security/eridani
	id = /obj/item/card/id/eridani

/datum/outfit/job/warden/eridani
	name = "Warden - Eridani"
	uniform = /obj/item/clothing/under/rank/security/eridani
	id = /obj/item/card/id/eridani

/datum/outfit/job/forensics/eridani
	name = "Forensic Technician - Eridani"
	uniform = /obj/item/clothing/under/rank/security/eridani
	id = /obj/item/card/id/eridani

/datum/outfit/job/paramedic/eridani
	name = "Paramedic - Eridani"
	uniform = /obj/item/clothing/under/rank/eridani_medic
	id = /obj/item/card/id/eridani

/datum/outfit/job/representative/eridani
	name = "Eridani Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/security/eridani/alt
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/eridani