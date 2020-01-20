/datum/job/assistant
	title = "Settler"
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "whoever you want"
	selection_color = "#C0C0C0"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Visitor")
	outfit = /datum/outfit/job/assistant

/datum/job/assistant/get_access(selected_title)
	if(config.assistant_maint && selected_title == "Settler")
		return list(access_maint_tunnels)
	else
		return list()

/datum/outfit/job/assistant
	name = "Settler"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/black