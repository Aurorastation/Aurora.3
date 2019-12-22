/obj/item/material/lock_construct
	name = "lock"
	desc = "A crude but useful lock and bolt."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebinemag"
	w_class = 1
	var/lock_data

/obj/item/material/lock_construct/New()
	..()
	force = 0
	throwforce = 0
	lock_data = generateRandomString(round(material.integrity/50))

/obj/item/material/lock_construct/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/key))
		var/obj/item/key/K = I
		if(!K.key_data)
			to_chat(user, "<span class='notice'>You fashion \the [I] to unlock \the [src]</span>")
			K.key_data = lock_data
		else
			to_chat(user, "<span class='warning'>\The [I] already unlocks something.</span>")
		return
	..()

/obj/item/material/lock_construct/proc/create_lock(var/atom/target, var/mob/user)
	. = new /datum/lock(target,lock_data)
	user.drop_from_inventory(src,user)
	user.visible_message("<span class='notice'>\The [user] attaches \the [src] to \the [target].</span>")
	qdel(src)
