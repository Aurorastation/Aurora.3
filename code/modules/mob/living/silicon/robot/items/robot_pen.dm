// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.
/obj/item/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/pen/robopen/attack_self(mob/user)
	var/choice = input(user, "Would you like to change colour or mode?", "Pen Selector") as null|anything in list("Colour", "Mode")
	if(!choice)
		return

	playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)

	switch(choice)
		if("Colour")
			var/newcolour = input(user, "Which colour would you like to use?", "Colour Selector") as null|anything in list("black", "blue", "red", "green", "yellow")
			if(newcolour)
				colour = newcolour
		if("Mode")
			if(mode == 1)
				mode = 2
			else
				mode = 1
			to_chat(user, SPAN_NOTICE("Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'"))
	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/pen/robopen/proc/RenamePaper(var/mob/user, var/obj/paper)
	if(!user || !paper)
		return
	var/n_name = sanitizeSafe(input(user, "What would you like to label the paper?", "Paper Labelling") as text, 32)
	if(!user || !paper)
		return

	if((get_dist(user,paper) <= 1 && !user.stat))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(user)
	return