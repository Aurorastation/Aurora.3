/obj/item/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/items.dmi'
	icon_state = "keys"
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	w_class = ITEMSIZE_TINY
	var/key_data = ""

/obj/item/key/New(var/newloc,var/data)
	if(data)
		key_data = data
	..(newloc)

/obj/item/key/proc/get_data(var/mob/user)
	return key_data

/obj/item/key/soap
	name = "soap key"
	desc = "a fragile key made using a bar of soap."
	var/uses = 0

/obj/item/key/soap/get_data(var/mob/user)
	uses--
	if(uses <= 0)
		user.drop_from_inventory(src,user)
		to_chat(user, "<span class='warning'>\The [src] crumbles in your hands!</span>")
		qdel(src)
	return ..()

/obj/item/key/bike
	name = "bike key"
	desc = "Used to start a bike."
	icon_state = "key_tag_gray"

/obj/item/key/bike/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "\The [src] has a small tag attached to it, written on it is '[key_data]'."

/obj/item/key/bike/sport
	name = "sports bike key"
	desc = "Used to start a sporty, fast bike."
	icon_state = "key_tag_red"

/obj/item/key/bike/sport/Initialize(mapload, ...)
	. = ..()
	icon_state = pick("key_tag_red", "key_tag_blue")

/obj/item/key/bike/moped
	name = "moped key"
	desc = "Used to start a cheap moped bike."
	icon_state = "key_tag_green"

/obj/item/key/bike/moped/Initialize(mapload, ...)
	. = ..()
	icon_state = pick("key_tag_gray", "key_tag_green", "key_tag_purple")

/obj/item/key/bike/police
	name = "police bike key"
	desc = "Used to start a police bike."
	icon_state = "key_tag_police"
