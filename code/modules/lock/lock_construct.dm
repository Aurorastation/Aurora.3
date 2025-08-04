/obj/item/material/lock_construct
	name = "lock"
	desc = "A crude but useful lock and bolt."
	icon = 'icons/obj/crate.dmi'
	icon_state = "largebinemag"
	w_class = WEIGHT_CLASS_TINY
	var/lock_data

/obj/item/material/lock_construct/Initialize(newloc, material_key)
	. = ..()
	force = 0
	throwforce = 0
	lock_data = generateRandomString(round(material.integrity/50))

/obj/item/material/lock_construct/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/key))
		var/obj/item/key/K = attacking_item
		if(!K.key_data)
			to_chat(user, SPAN_NOTICE("You fashion \the [attacking_item] to unlock \the [src]"))
			K.key_data = lock_data
		else
			to_chat(user, SPAN_WARNING("\The [attacking_item] already unlocks something."))
		return
	..()

/obj/item/material/lock_construct/proc/create_lock(var/atom/target, var/mob/user)
	. = new /datum/lock(target,lock_data)
	user.drop_from_inventory(src,user)
	user.visible_message(SPAN_NOTICE("\The [user] attaches \the [src] to \the [target]."))
	qdel(src)
