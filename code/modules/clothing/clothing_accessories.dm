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
			to_chat(usr, "<span class='warning'>You cannot attach accessories of any kind to \the [src].</span>")
			return

		var/obj/item/clothing/accessory/A = I
		if(can_attach_accessory(A))
			user.drop_item()
			attach_accessory(user, A)
			return
		else
			to_chat(user, "<span class='warning'>You cannot attach more accessories of this type to [src].</span>")
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
	if(ishuman(usr) || issmall(usr))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if(!(src.loc == usr))
			return

		if(!over_object || over_object == src)
			return

		if(istype(over_object, /obj/screen/inventory))
			var/obj/screen/inventory/S = over_object
			if(S.slot_id == src.equip_slot)
				return

		if(use_check_and_message(usr))
			return

		if(!usr.canUnEquip(src))
			return

		var/obj/item/clothing/C = src
		usr.unEquip(C)

		switch(over_object.name)
			if("right hand")
				if(istype(src, /obj/item/clothing/ears))
					C = check_two_ears(usr)
				usr.equip_to_slot_if_possible(C, slot_r_hand)
			if("left hand")
				if(istype(src, /obj/item/clothing/ears))
					C = check_two_ears(usr)
				usr.equip_to_slot_if_possible(C, slot_l_hand)
		src.add_fingerprint(usr)

/obj/item/clothing/proc/check_two_ears(var/mob/user)
	// if you have to ask, it's earcode
	// var/obj/item/clothing/ears/E
	var/obj/item/clothing/ears/main_ear
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	for(var/obj/item/clothing/ears/E in H.contents)
		H.u_equip(E)
		if(istype(E, /obj/item/clothing/ears/offear))
			qdel(E)
		else
			main_ear = E

	return main_ear


/obj/item/clothing/examine(var/mob/user)
	..(user)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			to_chat(user, "\A [A] [A.gender == PLURAL ? "are" : "is"] attached to it.")

/obj/item/clothing/proc/update_accessory_slowdown()
	slowdown_accessory = 0
	for(var/obj/item/clothing/accessory/bling in accessories)
		slowdown_accessory += bling.slowdown

/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	LAZYADD(accessories, A)
	A.on_attached(src, user)
	src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_clothing_icon()
	update_accessory_slowdown()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!(A in accessories))
		return

	A.on_removed(user)
	LAZYREMOVE(accessories, A)
	update_clothing_icon()
	update_accessory_slowdown()

/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return

	var/mob/living/M = usr

	if(use_check_and_message(M))
		return

	if(!LAZYLEN(accessories))
		return
	
	var/obj/item/clothing/accessory/A
	if(LAZYLEN(accessories) > 1)
		var/list/options = list()
		for (var/obj/item/clothing/accessory/i in accessories)
			var/image/radial_button = image(icon = i.icon, icon_state = i.icon_state)
			options[i] = radial_button
		A = show_radial_menu(M, M, options, radius = 42, tooltips = TRUE)
	else
		A = accessories[1]
	remove_accessory(usr,A)
	if(!LAZYLEN(accessories))
		verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()
