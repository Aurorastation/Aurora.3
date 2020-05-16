var/datum/antagonist/renegade/renegades

/datum/antagonist/renegade
	role_text = "Renegade"
	role_text_plural = "Renegades"
	welcome_text = "You're extremely paranoid today. For your entire life, you've theorized about a shadow corporation out for your blood and yours only. Something's here to kill you, but you don't know what... Remember that you're not a full antagonist. You can prepare to murder someone and kill, but you shouldn't actively seek conflict."
	id = MODE_RENEGADE
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 7

	hard_cap = 8
	hard_cap_round = 12
	initial_spawn_req = 3
	initial_spawn_target = 6

	bantype = "renegade"

/datum/antagonist/renegade/New()
	..()
	renegades = src

/datum/antagonist/renegade/can_become_antag(var/datum/mind/player, var/ignore_role)
	if(..())
		if(player.current && ishuman(player.current))
			return TRUE
	return FALSE

/datum/antagonist/renegade/create_objectives(var/datum/mind/player)
	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/datum/antagonist/renegade/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	if(!player.back)
		player.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(player), slot_back) // if they have no backpack, spawn one
	player.equip_to_slot_or_del(new /obj/item/storage/box/syndie_kit/random_weapon/concealable(player), slot_in_backpack)

/proc/rightandwrong()
	to_chat(usr, "<B>You summoned guns!</B>")
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		renegades.add_antagonist(H.mind)
