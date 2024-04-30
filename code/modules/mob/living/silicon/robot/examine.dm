/mob/living/silicon/robot/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	var/custom_infix = custom_name ? ", [mod_type] [braintype]" : ""
	. = ..(user, distance, is_adjacent, infix = custom_infix)

	. += describe_all_modules() // describe modules

	. += "<span class='warning'>"
	if(getBruteLoss())
		if(getBruteLoss() < 75)
			. += "It looks slightly dented."
		else
			. += "<B>It looks severely dented!</B>"
	if(getFireLoss())
		if(getFireLoss() < 75)
			. += "It looks slightly charred."
		else
			. += "<B>It looks severely burnt and heat-warped!</B>"
	. += "</span>"

	if(opened)
		. += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>"
	else
		. += "Its cover is closed."

	if(!has_power)
		. += "<span class='warning'>It appears to be running on backup power.</span>"

	switch(stat)
		if(CONSCIOUS)
			if(!client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += "<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)
			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"

	if(print_flavor_text())
		. += "\n[print_flavor_text()]\n"

	if(pose)
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose, ".") // Makes sure all emotes end with punctuation.
		. += "\nIt [pose]"

	. += user.examine_laws(src)
