var/datum/antagonist/burglar/burglars

/datum/antagonist/burglar
	id = MODE_BURGLAR
	role_text = "Burglar"
	role_text_plural = "Burglars"
	bantype = "burglar"
	antag_indicator = "burglar"
	landmark_id = "burglarspawn"
	welcome_text = "You are a Burglar, someone underequipped to deal with well armed facilities. You will probably not survive for the whole round, so don't sweat it if you die!<br>\
	Your (syndicate) sponsored uplink will grant you access to various tools you may need to attempt to accomplish your goal.<br>\
	You can use :H or :B to talk on your encrypted channel, which only you and your partner can read.<br>\
	<b>You have been outfitted with a special teleportation device, make sure to use it!</b>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudburglar"
	required_age = 7

	hard_cap = 2
	hard_cap_round = 3
	initial_spawn_req = 2
	initial_spawn_target = 2

	faction = "syndicate"

	id_type = /obj/item/card/id/syndicate

/datum/antagonist/burglar/New()
	..()
	burglars = src

/datum/antagonist/burglar/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.name = "[player.real_name]'s Passport"
			id.registered_name = player.real_name
			W.name = "[initial(W.name)] ([id.name])"

/datum/antagonist/burglar/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for(var/obj/item/I in player)
		if(istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/burglar, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/burglar, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	return TRUE

/datum/antagonist/burglar/get_antag_radio()
	return "Burglar"
