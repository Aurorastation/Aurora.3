/obj/item/modular_computer/wristbound
	name = "wristbound computer"
	desc = "A portable wristbound device for your needs on the go. Quite comfortable."
	description_info = "A NanoTrasen design, this wristbound computer allows the user to quickly and safely access critical info, without taking their hands out of the equation."
	icon = 'icons/obj/modular_wristbound.dmi'
	icon_state = "wristbound"
	icon_state_unpowered = "wristbound_unpowered"
	icon_state_menu = "menu"
	icon_state_screensaver = "standby"
	hardware_flag = PROGRAM_WRISTBOUND
	slot_flags = SLOT_GLOVES
	max_hardware_size = 1
	w_class = ITEMSIZE_NORMAL
	light_strength = 1
	menu_light_color = COLOR_GREEN

/obj/item/modular_computer/wristbound/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.gloves == src)
			return attack_self(user)
	..()

/obj/item/modular_computer/wristbound/MouseDrop(obj/over_object)
	var/mob/living/carbon/user = usr
	if(!ishuman(user) || !issmall(user))
		return
	switch(over_object.name)
		if(BP_R_HAND)
			user.u_equip(src)
			user.put_in_r_hand(src, FALSE)
		if(BP_L_HAND)
			user.u_equip(src)
			user.put_in_l_hand(src, FALSE)

/obj/item/modular_computer/wristbound/AltClick(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.gloves == src)
			H.unEquip(src)