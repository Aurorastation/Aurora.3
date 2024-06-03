/mob/living/silicon/robot/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	var/custom_infix = custom_name ? ", [mod_type] [braintype]" : ""
	. = ..(user, distance, is_adjacent, infix = custom_infix)

	. += describe_all_modules() // describe modules

	var/robot_status_desc
	if(getBruteLoss())
		if(getBruteLoss() < 75)
			robot_status_desc += "It looks slightly dented."
		else
			robot_status_desc += "<B>It looks severely dented!</B>"
	if(getFireLoss())
		if(getFireLoss() < 75)
			robot_status_desc += "It looks slightly charred."
		else
			robot_status_desc += "<B>It looks severely burnt and heat-warped!</B>"

	. += SPAN_WARNING(robot_status_desc)

	if(opened)
		. += SPAN_WARNING("Its cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += "Its cover is closed."

	if(!has_power)
		. += SPAN_WARNING("It appears to be running on backup power.")

	switch(stat)
		if(CONSCIOUS)
			if(!client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += SPAN_WARNING("It doesn't seem to be responding.")
		if(DEAD)
			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"

	if(print_flavor_text())
		. += "\n[print_flavor_text()]\n"

	if(pose)
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose, ".") // Makes sure all emotes end with punctuation.
		. += "\nIt [pose]"

	. += user.examine_laws(src)
