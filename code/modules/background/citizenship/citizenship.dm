/datum/citizenship
	var/name
	var/description
	var/datum/outfit/consular_outfit = /datum/outfit/job/representative/consular
	var/demonym
	var/list/job_species_blacklist = list()

/datum/citizenship/proc/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of the [current_map.boss_name] being unfair or oppressive against employees from [name], to be used as leverage in future diplomatic talks",
							"Convince [rand(1,3)] [demonym] employees to apply for the [demonym] armed forces")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Have [rand(2,5)] amount of [demonym] citizens write down their grievances with the company, and present the report to vessel command")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure vessel areas",
							"Convince Horizon command to turn a [demonym] crewmember's sentence into a fine")


	return rep_objectives
