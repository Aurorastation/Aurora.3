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

	description_fluff = "Adapted from fishing tools, Frozen Sea Harpoon Guns were found to be useful weapons in the hands of the Royal Navy and Army. Their ammunition can be equipped \
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
	if(wielded)
		item_state = "[initial(item_state)]-[harpoons.len]-w"
	else
		item_state = "[initial(icon_state)]-[harpoons.len]"
	update_held_icon()

/obj/item/gun/launcher/harpoon/special_check(mob/user)
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing \the [src]!</span>")
		return FALSE
	return ..()

/obj/item/gun/launcher/harpoon/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/material/harpoon))
		if(harpoons.len < max_harpoons)
			user.drop_from_inventory(I,src)
			harpoons += I
			to_chat(user, "<span class='notice'>You load \the [I] in \the [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='warning'>\The [src] is already loaded.</span>")


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
