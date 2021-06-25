/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	intro_prefix = "an"
	supervisors = "absolutely everyone"
	selection_color = "#90524b"
	economic_modifier = 1

	playtime_type = PLAYTIME_TYPE_CREW

	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant

/datum/job/assistant/get_access(selected_title)
	if(config.assistant_maint && selected_title == "Assistant")
		return list(access_maint_tunnels)
	else
		return list()

/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/black

/datum/job/visitor
	title = "Visitor"
	flag = VISITOR
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#90524b"
	economic_modifier = 1

	playtime_type = PLAYTIME_TYPE_CREW

	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/visitor

/datum/outfit/job/visitor
	name = "Visitor"
	jobtype = /datum/job/visitor

	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/black
