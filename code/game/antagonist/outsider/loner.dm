var/datum/antagonist/loner/loners

/datum/antagonist/loner
	id = MODE_LONER
	role_text = "Loner"
	role_text_plural = "Loners"
	bantype = "loner"
	antag_indicator = "loner"
	landmark_id = "lonerspawn"
	welcome_text = "You are a Loner, someone underequipped to deal with the ship. You will probably not survive for the whole round, so don't sweat it if you die!<br>\
	You are equipped with a lesser cerebro-enhancer, which allows you to unlock your psionic potential. Use it in-hand to choose your boosted faculty, then install it on your head."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudloner"
	required_age = 7

	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

	faction = "syndicate"

	id_type = /obj/item/card/id/syndicate

/datum/antagonist/loner/New()
	..()
	loners = src

/datum/antagonist/loner/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for(var/obj/item/I in player)
		if(istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/mercenary/loner, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/mercenary/loner, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	return TRUE
