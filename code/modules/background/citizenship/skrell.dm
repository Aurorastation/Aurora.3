/datum/citizenship/jargon
	name = CITIZENSHIP_JARGON
	description = "Home of the Skrell, a centralized union of solar systems run by councilors of different ranks and positions. The capital of the Federation is located at the city of \
	Kal'lo on the core planet Jargon IV, also known as Querrbalak, within the Jargon system. While the majority of Skrell live within the Jargon Federation, a sizable portion live in \
	independent nations within the Traverse, or abroad. The quality of life within Federation is considered to be the best in the galaxy (due in part to their technological advances \
	and the availability of both C'thur and Dionaea as manual labourers), allowing Federation Citizens to focus on less intensive pursuits. A rogue artificial intelligence, \
	Glorsh-Omega, has traumatized this nation for centuries to come, and the Federation is very wary of humanity, who has acquired AI technology (such as IPCs) after a Federation \
	tech leak."
	consular_outfit = /datum/outfit/job/representative/consular/jargon

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR
		)
	)

/datum/citizenship/jargon/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Some Skrell are not part of the Federation; attempt to convince them to become a citizen",
							"Acquire information on dissidents towards the Federation, forwarding it to the embassy",
							"Curtail the spreading of written literature or verbal notions that contain negative connotations towards the Federation")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Ensure the interests of Federation citizens are upheld by the station. This includes C'thur and Diona of Federation origin",
							"Legally curtail the advancements and liberal thinking towards synthetics",
							"The Aurora hosts some of the brightest minds in the galaxy; winning them over towards the Federation is a major victory")
		else
			rep_objectives = pick("Consider assisting crew within the capacity of your role, an altruistic image is good PR towards the federation",
							"Some Skrell are not part of the Federation; attempt to convince them to become a citizen")

	return rep_objectives

/datum/outfit/job/representative/consular/jargon
	name = "Jargon Consular Officer"

	uniform = /obj/item/clothing/under/skrell