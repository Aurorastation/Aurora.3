//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_screen = "aiupload"
	icon_keyboard = "blue_key"
	icon_keyboard_emis = "blue_key_mask"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = 0


/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)
	if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon))
		return

	opened = !opened
	if(opened)
		to_chat(usr, SPAN_NOTICE("The access panel is now open."))
	else
		to_chat(usr, SPAN_NOTICE("The access panel is now closed."))
	return


/obj/machinery/computer/aiupload/attackby(obj/item/attacking_item, mob/user)
	if(isNotStationLevel(src.z))
		to_chat(user, SPAN_DANGER("Unable to establish a connection:"))
		return TRUE
	if(istype(attacking_item, /obj/item/aiModule))
		var/obj/item/aiModule/M = attacking_item
		M.install(src)
		return TRUE
	else
		return ..()


/obj/machinery/computer/aiupload/attack_hand(var/mob/user as mob)
	if(src.stat & NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return
	if(src.stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return

	src.current = select_active_ai(user)

	if (!src.current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")
	return

/obj/machinery/computer/aiupload/attack_ghost(user as mob)
	return 1


/obj/machinery/computer/borgupload
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	icon_screen = "aiupload"
	icon_keyboard = "blue_key"
	icon_keyboard_emis = "blue_key_mask"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


/obj/machinery/computer/borgupload/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/aiModule/module = attacking_item
	if(isNotStationLevel(src.z))
		to_chat(user, SPAN_DANGER("Unable to establish a connection:"))
		return TRUE
	if(istype(module, /obj/item/aiModule))
		module.install(src)
		return TRUE
	else
		return ..()


/obj/machinery/computer/borgupload/attack_hand(var/mob/user as mob)
	if(src.stat & NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return
	if(src.stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return

	src.current = freeborg()

	if (!src.current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")
	return

/obj/machinery/computer/borgupload/attack_ghost(user as mob)
	return 1
