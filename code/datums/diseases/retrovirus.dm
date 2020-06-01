/datum/disease/dna_retrovirus
	name = "Retrovirus"
	max_stages = 4
	spread = "Contact"
	spread_type = CONTACT_GENERAL
	cure = "Rest or an injection of ryetalyn"
	cure_chance = 6
	agent = ""
	affected_species = list("Human")
	desc = "A DNA-altering retrovirus that scrambles the structural and unique enzymes of a host constantly."
	severity = "Severe"
	permeability_mod = 0.4
	stage_prob = 2
	var/SE
	var/UI
	var/restcure = 0
	New()
		..()
		agent = "Virus class [pick("A","B","C","D","E","F")][pick("A","B","C","D","E","F")]-[rand(50,300)]"
		if(prob(40))
			cure_id = list("ryetalyn")
			cure_list = list("ryetalyn")
		else
			restcure = 1




/datum/disease/dna_retrovirus/stage_act()
	..()
	switch(stage)
		if(1)
			if(restcure)
/*
				if(affected_mob.sleeping && prob(30))  //removed until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
*/
				if(affected_mob.lying && prob(30))  //changed FROM prob(20) until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
			if (prob(8))
				to_chat(affected_mob, SPAN_WARNING("Your head hurts."))
			if (prob(9))
				to_chat(affected_mob, SPAN_WARNING("You feel a tingling sensation in your chest."))
			if (prob(9))
				to_chat(affected_mob, SPAN_WARNING("You feel angry."))
		if(2)
			if(restcure)
/*
				if(affected_mob.sleeping && prob(20))  //removed until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
*/
				if(affected_mob.lying && prob(20))  //changed FROM prob(10) until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
			if (prob(8))
				to_chat(affected_mob, SPAN_WARNING("Your skin feels loose."))
			if (prob(10))
				to_chat(affected_mob, SPAN_WARNING("You feel very strange."))
			if (prob(4))
				to_chat(affected_mob, SPAN_WARNING("You feel a stabbing pain in your head!"))
				affected_mob.Paralyse(2)
			if (prob(4))
				to_chat(affected_mob, SPAN_WARNING("Your stomach churns."))
		if(3)
			if(restcure)
/*
				if(affected_mob.sleeping && prob(20))  //removed until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
*/
				if(affected_mob.lying && prob(20))  //changed FROM prob(10) until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
			if (prob(10))
				to_chat(affected_mob, SPAN_WARNING("Your entire body vibrates."))

			if (prob(35))
				if(prob(50))
					scramble(1, affected_mob, rand(15,45))
				else
					scramble(0, affected_mob, rand(15,45))

		if(4)
			if(restcure)
/*
				if(affected_mob.sleeping && prob(10))  //removed until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
*/
				if(affected_mob.lying && prob(5))  //changed FROM prob(5) until sleeping is fixed
					to_chat(affected_mob, SPAN_NOTICE("You feel better."))
					cure()
					return
			if (prob(60))
				if(prob(50))
					scramble(1, affected_mob, rand(50,75))
				else
					scramble(0, affected_mob, rand(50,75))
