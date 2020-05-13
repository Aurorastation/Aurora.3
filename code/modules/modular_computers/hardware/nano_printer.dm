/obj/item/computer_hardware/nano_printer
	name = "nano printer"
	desc = "Small integrated printer with paper recycling module."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	critical = FALSE
	icon_state = "printer"
	hardware_size = 1
	var/stored_paper = 5
	var/max_paper = 10

/obj/item/computer_hardware/nano_printer/diagnostics(var/mob/user)
	..()
	to_chat(user, SPAN_NOTICE("Paper Buffer Level: [stored_paper]/[max_paper]"))

/obj/item/computer_hardware/nano_printer/proc/print_text(var/text_to_print, var/paper_title = null, var/paper_color = null)
	if(!stored_paper)
		return FALSE
	if(!enabled)
		return FALSE
	if(!check_functionality())
		return FALSE

	// Damaged printer causes the resulting paper to be somewhat harder to read.
	if(damage > damage_malfunction)
		text_to_print = stars(text_to_print, 100-malfunction_probability)
	var/obj/item/paper/P = new /obj/item/paper(get_turf(parent_computer),text_to_print, paper_title)
	P.info = text_to_print
	if (paper_color)
		P.color = paper_color

	stored_paper--
	return P

/obj/item/computer_hardware/nano_printer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper))
		if(stored_paper >= max_paper)
			to_chat(user, SPAN_WARNING("You try to add \the [W] to the [src], but its paper bin is full."))
			return
		to_chat(user, SPAN_NOTICE("You insert \the [W] into [src]."))
		qdel(W)
		stored_paper++
	else
		..()

/obj/item/computer_hardware/nano_printer/Destroy()
	if(parent_computer?.nano_printer == src)
		parent_computer.nano_printer = null
	parent_computer = null
	return ..()