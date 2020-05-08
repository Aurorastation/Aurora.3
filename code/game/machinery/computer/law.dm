/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	light_color = LIGHT_COLOR_GREEN

	icon_screen = "command"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current
	var/opened = FALSE

/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	opened = !opened
	to_chat(usr, SPAN_NOTICE("The access panel is now [opened ? "open" : "closed"]."))
	return

/obj/machinery/computer/aiupload/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/aiModule))
		if(isNotStationLevel(src.z))
			to_chat(user, SPAN_WARNING("Unable to establish a connection."))
			return
		var/obj/item/aiModule/M = O
		M.install(src)
	else
		..()

/obj/machinery/computer/aiupload/attack_hand(mob/user)
	if(src.stat & NOPOWER)
		to_chat(user, SPAN_WARNING("The upload computer has no power!"))
		return
	if(src.stat & BROKEN)
		to_chat(user, SPAN_WARNING("The upload computer is broken!"))
		return

	src.current = select_active_ai(user)

	if(!src.current)
		to_chat(user, SPAN_WARNING("No active AIs detected."))
	else
		to_chat(user, SPAN_NOTICE("[src.current.name] selected for law changes."))
	return

/obj/machinery/computer/aiupload/attack_ghost(user)
	return TRUE

/obj/machinery/computer/borgupload
	name = "stationbound upload console"
	desc = "Used to upload laws to stationbounds."
	light_color = LIGHT_COLOR_GREEN
	icon_screen = "command"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current

/obj/machinery/computer/borgupload/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/aiModule))
		if(isNotStationLevel(src.z))
			to_chat(user, SPAN_WARNING("Unable to establish a connection."))
			return
		var/obj/item/aiModule/module = O
		module.install(src)
	else
		return ..()

/obj/machinery/computer/borgupload/attack_hand(mob/user)
	if(src.stat & NOPOWER)
		to_chat(user, SPAN_WARNING("The upload computer has no power!"))
		return
	if(src.stat & BROKEN)
		to_chat(user, SPAN_WARNING("The upload computer is broken!"))
		return

	src.current = freeborg()

	if(!src.current)
		to_chat(user, SPAN_WARNING("No free cyborgs detected."))
	else
		to_chat(user, SPAN_NOTICE("[src.current.name] selected for law changes."))
	return

/obj/machinery/computer/borgupload/attack_ghost(user)
	return TRUE