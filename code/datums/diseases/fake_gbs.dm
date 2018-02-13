/datum/disease/fake_gbs
	name = "GBS"
	max_stages = 5
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Synaptizine & Sulfur"
	cure_id = list("synaptizine","sulfur")
	agent = "Gravitokinetic Bipotential SADS-"
	affected_species = list("Human", "Monkey")
	desc = "If left untreated death will occur."
	severity = "Major"

/datum/disease/fake_gbs/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1))
				send_emote("sneeze",affected_mob)
		if(3)
			if(prob(5))
				send_emote("cough",affected_mob)
			else if(prob(5))
				send_emote("gasp",affected_mob)
			if(prob(10))
				affected_mob << "<span class='warning'>You're starting to feel very weak...</span>"
		if(4)
			if(prob(10))
				send_emote("cough",affected_mob)

		if(5)
			if(prob(10))
				send_emote("cough",affected_mob)
