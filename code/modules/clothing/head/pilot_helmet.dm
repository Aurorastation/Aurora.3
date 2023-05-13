/obj/item/clothing/head/helmet/pilot
	name = "flight helmet"
	desc = "A helmet with a toggleable pilot visor attached. The visor feeds its wearer in-flight information via an integrated heads-up display."
	icon = 'icons/clothing/head/pilot_helmets.dmi'
	icon_state = "pilot_helmet"
	item_state = "pilot_helmet"
	contained_sprite = TRUE
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD|EYES
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35
	action_button_name = "Toggle Visor"

	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/helmet.dmi'
		)

	var/visor_toggled = FALSE
	var/obj/machinery/computer/shuttle_control/linked_console
	var/obj/machinery/computer/ship/helm/linked_helm

	var/obj/pilot_overlay_holder/hud_overlay
	var/obj/pilot_overlay_holder/ship_hud/ship_overlay

	has_storage = FALSE

/obj/item/clothing/head/helmet/pilot/Initialize()
	. = ..()
	hud_overlay = new(src)
	ship_overlay = new(src)
	set_console(null)

/obj/item/clothing/head/helmet/pilot/Destroy()
	if(linked_console)
		linked_console.linked_helmets -= src
		linked_console = null
	return ..()

/obj/item/clothing/head/helmet/pilot/proc/set_console(var/obj/machinery/computer/C)
	if(linked_console)
		linked_console.linked_helmets -= src
		linked_console = null
	if(linked_helm)
		linked_helm.linked_helmets -= src
		linked_helm = null

	if(!isnull(C))
		if(istype(C, /obj/machinery/computer/shuttle_control))
			linked_console = C
			linked_console.linked_helmets += src
			hud_overlay.maptext_height = initial(hud_overlay.maptext_height)
			hud_overlay.maptext_y = initial(hud_overlay.maptext_y)
		else if(istype(C, /obj/machinery/computer/ship/helm))
			linked_helm = C
			linked_helm.linked_helmets += src
			hud_overlay.maptext_height = 64
			hud_overlay.maptext_y = -12
			check_ship_overlay(loc, linked_helm.linked)
	else
		set_hud_maptext("Vessel Status: No Vessel Linked.")

/obj/item/clothing/head/helmet/pilot/attack_self()
	visor_toggled()

/obj/item/clothing/head/helmet/pilot/verb/visor_toggled()
	set name = "Toggle Visor"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return

	visor_toggled = !visor_toggled
	if(visor_toggled)
		icon_state = "[initial(icon_state)]_off"
		item_state = "[initial(item_state)]_off"
		to_chat(user, SPAN_NOTICE("You deactivate the pilot visor."))
		check_hud_overlay(user)
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		to_chat(user, SPAN_NOTICE("You activate the pilot visor."))
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
	if(!istype(user) || !user.client)
		return
	if(!equip_slot)
		equip_slot = get_equip_slot()
	if(!visor_toggled && (equip_slot == slot_head))
		user.client.screen |= hud_overlay
	else
		user.client.screen -= hud_overlay
	check_ship_overlay(user, null, equip_slot)

/obj/item/clothing/head/helmet/pilot/proc/check_ship_overlay(var/mob/user, var/obj/effect/overmap/visitable/V, var/equip_slot)
	if(!istype(user) || !user.client)
		return
	if(!equip_slot)
		equip_slot = get_equip_slot()

	if(!V && linked_helm)
		V = linked_helm.linked
	if(!V)
		return

	if(V)
		ship_overlay.appearance = V.appearance
		ship_overlay.dir = V.dir
		ship_overlay.mouse_opacity = 0
	else
		ship_overlay.icon = null
		ship_overlay.icon_state = null

	if(!visor_toggled && (equip_slot == slot_head))
		user.client.screen |= ship_overlay
	else
		user.client.screen -= ship_overlay

/obj/item/clothing/head/helmet/pilot/proc/set_hud_maptext(var/text)
	if(length(text) > 26)
		hud_overlay.screen_loc = "CENTER:-80,NORTH:-6" // text longer than 26 usually breaks into two lines, we need to shift the screen_loc else it looks weird
	else
		hud_overlay.screen_loc = initial(screen_loc)
	hud_overlay.maptext = SMALL_FONTS(7, "<center>[text]</center>")

/obj/item/clothing/head/helmet/pilot/legion
	name = "foreign legion flight helmet"
	desc = "A helmet clearly belonging to a TCFL pilot, it has aged pilot visor attached to it. The visor feeds its wearer in-flight information via an integrated heads-up display."
	icon_state = "legion_pilot"
	item_state = "legion_pilot"
	camera = /obj/machinery/camera/network/tcfl

/obj/pilot_overlay_holder
	name = null
	icon = null
	icon_state = null
	screen_loc = "CENTER:-80,NORTH"
	maptext_width = 192

/obj/pilot_overlay_holder/ship_hud
	screen_loc = "CENTER:90,NORTH:-10"
