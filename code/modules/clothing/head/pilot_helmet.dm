/obj/item/clothing/head/helmet/legion_pilot
	name = "foreign legion flight helmet"
	desc = "A helmet with an aged pilot visor mounted to it. The visor feeds its wearer in-flight information via a heads-up display."
	icon_state = "legion_pilot"
	body_parts_covered = null
	flags_inv = BLOCKHEADHAIR
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	camera = /obj/machinery/camera/network/tcfl
	siemens_coefficient = 0.35
	action_button_name = "Flip Pilot Visor"

	var/flipped_up = FALSE
	var/obj/machinery/computer/shuttle_control/linked_console
	var/obj/pilot_overlay_holder/hud_overlay

/obj/item/clothing/head/helmet/legion_pilot/Initialize()
	. = ..()
	hud_overlay = new(src)

/obj/item/clothing/head/helmet/legion_pilot/Destroy()
	linked_console = null
	return ..()

/obj/item/clothing/head/helmet/legion_pilot/attack_self()
	flip_visor()

/obj/item/clothing/head/helmet/legion_pilot/verb/flip_visor()
	set name = "Flip Pilot Visor"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return

	flipped_up = !flipped_up
	if(flipped_up)
		icon_state = "[initial(icon_state)]_up"
		to_chat(user, SPAN_NOTICE("You flip up the pilot visor."))
		set_hud_overlay(user, FALSE)
	else
		icon_state = initial(icon_state)
		to_chat(user, SPAN_NOTICE("You flip down the pilot visor."))
		sound_to(user, 'sound/items/goggles_charge.ogg')
		set_hud_overlay(user, TRUE)
	update_clothing_icon()
	user.update_action_buttons()

/obj/item/clothing/head/helmet/legion_pilot/dropped(mob/user)
	. = ..()
	set_hud_overlay(user, FALSE)

/obj/item/clothing/head/helmet/legion_pilot/on_slotmove(mob/user, slot)
	. = ..()
	set_hud_overlay(user, FALSE)

/obj/item/clothing/head/helmet/legion_pilot/equipped(mob/user, slot)
	. = ..()
	set_hud_overlay(user, TRUE)

/obj/item/clothing/head/helmet/legion_pilot/proc/set_hud_overlay(var/mob/user, var/on = TRUE)
	if(!user.client)
		return
	if(on && get_equip_slot() == slot_head)
		user.client.screen |= hud_overlay
	else
		user.client.screen -= hud_overlay

/obj/pilot_overlay_holder
	name = null
	icon = null
	icon_state = null
	screen_loc = "CENTER,CENTER"

/obj/pilot_overlay_holder/Initialize(mapload, ...)
	. = ..()
	maptext = SMALL_FONTS(7, "bingus")