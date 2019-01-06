/datum/disease/blackdeath
	name = "The Black Death"
	max_stages = 3
	spread = "Airborne"
	cure = "Spaceacillin"
	cure_id = "spaceacillin"
	cure_chance = 10
	agent = "Bl3ck V3tosi"
	affected_species = list("Human", "Monkey")
	permeability_mod = 0.75
	desc = "If left untreated the subject will feel a insane fever and slowly succumb into a coma. Caused by eating mice" //Mice shaming is a good thing --Drago
	severity = "Medium"

/datum/disease/blackdeath/stage_act()
	..()
	switch(stage)
		if(2)

			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "<span class='warning'>Your muscles ache.</span>"
				if(prob(20))
					affected_mob.take_organ_damage(2)
			if(prob(1))
				affected_mob << "<span class='warning'>Your stomach hurts.</span>"
				if(prob(20))
					affected_mob.adjustToxLoss(1)
					affected_mob.updatehealth()
					affected_mob.adjustHalLoss(20)

		if(3)

			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "<span class='warning'>Your muscles ache.</span>"
				if(prob(20))
					affected_mob.take_organ_damage(1)
					affected_mob.adjustHalLoss(20)
					affected_mob.say( pick( list("AAAARRRGGHGHHHH", "...ffff.a.aahhh", "*groans*", "euaaycch!") ) )
			if(prob(1))
				affected_mob << "<span class='warning'>Your stomach hurts.</span>"
				if(prob(20))
					affected_mob.adjustToxLoss(1)
					affected_mob.updatehealth()
					affected_mob.adjustHalLoss(20)
			if(prob(5))
				affected_mob << "<span class='warning'>You slowly fall asleep sleep.</span>"
				affected_mob.Weaken(15)
				affected_mob.adjustOxyLoss(5)
				affected_mob.vomit()

			if(prob(10))
				affected_mob << "<span class='warning'>You break into a deep sweat, screaming in agony.</span>"
				affected_mob.vomit()
				affected_mob.dizziness += 20
				affected_mob.confused += 20
				affected_mob.Jitter(20)
				affected_mob.adjustHalLoss(20)
				affected_mob.say( pick( list("AAAARRRGGHGHHHH", "...ffff.a.aahhh", "*groans*", "euaaycch!") ) )

	return