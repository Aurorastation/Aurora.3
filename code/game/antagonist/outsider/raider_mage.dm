var/datum/antagonist/raider_mages/raider_mages

/datum/antagonist/raider_mages
	id = MODE_RAIDER_MAGES
	role_text = "Raider Mage"
	role_text_plural = "Raider Mages"
	bantype = "raider"
	antag_indicator = "magineer"
	landmark_id = "voxstart"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_NO_FLAVORTEXT
	antaghud_indicator = "hudmagineer"
	required_age = 10

	hard_cap = 6
	hard_cap_round = 10
	initial_spawn_req = 4
	initial_spawn_target = 6

	faction = "Space Wizard"

	id_type = /obj/item/card/id/syndicate

/datum/antagonist/raider_mages/New()
	..()
	raider_mages = src

/datum/antagonist/raider_mages/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.name = "[player.real_name]'s Passport"
			id.registered_name = player.real_name
			W.name = "[initial(W.name)] ([id.name])"

/datum/antagonist/raider_mages/proc/is_raider_crew_safe()
	if(!length(current_antagonists))
		return FALSE

	for(var/datum/mind/player in current_antagonists)
		if(!player.current || get_area(player.current) != locate(/area/antag/raider))
			return FALSE
	return TRUE

/datum/antagonist/raider_mages/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for(var/obj/item/I in player)
		if(istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/raider_mage, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/raider_mage, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()
	return TRUE

/datum/antagonist/raider_mages/get_antag_radio()
	return "Raider"