var/datum/antagonist/commander/commander

/datum/antagonist/commander
	id = MODE_COMMANDER
	role_text = "Syndicate Commander"
	role_text_plural = "Syndicate Commanders"
	welcome_text = "You are in charge of the syndicate sleeper agents aboard the NSS Aurora. Their success, and the Syndicate's, rests in your capable hands. Good luck."
	id_type = /obj/item/weapon/card/id/syndicate
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	landmark_id = "Syndicate-Spawn"

	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/commander/New()
    ..()
    commander = src

/datum/antagonist/commander/equip(var/mob/living/carbon/human/player)
	if(!..())
		return 0

	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(player), slot_shoes)
	if(!player.shoes) //If equipping shoes failed, fall back to equipping toeless jackboots
		var/fallback_type = pick(/obj/item/clothing/shoes/jackboots/unathi)
		player.equip_to_slot_or_del(new fallback_type(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/military(player), slot_belt)
	if(player.backbag == 2) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/syndie(player), slot_back)
	if(player.backbag == 3) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_syndie(player), slot_back)
	if(player.backbag == 4) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(player), slot_back)
	if(player.backbag == 5) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/duffel/syndie(player), slot_back)
	if(player.backbag == 6) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/messenger/syndie(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(player.back), slot_in_backpack)

	var/obj/item/device/radio/uplink/U = new(player.loc, player.mind, DEFAULT_TELECRYSTAL_AMOUNT)
	player.put_in_hands(U)

	player.update_icons()
	player.faction = "syndicate"

	create_id("Mercenary", player)
	create_radio(SYND_FREQ, player)

	return 1