///A list of `/turf` where the Srom is located, and people entering the shared dream (presumably Skrells sleeping) will be casted to
GLOBAL_LIST_EMPTY_TYPED(dream_entries, /turf)

/mob
	var/mob/living/brain_ghost/bg

/mob/living/carbon/human
	var/datum/weakref/srom_pulled_by
	var/datum/weakref/srom_pulling

/mob/living/carbon/human/proc/handle_shared_dreaming(var/force_wakeup = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	if(is_psi_blocked(src)) // Can't enter the dream if the caster is blocked from RECEIVING. It's a two-way street.
		return

	// This is one of the legitimate uses for has_psionics() that should be kept even though has_psionics() is deprecated.
	// Entering the dream requires the caster be capable of SENDING.
	var/is_psionic = has_psionics()

	// Entering the dream requires that the caster either be capable of SENDING, or has a "guide" performing the SENDING on their behalf.
	var/mob/living/carbon/human/srom_puller = srom_pulled_by?.resolve()
	if((is_psionic || (srom_puller && Adjacent(srom_puller))) && stat == UNCONSCIOUS && sleeping > 1)
		if(!istype(bg) && client) // Don't spawn a brainghost if we're not logged in.
			bg = new /mob/living/brain_ghost(src, src) // Generate a new brainghost.
			if(isnull(bg)) // Prevents you from getting kicked if the brain ghost didn't spawn - geeves
				return
			vr_mob = bg
			bg.ckey = ckey
			bg.client = client
			ckey = "@[bg.ckey]"
			to_chat(bg, SPAN_NOTICE("As you lose consiousness, you feel yourself entering Srom."))
			to_chat(bg, SPAN_WARNING("Whilst in shared dreaming, you find it difficult to hide your secrets."))
			if(willfully_sleeping)
				to_chat(bg, "To wake up, use the \"Awaken\" verb in the IC tab.")
			if(!srom_pulling && is_psionic)
				var/obj/item/grab/G = r_hand
				if(!G)
					G = l_hand
				if(G)
					var/mob/living/carbon/human/victim = G.affecting
					// Victims must be capable of RECEIVING.
					if(!victim.is_psi_blocked(src) && ((victim.check_psi_sensitivity() > 0) || victim.has_zona_bovinae()))
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
				if(is_psionic || srom_pulled_by)
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
				var/sensitivity = check_psi_sensitivity()
				if(sensitivity <= 0)
					dizziness += 40
					confused += 40
					slurring += 40
					eye_blurry += 40
					return_text += " You feel dizzy, confused and weird..."
				else
					return_text += " You stave off most of the post-Srom pull symptoms, but you still feel like your mind is clouded."
				// Non-Psions can have a RECEIVING stat, so we'll account for it by giving them a leeway on the brain damage if they're sufficiently sensitive.
				adjustBrainLoss(10 - min(10, 5 * sensitivity))
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
			old_bg.visible_message(SPAN_NOTICE("[old_bg] begins to fade as they depart from the dream..."))
			animate(old_bg, alpha=0, time = 20)
			QDEL_IN(old_bg, 20)
			to_chat(return_mob, SPAN_WARNING("[return_text]"))
