/datum/computer_file/program/research_tracker
	filename = "researchtracker"
	filedesc = "Research Tracker"
	program_icon_state = "lightbulb"
	extended_desc = "This program connects to the Research & Development database to display up-to-date progress."
	required_access_run = access_tox
	required_access_download = access_tox
	requires_ntnet = TRUE
	network_destination = "research progress tracking system"
	size = 11
	usage_flags = PROGRAM_ALL_REGULAR | PROGRAM_STATIONBOUND
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/research_tracker/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-research-researchtracker", 800, 600, "Research Tracker")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/research_tracker/vueui_transfer(oldobj)
	for(var/o in SSvueui.transfer_uis(oldobj, src, "mcomputer-research-researchtracker", 800, 600, "Research Tracker"))
		var/datum/vueui/ui = o
		ui.auto_update_content = TRUE
	return TRUE

/datum/computer_file/program/research_tracker/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata

	data["max_level"] = MAX_TECH_LEVEL
	data["techs"] = list()
	for(var/tech_id in SSresearch.global_research.known_tech)
		var/list/tech_data = list()
		var/datum/tech/T = SSresearch.global_research.known_tech[tech_id]
		tech_data["name"] = T.name
		tech_data["desc"] = T.desc
		tech_data["id"] = T.id
		tech_data["level"] = T.level
		tech_data["next_level_progress"] = T.next_level_progress
		tech_data["next_level_threshold"] = T.next_level_threshold

		data["techs"][++data["techs"].len] += tech_data

	return data

/datum/computer_file/program/research_tracker/Topic(href, href_list)
	. = ..()
