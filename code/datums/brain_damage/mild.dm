//Mild traumas are the most common; they are generally minor annoyances.
//They can be suppressed with escitalopram, but not chemically cured, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Hallucinations"
	desc = "Patient suffers constant hallucinations."
	scan_desc = "schizophrenia"
	gain_text = "<span class='warning'>You feel your grip on reality slipping...</span>"
	lose_text = "<span class='notice'>You feel more grounded.</span>"
	cure_type = CURE_SOLITUDE

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
	cure_type = CURE_CRYSTAL

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
	cure_type = CURE_CRYSTAL

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
	cure_type = CURE_CRYSTAL

/datum/brain_trauma/mild/speech_impediment/on_gain()
	owner.disabilities |= UNINTELLIGIBLE
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	owner.disabilities &= ~UNINTELLIGIBLE
	..()

/datum/brain_trauma/mild/tourettes
	name = "Tourettes Syndrome"
	desc = "Patient is compelled to vulgarity."
	scan_desc = "vulgarity problem"
	gain_text = "Your mind fills with foul language!"
	lose_text = "Your mind returns to decency."
	cure_type = CURE_CRYSTAL
	can_gain = FALSE

/datum/brain_trauma/mild/tourettes/on_gain()
	owner.disabilities |= TOURETTES
	..()

/datum/brain_trauma/mild/tourettes/on_lose()
	owner.disabilities &= ~TOURETTES
	..()

/datum/brain_trauma/mild/gertie
	name = "Gerstmann Syndrome"
	desc = "Patient displays severe left right disorientation."
	scan_desc = "left-right disorientation"
	gain_text = "You wonder to yourself, does three rights really make a left?!"
	lose_text = "You remember that you can just turn left directly!"
	cure_type = CURE_HYPNOSIS

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
	cure_type = CURE_SURGERY

/datum/brain_trauma/mild/concussion/on_life()
	if(prob(25))
		switch(rand(1,9))
			if(1)
				to_chat(owner, "<span class='notice'>Your stomach writhes with pain.</span>")
				owner.vomit()
			if(2,3)
				to_chat(owner, "<span class='notice'>You feel light-headed.</span>")
				owner.dizziness = max(owner.slurring, 10)
			if(4,5)
				to_chat(owner, "<span class='notice'>it becomes hard to see for some reason.</span>")
				owner.confused = max(owner.slurring, 10)
				owner.apply_effect(10,EYE_BLUR)
			if(6 to 9)
				to_chat(owner, "<span class='notice'>Your tongue feels thick in your mouth.</span>")
				owner.slurring = max(owner.slurring, 30)

	..()

/datum/brain_trauma/mild/concussion/on_lose()
	owner.dizziness = 0
	owner.slurring = 0
	owner.confused = 0
	..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Muscle Weakness"
	desc = "Patient experiences occasional bouts of muscle weakness."
	scan_desc = "weak motor nerve signal"
	gain_text = "<span class='warning'>Your muscles feel oddly faint.</span>"
	lose_text = "<span class='notice'>You feel in control of your muscles again.</span>"
	cure_type = CURE_CRYSTAL

/datum/brain_trauma/mild/muscle_weakness/on_life()
	var/fall_chance = 5
	if(owner.m_intent == "run")
		fall_chance += 15
	if(prob(fall_chance) && !owner.lying && !owner.buckled)
		to_chat(owner, "<span class='warning'>Your leg gives out!</span>")
		owner.Weaken(5)

	else if(owner.get_active_hand())
		var/drop_chance = 15
		var/obj/item/I = owner.get_active_hand()
		drop_chance += I.w_class
		if(prob(drop_chance) && owner.drop_from_inventory(I))
			to_chat(owner, "<span class='warning'>You drop [I]!</span>")

	else if(prob(3))
		to_chat(owner, "<span class='warning'>You feel a sudden weakness in your muscles!</span>")
		owner.adjustHalLoss(25)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "Muscle Spasms"
	desc = "Patient has occasional muscle spasms, causing them to move unintentionally."
	scan_desc = "nervous fits"
	gain_text = "<span class='warning'>Your muscles feel oddly faint.</span>"
	lose_text = "<span class='notice'>You feel in control of your muscles again.</span>"
	cure_type = CURE_CRYSTAL

/datum/brain_trauma/mild/muscle_spasms/on_life()
	if(prob(25))
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

				var/list/mob/living/targets = list()
				var/range = 1
				if(istype(owner.get_active_hand(), /obj/item/gun)) //get targets to shoot at
					range = 7
					for(var/turf/T in oview(owner, range))
						targets += T

				else
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

/datum/brain_trauma/mild/nearsightedness
	name = "Cerebral Near-Blindness"
	desc = "Patient's brain is loosely connected to its eyes."
	scan_desc = "minor damage to the brain's occipital lobe"
	gain_text = "<span class='warning'>You can barely see!</span>"
	lose_text = "<span class='notice'>Your vision returns.</span>"
	cure_type = CURE_SURGERY

/datum/brain_trauma/mild/nearsightedness/on_gain()
	owner.disabilities |= NEARSIGHTED
	..()

//no fiddling with genetics to get out of this one
/datum/brain_trauma/mild/nearsightedness/on_life()
	if(!(owner.disabilities & NEARSIGHTED))
		on_gain()
	..()

/datum/brain_trauma/mild/nearsightedness/on_lose()
	if(owner.disabilities & NEARSIGHTED)
		owner.disabilities &= ~NEARSIGHTED
	..()

/datum/brain_trauma/mild/colorblind
	name = "Partial Colorblindedness"
	desc = "Patient's brain is loosely connected to ocular cones."
	scan_desc = "minor damage to the brain's occipital lobe"
	gain_text = "<span class='warning'>Your perception of color distorts!</span>"
	lose_text = "<span class='notice'>Your vision returns.</span>"
	cure_type = CURE_SURGERY
	var/colorblindedness

/datum/brain_trauma/mild/colorblind/on_gain()
	colorblindedness = pick("deuteranopia", "protanopia", "tritanopia")
	switch(colorblindedness)
		if("deuteranopia")
			owner.add_client_color(/datum/client_color/deuteranopia)
		if("protanopia")
			owner.add_client_color(/datum/client_color/protanopia)
		if("tritanopia")
			owner.add_client_color(/datum/client_color/tritanopia)
	..()

/datum/brain_trauma/mild/colorblind/on_life()
	if(owner.client && !owner.client.color)
		on_gain()

/datum/brain_trauma/mild/colorblind/on_lose()
	switch(colorblindedness)
		if("deuteranopia")
			owner.remove_client_color(/datum/client_color/deuteranopia)
		if("protanopia")
			owner.remove_client_color(/datum/client_color/protanopia)
		if("tritanopia")
			owner.remove_client_color(/datum/client_color/tritanopia)
	..()