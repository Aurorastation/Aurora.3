var/list/dream_entries = list()

/mob/living/carbon/human
	var/mob/living/brain_ghost/bg = null

/mob/living/carbon/human/proc/handle_shared_dreaming()
	// If they're an Unconsious person with the abillity to do Skrellepathy.
	// If either changes, they should be nocked back to the real world.
	if(can_commune() && stat == UNCONSCIOUS && sleeping > 1)
		if(!istype(bg))
			bg = new(src) // Generate a new brainghost.
			bg.ckey = ckey
			bg.client = client
			ckey = "@[bg.ckey]"
			bg << "<span class='notice'>As you lose consiousness, you feel yourself entering Srom.</span>"
			bg << "<span class='warning'>Whilst in shared dreaming, you find it difficult to hide your secrets.</span>"
			if(willfully_sleeping)
				bg << "To wake up, use the \"Awaken\" verb in the IC tab."
	// Does NOT
	else
		if(istype(bg))
			// If we choose to be asleep, keep sleeping.
			if(willfully_sleeping && sleeping && stat == UNCONSCIOUS)
				sleeping = 5
				return
			var/mob/living/brain_ghost/old_bg = bg
			bg = null
			ckey = old_bg.ckey
			old_bg.show_message("<span class='notice'>[bg] fades as their connection is severed.</span>")
			animate(old_bg, alpha=0, time = 200)
			spawn(20)
				qdel(old_bg)
			src << "<span class='warning'>You are ripped from the Srom as your body awakens.<span>"