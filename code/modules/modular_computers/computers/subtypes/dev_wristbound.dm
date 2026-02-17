/obj/item/modular_computer/handheld/wristbound
	name = "wristbound computer"
	lexical_name = "wristbound"
	desc = "A portable wristbound device for your needs on the go. Quite comfortable."
	desc_extended = "A NanoTrasen design, this wristbound computer allows the user to quickly and safely access critical info, without taking their hands out of the equation."
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

/obj/item/modular_computer/handheld/wristbound/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	var/mob/living/carbon/human/H = user
	var/atom/movable/screen/inventory/S = over
	if(!canremove || !istype(over) || over == src || !istype(H) || S.slot_id == equip_slot)
		return

	if(!(loc == user) || (loc && loc.loc == user))
		return
	if(use_check_and_message(user))
		return
	if(!user.unEquip(src))
		return

	user.u_equip(src)
	user.equip_to_slot_if_possible(src, S.slot_id)
	add_fingerprint(user)
