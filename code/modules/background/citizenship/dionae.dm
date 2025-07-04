/datum/citizenship/consortium
	name = CITIZENSHIP_CONSORTIUM
	description =  "A nation of Hieroaetheria predating Nralakk discovery, the Consortium was a loose confederation of dozens of \
	dionae groups across the region of Mede that have since unified into one alliance. The Consortium prides itself on progressive stances, \
	aiming to foster a multicultural society inclusive of non-Dionae."
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/consortium

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
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
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
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		),
		"Diplomatic Bodyguard" = list(
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
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		)
	)


/obj/outfit/job/diplomatic_bodyguard/consortium
	name = "Consortium of Hieroaetheria Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1
	)

/datum/citizenship/consortium/get_objectives(mission_level, var/mob/living/carbon/human/H)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_LOW)
			var/picked_objective = pick("Hold a meeting to promote the relationship between the Consortium of Hieroaetheria and [SSatlas.current_map.boss_name].", "Secure [rand(2,4)] investments worth a total of [rand(5000,20000)] into the Hieroaetherian company [pick("Biomatik Inovations", "CosmoForge Technologies", "AstroTerra Enterprises")].", "Advertise positions that will be open at the [pick("Hieroaetherian College", "University of Western Mede")] next student intake, available to non-Hieroaetherian dionae and skrell. The university has set aside one scholarship you may award that will cover half of any tuition fees.")
			return picked_objective

/datum/citizenship/glaorr
	name = CITIZENSHIP_GLAORR
	description =  "An affront to the ideals of ther Consortium, the Union of Gla'orr is autocratic and xenophobic, opposed to the integration of non-Dionae \
	into Hieroaetherian societies. Though opposed to the ideals of the Consortium and though wishing a more secular handling of issues compared to Ekane, \
	they continue to engage in diplomatic relations with the other nations of the Commonwealth."
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/glaorr

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_SKRELL,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		),
		"Diplomatic Aide" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_SKRELL,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		),
		"Diplomatic Bodyguard" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_SKRELL,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		)
	)

/obj/outfit/job/diplomatic_bodyguard/glaorr
	name = "Union of Gla'orr Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1
	)

/datum/citizenship/glaorr/get_objectives(mission_level, var/mob/living/carbon/human/H)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_LOW)
			var/picked_objective = pick("Make use of the Entertainment channel to hold a Union broadcast. The suggested topic this broadcast is: [pick("the rich heritage of the Union of Gla'orr", "the elegance of Rootsong, withstanding alien influence to preserve a strong sense of dionae identity", "the importance of unity and solidarity among Union citizens")].", "Instill a sense of pride in any Union of Gla'orr dionae onboard; root out any signs of alien influence.", "Hold a seminar on Rootsong with any dionae onboard. The suggested topic this shift is: [pick("ease of communication in Rootsong", "Rootsong as a symbol of dionae identity", "the eloequence of Gla'orr Received Pronunciation", "bastardisations of Rootsong such as Consortium Standard")].")
			return picked_objective

/datum/citizenship/ekane
	name = CITIZENSHIP_EKANE
	description =  "Founded after first contact with the Nralakk Federation in communities gripped by Eternal thoughts, the Eternal Republic is an autocratic \
	theocracy staunchly against propositions of reform, inclusion of non-dionae, centralisation and deeply entwined with Eternal schools of thoughts, with \
	faith being a central component of all facets of life within the Eternal Republic."
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/ekane

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_SKRELL,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		),
		"Diplomatic Aide" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_SKRELL,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		),
		"Diplomatic Bodyguard" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_SKRELL,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		)
	)

/obj/outfit/job/diplomatic_bodyguard/ekane
	name = "Eternal Republic of The Ekane Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1
	)

/datum/citizenship/ekane/get_objectives(mission_level, var/mob/living/carbon/human/H)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_LOW)
			var/picked_objective = pick("Setup a Rootsong Performance open to any devout Eternal dionae onboard - any Ekanian dionae are to take lead in the performance.", "Identify dionae onboard who do not believe in an Eternal school of thought. Ensure their conversion to the Eternal through thorough proselytisation.", "Ensure Ekanian dionae onboard have not strayed from their Eternal beliefs in their time away from the Eternal Republic.")
			return picked_objective
