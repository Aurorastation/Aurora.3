	name = "nano printer"
	desc = "Small integrated printer with paper recycling module."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	critical = 0
	icon_state = "printer"
	hardware_size = 1
	var/stored_paper = 5
	var/max_paper = 10

	..()
	user << "Paper buffer level: [stored_paper]/[max_paper]"

	if(!stored_paper)
		return 0
	if(!enabled)
		return 0
	if(!check_functionality())
		return 0

	// Damaged printer causes the resulting paper to be somewhat harder to read.
	if(damage > damage_malfunction)
		text_to_print = stars(text_to_print, 100-malfunction_probability)

	stored_paper--
	return 1

		if(stored_paper >= max_paper)
			user << "You try to add \the [W] into [src], but it's paper bin is full"
			return

		user << "You insert \the [W] into [src]."
		qdel(W)
		stored_paper++

	if(holder2 && (holder2.nano_printer == src))
		holder2.nano_printer = null
	holder2 = null
	return ..()
