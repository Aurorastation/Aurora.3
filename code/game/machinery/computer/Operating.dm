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

	///The operating table we are hooked into
	var/obj/machinery/optable/table

	///The paper with the scan of the patient
	var/obj/item/paper/medscan/primer

	var/obj/machinery/body_scanconsole/embedded/embedded_scanner

/obj/machinery/computer/operating/Initialize()
	..()

	embedded_scanner = new /obj/machinery/body_scanconsole/embedded(src, 0, TRUE, TRUE)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/operating/LateInitialize()
	. = ..()

	for(var/obj/machinery/optable/T in orange(1, src))
		var/successfully_hooked = hook_table(T)
		if(successfully_hooked)
			break

/obj/machinery/computer/operating/Destroy()
	QDEL_NULL(embedded_scanner)
	QDEL_NULL(primer)

	//Clear the operating table
	if(table)
		unhook_table(table)

	. = ..()

/**
 * Used to connect (hook) the computer to the operating table
 *
 * Returns `TRUE` on successful hook, `FALSE` otherwise
 *
 * * table_to_hook - An `/obj/machinery/optable` to hook to
 */
/obj/machinery/computer/operating/proc/hook_table(obj/machinery/optable/table_to_hook)
	if(table)
		return FALSE

	if(QDELETED(table_to_hook))
		crash_with("Trying to hook a QDELETED optable!")
		return FALSE

	if(!istype(table_to_hook))
		crash_with("Trying to hook a table that is not of the correct type!")
		return FALSE

	table = table_to_hook
	table.computer = src

	return TRUE

/**
 * Used to disconnect (unhook) the computer to the operating table
 *
 * Returns `TRUE` on successful unhook, `FALSE` otherwise
 *
 * * table_to_unhook - An `/obj/machinery/optable` to hook to
 */
/obj/machinery/computer/operating/proc/unhook_table(obj/machinery/optable/table_to_unhook)
	if(table_to_unhook != table)
		crash_with("Trying to unhook a table that is not hooked!")
		return FALSE

	table.computer = null
	table = null

	return TRUE

/obj/machinery/computer/operating/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper/medscan))
		if(primer)
			to_chat(user, SPAN_WARNING("\The [src] already has a primer!"))
			return
		user.visible_message("\The [user] slides \the [attacking_item] into \the [src].", SPAN_NOTICE("You slide \the [attacking_item] into \the [src]."), range = 3)
		user.drop_from_inventory(attacking_item, src)
		primer = attacking_item

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
