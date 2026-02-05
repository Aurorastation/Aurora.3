/obj/structure/cult/talisman
	name = "daemon altar"
	desc = "A bloodstained altar. Looking at it makes you feel slightly terrified."
	icon_state = "talismanaltar"
	var/last_use = 0

/obj/structure/cult/talisman/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "If you are a Cultist, you could click on this altar to pray to Nar'Sie, who will in turn heal some of your ailments."
	. += "It has a cooldown time of 15 seconds. Do not tempt the wrath of Nar'Sie demanding more!"

/obj/structure/cult/talisman/attack_hand(mob/user)
	. = ..()
	if(iscultist(user) && ishuman(user))
		if(last_use <= world.time)
			last_use = world.time + 15 SECONDS // Cooldown of 15 seconds.
			var/mob/living/carbon/human/H = user
			H.heal_overall_damage(20, 20)
			to_chat(H, SPAN_CULT("You begin your prayer to Nar'Sie, your wounds slowly closing up..."))
			for(var/obj/item/organ/external/O in H.organs)
				if(O.status & ORGAN_ARTERY_CUT)
					to_chat(H, SPAN_WARNING("Severed artery found in [O.name], repairing..."))
					if(do_after(user, 2 SECONDS, do_flags = DO_USER_UNIQUE_ACT | DO_FAIL_FEEDBACK | DO_SHOW_PROGRESS))
						O.status &= ~ORGAN_ARTERY_CUT
				if(O.tendon_status() & TENDON_CUT)
					to_chat(H, SPAN_WARNING("Severed tendon found in [O.name], repairing..."))
					if(!O.tendon.can_recover())
						to_chat(H, SPAN_WARNING("The tissue surrounding the tendon in [O.name] is still too damaged."))
					else if(do_after(user, 2 SECONDS, do_flags = DO_USER_UNIQUE_ACT | DO_FAIL_FEEDBACK | DO_SHOW_PROGRESS))
						O.tendon.rejuvenate()
				if(O.status & ORGAN_BROKEN)
					to_chat(H, SPAN_WARNING("Broken bone found in [O.name], repairing..."))
					if(do_after(user, 2 SECONDS, do_flags = DO_USER_UNIQUE_ACT | DO_FAIL_FEEDBACK | DO_SHOW_PROGRESS))
						O.status &= ~ORGAN_BROKEN
				O.update_damages()
			if(!(H.species.flags & NO_BLOOD))
				var/total_blood = REAGENT_VOLUME(H.vessel, /singleton/reagent/blood)
				var/blood_to_add = H.species.blood_volume * 0.45
				if(total_blood < blood_to_add)
					H.vessel.add_reagent(/singleton/reagent/blood, blood_to_add, temperature = H.species.body_temperature)
		else
			to_chat(user, SPAN_WARNING("This altar isn't ready to be prayed at yet."))
	else
		to_chat(user, SPAN_WARNING("The altar lightly zaps you."))
