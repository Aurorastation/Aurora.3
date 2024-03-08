var/list/dream_entries = list()

/mob
	var/mob/living/brain_ghost/bg

/mob/living/carbon/human
	var/datum/weakref/srom_pulled_by
	var/datum/weakref/srom_pulling

/mob/living/carbon/human/Destroy()
	srom_pulled_by = null
	srom_pulling = null
	bg = null //Just to be sure.
	. = ..()

/mob/living/carbon/human/proc/handle_shared_dreaming(var/force_wakeup = FALSE)
	// If they're an Unconsious person with the abillity to do Skrellepathy.
	// If either changes, they should be nocked back to the real world.
	var/mob/living/carbon/human/srom_puller = srom_pulled_by?.resolve()
	if((has_psionics() || (srom_puller && Adjacent(srom_puller))) && stat == UNCONSCIOUS && sleeping > 1)
		if(!istype(bg) && client) // Don't spawn a brainghost if we're not logged in.
			bg = new /mob/living/brain_ghost(src) // Generate a new brainghost.
			if(isnull(bg)) // Prevents you from getting kicked if the brain ghost didn't spawn - geeves
				return
			vr_mob = bg
			bg.ckey = ckey
			bg.client = client
			ckey = "@[bg.ckey]"
			to_chat(bg, "<span class='notice'>As you lose consiousness, you feel yourself entering Srom.</span>")
			to_chat(bg, "<span class='warning'>Whilst in shared dreaming, you find it difficult to hide your secrets.</span>")
			if(willfully_sleeping)
				to_chat(bg, "To wake up, use the \"Awaken\" verb in the IC tab.")
			if(!srom_pulling && has_psionics())
				var/obj/item/grab/G = r_hand
				if(!G)
					G = l_hand
				if(G)
					var/mob/living/carbon/human/victim = G.affecting
					if(ishuman(victim) && !isSynthetic(victim) && victim.is_psi_pingable())
						to_chat(bg, SPAN_NOTICE("You have taken [victim] to the Srom with you."))
						victim.srom_pulled_by = WEAKREF(src)
						srom_pulling = WEAKREF(victim)
			for(var/thing in SSpsi.processing)
				var/datum/psi_complexus/psi = thing
				to_chat(psi.owner, SPAN_CULT("You sense an increase in the activity of Srom..."))
				sound_to(psi.owner, sound('sound/effects/psi/power_used.ogg'))
			log_and_message_admins("has entered the shared dream", bg)
	// Does NOT
	else
		if(istype(bg) || force_wakeup)
			// If we choose to be asleep, keep sleeping.
			if(willfully_sleeping && sleeping && stat == UNCONSCIOUS)
				if(has_psionics() || srom_pulled_by)
					sleeping = 5
					return
			for(var/thing in SSpsi.processing)
				var/datum/psi_complexus/psi = thing
				to_chat(psi.owner, SPAN_CULT("You feel the activity of Srom decrease."))
			log_and_message_admins("has left the shared dream",bg)
			var/mob/living/brain_ghost/old_bg = bg
			bg = null
			vr_mob = null
			var/return_text = "You are ripped from the Srom as your body awakens."
			var/mob/return_mob = src

			if(srom_pulled_by)
				if(!has_psi_aug())
					dizziness += 40
					confused += 40
					slurring += 40
					eye_blurry += 40
					return_text += " You feel dizzy, confused and weird..."
				else
					return_text += " Your augment staves off most of the post-Srom pull symptoms, but you still feel like your mind is clouded."
				adjustBrainLoss(10)
				srom_pulled_by = null

			var/mob/living/carbon/human/victim = srom_pulling?.resolve()
			if(victim)
				victim.srom_pulled_by = null
			srom_pulling = null

			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B?.host_brain)
				return_mob = B.host_brain
				return_text = "You are ripped from the Srom as you return to the captivity of your own mind."

			if(stat == DEAD)
				return_text = "You are ripped from the Srom." // You're dead - ensures there's no message about feeling weird or waking up.

			return_mob.ckey = old_bg.ckey
			old_bg.visible_message("<span class='notice'>[old_bg] begins to fade as they depart from the dream...</span>")
			animate(old_bg, alpha=0, time = 20)
			QDEL_IN(old_bg, 20)
			to_chat(return_mob, SPAN_WARNING("[return_text]"))
