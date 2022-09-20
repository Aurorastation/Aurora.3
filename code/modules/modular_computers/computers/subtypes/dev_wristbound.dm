/obj/item/modular_computer/handheld/wristbound
	name = "wristbound computer"
	lexical_name = "wristbound"
	desc = "A portable wristbound device for your needs on the go. Quite comfortable."
	desc_lore = "A NanoTrasen design, this wristbound computer allows the user to quickly and safely access critical info, without taking their hands out of the equation."
	icon = 'icons/obj/modular_wristbound.dmi'
	icon_state = "wristbound"
	icon_state_unpowered = "wristbound"
	icon_state_menu = "menu"
	icon_state_screensaver = "standby"
	hardware_flag = PROGRAM_WRISTBOUND
	slot_flags = SLOT_WRISTS|SLOT_ID
	can_reset = TRUE
	max_hardware_size = 1
	menu_light_color = COLOR_GREEN

/obj/item/modular_computer/handheld/wristbound/set_icon()
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/wristbound/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.wrists == src || H.wear_id == src)
			return attack_self(user)
	..()

/obj/item/modular_computer/handheld/wristbound/MouseDrop(obj/over_object)
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
			if("right hand")
				usr.u_equip(src)
				usr.equip_to_slot_if_possible(src, slot_r_hand)
			if("left hand")
				usr.u_equip(src)
				usr.equip_to_slot_if_possible(src, slot_l_hand)
		add_fingerprint(usr)
