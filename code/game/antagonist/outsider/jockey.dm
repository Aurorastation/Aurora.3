GLOBAL_DATUM(jockeys, /datum/antagonist/jockey)

/datum/antagonist/jockey
	id = MODE_JOCKEY
	role_text = "Jockey"
	role_text_plural = "Jockeys"
	bantype = "jockey"
	antag_indicator = "jockey"
	landmark_id = "jockeyspawn"
	welcome_text = "You are a Jockey, one of the best damn mech pilots in the spur.<br>\
	Your uplink will grant you access to various tools you may need to attempt to accomplish your goal.<br>\
	You can use :H or :B to talk on your encrypted channel, which only you and your partner can read.<br>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudjockey"
	required_age = 7

	hard_cap = 3
	hard_cap_round = 3
	initial_spawn_req = 2
	initial_spawn_target = 2

	faction = "syndicate"

	id_type = /obj/item/card/id/syndicate

/datum/antagonist/jockey/New()
	..()
	GLOB.jockeys = src

/datum/antagonist/jockey/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.name = "passport - [player.real_name]"
			id.registered_name = player.real_name
			W.name = "[initial(W.name)] ([id.name])"

/datum/antagonist/jockey/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for(var/obj/item/I in player)
		if(istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/obj/outfit/admin/syndicate/jockey, FALSE)
	player.equipOutfit(/obj/outfit/admin/syndicate/jockey, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	return TRUE

/datum/antagonist/jockey/get_antag_radio()
	return "Jockey"
