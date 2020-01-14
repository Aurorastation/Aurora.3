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

	var/list/spawn_guns = list(
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/retro,
		/obj/item/gun/energy/xray,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/projectile/revolver/deckard,
		/obj/item/gun/projectile/revolver/adhomian,
		/obj/item/gun/projectile/automatic/c20r,
		/obj/item/gun/projectile/deagle,
		/obj/item/gun/projectile/pistol,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/gun/projectile/shotgun/pump/rifle/obrez,
		/obj/item/gun/projectile/automatic,
		/obj/item/gun/projectile/automatic/c20r,
		/obj/item/gun/projectile/automatic/tommygun,
		/obj/item/gun/projectile/automatic/mini_uzi,
		/obj/item/gun/projectile/tanto
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
	if(!player.back)
		player.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(player), slot_back) // if they have no backpack, spawn one
	player.equip_to_slot_or_del(new gun_type(player), slot_in_backpack)

/proc/rightandwrong()
	to_chat(usr, "<B>You summoned guns!</B>")
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		renegades.add_antagonist(H.mind)
