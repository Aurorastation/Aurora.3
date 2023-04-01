/datum/admin_secret_item/fun_secret/turn_tesharis_into_monkeys
	name = "Turn All tesharis Into Monkeys"

/datum/admin_secret_item/fun_secret/turn_tesharis_into_monkeys/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/mob/living/carbon/teshari/H in mob_list)
		spawn(0)
			H.monkeyize()
