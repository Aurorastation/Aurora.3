var/datum/antagonist/commander/commander

/datum/antagonist/commander
	id = MODE_COMMANDER
	role_text = "Syndicate Commander"
	role_text_plural = "Syndicate Commanders"
	welcome_text = "You are in charge of the syndicate sleeper agents aboard the NSS Aurora. You report directly to the upper echelons of the Syndicate, and their benefactors."
	id_type = /obj/item/weapon/card/id/syndicate
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	landmark_id = "SyndiCommander"

	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/commander/New()
    ..()
    commander = src

/datum/antagonist/commander/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/weapon/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/officer/commander, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/officer/commander, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	give_codewords(player)
	return TRUE