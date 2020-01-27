/obj/structure/cult/talisman
	name = "daemon altar"
	desc = "A bloodstained altar. Looking at it makes you feel slightly terrified."
	description_antag = "If you are a cultist, you could click on this altar to pray to Nar'Sie, who will in turn heal some of your ailments."
	icon_state = "talismanaltar"
	var/last_use = 0

/obj/structure/cult/talisman/attack_hand(mob/user)
	. = ..()
	if(iscultist(user) && ishuman(user))
		if(last_use <= world.time)
			last_use = world.time + 1200 // Cooldown of two minutes
			var/mob/living/carbon/human/H = user
			H.heal_overall_damage(20, 20)
			to_chat(H, span("cult", "You begin your prayer to Nar'Sie, your wounds slowly closing up..."))
			for(var/obj/item/organ/external/O in H.organs)
				if(O.status & ORGAN_ARTERY_CUT)
					to_chat(H, span("warning", "Severed artery found in [O.name], repairing..."))
					if(do_after(user, 20))
						O.status &= ~ORGAN_ARTERY_CUT
				if(O.status & ORGAN_TENDON_CUT)
					to_chat(H, span("warning", "Severed tendon found in [O.name], repairing..."))
					if(do_after(user, 20))
						O.status &= ~ORGAN_TENDON_CUT
				if(O.status & ORGAN_BROKEN)
					to_chat(H, span("warning", "Broken bone found in [O.name], repairing..."))
					if(do_after(user, 20))
						O.status &= ~ORGAN_BROKEN
				O.update_damages()

			var/virus_found
			for(var/datum/disease/D in H.viruses)
				virus_found = TRUE
				D.cure()
			for(var/ID in H.virus2)
				var/datum/disease2/disease/V = H.virus2[ID]
				virus_found = TRUE
				V.cure(src)
			if(virus_found)
				to_chat(H, span("warning", "Virus found, curing..."))
		else
			to_chat(user, span("warning", "This altar isn't ready to be prayed at yet."))
	else
		to_chat(user, span("warning", "The altar lightly zaps you."))