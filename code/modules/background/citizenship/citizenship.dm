/datum/citizenship
	var/name
	var/description
	var/datum/outfit/consular_outfit = null
	var/demonym

/datum/citizenship/proc/get_objectives(mission_level)
	var/rep_objectives

	switch(mission_level)
		if("high")
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against employees from [name], to be used as leverage in future diplomatic talks",
							"Convince [rand(1,3)] [demonym] employees to apply for the [demonym] armed forces")

		if("medium")
			rep_objectives = pick("Have [rand(2,5)] amount of [demonym] citizens write down their grievances with the company, and present the report to station command")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure station areas",
							"Convince station command to turn a [demonym] crewmember's sentence into a fine.")


	return rep_objectives