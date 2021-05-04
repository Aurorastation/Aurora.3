/obj/item/clothing/head/helmet/pilot
	name = "flight helmet"
	desc = "A helmet flip-down pilot visor mounted to it. The visor feeds its wearer in-flight information via a heads-up display."
	icon = 'icons/clothing/head/pilot_helmets.dmi'
	icon_state = "pilot_helmet"
	item_state = "pilot_helmet"
	contained_sprite = TRUE
	flags_inv = BLOCKHEADHAIR
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35
	action_button_name = "Flip Pilot Visor"

	var/flipped_up = FALSE
	var/obj/machinery/computer/shuttle_control/linked_console
	var/obj/pilot_overlay_holder/hud_overlay

/obj/item/clothing/head/helmet/pilot/Initialize()
	. = ..()
	hud_overlay = new(src)
	set_hud_maptext("Shuttle Status: No Shuttle Linked.")

/obj/item/clothing/head/helmet/pilot/Destroy()
	if(linked_console)
		linked_console.linked_helmets -= src
		linked_console = null
	return ..()

/obj/item/clothing/head/helmet/pilot/attack_self()
	flip_visor()

/obj/item/clothing/head/helmet/pilot/verb/flip_visor()
	set name = "Flip Pilot Visor"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return

	flipped_up = !flipped_up
	if(flipped_up)
		icon_state = "[initial(icon_state)]_up"
		item_state = "[initial(item_state)]_up"
		body_parts_covered = HEAD
		to_chat(user, SPAN_NOTICE("You flip up the pilot visor."))
		check_hud_overlay(user)
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		body_parts_covered = HEAD|EYES
		to_chat(user, SPAN_NOTICE("You flip down the pilot visor."))
		sound_to(user, 'sound/items/goggles_charge.ogg')
		check_hud_overlay(user)
	update_clothing_icon()
	user.update_action_buttons()

/obj/item/clothing/head/helmet/pilot/dropped(mob/user)
	. = ..()
	check_hud_overlay(user)

/obj/item/clothing/head/helmet/pilot/equipped(mob/user, slot, assisted_equip)
	. = ..()
	check_hud_overlay(user, slot)

/obj/item/clothing/head/helmet/pilot/proc/check_hud_overlay(var/mob/user, var/equip_slot)
	if(!user.client)
		return
	if(!equip_slot)
		equip_slot = get_equip_slot()
	if(!flipped_up && (equip_slot == slot_head))
		user.client.screen |= hud_overlay
	else
		user.client.screen -= hud_overlay

/obj/item/clothing/head/helmet/pilot/proc/set_hud_maptext(var/text)
	if(length(text) > 26)
		hud_overlay.screen_loc = "CENTER:-80,NORTH:-6" // text longer than 26 usually breaks into two lines, we need to shift the screen_loc else it looks weird
	else
		hud_overlay.screen_loc = initial(screen_loc)
	hud_overlay.maptext = SMALL_FONTS(7, "<center>[text]</center>")

/obj/item/clothing/head/helmet/pilot/legion
	name = "foreign legion flight helmet"
	desc = "A helmet clearly belonging to a TCFL pilot, it has aged pilot visor mounted to it. The visor feeds its wearer in-flight information via a heads-up display."
	icon_state = "legion_pilot"
	item_state = "legion_pilot"

/obj/pilot_overlay_holder
	name = null
	icon = null
	icon_state = null
	screen_loc = "CENTER:-80,NORTH"
	maptext_width = 192