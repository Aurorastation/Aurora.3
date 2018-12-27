var/datum/antagonist/tcfl/tcfl

/datum/antagonist/tcfl
	id = MODE_TCFL
	bantype = "Tau Ceti Foreign Legion"
	role_text = "Tau Ceti Foreign Legion Volunteer"
	role_text_plural = "Tau Ceti Foreign Legion Volunteers"
	welcome_text = "As member of the Tau Ceti Foreign Legion, you answer only to your leader and goverment officials."
	leader_welcome_text = "As leader of the au Ceti Foreign Legion Team, you answer only to goverment officials, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
	landmark_id = "Tau Ceti Legion"

	id_type = /obj/item/weapon/card/id/tcfl

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7

/datum/antagonist/tcfl/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/tcfl/New()
	..()
	tcfl = src

/datum/antagonist/tcfl/greet(var/datum/mind/player)
	if(!..())
		return
	player.current << "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect [current_map.company_name]. There is a code red alert on [station_name()], you are tasked to go and fix the problem."
	player.current << "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready."

/datum/antagonist/tcfl/equip(var/mob/living/carbon/human/player)

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/tcfl(src), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/tcfl(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/legion(src), slot_back)

	create_id(role_text, player)
	return 1
