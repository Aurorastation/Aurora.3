/obj/item/chemistry_codex
	name = "chemistry codex"
	desc = "A handy device that can be used to view chemical reactions and how to make them."
	icon = 'icons/obj/devices/paperscanner.dmi'
	icon_state = "paperscanner"
	item_state = "paperscanner"
	contained_sprite = TRUE

	var/search
	var/show_description = TRUE
	var/list/ignored_reaction_path = list(/datum/chemical_reaction/slime)
	var/list/ignored_result_path = list(/datum/reagent/drink, /datum/reagent/alcohol, /datum/reagent/paint)
	var/list/required_result_path = null

/obj/item/chemistry_codex/Initialize(mapload, ...)
	. = ..()
	color = color_rotation(150)

/obj/item/chemistry_codex/attack_self(mob/user)
	ui_interact(user)

/obj/item/chemistry_codex/ui_interact(mob/user)
	var/dat = "<body>"

	dat += "<div class='settings-block'>"
	var/search_text = search ? search : "Any"
	dat += "<font size='3'; color='#5c87a8'><b>Search:</b></font> <a href='?src=\ref[src];do_search=1'>[search_text]</a><br>"
	var/desc_text = show_description ? "On" : "Off"
	dat += "<font size='3'; color='#5c87a8'><b>Descriptions:</b></font> <a href='?src=\ref[src];toggle_desc=1'>[desc_text]</a><hr>"
	dat += "</div>"

	for(var/chem_path in SSchemistry.chemical_reactions_clean)
		if(ignored_reaction_path && is_path_in_list(chem_path, ignored_reaction_path))
			continue
		var/datum/chemical_reaction/CR = new chem_path
		if(!CR.result)
			continue
		if(ignored_result_path && is_path_in_list(CR.result, ignored_result_path))
			continue
		if(required_result_path && !is_path_in_list(CR.result, required_result_path))
			continue
		var/datum/reagent/R = new CR.result
		if(search && search != "Any" && !findtext(R.name, search))
			continue
		dat += "<div class='recipe-block'>"
		dat += "<h2>[R.name]</h2>"
		if(show_description)
			dat += "<div class='sub-text'>[R.description]</div>"
		dat += "<div class='sub-text'>Amount: [CR.result_amount]</div>"

		dat += "<div class='list-block'>"
		dat += "<h3>Required Reagents</h3>"
		for(var/reagent_path in CR.required_reagents)
			var/datum/reagent/required_reagent = reagent_path
			dat += "<p>[initial(required_reagent.name)]: [CR.required_reagents[reagent_path]]</p>"
		dat += "</div>"

		dat += get_additional_data()

		if(length(CR.catalysts))
			dat += "<div class='list-block'>"
			dat += "<h3>Catalysts</h3>"
			for(var/reagent_path in CR.catalysts)
				var/datum/reagent/required_reagent = reagent_path
				dat += "<p>[initial(required_reagent.name)]: [CR.catalysts[reagent_path]]</p>"
			dat += "</div>"

		if(length(CR.inhibitors))
			dat += "<div class='list-block'>"
			dat += "<h3>Inhibitors</h3>"
			for(var/reagent_path in CR.inhibitors)
				var/datum/reagent/required_reagent = reagent_path
				var/inhibitor_amount = CR.inhibitors[reagent_path] ? CR.inhibitors[reagent_path] : "Any"
				dat += "<p>[initial(required_reagent.name)]: [inhibitor_amount]</p>"
			dat += "</div>"

		if(length(CR.required_temperatures_min))
			dat += "<div class='list-block'>"
			dat += "<h3>Temperatures Required Min</h3>"
			for(var/reagent_path in CR.required_temperatures_min)
				var/datum/reagent/required_reagent = reagent_path
				dat += "<p>[initial(required_reagent.name)]: [CR.required_temperatures_min[reagent_path]]K</p>"
			dat += "</div>"

		if(length(CR.required_temperatures_max))
			dat += "<div class='list-block'>"
			dat += "<h3>Temperatures Required Max</h3>"
			for(var/reagent_path in CR.required_temperatures_max)
				var/datum/reagent/required_reagent = reagent_path
				dat += "<p>[initial(required_reagent.name)]: [CR.required_temperatures_max[reagent_path]]K</p>"
			dat += "</div>"
		dat += "</div>"

	dat += "</body>"

	var/datum/browser/chem_win = new(user, "chemistry_codex", "Chemistry Codex", 550, 600)
	chem_win.set_content(dat)
	chem_win.add_stylesheet("misc", 'html/browser/misc.css')
	chem_win.add_stylesheet("chemcodex", 'html/browser/chemcodex.css')
	chem_win.open()

/obj/item/chemistry_codex/proc/get_additional_data()
	return

/obj/item/chemistry_codex/Topic(href, href_list)
	if(use_check_and_message(usr))
		return

	if(href_list["do_search"])
		var/search_value = input(usr, "Enter the chemical name you want to search for: (Leave blank for no search)", "Codex Search") as text
		if(!search_value || search_value == "")
			search = null
			ui_interact(usr)
			return
		search = search_value
		ui_interact(usr)
		return

	if(href_list["toggle_desc"])
		show_description = !show_description
		ui_interact(usr)
		return