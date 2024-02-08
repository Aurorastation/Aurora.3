/mob/living/silicon/robot/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	var/custom_infix = custom_name ? ", [mod_type] [braintype]" : ""
	. = ..(user, distance, is_adjacent, infix = custom_infix)

	. += "\n"
	. += describe_all_modules() // describe modules
	. += "\n"

	. += "<span class='warning'>"
	if(getBruteLoss())
		if(getBruteLoss() < 75)
			. += "It looks slightly dented.\n"
		else
			. += "<B>It looks severely dented!</B>\n"
	if(getFireLoss())
		if(getFireLoss() < 75)
			. += "It looks slightly charred.\n"
		else
			. += "<B>It looks severely burnt and heat-warped!</B>\n"
	. += "</span>"

	if(opened)
		. += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>\n"
	else
		. += "Its cover is closed.\n"

	if(!has_power)
		. += "<span class='warning'>It appears to be running on backup power.</span>\n"

	switch(stat)
		if(CONSCIOUS)
			if(!client)
				. += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)
			. += "<span class='warning'>It doesn't seem to be responding.</span>\n"
		if(DEAD)
			. += "<span class='deadsay'>It looks completely unsalvageable.</span>\n"
	. += "*---------*"

	if(print_flavor_text())
		. += "\n[print_flavor_text()]\n"

	if(pose)
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0 )
			pose = addtext(pose, ".") //Makes sure all emotes end with a period.
		. += "\nIt [pose]"
	user.showLaws(src)
