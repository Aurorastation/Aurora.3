//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Hallucinations"
	desc = "Patient suffers constant hallucinations."
	scan_desc = "schizophrenia"
	gain_text = "<span class='warning'>You feel your grip on reality slipping...</span>"
	lose_text = "<span class='notice'>You feel more grounded.</span>"

/datum/brain_trauma/mild/hallucinations/on_life()
	owner.hallucination = min(owner.hallucination + 10, 50)
	..()

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.hallucination = 0
	..()

/datum/brain_trauma/mild/stuttering
	name = "Stuttering"
	desc = "Patient can't speak properly."
	scan_desc = "reduced mouth coordination"
	gain_text = "<span class='warning'>Speaking clearly is getting harder.</span>"
	lose_text = "<span class='notice'>You feel in control of your speech.</span>"

/datum/brain_trauma/mild/stuttering/on_life()
	owner.stuttering = min(owner.stuttering + 5, 25)
	..()

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.stuttering = 0
	..()

/datum/brain_trauma/mild/dumbness
	name = "Dumbness"
	desc = "Patient has reduced brain activity, making them less intelligent."
	scan_desc = "reduced brain activity"
	gain_text = "<span class='warning'>You feel dumber.</span>"
	lose_text = "<span class='notice'>You feel smart again.</span>"

/datum/brain_trauma/mild/dumbness/on_gain()
	owner.disabilities |= DUMB
	..()

/datum/brain_trauma/mild/dumbness/on_life()
	owner.tarded = min(owner.slurring + 5, 25)
	if(prob(3))
		owner.emote("drool")
	..()

/datum/brain_trauma/mild/dumbness/on_lose()
	owner.disabilities &= ~DUMB
	owner.tarded = 0
	..()

/datum/brain_trauma/mild/speech_impediment
	name = "Speech Impediment"
	desc = "Patient is unable to form coherent sentences."
	scan_desc = "communication disorder"
	gain_text = "You feel lost for words!"
	lose_text = "You regain your bearing!"

/datum/brain_trauma/mild/speech_impediment/on_gain()
	owner.disabilities |= UNINTELLIGIBLE
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	owner.disabilities &= ~UNINTELLIGIBLE
	..()

/datum/brain_trauma/mild/pirate
	name = "Piracy Syndrome"
	desc = "Patient is unable to form a coherent thought without drifting the seven seas."
	scan_desc = "piracy problem"
	gain_text = "Your mind drifts across the seven seas!"
	lose_text = "Your mind returns to port."

/datum/brain_trauma/mild/pirate/on_gain()
	owner.disabilities |= PIRATE
	..()

/datum/brain_trauma/mild/pirate/on_lose()
	owner.disabilities &= ~PIRATE
	..()

/datum/brain_trauma/mild/gertie
	name = "Gerstmann Syndrome"
	desc = "Patient displays severe left right disorientation."
	scan_desc = "swedish problem"
	gain_text = "You wonder to yourself, does three rights really make a left?!"
	lose_text = "You remember that you can just turn left directly!"

/datum/brain_trauma/mild/gertie/on_gain()
	owner.disabilities |= GERTIE
	..()

/datum/brain_trauma/mild/gertie/on_lose()
	owner.disabilities &= ~GERTIE
	..()

/datum/brain_trauma/mild/concussion
	name = "Concussion"
	desc = "Patient's brain is concussed."
	scan_desc = "a concussion"
	gain_text = "<span class='warning'>Your head hurts!</span>"
	lose_text = "<span class='notice'>The pressure inside your head starts fading.</span>"

/datum/brain_trauma/mild/concussion/on_life()
	if(prob(5))
		switch(rand(1,11))
			if(1)
				owner.vomit()
			if(2,3)
				owner.dizziness += 10
			if(4,5)
				owner.confused += 10
				owner.apply_effect(10,EYE_BLUR)
			if(6 to 9)
				owner.slurring += 30
			if(10)
				to_chat(owner, "<span class='notice'>You forget for a moment what you were doing.</span>")
				owner.Stun(20)
			if(11)
				to_chat(owner, "<span class='warning'>You faint.</span>")
				owner.Sleeping(80)

	..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Muscle Weakness"
	desc = "Patient experiences occasional bouts of muscle weakness."
	scan_desc = "weak motor nerve signal"
	gain_text = "<span class='warning'>Your muscles feel oddly faint.</span>"
	lose_text = "<span class='notice'>You feel in control of your muscles again.</span>"

/datum/brain_trauma/mild/muscle_weakness/on_life()
	var/fall_chance = 1
	if(owner.m_intent == "run")
		fall_chance += 2
	if(prob(fall_chance) && !owner.lying && !owner.buckled)
		to_chat(owner, "<span class='warning'>Your leg gives out!</span>")
		owner.Paralyse(35)

	else if(owner.get_active_hand())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_hand()
		drop_chance += I.w_class
		if(prob(drop_chance) && owner.drop_from_inventory(I))
			to_chat(owner, "<span class='warning'>You drop [I]!</span>")

	else if(prob(3))
		to_chat(owner, "<span class='warning'>You feel a sudden weakness in your muscles!</span>")
		owner.adjustHalLoss(50)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "Muscle Spasms"
	desc = "Patient has occasional muscle spasms, causing them to move unintentionally."
	scan_desc = "nervous fits"
	gain_text = "<span class='warning'>Your muscles feel oddly faint.</span>"
	lose_text = "<span class='notice'>You feel in control of your muscles again.</span>"

/datum/brain_trauma/mild/muscle_spasms/on_life()
	if(prob(7))
		switch(rand(1,5))
			if(1)
				if(owner.canmove)
					to_chat(owner, "<span class='warning'>Your leg spasms!</span>")
					step(owner, pick(cardinal))
			if(2)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_hand()
				if(I)
					to_chat(owner, "<span class='warning'>Your fingers spasm!</span>")
					I.attack_self(owner)
			if(3)
				var/prev_intent = owner.a_intent
				owner.a_intent = I_HURT

				var/range = 1
				if(istype(owner.get_active_hand(), /obj/item/weapon/gun)) //get targets to shoot at
					range = 7

				var/list/mob/living/targets = list()
				for(var/mob/M in oview(owner, range))
					if(isliving(M))
						targets += M
				if(LAZYLEN(targets))
					to_chat(owner, "<span class='warning'>Your arm spasms!</span>")
					owner.ClickOn(pick(targets))
				owner.a_intent = prev_intent
			if(4)
				var/prev_intent = owner.a_intent
				owner.a_intent = I_HURT
				var/list/mob/living/targets = list()
				if(LAZYLEN(targets))
					to_chat(owner, "<span class='warning'>Your arm spasms!</span>")
					owner.ClickOn(owner)
				owner.a_intent = prev_intent
			if(5)
				if(owner.incapacitated())
					return
				var/obj/item/I =owner.get_active_hand()
				var/list/turf/targets = list()
				for(var/turf/T in oview(owner, 3))
					targets += T
				if(LAZYLEN(targets) && I)
					to_chat(owner, "<span class='warning'>Your arm spasms!</span>")
					owner.throw_item(pick(targets))
	..()
