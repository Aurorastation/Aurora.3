var/datum/antagonist/highlander/highlanders

/datum/antagonist/highlander
	role_text = "Highlander"
	role_text_plural = "Highlanders"
	welcome_text = "There can be only one."
	id = MODE_HIGHLANDER
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 3
	initial_spawn_target = 5

	bantype = "highlander"

/datum/antagonist/highlander/New()
	..()
	highlanders = src

/datum/antagonist/highlander/create_objectives(var/datum/mind/player)

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = player
	steal_objective.set_target("nuclear authentication disk")
	player.objectives |= steal_objective

	var/datum/objective/hijack/hijack_objective = new
	hijack_objective.owner = player
	player.objectives |= hijack_objective

/datum/antagonist/highlander/equip(var/mob/living/carbon/human/player)

	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/highlander, FALSE)
	player.equipOutfit(/datum/outfit/admin/highlander, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

/proc/only_one()

	if(!ROUND_IS_STARTED)
		alert("The game hasn't started yet!")
		return

	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		highlanders.add_antagonist(H.mind)

	message_admins("<span class='notice'>[key_name_admin(usr)] used THERE CAN BE ONLY ONE!</span>", 1)
	log_admin("[key_name(usr)] used there can be only one.", admin_key=key_name(usr))
