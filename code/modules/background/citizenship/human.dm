/datum/citizenship/tau_ceti
	name = CITIZENSHIP_BIESEL
	description = "The Republic of Biesel is an independent system within the Core of human space. It is heavily tied to the NanoTrasen corporation at nearly every level of government. \
	It is one of the most populated systems in human space, a financial center, industrial powerhouse and one of the most prestigious systems in the galaxy. It is also very known for \
	its large xeno population which enjoys various privileges compared to other space powers. With a very lax migration policy, virtually everyone is welcome to live here. However, \
	unrest and gridlock undermine the government, and the aggressive attitude of the Sol Alliance against its former system has made many worried for the future of the Republic."
	consular_outfit = /datum/outfit/job/representative/consular/ceti

/datum/citizenship/tau_ceti/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Compile and report and audit [rand(1,3)] suspicious indivduals who might be spies or otherwise act hostile against the Republic.",
							"Have [rand(2,6)] crewmembers sign a pledge of loyalty to the Republic.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Convince [rand(2,4)] Tau Ceti crewmembers who are not a part of Command or Security to join the Tau Ceti Foreign Legion.",
							"Convince [rand(3,6)] crewmembers of Tau Ceti superiority over the Sol Alliance.")
		else
			rep_objectives = pick("Run a questionnaire on Tau Ceti citizens' views on synthetic citizenship.",
							"Run a questionnaire on Tau Ceti citizens' views on vaurca citizenship.")


	return rep_objectives

/datum/outfit/job/representative/consular/ceti
	name = "Tau Ceti Consular Officer"

	uniform = /obj/item/clothing/under/lawyer/blue
	accessory = /obj/item/clothing/accessory/tc_pin
	backpack_contents = list(
		/obj/item/storage/box/ceti_visa = 1,
		/obj/item/storage/box/tcfl_pamphlet = 1,
		/obj/item/gun/energy/pistol = 1
	)


/datum/citizenship/sol_alliance
	name = CITIZENSHIP_SOL
	description = "A juggernaut in terms of cultural and political influence, the Alliance of Sovereign Solarian Nations (ASSN), commonly referred to as SolGov or the Sol Alliance is \
	by far the largest nation within all of known space. It is arguably the most culturally and linguistically diverse entity within known space, owing primarily to the age of its \
	colonies and its control over the Sol system and Earth. In recent times, however, Sol Alliance has been failing to hold its grip, and many believe it to be in a state of decline. \
	It is generally authoritarian, and many aliens here find themselves discriminated against."
	consular_outfit = /datum/outfit/job/representative/consular/sol

/datum/citizenship/sol_alliance/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Solarian employees, to be used as leverage in future diplomatic talks.",
							"Convince [rand(1,3)] solarian employees to apply for the Solarian armed forces.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Have [rand(2,5)] amount of Sol citizens write down their grievances with the company, and present the report to station command.",
							"Convince [rand(3,6)] qualified specialists among crew to enter Sol Alliance space, and issue them a visa recommendation.")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure station areas.",
							"Convince station command to turn a Solarian crewmember's sentence into a fine.")

	return rep_objectives

/datum/outfit/job/representative/consular/sol
	name = "Sol Consular Officer"

	accessory = /obj/item/clothing/accessory/sol_pin
	backpack_contents = list(
		/obj/item/storage/box/sol_visa = 1,
		/obj/item/device/camera = 1,
		/obj/item/gun/projectile/pistol/sol = 1
	)

/datum/citizenship/sol_alliance/eridani
	name = CITIZENSHIP_ERIDANI
	description = "Eridani, or the Eridani Corporate Federation, is a dystopian oligarchic republic in the Epsilon Eridani system, dominated entirely by a council of mega-corporations \
	that seek profit and expansion at any cost. It is characterized by a stark class divide, with citizens falling into one into two groups - pristine, inoffensive and rich Corporates, \
	and poor, yet free-willed and provocative Dregs. The Federation is controlled by several megacorporations, and although NanoTrasen is not one of them, it is a common former \
	workplace of various contractors on board NSS Aurora."

/datum/citizenship/frontier
	name = CITIZENSHIP_FRONTIER
	description = "Rising from the former Coalition of Colonies, the Frontier Alliance is a loose confederation of united \"entities\" within the human frontier. These entities range \
	from whole colonial systems to travelling super ships to mining and farming outposts. Most communities here are, although not as developed as many galactic powers, very \
	tightly-knit. Almost anything and anyone can be found in these wild, mostly uncharted lands. "
	demonym = "frontiersman"

/datum/citizenship/elyra
	name = CITIZENSHIP_ELYRA
	description = "The Republic of Elyra, or its more official name, The Serene Republic of Elyra, was formed during a large scale colonization and emigration effort from south \
	western asia and northern africa during the early years of space colonization from Pre-Alliance Earth. It is made up of multiple star systems. It's national motto \
	is \"For Greatness We Strive\". It's official language is Tau Ceti Basic, though several old-earth languages cling to life in small enclaves, such as arabic, persian, and farsi. \
	The Republic has mixed relations with NanoTrasen, due to their own possession of phoron."
	demonym = "elyrian"

/datum/citizenship/dominia
	name = CITIZENSHIP_DOMINIA
	description = "A heavily religious absolute monarchy with its capital, Nova Luxembourg, on the planet of Dominia in the X'yr Vharn'p system. This autocratic state is ruled by His \
	Imperial Majesty Boleslaw Keeser. The Empire of Dominia was proclaimed in 2437 by Unathi raiders who invaded the planet of Moroz, a colony which had been isolated for hundreds of \
	years. Imperial society is dominated by the Great and Minor Houses under the Emperor and is very socio-economically stratified due to the so-called blood debt, \
	known as the Mor'iz'al. All citizens are born with the Mor'iz'al debt in exchange for the privileges of citizenship, a debt that takes a lifetime or more to pay off. \
	Indebted citizens are known as Ma'zals, forming the massive underclass in Dominia. Many in the Empire follow a strict code of honor."
	consular_outfit = /datum/outfit/job/representative/consular/dominia

/datum/citizenship/dominia/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Have [rand(2,5)] employees write their grievances with the stationbounds and IPC workers, and present the report to station command.",
							"Convince [rand(2,5)] crewmembers of Moroz Holy Tribunal being the superior religion.")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Promote and distribute the copies of Dominian Code of Honor to [rand(3,6)] crewmembers.",
							"Convince a Dominian citizen to return to the Empire with valuable information on NanoTrasen to present.")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure station areas.",
							"Convince [rand(3,6)] crewmembers to apply for a Dominian tourist visa.")

	return rep_objectives

/datum/outfit/job/representative/consular/dominia
	name = "Empire of Dominia Consular Officer"

	backpack_contents = list(
		/obj/item/storage/box/dominia_honor = 1,
		/obj/item/gun/energy/pistol = 1
	)
