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
	var/obj/item/paper/P = new /obj/item/paper(get_turf(parent_computer), text_to_print, paper_title)
	if(paper_color)
		P.color = paper_color

	stored_paper--

	if(ismob(usr))
		usr.put_in_hands(P, TRUE)
	return P

/// Prints a modular-computer PNG onto photograph stock.
/obj/item/computer_hardware/nano_printer/proc/print_image(datum/computer_file/image/image_file, mob/user)
	if(!stored_paper || !enabled || !check_functionality() || !image_file?.stored_icon)
		return FALSE
	var/icon/photo_image = icon(image_file.stored_icon)
	var/icon/small_image = icon(photo_image)
	var/icon/tiny_image = icon(photo_image)
	var/icon/photo_icon = icon('icons/obj/bureaucracy.dmi', "photo")
	var/icon/tiny_icon = icon('icons/obj/bureaucracy.dmi', "photo")
	small_image.Scale(8, 8)
	tiny_image.Scale(4, 4)
	photo_icon.Blend(small_image, ICON_OVERLAY, 10, 13)
	tiny_icon.Blend(tiny_image, ICON_OVERLAY, 12, 19)
	var/obj/item/photo/printed_photo = new(get_turf(parent_computer))
	printed_photo.name = "photo ([image_file.filename])"
	printed_photo.caption = image_file.filename
	printed_photo.picture_desc = image_file.filedesc || "A digitally printed image."
	printed_photo.img = photo_image
	printed_photo.icon = photo_icon
	printed_photo.tiny = tiny_icon
	printed_photo.taken_by = image_file.author_ckey
	stored_paper--
	if(user)
		user.put_in_hands(printed_photo, TRUE)
	return printed_photo

/obj/item/computer_hardware/nano_printer/attackby(obj/item/attacking_item, mob/user)
	//We only care about papers here
	if(!istype(attacking_item, /obj/item/paper))
		return ..()

	var/obj/item/paper/attacking_paper = attacking_item

	//If the paper is already written onto, we can't add it to the printer
	if(attacking_paper.free_space != initial(attacking_paper.free_space))
		to_chat(user, SPAN_WARNING("You try to add \the [attacking_paper] to the [src], but the paper is written onto already."))
		return

	if(stored_paper >= max_paper)
		to_chat(user, SPAN_WARNING("You try to add \the [attacking_paper] to the [src], but its paper bin is full."))
		return

	to_chat(user, SPAN_NOTICE("You insert \the [attacking_paper] into [src]."))
	qdel(attacking_paper)
	stored_paper++

/obj/item/computer_hardware/nano_printer/Destroy()
	if(parent_computer?.nano_printer == src)
		parent_computer.nano_printer = null
	parent_computer = null
	return ..()
