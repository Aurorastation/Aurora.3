/obj/item/gun/launcher/harpoon
	name = "harpoon gun"
	desc = "A harpoon cannon adapted into a portable firearm. Perfect for hunting space whales."
	icon = 'icons/obj/guns/harpoon.dmi'
	icon_state = "harpoon"
	item_state = "harpoon"
	release_force = 25
	throw_distance = 12
	needspin = FALSE

	slot_flags = SLOT_BELT

	is_wieldable = TRUE

	fire_sound = 'sound/weapons/crossbow.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 1

	desc_extended = "Adapted from fishing tools, Frozen Sea Harpoon Guns were found to be useful weapons in the hands of the Royal Navy and Army. Their ammunition can be equipped \
	with all shorts of implements, such as explosives and even grappling hooks. Large guns are usually mounted on warships, serving as a complement to their traditional cannons. \
	While smaller version are carried by sailors and fishermen."

	var/max_harpoons = 1
	var/list/harpoons = list()


/obj/item/gun/launcher/harpoon/Initialize()
	. = ..()
	var/obj/item/material/harpoon/H = new(src)
	harpoons += H
	update_icon()

/obj/item/gun/launcher/harpoon/update_icon()
	icon_state = "[initial(icon_state)]-[harpoons.len]"
	item_state = "[initial(item_state)]-[harpoons.len]"
	..()

/obj/item/gun/launcher/harpoon/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
		return FALSE
	return ..()

/obj/item/gun/launcher/harpoon/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/harpoon))
		if(harpoons.len < max_harpoons)
			user.drop_from_inventory(attacking_item, src)
			harpoons += attacking_item
			to_chat(user, SPAN_NOTICE("You load \the [attacking_item] in \the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is already loaded."))


/obj/item/gun/launcher/harpoon/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(harpoons.len)
			var/obj/item/material/harpoon/I = harpoons[1]
			I.forceMove(get_turf(src))
			user.put_in_hands(I)
			harpoons -= I
			update_icon()
	else
		..()

/obj/item/gun/launcher/harpoon/consume_next_projectile()
	if(harpoons.len)
		var/obj/item/material/harpoon/I = harpoons[1]
		I.prime()
		harpoons -= I
		return I
	return null
