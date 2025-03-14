/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	if(valid_accessory_slots && istype(A) && (A.slot in valid_accessory_slots))
		.=1
	else
		return 0
	if(LAZYLEN(accessories) && restricted_accessory_slots && (A.slot in restricted_accessory_slots))
		for(var/obj/item/clothing/accessory/AC in accessories)
			if (AC.slot == A.slot)
				return 0

/obj/item/clothing/attackby(obj/item/attacking_item, mob/user)
	if(IC && (istype(attacking_item, /obj/item/integrated_circuit) || attacking_item.iswrench() || attacking_item.iscrowbar() || \
				istype(attacking_item, /obj/item/device/integrated_electronics/wirer) || istype(attacking_item, /obj/item/device/integrated_electronics/debugger) || \
				attacking_item.ismultitool() || attacking_item.isscrewdriver() || istype(attacking_item, /obj/item/cell/device)))

		IC.attackby(attacking_item, user)

	else if(istype(attacking_item, /obj/item/clothing/accessory))

		if(!valid_accessory_slots || !valid_accessory_slots.len)
			to_chat(usr, SPAN_WARNING("You cannot attach accessories of any kind to \the [src]."))
			return

		var/obj/item/clothing/accessory/A = attacking_item
		A.before_attached(src, user)
		if(can_attach_accessory(A))
			user.drop_item()
			attach_accessory(user, A)
			return
		else
			to_chat(user, SPAN_WARNING("You cannot attach more accessories of this type to [src]."))
		return

	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(attacking_item, user)
		return

	..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(LAZYLEN(accessories) && src.loc == user)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attack_hand(user)
		return
	return ..()

/obj/item/clothing/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(ishuman(user) || issmall(user))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if(!(src.loc == user))
			return

		if(!over || over == src)
			return

		if(istype(over, /atom/movable/screen/inventory))
			var/atom/movable/screen/inventory/S = over
			if(S.slot_id == src.equip_slot)
				return

		if(use_check_and_message(user))
			return

		if(!user.canUnEquip(src))
			return

		var/obj/item/clothing/C = src
		user.unEquip(C)

		switch(over.name)
			if("right hand")
				if(istype(src, /obj/item/clothing/ears))
					C = check_two_ears(user)
				user.equip_to_slot_if_possible(C, slot_r_hand)
			if("left hand")
				if(istype(src, /obj/item/clothing/ears))
					C = check_two_ears(user)
				user.equip_to_slot_if_possible(C, slot_l_hand)
		src.add_fingerprint(user)

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


/obj/item/clothing/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			. += SPAN_NOTICE("<a href='byond://?src=[REF(user)];lookitem=[REF(A)]>\A [A]</a> [A.gender == PLURAL ? "are" : "is"] attached to it.")

/obj/item/clothing/proc/update_accessory_slowdown(mob/user)
	slowdown_accessory = 0
	for(var/obj/item/clothing/accessory/bling in accessories)
		slowdown_accessory += bling.slowdown
	user?.update_equipment_speed_mods()

/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	LAZYADD(accessories, A)

	// sort the accessories so that they render correctly
	var/list/new_accessory_list = list()
	var/list/accessories_by_layer = list()

	for(var/i = ACCESSORY_LOWEST_LAYER, i <= ACCESSORY_HIGHEST_LAYER, i++)
		accessories_by_layer["[i]"] = list()

	for(var/obj/item/clothing/accessory/accessory as anything in accessories)
		accessories_by_layer["[accessory.accessory_layer]"] += accessory

	for(var/i = ACCESSORY_LOWEST_LAYER, i <= ACCESSORY_HIGHEST_LAYER, i++)
		var/list/layered_accessories = accessories_by_layer["[i]"]
		for(var/obj/item/clothing/accessory/accessory as anything in layered_accessories)
			new_accessory_list += accessory

	accessories = new_accessory_list

	A.on_attached(src, user)
	src.verbs |= /obj/item/clothing/proc/remove_accessory_verb

	update_clothing_icon()
	update_accessory_slowdown()
	recalculate_body_temperature_change()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!(A in accessories))
		return

	A.on_removed(user)
	LAZYREMOVE(accessories, A)
	update_clothing_icon()
	update_accessory_slowdown(user)
	recalculate_body_temperature_change()

/obj/item/clothing/proc/remove_accessory_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr

	remove_accessory_handler(usr)

/obj/item/clothing/proc/remove_accessory_handler(var/mob/living/user, var/force_radial = FALSE)
	if(!isliving(user))
		return

	if(use_check_and_message(user))
		return

	if(!LAZYLEN(accessories))
		return

	var/try_reopen_radial_after_removal = FALSE

	var/obj/item/clothing/accessory/A
	if(force_radial || LAZYLEN(accessories) > 1)
		var/list/options = list()
		for (var/obj/item/clothing/accessory/i in accessories)
			var/image/radial_button = image(icon = i.icon, icon_state = i.icon_state)
			if(i.color)
				radial_button.color = i.color
			if(i.build_from_parts && i.worn_overlay)
				radial_button.ClearOverlays()
				radial_button.AddOverlays(overlay_image(i.icon, "[i.icon_state]_[i.worn_overlay]", flags=RESET_COLOR))
			options[i] = radial_button
		A = show_radial_menu(user, user, options, radius = 42, tooltips = TRUE)
		if(!A)
			return
		try_reopen_radial_after_removal = TRUE
	else
		A = accessories[1]

	remove_accessory(usr, A)

	if(try_reopen_radial_after_removal)
		remove_accessory_handler(user, TRUE)
	else if(!LAZYLEN(accessories))
		verbs -= /obj/item/clothing/proc/remove_accessory_verb

/obj/item/clothing/emp_act(severity)
	. = ..()

	if(IC)
		IC.emp_act(severity)

	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
