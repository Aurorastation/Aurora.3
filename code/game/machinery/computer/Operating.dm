//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	desc = "A console that displays information on the status of the patient on an adjacent operating table."
	density = TRUE
	anchored = TRUE
	icon_screen = "crew"
	icon_keyboard = "teal_key"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/operating

	var/obj/machinery/optable/table
	var/obj/item/paper/medscan/primer
	var/obj/machinery/body_scanconsole/embedded/embedded_scanner

/obj/machinery/computer/operating/Initialize()
	. = ..()
	embedded_scanner = new /obj/machinery/body_scanconsole/embedded(src, 0, TRUE, TRUE)
	for(var/obj/machinery/optable/T in orange(1,src))
		table = T
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/Destroy()
	QDEL_NULL(embedded_scanner)
	QDEL_NULL(primer)
	table = null
	return ..()

/obj/machinery/computer/operating/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/paper/medscan))
		if(primer)
			to_chat(user, SPAN_WARNING("\The [src] already has a primer!"))
			return
		user.visible_message("\The [user] slides \the [item] into \the [src].", SPAN_NOTICE("You slide \the [item] into \the [src]."), range = 3)
		user.drop_from_inventory(item, src)
		primer = item

/obj/machinery/computer/operating/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/computer/operating/attack_hand(mob/user)
	if(..())
		return
	embedded_scanner.ui_interact(user)

/obj/machinery/computer/operating/verb/eject_primer()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Primer"

	if(!primer)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a primer!"))
		return

	usr.visible_message("\The [usr] takes \the [primer] out of \the [src].", SPAN_NOTICE("You take \the [primer] out of \the [src]"), range = 3)
	usr.put_in_hands(primer)
	primer = null

/obj/machinery/computer/operating/terminal
	name = "patient monitoring terminal"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "med_comp"
	icon_keyboard = "med_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1
