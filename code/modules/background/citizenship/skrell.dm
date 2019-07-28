/datum/citizenship/jargon
	name = CITIZENSHIP_JARGON
	description = "A centralized union of solar systems run by councillors of different ranks and positions. They range from running settlements to entire systems, with each being \
	voted with a popular vote. The highest position within the Federation is the Grand Councillor, managing the Federation at large. The capital of the Federation is located at the \
	city of Kal'lo on the core planet Jargon IV within the Jargon system. While the majority of Skrell are living within the Jargon Federation, a sizable portion live in independent \
	nations within the traverse or are living abroad."

/datum/citizenship/jargon/get_objectives(mission_level)
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