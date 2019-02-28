var/datum/antagonist/renegade/renegades

/datum/antagonist/renegade
	role_text = "Renegade"
	role_text_plural = "Renegades"
	welcome_text = "Your own safety matters above all else, trust no one and kill anyone who gets in your way. However, armed as you are, now would be the perfect time to settle that score or grab that pair of yellow gloves you've been eyeing..."
	id = MODE_RENEGADE
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 7

	hard_cap = 8
	hard_cap_round = 12
	initial_spawn_req = 3
	initial_spawn_target = 6

	var/list/spawn_guns = list(
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/retro,
		/obj/item/weapon/gun/energy/xray,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/gun/projectile/revolver/deckard,
		/obj/item/weapon/gun/projectile/revolver/detective,
		/obj/item/weapon/gun/projectile/revolver/derringer,
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/weapon/gun/projectile/deagle/camo,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle/obrez,
		/obj/item/weapon/gun/projectile/automatic,
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/weapon/gun/projectile/automatic/tommygun,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi,
		/obj/item/weapon/gun/energy/crossbow,
		/obj/item/weapon/gun/projectile/tanto
		)

/datum/antagonist/renegade/New()
	..()
	renegades = src

/datum/antagonist/renegade/create_objectives(var/datum/mind/player)

	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/datum/antagonist/renegade/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	var/gun_type = pick(spawn_guns)
	var/obj/item/gun = new gun_type(get_turf(player))
	if(!(player.l_hand && player.r_hand))
		player.put_in_hands(gun)


/proc/rightandwrong()
	usr << "<B>You summoned guns!</B>"
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		renegades.add_antagonist(H.mind)
