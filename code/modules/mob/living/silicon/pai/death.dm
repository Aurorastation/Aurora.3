/mob/living/silicon/pai/Destroy()
	if(parent_computer?.personal_ai == src)
		parent_computer.personal_ai = null
	parent_computer = null
	return ..()

/mob/living/silicon/pai/death(gibbed)
	if(card)
		card.removePersonality()
		if(gibbed)
			src.forceMove(get_turf(card))
			qdel(card)
		else
			close_up()
	if(mind)
		qdel(mind)
	..(gibbed)
	ghostize()
	qdel(src)