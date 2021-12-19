var/list/dream_entries = list()

/mob/living/carbon/human
	var/mob/living/brain_ghost/bg = null

/mob/living/carbon/human/proc/handle_shared_dreaming(var/force_wakeup = FALSE)
	// If they're an Unconsious person with the abillity to do Skrellepathy.
	// If either changes, they should be nocked back to the real world.
	if(can_commune() && stat == UNCONSCIOUS && sleeping > 1)
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
			log_and_message_admins("has entered the shared dream", bg)
	// Does NOT
	else
		if(istype(bg) || force_wakeup)
			// If we choose to be asleep, keep sleeping.
			if(willfully_sleeping && sleeping && stat == UNCONSCIOUS)
				sleeping = 5
				return
			log_and_message_admins("has left the shared dream",bg)
			var/mob/living/brain_ghost/old_bg = bg
			bg = null
			vr_mob = null
			var/return_text = "You are ripped from the Srom as your body awakens."
			var/mob/return_mob = src

			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B?.host_brain)
				return_mob = B.host_brain
				return_text = "You are ripped from the Srom as you return to the captivity of your own mind."

			return_mob.ckey = old_bg.ckey
			old_bg.show_message("<span class='notice'>[bg] fades as their connection is severed.</span>")
			animate(old_bg, alpha=0, time = 200)
			QDEL_IN(old_bg, 20)
			to_chat(return_mob, SPAN_WARNING("[return_text]"))