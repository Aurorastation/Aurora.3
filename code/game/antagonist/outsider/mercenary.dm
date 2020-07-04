var/datum/antagonist/mercenary/mercs

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_text = "Mercenary"
	bantype = "operative"
	antag_indicator = "synd"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_NO_FLAVORTEXT
	id_type = /obj/item/card/id/syndicate
	antaghud_indicator = "hudoperative"
	required_age = 10

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 4

	faction = "syndicate"

/datum/antagonist/mercenary/New()
	..()
	mercs = src

/datum/antagonist/mercenary/create_global_objectives()
	if(!..())
		return FALSE
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear
	return TRUE

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/mercenary, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/mercenary, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	give_codewords(player)
	return TRUE

/datum/antagonist/mercenary/get_antag_radio()
	return "Mercenary"