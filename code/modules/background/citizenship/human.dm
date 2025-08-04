/datum/citizenship/tau_ceti
	name = CITIZENSHIP_BIESEL
	description = "The Republic of Biesel is an independent system within the Core of human space. It is heavily tied to the NanoTrasen corporation at nearly every level of government. \
	It is one of the most populated systems in human space, a financial center, industrial powerhouse and one of the most prestigious systems in the galaxy. It is also very known for \
	its large xeno population which enjoys various privileges compared to other space powers. With a very lax migration policy, virtually everyone is welcome to live here. However, \
	unrest and gridlock undermine the government, and the aggressive attitude of the Sol Alliance against its former system has made many worried for the future of the Republic."
	consular_outfit = /obj/outfit/job/representative/consular/ceti
	assistant_outfit = /obj/outfit/job/diplomatic_aide/ceti

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK
		),
		"Diplomatic Aide" = list(
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Bodyguard" = list(
			SPECIES_VAURCA_WORKER
		)
	)

/datum/citizenship/tau_ceti/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			if(isvaurca(H))
				rep_objectives = pick("Compile and report and audit [rand(1,3)] suspicious indivduals who might be spies or otherwise act hostile against the Republic.",
								"Collect evidence of the [SSatlas.current_map.boss_name] being unfair or bigoted to Vaurca employees, to be used as leverage in future hive labor negotiations.",
								"Convince the command of the [SSatlas.current_map.station_name] of the utility of Bound labor over similar alternatives such as cyborgs or owned synthetics.")
			else
				rep_objectives = pick("Compile and report and audit [rand(1,3)] suspicious indivduals who might be spies or otherwise act hostile against the Republic.",
								"Have [rand(2,6)] crewmembers sign a pledge of loyalty to the Republic.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			if(isvaurca(H))
				rep_objectives = pick("Promote the superiority of the Republic of Biesel over the Sol Alliance.",
								"Encourage non-citizens to seek citizenship in the Republic via enlistment in the Tau Ceti Foreign Legion.",
								"Promote Zo'rane products such as Zo'ra Soda to the crew.")
			else
				rep_objectives = pick("Convince [rand(2,4)] Tau Ceti crewmembers who are not a part of Command or Security to join the Tau Ceti Foreign Legion.",
								"Convince [rand(3,6)] crewmembers of Tau Ceti superiority over the Sol Alliance.")
		else
			if(isvaurca(H))
				rep_objectives = pick("Run a questionanaire on Tau Ceti citizens' views on Vaurca citizenship.",
								"Question non-Vaurca employees about their Vaurca coworkers, looking for areas of improvement.",
								"Protect and promote the public image of the Zo'ra Hive to all [SSatlas.current_map.boss_name] employees.")
			else
				rep_objectives = pick("Run a questionnaire on Tau Ceti citizens' views on synthetic citizenship.",
								"Run a questionnaire on Tau Ceti citizens' views on vaurca citizenship.")


	return rep_objectives

/obj/outfit/job/representative/consular/ceti
	name = "Tau Ceti Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/navy
	accessory = /obj/item/clothing/accessory/tc_pin
	backpack_contents = list(
		/obj/item/storage/box/ceti_visa = 1,
		/obj/item/storage/box/tcaf_pamphlet = 1,
		/obj/item/device/versebook/biesel = 1, //constitution
		/obj/item/stamp/biesel = 1,
	)

/obj/outfit/job/diplomatic_aide/ceti
	name = "Tau Ceti Diplomatic Aide"
	accessory = /obj/item/clothing/accessory/tc_pin

/obj/outfit/job/diplomatic_bodyguard/ceti
	name = "Tau Ceti Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/gun/energy/blaster/revolver
	)

