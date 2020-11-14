/mob/living/silicon/pai/Destroy()
	var/obj/item/computer_hardware/ai_slot/A = computer?.hardware_by_slot(MC_AI)
	if(A?.stored_pai?.pai == src)
		A.stored_pai.pai = null
	computer = null
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
