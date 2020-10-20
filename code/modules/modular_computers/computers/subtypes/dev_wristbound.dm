/obj/item/modular_computer/wristbound
	name = "wristbound computer"
	desc = "A portable wristbound device for your needs on the go. Quite comfortable."
	desc_info = "A NanoTrasen design, this wristbound computer allows the user to quickly and safely access critical info, without taking their hands out of the equation."
	icon = 'icons/obj/modular_wristbound.dmi'
	icon_state = "wristbound"
	item_state = "wristbound"
	icon_state_menu = "menu"
	icon_state_screensaver = "standby"
	hardware_flag = PROGRAM_WRISTBOUND
	slot_flags = SLOT_GLOVES|SLOT_ID
	can_reset = TRUE
	max_hardware_size = 1
	w_class = ITEMSIZE_NORMAL
	light_strength = 1
	menu_light_color = COLOR_GREEN
	var/flipped = FALSE
	contained_sprite = TRUE

/obj/item/modular_computer/wristbound/verb/swapwrists()
	set category = "Object"
	set name = "Flip Wristbound Computer Wrist"
	set src in usr

	if(usr.stat || usr.restrained())
		return

	flipped = !flipped
	if(flipped)
		overlay_state = "[item_state]_alt"
		item_state = "[item_state]_alt"
	else
		item_state = initial(item_state)
		overlay_state = initial(overlay_state)
	to_chat(usr, SPAN_NOTICE("You change \the [src] to be on your [src.flipped ? "left" : "right"] hand."))
	if(ismob(loc))
		var/mob/M = src.loc
		M.update_inv_gloves()
		M.update_inv_wear_id()

/obj/item/modular_computer/CouldUseTopic(var/mob/user)
	..()
	if(iscarbon(user))
		playsound(src, 'sound/machines/pda_click.ogg', 20)

/obj/item/modular_computer/wristbound/Initialize()
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state
	. = ..()

/obj/item/modular_computer/wristbound/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.gloves == src || H.wear_id == src)
			return attack_self(user)
	..()

/obj/item/modular_computer/wristbound/MouseDrop(obj/over_object)
	if(!canremove)
		return
	if(!over_object || over_object == src)
		return
	if(istype(over_object, /obj/screen/inventory))
		var/obj/screen/inventory/S = over_object
		if(S.slot_id == equip_slot)
			return
	if(ishuman(usr))
		if(!(istype(over_object, /obj/screen)))
			return ..()

		if(!(loc == usr) || (loc && loc.loc == usr))
			return
		if(use_check_and_message(usr))
			return
		if((loc == usr) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if(BP_R_HAND)
				usr.u_equip(src)
				usr.put_in_r_hand(src,FALSE)
			if(BP_L_HAND)
				usr.u_equip(src)
				usr.put_in_l_hand(src,FALSE)
		add_fingerprint(usr)

/obj/item/modular_computer/wristbound/AltClick(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.gloves == src)
			H.unEquip(src)
