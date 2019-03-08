var/datum/antagonist/mercenary/republican

/datum/antagonist/pra
	id = MODE_PRA
	role_text = "Republican Soldier"
	bantype = "operative"
	antag_indicator = "synd"
	role_text_plural = "Republican Soldiers"
	landmark_id = "PRA-Spawn"
	leader_welcome_text = "You are the commander of the Republican Soldiers. Lead your soldiers to victory."
	welcome_text = "You are a soldier in the Republican Army, listen to your commander"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME  | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	id_type = null
	antaghud_indicator = "hudoperative"

	hard_cap = 10
	hard_cap_round = 10
	initial_spawn_req = 5
	initial_spawn_target = 5

	faction = "syndicate"

/datum/antagonist/pra/New()
	..()
	mercs = src

/datum/antagonist/pra/equip(var/mob/living/carbon/human/player)
	if(!..())
		return 0
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/clothing/under/uniform/pra/alt(player), slot_w_uniform)
		player.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/pra(player), slot_wear_suit)
		player.equip_to_slot_or_del(new /obj/item/clothing/beret/pra(player), slot_head)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/under/uniform/pra(player), slot_w_uniform)

	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(player), slot_shoes)
	if(!player.shoes) //If equipping shoes failed, fall back to equipping toeless jackboots
		var/fallback_type = pick(/obj/item/clothing/shoes/jackboots/unathi)
		player.equip_to_slot_or_del(new fallback_type(player), slot_shoes)

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/syndicate(player), slot_l_ear)

	player.update_icons()
	player.faction = "PRA"

	return 1
