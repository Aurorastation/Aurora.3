/mob/living/silicon/pai/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..(user, distance, is_adjacent, ", personal AI", suffix)
	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)
				. += "\nIt appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += "\n<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)
			. += "\n<span class='deadsay'>It looks completely unsalvageable.</span>"

	if(print_flavor_text())
		. += "\n[print_flavor_text()]\n"

	if(pose)
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose, ".") // Makes sure all emotes end with punctuation.
		. += "\nIt [pose]"
