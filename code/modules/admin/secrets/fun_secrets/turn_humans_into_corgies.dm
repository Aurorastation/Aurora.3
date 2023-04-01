/datum/admin_secret_item/fun_secret/turn_tesharis_into_corgies
	name = "Turn All tesharis Into Corgies"

/datum/admin_secret_item/fun_secret/turn_tesharis_into_corgies/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/mob/living/carbon/teshari/H in mob_list)
		spawn(0)
			H.corgize()
