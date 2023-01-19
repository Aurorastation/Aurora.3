/mob/living/carbon/alien/death(gibbed)
	if(!gibbed && icon_dead)
		icon_state = icon_dead
	return ..(gibbed,death_msg)