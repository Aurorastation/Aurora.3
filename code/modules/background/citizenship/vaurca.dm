/datum/citizenship/zora
	name = CITIZENSHIP_ZORA
	description = "Zo'ra, the largest and most powerful hive, and also the first one discovered by Humanity following their Hive-ship 'Titan Prime.' Information gained through contact \
	with Vaurca present in Tau Ceti has lead to unconfirmed projections putting their population in Vaurca space at 77 billion (17.1 million in known space). Zo'ra believe themselves to \
	be the Alpha of the Vaurca and the face of their species. They make up the majority of the Vaurca present in Tau Ceti and human space.Zo'ra have cold relations with other hives. In \
	Tau Ceti, this has lead to confrontations between them and other hives arriving in the system. The Zo'ra are the most politically developed hive, recently helping in the funding of \
	the Tau Ceti Foreign Legion, and making active progress to spread their influence."
	demonym = "vaurcasian"

/datum/citizenship/zora/get_objectives(mission_level)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of Nanotrasen being unfair or bigoted to Vaurca employees, to be used as leverage in future hive labor negotiations",
							"Begin the TCFL enlistment process for an individual, completing an Enlistment form to be turned in by the individual,"
							"Develop a metric to grade the performance of different Vaurca broods that share a job")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Assist Zo'ra Nanotrasen personnel in their avowal process",
							"Promote [rand(3,6)] amount of Zo'rane products, be it energy drinks or merchandise",
							"Sell [rand(2,5)] copies of the Tau Ceti Foreign Legion infobook, 10 credits each")
		else
			rep_objectives = pick("Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement",
							"Protect and promote the public image of the Zo'ra hive to all Nanotrasen employees",
							"Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement")

	return rep_objectives
