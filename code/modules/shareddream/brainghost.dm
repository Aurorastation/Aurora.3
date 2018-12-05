/mob/living/brain_ghost
	name = "Brain Ghost"
	desc = "A Telepathic connection."

	alpha = 127

	var/image/ghostimage = null
	var/mob/living/carbon/human/body = null


	New(var/mob/living/carbon/human/form)
		..()
		overlays += image(form.icon,form,form.icon_state)
		overlays += form.overlays
		name = form.real_name
		loc = pick(dream_entries)
		body = form


	verb/awaken()
		set name = "Awaken"
		set category = "IC"

		if(body.willfully_sleeping)
			body.sleeping = max(body.sleeping - 5, 0)
			body.willfully_sleeping = 0
			src << "<span class='notice'>You release your concentration on sleep, allowing yourself to awake.</span>"
		else
			src << "<span class='warning'>You've already released concentration. Wait to wake up naturally.</span>"

	Life()
		..()
		// Out body was probs gibbed or somefin
		if(!istype(body))
			show_message("<span class='danger'>[src] suddenly pops from the Srom.</span>")
			src << "<span class='danger'>Your body was destroyed!</span>"
			qdel(src)
			return

		if(body.stat == DEAD) // Body is dead, and won't get a life tick.
			body.handle_shared_dreaming()