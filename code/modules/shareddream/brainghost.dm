/mob/living/brain_ghost
	name = "Brain Ghost"
	desc = "A Telepathic connection."
	accent = ACCENT_SROM

	alpha = 200

	var/mob/living/carbon/human/body = null


/mob/living/brain_ghost/Initialize(mapload, mob/living/carbon/human/dreamer)
	. = ..()

	body = dreamer
	if(!istype(body))
		//This is to handle the unit tests
		if(!isnull(body))
			stack_trace("No /mob/living/carbon/human found for brain ghost as loc!")
		return INITIALIZE_HINT_QDEL

	name = body.real_name
	old_mob = body

	var/mutable_appearance/MA = new(body)
	MA.appearance_flags |= KEEP_APART | RESET_TRANSFORM
	MA.transform = matrix() //Mutable appearances copy various vars, including transform, so we have to reset it here

	AddOverlays(MA)


	var/turf/T = pick(GLOB.dream_entries)
	if(!T)
		stack_trace("No dream entries found for Srom!")
		awaken_impl(TRUE)
		return

	src.forceMove(T)

	if(client)
		LateLogin()

/mob/living/brain_ghost/Destroy()
	body = null

	. = ..()

/mob/living/brain_ghost/LateLogin()
	..()
	client.screen |= body.healths

/mob/living/brain_ghost/verb/awaken()
	set name = "Awaken"
	set category = "IC"

	awaken_impl()

/mob/living/brain_ghost/proc/awaken_impl(var/force_awaken = FALSE)

	if(body.willfully_sleeping)
		body.willfully_sleeping = FALSE
		if(force_awaken)
			body.sleeping = 0
			to_chat(src, SPAN_NOTICE("You suddenly feel like your connection to the dream is breaking up by the outside force."))
		else
			body.sleeping = max(body.sleeping - 5, 0)
			to_chat(src, SPAN_NOTICE("You release your concentration on sleep, allowing yourself to wake up."))
	else
		to_chat(src, SPAN_WARNING("You've already released concentration. Wait to wake up naturally."))

/mob/living/brain_ghost/Life(seconds_per_tick, times_fired)
	..()
	// Out body was probs gibbed or somefin
	if(!istype(body))
		show_message(SPAN_DANGER("[src] suddenly pops from the Srom."))
		to_chat(src, SPAN_DANGER("Your body was destroyed!"))
		qdel(src)
		return

	if(body.stat == DEAD) // Body is dead, and won't get a life tick.
		awaken_impl(TRUE)
		body.handle_shared_dreaming(TRUE)

/mob/living/brain_ghost/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE, var/skip_edit = FALSE)
	if(!istype(body) || body.stat!=UNCONSCIOUS)
		return
	if(prob(20)) // 1/5 chance to mumble out anything you say in the dream.
		var/list/words = text2list(replacetext(message, "\[^a-zA-Z]*$", ""), " ")
		var/word_count = rand(1, words.len) // How many words to mumble out from within the sentance
		var/words_start = rand(1, words.len - (word_count - 1)) // Where the chunk of said words should start.

		var/mumble_into = words_start == 1 ? "" : "..." // Text to show if we start mumbling after the start of a sentance

		words = words.Copy(words_start, word_count + words_start) // Copy the chunk of the message we mumbled.
		var/mumble_message = "[mumble_into][words.Join(" ")]..."

		body.set_stat(CONSCIOUS) // FILTHY hack to get the sleeping person to say something.
		body.say(mumble_message) // Mumble in Nral Malic
		body.set_stat(UNCONSCIOUS) // Toggled before anything else can happen. Ideally.

	..(message, speaking, verb="says", alt_name="")


/mob/living/brain_ghost/get_floating_chat_y_offset()
	return 8
