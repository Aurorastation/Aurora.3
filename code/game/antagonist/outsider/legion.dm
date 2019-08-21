var/datum/antagonist/legion/legion

/datum/antagonist/legion
	id = MODE_LEGION
	bantype = "Tau Ceti Foreign Legion"
	role_text = "Tau Ceti Foreign Legion Volunteer"
	role_text_plural = "Tau Ceti Foreign Legion Volunteers"
	welcome_text = "As member of the Tau Ceti Foreign Legion, you answer to your leader and NanoTrasen officials."
	leader_welcome_text = "As leader of the Tau Ceti Foreign Legion Team, you answer only to the Tau Ceti government and NanoTrasen officials. It is recommended that you attempt to cooperate with the captain and the crew when possible."
	landmark_id = "Tau Ceti Legion"

	id_type = /obj/item/weapon/card/id/legion

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7

/datum/antagonist/legion/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/legion/New()
	..()
	legion = src

/datum/antagonist/legion/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current,  "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect [current_map.company_name]. There is a code red alert on [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/legion/equip(var/mob/living/carbon/human/player)

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/legion(src), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/legion(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/legion(src), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(player.back), slot_in_backpack)

	create_id(role_text, player)
	return 1
