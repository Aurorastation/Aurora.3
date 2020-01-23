/obj/effect/rune/sacrifice/do_rune_action(mob/living/user)
	var/list/mob/living/carbon/human/cultsinrange = list()
	var/list/mob/living/carbon/human/victims = list()
	for(var/mob/living/carbon/human/V in src.loc)//Checks for non-cultist humans to sacrifice
		if(ishuman(V))
			if(!(iscultist(V)))
				victims += V//Checks for cult status and mob type
	for(var/obj/item/I in src.loc)//Checks for MMIs/brains/Intellicards
		if(istype(I,/obj/item/organ/internal/brain))
			var/obj/item/organ/internal/brain/B = I
			victims += B.brainmob
		else if(istype(I,/obj/item/device/mmi))
			var/obj/item/device/mmi/B = I
			victims += B.brainmob
		else if(istype(I,/obj/item/aicard))
			for(var/mob/living/silicon/ai/A in I)
				victims += A
	for(var/mob/living/carbon/C in orange(1,src))
		if(iscultist(C) && !C.stat)
			cultsinrange += C
			C.say("Barhah hra zar[pick("'","`")]garis!")

	for(var/mob/H in victims)

		var/worth = 0
		if(istype(H,/mob/living/carbon/human))
			var/mob/living/carbon/human/lamb = H
			if(lamb.species.rarity_value > 3)
				worth = 1

		if (SSticker.mode.name == "Cult")
			if(H.mind == cult.sacrifice_target)
				if(cultsinrange.len >= 3)
					cult.sacrificed += H.mind
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()
					to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice, your objective is now complete.</span>")
				else
					to_chat(user, "<span class='warning'>Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual.</span>")
			else
				if(cultsinrange.len >= 3)
					if(H.stat != DEAD)
						if(prob(80) || worth)
							to_chat(user, "<span class='cult'>The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice.</span>")
						else
							to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
							to_chat(user, "<span class='warning'>However, this soul was not enough to gain His favor.</span>")
						if(isrobot(H))
							H.dust()//To prevent the MMI from remaining
						else
							H.gib()
					else
						if(prob(40) || worth)
							to_chat(user, "<span class='cult'>The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice.</span>")
						else
							to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
							to_chat(user, "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>")
						if(isrobot(H))
							H.dust()//To prevent the MMI from remaining
						else
							H.gib()
				else
					if(H.stat != DEAD)
						to_chat(user, "<span class='warning'>The victim is still alive, you will need more cultists chanting for the sacrifice to succeed.</span>")
					else
						if(prob(40))

							to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
						else
							to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
							to_chat(user, "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>")
						if(isrobot(H))
							H.dust()//To prevent the MMI from remaining
						else
							H.gib()
		else
			if(cultsinrange.len >= 3)
				if(H.stat != DEAD)
					if(prob(80))
						to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
					else
						to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
						to_chat(user, "<span class='warning'>However, this soul was not enough to gain His favor.</span>")
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()
				else
					if(prob(40))
						to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
					else
						to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
						to_chat(user, "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>")
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()
			else
				if(H.stat != DEAD)
					to_chat(user, "<span class='warning'>The victim is still alive, you will need more cultists chanting for the sacrifice to succeed.</span>")
				else
					if(prob(40))
						to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
					else
						to_chat(user, "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>")
						to_chat(user, "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>")
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()