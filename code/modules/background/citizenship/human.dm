/datum/citizenship/tau_ceti
	name = CITIZENSHIP_BIESEL
	description = "The Republic of Biesel is an independent system within the Core of human space. It is heavily tied to the NanoTrasen corporation at nearly every level of government. \
	The Republic of Biesel is the government of the Tau Ceti System, exercising authority over Biesel, New Gibson and all other settlements and installations within Tau Ceti's gravity \
	well. It is one of the most populated systems in human space, a financial center, industrial powerhouse and one of the most prestigious systems in the galaxy. However, unrest and \
	gridlock undermine the government, and the aggressive attitude of the Sol Alliance against its former system has made many worried of the future of the Republic."
	consular_outfit = /datum/outfit/job/representative/consular/ceti

/datum/citizenship/tau_ceti/get_objectives(mob/living/carbon/human/H, mission_level)
	var/rep_objectives

	switch(mission_level)
		if("high")
			rep_objectives = pick("Compile and report and audit [rand(1,3)] suspicious indivduals who might be spies or otherwise act hostile against the Republic",
							"Have [rand(2,6)] crewmembers sign a pledge of loyalty to the Republic")

		if("medium")
			rep_objectives = pick("Sell [rand(2,5)] Tau Ceti residence visas to foreign employees, 2000 credits each.",
							"Convince [rand(3,6)] crewmembers of Tau Ceti superiority over the Sol Alliance")
		else
			rep_objectives = pick("Run a questionnaire on Tau Ceti citizens' views on synthetic citizenship",
							"Run a questionnaire on Tau Ceti citizens' views on vaurca citizenship")


	return rep_objectives

/datum/outfit/job/representative/consular/ceti
	name = "Tau Ceti Consular Officer"

	uniform = /obj/item/clothing/under/lawyer/blue
	backpack_contents = list(
		/obj/item/clothing/accessory/tc_pin = 1,
		/obj/item/weapon/storage/box/ceti_visa = 1,
		/obj/item/weapon/gun/energy/pistol = 1
	)


/datum/citizenship/sol_alliance
	name = CITIZENSHIP_SOL
	description = "An absolute juggernaut in terms of cultural and political influence, the Alliance of Sovereign Solarian Nations (ASSN), commonly referred to as SolGov, the \
	Sol Alliance, and sometimes the Alliance, is a federal union of 125 member state star systems, and 212 dependencies including the Eridani Federation. Dependencies can vary between \
	undeveloped star systems, outposts on asteroids, or even micro-nation space stations. The capital of the Sol Alliance is the bustling Unity Station in orbit over Earth. 52 Alliance \
	states and 25 dependencies are located within the Inner Colonies. The remaining dependencies are located within the Mid Colonies and outer colonies. With control of hundreds of \
	systems and a large population of about 100 billion, the Sol Alliance is by far the largest nation within all of known space. It is arguably the most culturally and linguistically \
	diverse entity within known space, owing primarily to the age of its colonies and its control over the Sol system and Earth."
	consular_outfit = /datum/outfit/job/representative/consular/sol

/datum/citizenship/sol_alliance/get_objectives(mission_level)
	var/rep_objectives

	switch(mission_level)
		if("high")
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Solarian employees, to be used as leverage in future diplomatic talks",
							"Convince [rand(1,3)] solarian employees to apply for the solarian armed forces")

		if("medium")
			rep_objectives = pick("Have [rand(2,5)] amount of Sol citizens write down their grievances with the company, and present the report to station command",
							"Convince [rand(3,6)] human crewmembers to apply for solarian citizenship")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure station areas",
							"Convince station command to turn a solarian crewmember's sentence into a fine.")

	return rep_objectives

/datum/outfit/job/representative/consular/sol
	name = "Sol Consular Officer"

	backpack_contents = list(
		/obj/item/clothing/accessory/sol_pin = 1,
		/obj/item/weapon/storage/box/sol_visa = 1,
		/obj/item/device/camera = 1,
		/obj/item/weapon/gun/projectile/pistol/sol = 1
	)


/datum/citizenship/frontier
	name = CITIZENSHIP_FRONTIER
	description = "Rising from the former Coalition of Colonies, the Frontier Alliance is a loose confederation of united \"entities\" within the human frontier. These entities range \
	from whole colonial systems to travelling super ships to mining and farming outposts. The Frontier’s motto is \"Together We Are\". Though nearly any language can be found in the \
	Frontier, Tau Ceti Basic and Freespeak are the most common."

/datum/citizenship/elyra
	name = CITIZENSHIP_ELYRA
	description = "The Republic of Elyra, or its more official name, The Serene Republic of Elyra, was formed during a large scale colonization and emigration effort from south western \
	asia and northern africa during the early years of space colonization from Pre-Alliance Earth. It is made up of multiple star systems. It's national motto \
	is \"For Greatness We Strive\". It's official language is Tau Ceti Basic, though several old-earth languages cling to life in small enclaves, such as arabic, persian, and farsi."

/datum/citizenship/eridani
	name = CITIZENSHIP_ERIDANI
	description = "Eridani, or the Eridani Corporate Federation, is a dystopic oligarchic republic in the Epsilon Eridani system dominated entirely by a council of mega-corporations \
	that seek profit and expansion at any cost. It's capital is the planet of Oran, inside a sprawling corporate headquarters the size of a small city. It's citizens are called \
	Eridanians. The primary languages are Sol Common and Tradeband for the upper class Corporates, and Gutter for the lower class Dregs."

/datum/citizenship/dominia
	name = CITIZENSHIP_DOMINIA
	description = "A heavily religious absolute monarchy with its capital, Nova Luxembourg, on the planet of Dominia in the X’yr Vharn’p system. This autocratic state is ruled by \
	His Imperial Majesty Boleslaw Keeser. The Empire of Dominia was proclaimed in 2437 by Unathi raiders who invaded the planet of Moroz, a colony which had been isolated for hundreds \
	of years. Imperial society is dominated by the Great and Minor Houses under the Emperor and is very socio-economically stratified due to the so-called blood debt, known as the \
	Mor’iz’al. All citizens are born with the Mor’iz’al debt in exchange for the privileges of citizenship, a debt that takes a lifetime or more to pay off. Indebted citizens are known \
	as Ma’zals, forming the massive underclass in Dominia. Many in the Empire follow a strict code of honor. The Empire of Dominia is considered by many to be a threat to the \
	sovereignty of Frontier systems."
