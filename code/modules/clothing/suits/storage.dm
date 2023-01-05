/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 2	//two slots
	pockets.max_w_class = ITEMSIZE_SMALL		//fit only pocket sized items
	pockets.max_storage_space = 4

/obj/item/clothing/suit/storage/Destroy()
	qdel(pockets)
	pockets = null
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user as mob)
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object as obj)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/handle_middle_mouse_click(mob/user)
	if(Adjacent(user))
		pockets.open(user)
		return TRUE
	return FALSE

/obj/item/clothing/suit/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/clothing/accessory))
		return
	pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/storage/hear_talk(mob/M, var/msg, verb, datum/language/speaking)
	pockets.hear_talk(M, msg, verb, speaking)
	..()

//Jackets with buttons
/obj/item/clothing/suit/storage/toggle
	var/opened = FALSE

/obj/item/clothing/suit/storage/toggle/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	toggle_open()

/obj/item/clothing/suit/storage/toggle/proc/toggle_open()
	opened = !opened
	to_chat(usr, SPAN_NOTICE("You [opened ? "unbutton" : "button up"] \the [src]."))
	playsound(src, /singleton/sound_category/rustle_sound, EQUIP_SOUND_VOLUME, TRUE)
	icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
	item_state = icon_state
	update_icon()
	update_clothing_icon()

/obj/item/clothing/suit/storage/toggle/Initialize()
	. = ..()
	if(opened) // for stuff that's supposed to spawn opened, like labcoats.
		icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
		item_state = icon_state

/obj/item/clothing/suit/storage/vest/hos/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEMSIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/vest
	var/icon_badge
	var/icon_nobadge
	verb/toggle()
		set name ="Adjust Badge"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_badge)
			icon_state = icon_nobadge
			to_chat(usr, "You conceal \the [src]'s badge.")
		else if(icon_state == icon_nobadge)
			icon_state = icon_badge
			to_chat(usr, "You reveal \the [src]'s badge.")
		else
			to_chat(usr, "\The [src] does not have a vest badge.")
			return
		update_clothing_icon()
