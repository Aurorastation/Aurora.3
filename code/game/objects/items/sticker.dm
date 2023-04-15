/obj/item/sticker
	name = "sticker"
	desc = "It's a sticker."
	icon = 'icons/obj/sticker.dmi'
	icon_state = "sticker"
	flags = NOBLUDGEON
	w_class = ITEMSIZE_TINY
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_DIR

	var/datum/weakref/attached
	var/list/rand_icons

/obj/item/sticker/Initialize()
	. = ..()
	if(LAZYLEN(rand_icons))
		icon_state = pick(rand_icons)

/obj/item/sticker/attack_hand(mob/user)
	if(!isliving(user) || !attached)
		return ..()

	if(user.a_intent == I_HELP)
		remove_sticker(user)
		return

	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom)
		attached_atom.attack_hand(user) // don't allow people to make sticker armor

/obj/item/sticker/attack_ranged(mob/user)
	if(!attached)
		return

	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom && user.Adjacent(attached_atom))
		attack_hand(user)

/obj/item/sticker/attackby(obj/item/I, mob/user)
	if(!attached)
		return ..()

	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom)
		attached_atom.attackby(I, user) // don't allow people to make sticker armor
		return TRUE

/obj/item/sticker/afterattack(atom/movable/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!istype(target) || (ismob(target) && !isbot(target)))
		return
	if(!target.can_attach_sticker(user, src))
		return

	var/list/mouse_control = mouse_safe_xy(click_parameters)
	pixel_x = mouse_control["icon-x"] - 16
	pixel_y = mouse_control["icon-y"] - 16

	attach_to(user, target)

/obj/item/sticker/proc/attach_to(var/mob/user, var/atom/movable/A)
	to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [A]."))
	user.drop_from_inventory(src, A)
	attached = WEAKREF(A)
	A.vis_contents += src

/obj/item/sticker/proc/remove_sticker(var/mob/user)
	user.put_in_hands(src)
	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom)
		to_chat(user, SPAN_NOTICE("You remove \the [src] from \the [attached_atom]."))
		attached_atom.vis_contents -= src
		attached = null

/obj/item/sticker/googly_eye
	name = "googly eye"
	desc = "A large googly eye sticker."
	rand_icons = list("googly", "googly1", "googly2")

/obj/item/sticker/goldstar
	name = "gold star"
	desc = "A sticker of a gold star, for those overachievers."
	icon_state = "goldstar"
