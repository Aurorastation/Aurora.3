/obj/structure/weapon_rack
	name = "weapon rack"
	desc = "A wooden rack designated to store weapons."
	icon = 'icons/obj/weaponrack.dmi'
	icon_state = "rack"
	anchored = TRUE
	density = FALSE

	var/obj/item/held_weapon

/obj/structure/weapon_rack/Initialize()
	. = ..()
	if(held_weapon)
		held_weapon = new held_weapon(src)
		icon_state = initial(icon_state) + "_[held_weapon.icon_state]"

/obj/structure/weapon_rack/attackby(obj/item/W, mob/user)
	if(isrobot(user))
		return
	if((initial(icon_state) + "_[W.icon_state]") in icon_states(icon))
		user.unEquip(W)
		W.forceMove(src)
		held_weapon = W
		to_chat(user, SPAN_NOTICE("You place \the [W] on \the [src]."))
		icon_state = initial(icon_state) + "_[W.icon_state]"
	else
		to_chat(user, SPAN_NOTICE("[W] does not fit on \the [src]."))

/obj/structure/weapon_rack/attack_hand(mob/user)
	if(isrobot(user))
		return
	if (!user.can_use_hand())
		return
	if(held_weapon)
		user.put_in_hands(held_weapon)
		to_chat(user, SPAN_NOTICE("You take \the [held_weapon] from \the [src]."))
		held_weapon = null
		icon_state = initial(icon_state)

/obj/structure/weapon_rack/do_simple_ranged_interaction(var/mob/user)
	if(held_weapon)
		held_weapon.forceMove(loc)
		to_chat(user, SPAN_NOTICE("You telekinetically remove \the [held_weapon] from \the [src]."))
		held_weapon = null
		icon_state = initial(icon_state)

// Premade types

/obj/structure/weapon_rack/double
	held_weapon = /obj/item/gun/projectile/shotgun/doublebarrel

/obj/structure/weapon_rack/double_pellet
	held_weapon = /obj/item/gun/projectile/shotgun/doublebarrel/pellet

/obj/structure/weapon_rack/pump
	held_weapon = /obj/item/gun/projectile/shotgun/pump

/obj/structure/weapon_rack/combat
	held_weapon = /obj/item/gun/projectile/shotgun/pump/combat

/obj/structure/weapon_rack/improvised
	held_weapon = /obj/item/gun/projectile/shotgun/improvised

/obj/structure/weapon_rack/dragunov
	name = "marksman rifle rack"
	desc = "A wooden rack holding a marksman rifle."
	held_weapon = /obj/item/gun/projectile/dragunov
