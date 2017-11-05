/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	if(valid_accessory_slots && istype(A) && (A.slot in valid_accessory_slots))
		.=1
	else
		return 0
	if(LAZYLEN(accessories) && restricted_accessory_slots && (A.slot in restricted_accessory_slots))
		for(var/obj/item/clothing/accessory/AC in accessories)
			if (AC.slot == A.slot)
				return 0

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/accessory))

		if(!valid_accessory_slots || !valid_accessory_slots.len)
			usr << "<span class='warning'>You cannot attach accessories of any kind to \the [src].</span>"
			return

		var/obj/item/clothing/accessory/A = I
		if(can_attach_accessory(A))
			user.drop_item()
			attach_accessory(user, A)
			return
		else
			user << "<span class='warning'>You cannot attach more accessories of this type to [src].</span>"
		return

	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(I, user)
		return

	..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(LAZYLEN(accessories) && src.loc == user)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attack_hand(user)
		return
	return ..()

/obj/item/clothing/MouseDrop(var/obj/over_object)
	if (ishuman(usr) || issmall(usr))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if (!(src.loc == usr))
			return

		if(!over_object)
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if (!usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

/obj/item/clothing/examine(var/mob/user)
	..(user)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			user << "\A [A] is attached to it."

/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	LAZYADD(accessories, A)
	A.on_attached(src, user)
	src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!(A in accessories))
		return

	A.on_removed(user)
	LAZYREMOVE(accessories, A)
	update_clothing_icon()

/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(!LAZYLEN(accessories)) return
	var/obj/item/clothing/accessory/A
	if(LAZYLEN(accessories) > 1)
		A = input("Select an accessory to remove from [src]") as null|anything in accessories
	else
		A = accessories[1]
	src.remove_accessory(usr,A)
	if(!LAZYLEN(accessories))
		src.verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()
