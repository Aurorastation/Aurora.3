/mob/living
	var/datum/psi_complexus/psi

/mob/living/LateLogin()
	..()
	if(psi)
		psi.update(TRUE)
		if(!psi.suppressed)
			psi.show_auras()

/mob/living/Destroy()
	QDEL_NULL(psi)
	. = ..()

/mob/living/proc/set_psi_rank(var/rank, var/defer_update, var/temporary)
	if(HAS_TRAIT(src, TRAIT_PSIONICALLY_DEAF))
		to_chat(src, SPAN_WARNING("Something tingles in your head."))
		return
	if(!psi)
		psi = new(src)
	var/current_rank = psi.get_rank()
	if(current_rank != rank && current_rank < rank)
		psi.set_rank(rank, defer_update, temporary)
