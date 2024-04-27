/datum/computer_file/program/pai_directives
	filename = "pai_directives"
	filedesc = "pAI Directives"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program is for viewing currently assigned directives."
	size = 0

	usage_flags = PROGRAM_SILICON_PAI
	tgui_id = "pAIDirectives"

// Gaters data for ui
/datum/computer_file/program/pai_directives/ui_data(mob/user)
	var/list/data = list()
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

	data["master"] = host.master
	data["dna"] = host.master_dna
	data["prime"] = host.pai_law0
	data["supplemental"] = host.pai_laws

	return data

/datum/computer_file/program/pai_directives/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	if(action == "getdna")
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
				v.show_message(SPAN_NOTICE("[M] presses [M.get_pronoun("his")] thumb against [host]."), 3, SPAN_NOTICE("[host] makes a sharp clicking sound as it extracts DNA material from [M]."), 2)
			var/datum/dna/dna = M.dna
			to_chat(host, "<font color = red><h3>[M]'s UE string : [dna.unique_enzymes]</h3></font>")
			if(dna.unique_enzymes == host.master_dna)
				to_chat(host, SPAN_NOTICE("<b>Provided DNA is a match to stored Master DNA.</b>"))
			else
				to_chat(host, SPAN_WARNING("<b>Provided DNA does not match stored Master DNA.</b>"))
		else
			to_chat(host, SPAN_WARNING("[M] does not seem like [M.get_pronoun("he")] [M.get_pronoun("is")] going to provide a DNA sample willingly."))
		return 1
