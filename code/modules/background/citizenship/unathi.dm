/datum/citizenship/izweski
	name = CITIZENSHIP_IZWESKI
	description = "The Hegemony is a feudal empire ruled by the Izweski Clan. Underneath the Hegemon, who rules from the homeworld of Moghes, there are colony worlds ruled by Overlords. \
	Under Overlords land on planets are divided between Lords, with the rest of the feudal hierarchy being beneath them. The Clan system is deeply entrenched in Unathi society, \
	with everything else revolving around it. It forms a major part of their code of honor, which stresses the importance of martial abilities and loyalty to the Clan. Despite an \
	apocalyptic world war that nearly plunged the species into ruin, the Izweski Hegemony has rebounded and is currently working on making the Hegemony a galactic power."
	consular_outfit = /datum/outfit/job/representative/consular/izweski

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
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

/datum/citizenship/izweski/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			if(isvaurca(H))
				rep_objectives = pick("Obtain [rand(2,3)] sheets of solid phoron below market value, buying directly from the source")
			else
				rep_objectives = pick("Encourage [rand(1,2)] Unathi to become Zo'saa by signing up with the local Order",
								"Gather [rand(2,3)] evidences of any marginalization of Unathi beliefs")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			if(isvaurca(H))
				rep_objectives = pick("Collect evidence of the [current_map.boss_name] being unfair or bigoted to Vaurca or Unathi Employees, to be used as leverage in future labor negotiations",
								"Upsell K'laxan Vaurca to different command staff. Have one complete a Bound Vaurca requisition form")
			else
				rep_objectives = pick("Speak out against any violation of the Honor Code to or by Unathi on the [current_map.station_short]",
								"Proselytize the Sk'akh or Tha'kh religions to the crew",
								"Encourage [rand(2,4)] Unathi to visit the Akhandi Order temples in Tau Ceti")
		else
			if(isvaurca(H))
				rep_objectives = pick("Promote Cultural Exchange between Vaurca, Unathi and other species")
			else
				rep_objectives = pick("Ensure all Unathi on the  are being respected in their beliefs and customs and traditions",
								"Discourage people from associating with Guwans, but convince [rand(2,3)] Guwan to redeem themselves by becoming Zo'saa or Ahkandi")

	return rep_objectives

/datum/outfit/job/representative/consular/izweski
	name = "Izweski Hegemony Consular Officer"

	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/accessory/poncho/unathimantle
	backpack_contents = list(/obj/item/device/camera = 1)
	belt = /obj/item/gun/energy/pistol/hegemony
