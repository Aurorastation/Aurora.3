/datum/computer_file/program/manifest
	filename = "manifest"
	filedesc = "Crew Manifest"
	program_icon_state = "menu"
	program_key_icon_state = "black_key"
	extended_desc = "This program is used for viewing the crew manifest."
	usage_flags = PROGRAM_ALL
	size = 3
	tgui_id = "NTOSManifest"

	requires_ntnet = TRUE
	available_on_ntnet = TRUE

/datum/computer_file/program/manifest/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = SSrecords.get_manifest_list()
	return data

// /datum/computer_file/program/manifest/Topic(href, href_list)
// 	. = ..()

// 	if(href_list["action"] == "print" && can_run(usr, 1) && !isnull(computer?.nano_printer))
// 		if(!computer.nano_printer.print_text(SSrecords.get_manifest_text(), text("crew manifest ([])", worldtime2text())))
// 			to_chat(usr, SPAN_WARNING("Hardware error: Printer was unable to print the file. It might be out of paper."))
// 			return
// 		else
// 			computer.visible_message(SPAN_NOTICE("\The [computer] prints out a paper."))

// 	if(!istype(computer, /obj/item/modular_computer/silicon))
// 		return
// 	var/obj/item/modular_computer/silicon/true_computer = computer
// 	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
// 		return
// 	var/mob/living/silicon/pai/host = true_computer.computer_host

// 	host.radio.Topic(href, href_list)
