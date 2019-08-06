
//Non-Armour hats
/obj/item/clothing/head/fleet/securityberet
	name = "Fleet Security beret"
	desc = "A slick black beret worn by Intelligence Operatives and Commanders."
	icon_state = "ccberet"

/obj/item/clothing/head/fleet/officerberet
	name = "Officer beret"
	desc = "A Naval Intelligence Officers beret, belonging to a member of the Terran Eighth Fleet.."
	icon_state = "iofficerberet"

//Civil Protection Helmets
/obj/item/clothing/head/helmet/fleet
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/fleet/trooper
	name = "Fleet Security helmet"
	desc = "A full helmet made of highly advanced ceramic materials, complete with a blue visor. Worn by Intelligence Operatives and Commanders."
	icon_state = "cphelm"
	item_state = "cphelm"
	body_parts_covered = HEAD|FACE|EYES //face shield
	flags_inv = HIDEEARS
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/fleet/civilprotection/attack_self(mob/user as mob)
	if (use_check_and_message(user))
		return

	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]-up"
		to_chat(user, "You raise the visor on \the [src].")
		body_parts_covered = HEAD
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on \the [src].")
		body_parts_covered = HEAD|FACE|EYES
	update_clothing_icon()