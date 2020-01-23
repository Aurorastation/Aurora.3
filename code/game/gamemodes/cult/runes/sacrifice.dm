/obj/effect/rune/sacrifice/do_rune_action(mob/living/user)
	var/list/mob/living/carbon/human/cultists_in_range = list()
	var/list/mob/living/carbon/human/victims = list()

	for(var/mob/living/carbon/human/V in get_turf(src)) // Checks for non-cultist humans to sacrifice
		if(ishuman(V) && !iscultist(V))
			victims += V // Checks for cult status and mob type

	for(var/obj/item/I in get_turf(src)) // Checks for MMIs/brains/Intellicards
		if(istype(I,/obj/item/organ/internal/brain))
			var/obj/item/organ/internal/brain/B = I
			victims += B.brainmob

		else if(istype(I,/obj/item/device/mmi))
			var/obj/item/device/mmi/B = I
			victims += B.brainmob

		else if(istype(I,/obj/item/aicard))
			for(var/mob/living/silicon/ai/A in I)
				victims += A
	
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			cultists_in_range += C
			C.say("Barhah hra zar[pick("'","`")]garis!")

	for(var/mob/H in victims)
		var/worthy = FALSE
		if(istype(H,/mob/living/carbon/human))
			var/mob/living/carbon/human/lamb = H
			if(lamb.species.rarity_value > 3)
				worthy = TRUE

		var/output
		if(SSticker.mode.name == "Cult")
			if(H.mind == cult.sacrifice_target)
				if(cultists_in_range.len >= 3)
					cult.sacrificed += H.mind
					if(isrobot(H))
						H.dust() // To prevent the MMI from remaining
					else
						H.gib()
					output = span("cult", "The Geometer of Blood accepts this sacrifice, your objective is now complete.")
				else
					output = span("cult", "Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual.")
			else
				do_sacrifice(cultists_in_range, H, H.stat, 80, worthy)
		else
			fizzle(user)
		
		if(output)
			for(var/mob/C in cultists_in_range)
				to_chat(C, output)

/obj/effect/rune/sacrifice/proc/do_sacrifice(var/list/mob/cultists, var/mob/victim, var/victim_status, var/probability, var/worthy)
	var/victim_dead
	if(victim_status == DEAD)
		victim_dead = TRUE

	var/enough_cultists
	if(length(cultists) >= 3)
		enough_cultists = TRUE

	if(victim_dead && enough_cultists) // dead sacrifices are half as likely to satisfy nar'sie
		probability *= 0.5

	var/victim_sacrifice = TRUE // Checks whether we're gonna sacrifice the victim or not
	for(var/mob/C in cultists)
		if(!victim_dead && enough_cultists)
			if(prob(probability) || worthy)
				to_chat(C, span("cult", "The Geometer of Blood accepts this sacrifice."))
			else
				to_chat(C, span("cult", "The Geometer of Blood accepts this sacrifice."))
				to_chat(C, span("warning", "However, this soul was not enough to gain His favor."))
		else if(!victim_dead && !enough_cultists)
			to_chat(C, span("warning", "The victim is still alive, you will need more cultists chanting for the sacrifice to succeed."))
			victim_sacrifice = FALSE

	if(victim_sacrifice)
		if(isrobot(victim))
			victim.dust() // To prevent the MMI from remaining
		else
			victim.gib()