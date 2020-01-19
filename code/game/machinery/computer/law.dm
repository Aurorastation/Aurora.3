//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	light_color = LIGHT_COLOR_GREEN

	icon_screen = "command"
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
		to_chat(usr, "<span class='notice'>The access panel is now open.</span>")
	else
		to_chat(usr, "<span class='notice'>The access panel is now closed.</span>")
	return


/obj/machinery/computer/aiupload/attackby(obj/item/O as obj, mob/user as mob)
	if(isNotStationLevel(src.z))
		to_chat(user, "<span class='danger'>Unable to establish a connection:</span>")
		return
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		M.install(src)
	else
		..()


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
	light_color = LIGHT_COLOR_GREEN

	icon_screen = "command"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


/obj/machinery/computer/borgupload/attackby(obj/item/aiModule/module as obj, mob/user as mob)
	if(isNotStationLevel(src.z))
		to_chat(user, "<span class='danger'>Unable to establish a connection:</span>")
		return
	if(istype(module, /obj/item/aiModule))
		module.install(src)
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
