/datum/citizenship/izweski
	name = CITIZENSHIP_IZWESKI
	description = "The Hegemony is a feudal empire ruled by the Izweski Clan. Underneath the Hegemon, who rules from the homeworld of Moghes, there are colony worlds ruled by Overlords. \
	Under Overlords land on planets are divided between Lords, with the rest of the feudal hierarchy being beneath them. The Clan system is deeply entrenched in Unathi society, \
	with everything else revolving around it. It forms a major part of their code of honor, which stresses the importance of martial abilities and loyalty to the Clan. Despite an \
	apocalyptic world war that nearly plunged the species into ruin, the Izweski Hegemony has rebounded and is currently working on making the Hegemony a galactic power."
	consular_outfit = /obj/outfit/job/representative/consular/izweski
	assistant_outfit = /obj/outfit/job/diplomatic_aide/izweski

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
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
		),
		"Diplomatic Aide" = list(
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
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_VAURCA_BREEDER
		)
	)

/datum/citizenship/izweski/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			if(isvaurca(H))
				rep_objectives = pick("Obtain [rand(2,3)] sheets of solid phoron below market value, buying directly from the source.",
								"Compile and report information on Hegemony citizens who could potentially harbor anti-Izweski sentiment.",
								"Promote the advantages of K'lax engineering to the [SSatlas.current_map.boss_name] in order to invite future investment in the Hegemony.")
			else
				rep_objectives = pick("Encourage [rand(1,2)] Unathi to become Zo'saa by signing up with the local Order",
								"Gather [rand(2,3)] evidences of any marginalization of Unathi beliefs",
								"Compile and report information on Hegemony citizens who could potentially harbor anti-Izweski sentiment.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			if(isvaurca(H))
				rep_objectives = pick("Collect evidence of the [SSatlas.current_map.boss_name] being unfair or bigoted to Vaurca or Unathi Employees, to be used as leverage in future labor negotiations",
								"Upsell K'laxan Vaurca to different command staff. Have one complete a Bound Vaurca requisition form.",
								"Promote K'lax and Unathi culture to the crew of the [SSatlas.current_map.station_name]. Encourage tourism to Izweski space.")
			else
				rep_objectives = pick("Speak out against any violation of the Honor Code to or by Unathi on the [SSatlas.current_map.station_short]",
								"Proselytize the Sk'akh or Tha'kh religions to the crew.",
								"Discourage the Unathi crew of the [SSatlas.current_map.station_name] from the Aut'akh or Si'akh heresies.")
		else
			if(isvaurca(H))
				rep_objectives = pick("Promote Cultural Exchange between Vaurca, Unathi and other species.",
								"Question employees about their K'laxan and Unathi coworkers to discern areas of potential improvement.")
			else
				rep_objectives = pick("Ensure all Unathi on the  are being respected in their beliefs and customs and traditions",
								"Discourage people from associating with Guwans, but convince Guwan to seek atonement and redemption for their crimes.")

	return rep_objectives

/obj/outfit/job/representative/consular/izweski
	name = "Izweski Hegemony Consular Officer"

	uniform = /obj/item/clothing/under/unathi
	backpack_contents = list(/obj/item/device/camera = 1)

/obj/outfit/job/representative/consular/izweski/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H)
		if(isvaurca(H))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/gearharness(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/hegemony(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder/klax(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder/klax(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/klax(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/vaurca/blaster(H), slot_belt) // Hegemony Ta Consulars get a Thermic Blaster.
		else if(H.is_diona())
			H.equip_or_collect(new /obj/item/device/uv_light(src), slot_in_backpack)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/poncho/unathimantle(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/pistol/hegemony(H), slot_belt)
		if(!visualsOnly)
			addtimer(CALLBACK(src, .proc/send_representative_mission, H), 5 MINUTES)
	return TRUE

/obj/outfit/job/diplomatic_aide/izweski
	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/accessory/poncho/unathimantle
