/datum/computer_file/program/manifest
	filename = "manifest"
	filedesc = "Crew Manifest"
	program_icon_state = "generic"
	extended_desc = "This program is used for viewing the crew manifest."
	usage_flags = PROGRAM_ALL
	size = 3

	requires_ntnet = 1
	available_on_ntnet = 1


/datum/computer_file/program/manifest/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "manifest", 450, 600, "Crew Manifest")
	ui.open()

/datum/computer_file/program/manifest/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "manifest", 450, 600, "Crew Manifest")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/manifest/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	VUEUI_SET_CHECK(data["manifest"], SSrecords.get_manifest_list(), ., data)

/datum/computer_file/program/manifest/Topic(href, href_list)
	. = ..()

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	host.radio.Topic(href, href_list)
