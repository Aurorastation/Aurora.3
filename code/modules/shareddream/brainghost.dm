/mob/living/brain_ghost
	name = "Brain Ghost"
	desc = "A Telepathic connection."

	alpha = 200

	var/image/ghostimage = null
	var/mob/living/carbon/human/body = null


/mob/living/brain_ghost/Initialize()
	. = ..()
	var/mob/living/carbon/human/form = loc
	if(!istype(form))
		qdel(src)
		return
	overlays += image(form.icon,form,form.icon_state)
	overlays += form.overlays
	name = form.real_name
	loc = pick(dream_entries)
	body = form


/mob/living/brain_ghost/verb/awaken()
	set name = "Awaken"
	set category = "IC"

	awaken_impl()

/mob/living/brain_ghost/proc/awaken_impl(var/force_awaken = FALSE)

	if(body.willfully_sleeping)
		body.sleeping = max(body.sleeping - 5, 0)
		body.willfully_sleeping = FALSE
		if(force_awaken)
			to_chat(src, "<span class='notice'>You suddenly feel like your connection to the dream is breaking up by the outside force.</span>")
		else
			to_chat(src, "<span class='notice'>You release your concentration on sleep, allowing yourself to wake up.</span>")
	else
		to_chat(src, "<span class='warning'>You've already released concentration. Wait to wake up naturally.</span>")

/mob/living/brain_ghost/Life()
	..()
	// Out body was probs gibbed or somefin
	if(!istype(body))
		show_message("<span class='danger'>[src] suddenly pops from the Srom.</span>")
		to_chat(src, "<span class='danger'>Your body was destroyed!</span>")
		qdel(src)
		return

	if(body.stat == DEAD) // Body is dead, and won't get a life tick.
		body.handle_shared_dreaming()

/mob/living/brain_ghost/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if(!istype(body) || body.stat!=UNCONSCIOUS)
		return
	if(prob(20)) // 1/5 chance to mumble out anything you say in the dream.
		var/list/words = text2list(replacetext(message, "\[^a-zA-Z]*$", ""), " ")
		var/word_count = rand(1, words.len) // How many words to mumble out from within the sentance
		var/words_start = rand(1, words.len - (word_count - 1)) // Where the chunk of said words should start.

		var/mumble_into = words_start == 1 ? "" : "..." // Text to show if we start mumbling after the start of a sentance

		words = words.Copy(words_start, word_count + words_start) // Copy the chunk of the message we mumbled.
		var/mumble_message = "[mumble_into][words.Join(" ")]..."

		body.stat = CONSCIOUS // FILTHY hack to get the sleeping person to say something.
		body.say(mumble_message) // Mumble in Nral Malic
		body.stat = UNCONSCIOUS // Toggled before anything else can happen. Ideally.

	..(message, speaking, verb="says", alt_name="")
