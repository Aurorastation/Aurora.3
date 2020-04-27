/datum/computer_file/program/pai_directives
	filename = "pai_directives"
	filedesc = "pAI Directives"
	program_icon_state = "generic"
	extended_desc = "This program is for viewing currently assigned directives."
	size = 0

	usage_flags = PROGRAM_SILICON_PAI

/datum/computer_file/program/pai_directives/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-pai-directives", 450, 500, "pAI directives")
	ui.open()

/datum/computer_file/program/pai_directives/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-pai-directives", 450, 500, "pAI directives")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/pai_directives/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	VUEUI_SET_CHECK(data["master"], host.master, ., data)
	VUEUI_SET_CHECK(data["dna"], host.master_dna, ., data)
	VUEUI_SET_CHECK(data["prime"], host.pai_law0, ., data)
	VUEUI_SET_CHECK(data["supplemental"], host.pai_laws, ., data)
	
/datum/computer_file/program/pai_directives/Topic(href, href_list)
	. = ..()

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host
	
	if(href_list["getdna"])
		var/mob/living/M = host.loc
		var/count = 0

		// Find the carrier
		while(!istype(M, /mob/living))
			if(!M || !M.loc || count > 6)
				//For a runtime where M ends up in nullspace (similar to bluespace but less colourful)
				to_chat(src, SPAN_WARNING("You are not being carried by anyone!"))
				return 0
			M = M.loc
			count++

		// Check the carrier
		var/answer = input(M, "[host] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[host] Check DNA", "No") in list("Yes", "No")
		if(answer == "Yes")
			var/turf/T = get_turf_or_move(host.loc)
			for (var/mob/v in viewers(T))
				v.show_message(SPAN_NOTICE("[M] presses \his thumb against [host]."), 3, SPAN_NOTICE("[host] makes a sharp clicking sound as it extracts DNA material from [M]."), 2)
			var/datum/dna/dna = M.dna
			to_chat(host, "<font color = red><h3>[M]'s UE string : [dna.unique_enzymes]</h3></font>")
			if(dna.unique_enzymes == host.master_dna)
				to_chat(host, SPAN_NOTICE("<b>Provided DNA is a match to stored Master DNA.</b>"))
			else
				to_chat(host, SPAN_WARNING("<b>Provided DNA does not match stored Master DNA.</b>"))
		else
			to_chat(host, SPAN_WARNING("[M] does not seem like \he [gender_datums[M.gender].is] going to provide a DNA sample willingly."))
		return 1