/obj/outfit/job/representative/consular/ceti/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H)
		if(isvaurca(H))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/gearharness(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/biesel(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec(H), slot_back)
		if(!visualsOnly)
			addtimer(CALLBACK(src, .proc/send_representative_mission, H), 5 MINUTES)
	return TRUE

/datum/citizenship/sol_alliance
	name = CITIZENSHIP_SOL
	description = "Once considered a juggernaut in terms of cultural and political influence, the Alliance of Sovereign Solarian Nations (ASSN), commonly referred to as the Sol Alliance, has greatly declined in the wake of the phoron crisis and the Solarian collapse of 2462. \
	Once the spur's largest interstellar power, in recent times the Sol Alliance has retreated to its wealthy so-called Jewel Worlds and inner colonies, with its reach barely extending to a few select middle colonies. \
	However, it still controls the largest human military in the entire spur, and their cooperation with Einstein Engines and the Nralakk Federation has contributed to it gradually regaining some of its pre-collapse influence and power. \
	Presently ruled by a military junta that is gradually giving way to civilian control, the Alliance is also generally xenophobic, and most non-humans find themselves discriminated against in Solarian territory. \
	Though much of its former possessions are now occupied by warlord statelets and other interstellar powers, the Alliance still maintains a revanchist outlook, refusing to relinquish its claims to its lost territories."
	consular_outfit = /obj/outfit/job/representative/consular/sol
	assistant_outfit = /obj/outfit/job/diplomatic_aide/sol
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/sol
	job_species_blacklist = list(
		"Consular Officer" = list(
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
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Aide" = list(
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
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Bodyguard" = list(
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
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

/datum/citizenship/sol_alliance/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of the [SSatlas.current_map.boss_name] being unfair or oppressive against Solarian employees, to be used as leverage in future diplomatic talks.",
							"Convince [rand(1,3)] Solarian employees to apply for the Solarian Armed Forces.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Have [rand(2,5)] amount of Sol citizens write down their grievances with the company, and present the report to [SSatlas.current_map.station_short] command.",
							"Convince [rand(3,6)] qualified specialists among crew to enter Sol Alliance space, and issue them a visa recommendation.")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure [SSatlas.current_map.station_short] areas.",
							"Convince Horizon command to turn a Solarian crewmember's sentence into a fine.")

	return rep_objectives

/obj/outfit/job/representative/consular/sol
	name = "Sol Consular Officer"

	accessory = /obj/item/clothing/accessory/sol_pin
	backpack_contents = list(
		/obj/item/storage/box/sol_visa = 1,
		/obj/item/stamp/sol = 1,
		/obj/item/device/camera = 1
	)

/obj/outfit/job/diplomatic_aide/sol
	name = "Sol Consular Officer"

	accessory = /obj/item/clothing/accessory/sol_pin

/obj/outfit/job/diplomatic_bodyguard/sol
	name = "Sol Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/gun/projectile/pistol/sol = 1
	)

/datum/citizenship/sol_alliance/eridani
	name = CITIZENSHIP_ERIDANI
	description = "Eridani, or the Eridani Corporate Federation, is a dystopian oligarchic republic in the Epsilon Eridani system, dominated entirely by a council of mega-corporations \
	that seek profit and expansion at any cost. It is characterized by a stark class divide, with citizens falling into one into two groups - pristine, inoffensive and rich Corporates, \
	and poor, yet free-willed and provocative Dregs. The Federation is controlled by several megacorporations, and although NanoTrasen is not one of them, it is a common former \
	workplace of various contractors on-board."

	job_species_blacklist = list(
		"Consular Officer" = ALL_SPECIES,
		"Diplomatic Aide" = ALL_SPECIES
	)

/datum/citizenship/coalition
	name = CITIZENSHIP_COALITION
	description = "The Coalition of Colonies is a loose confederation of united \"entities\" within the human frontier. These entities range \
	from whole colonial systems to travelling super ships to mining and farming outposts. Most communities here are, although not as developed as many galactic powers, very \
	tightly-knit. Almost anything and anyone can be found in these wild, mostly uncharted lands. "
	demonym = "frontiersman"
	consular_outfit = /obj/outfit/job/representative/consular/coalition
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/coalition

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Aide" = list(
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Bodyguard" = list(
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

/obj/outfit/job/representative/consular/coalition
	name = "Coalition Consular Officer"

	backpack_contents = list(
		/obj/item/device/camera = 1
	)

