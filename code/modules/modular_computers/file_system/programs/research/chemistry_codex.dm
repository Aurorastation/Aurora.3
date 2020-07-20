/datum/computer_file/program/chemistry_codex
	filename = "chemcodex"
	filedesc = "Chemistry codex"
	program_icon_state = "generic"
	extended_desc = "Useful program to view chemical reactions and how to make them."
	size = 2
	available_on_ntnet = TRUE

	var/list/ignored_reaction_path = list(/datum/chemical_reaction/slime)
	var/list/ignored_result_path = list(/datum/reagent/drink, /datum/reagent/alcohol, /datum/reagent/paint)

/datum/computer_file/program/chemistry_codex/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-chemcodex", 450, 600, filedesc)
	ui.open()

/datum/computer_file/program/chemistry_codex/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-chemcodex", 450, 600, filedesc)
	return TRUE

// Gathers data for ui. This is not great vueui example, all data sent from server is static.
/datum/computer_file/program/chemistry_codex/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	// Here goes listification
	if(data["reactions"] == null)
		. = data
		data["reactions"] = list()
		for(var/chem_path in SSchemistry.chemical_reactions_clean)
			if(ignored_reaction_path && is_path_in_list(chem_path, ignored_reaction_path))
				continue
			var/datum/chemical_reaction/CR = new chem_path
			if(!CR.result)
				continue
			if(ignored_result_path && is_path_in_list(CR.result, ignored_result_path))
				continue
			var/datum/reagent/R = new CR.result
			var/reactionData = list(id = CR.id)
			reactionData["result"] = list(
				name = R.name,
				description = R.description,
				amount = CR.result_amount
			)
			
			reactionData["reagents"] = list()
			for(var/reagent in CR.required_reagents)
				var/datum/reagent/required_reagent = reagent
				reactionData["reagents"] += list(list(
					name = initial(required_reagent.name),
					amount = CR.required_reagents[reagent]
				))
			
			reactionData["catalysts"] = list()
			for(var/reagent_path in CR.catalysts)
				var/datum/reagent/required_reagent = reagent_path
				reactionData["catalysts"] += list(list(
					name = initial(required_reagent.name),
					amount = CR.catalysts[reagent_path]
				))

			reactionData["inhibitors"] = list()
			for(var/reagent_path in CR.inhibitors)
				var/datum/reagent/required_reagent = reagent_path
				var/inhibitor_amount = CR.inhibitors[reagent_path] ? CR.inhibitors[reagent_path] : "Any"
				reactionData["inhibitors"] += list(list(
					name = initial(required_reagent.name),
					amount = inhibitor_amount
				))

			reactionData["temp_min"] = list()
			for(var/reagent_path in CR.required_temperatures_min)
				var/datum/reagent/required_reagent = reagent_path
				reactionData["temp_min"] += list(list(
					name = initial(required_reagent.name),
					temp = CR.required_temperatures_min[reagent_path]
				))
			
			reactionData["temp_max"] = list()
			for(var/reagent_path in CR.required_temperatures_max)
				var/datum/reagent/required_reagent = reagent_path
				reactionData["temp_max"] += list(list(
					name = initial(required_reagent.name),
					temp = CR.required_temperatures_max[reagent_path]
				))
			
			data["reactions"] += list(reactionData)