/obj/outfit/job/diplomatic_bodyguard/coalition
	name = "Coalition Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/gun/projectile/xanupistol = 1
	)

/datum/citizenship/elyra
	name = CITIZENSHIP_ELYRA
	description = "The Republic of Elyra, or its more official name, The Serene Republic of Elyra, was formed during a large scale colonization and emigration effort from south \
	western asia and northern africa during the early years of space colonization from Pre-Alliance Earth. It is made up of multiple star systems. It's national motto \
	is \"For Greatness We Strive\". It's official language is Tau Ceti Basic, though several old-earth languages cling to life in small enclaves, such as arabic, persian, and farsi. \
	The Republic has mixed relations with NanoTrasen, due to their own possession of phoron."
	demonym = "elyran"
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/elyra


/obj/outfit/job/diplomatic_bodyguard/elyra
	name = "Elyra Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/gun/projectile/plasma/bolter/pistol = 1
	)

/datum/citizenship/elyran_ncp
	name = CITIZENSHIP_ELYRA_NCP
	description = "\"Non-Citizen Persons,\" (NCPs) as they are officially called, make-up approximately one-third of the total population of the Republic Elyra. \
					Most of these people are poor migrant labourers from the less wealthy planets in the Coalition of Colonies or the stateless Human Frontier. \
					They are often unskilled and undereducated, coming to Elyra in order to make enough money to send back home as remittances to their families, \
					or alternatively to save up enough money to return to their homeworlds with enough cash to make their lives there. their lack of citizenship \
					shuts them out of the Elyran public health and education systems, and grossly restricts the amount of influences they have on Elyran society, \
					having little to no legal representation in most courts of law either. They cannot vote and are not provided with any of the other benefits \
					that the average Elyran citizens enjoys."
	demonym = "elyran non-citizen person"
	consular_outfit = null
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
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

/datum/citizenship/dominia
	name = CITIZENSHIP_DOMINIA
	description = "A heavily religious absolute monarchy with its capital, Nova Luxembourg, on the planet of Moroz in the Mira Sancta system. This autocratic state is ruled by \
	His Imperial Majesty Boleslaw Keeser. The Empire of Dominia was proclaimed in 2385 by then-Emperor Godwin Keeser, unifying a colony which had been isolated for hundreds of years. \
	Imperial society is dominated by the Great and Minor Houses under the Emperor and is very socio-economically stratified due to the so-called blood debt, known as the Mor'iz'al."

	consular_outfit = /obj/outfit/job/representative/consular/dominia
	bodyguard_outfit = /obj/outfit/job/diplomatic_bodyguard/dominia

	job_species_blacklist = list(
		"Consular Officer" = list(
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
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Aide" = list(
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
			SPECIES_VAURCA_BREEDER
		),
		"Diplomatic Bodyguard" = list(
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
			SPECIES_VAURCA_BREEDER
		)
	)

/datum/citizenship/dominia/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Have [rand(2,5)] employees write their grievances with the stationbounds and IPC workers, and present the report to Horizon command.",
							"Convince [rand(2,5)] crewmembers of Moroz Holy Tribunal being the superior religion.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Promote and distribute the copies of Dominian Code of Honor to [rand(3,6)] crewmembers.",
							"Convince a Dominian citizen to return to the Empire with valuable information on the [SSatlas.current_map.boss_name] to present.")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure vessel areas.",
							"Convince [rand(3,6)] crewmembers to apply for a Dominian tourist visa.")

	return rep_objectives

/obj/outfit/job/representative/consular/dominia
	name = "Empire of Dominia Consular Officer"

	head = /obj/item/clothing/head/dominia
	suit = /obj/item/clothing/suit/storage/dominia/consular/coat
	uniform = /obj/item/clothing/under/dominia/consular

	backpack_contents = list(
		/obj/item/storage/box/dominia_honor = 1
	)

/obj/outfit/job/diplomatic_bodyguard/dominia
	name = "Empire of Dominia Diplomatic Bodyguard"
	backpack_contents = list(
		/obj/item/gun/projectile/pistol/dominia = 1
	)
