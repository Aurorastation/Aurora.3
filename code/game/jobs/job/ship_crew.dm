/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	intro_prefix = "an"
	supervisors = "absolutely everyone"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /obj/outfit/job/assistant
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

	alt_titles = list("Lab Assistant", "Technical Assistant", "Medical Orderly", "Wait Staff")
	// alt_outfits = list("Lab Assistant" = , "Technical Assistant" = , "Medical Orderly" = , "Wait Staff" = )
	alt_factions = list(
		"Assistant" = list("NanoTrasen", "Idris Incorporated", "Hephaestus Industries", "Orion Express", "Zavodskoi Interstellar", "Zeng-Hu Pharmaceuticals", "Private Military Contracting Group"),
		"Lab Assistant" = list("NanoTrasen", "Zeng-Hu Pharmaceuticals", "Zavodskoi Interstellar"),
		"Technical Assistant" = list("Hephaestus Industries", "Zavodskoi Interstellar"),
		"Medical Orderly" = list("NanoTrasen", "Zeng-Hu Pharmaceuticals", "Private Military Contracting Group"),
		"Wait Staff" = list("NanoTrasen", "Idris Incorporated", "Orion Express")
	)


/datum/job/assistant/get_access(selected_title)
	var/list/out_list = list()

	if(GLOB.config.assistant_maint)
		out_list += list(ACCESS_MAINT_TUNNELS)

	switch(selected_title)
		if("Lab Assistant")
			out_list += list(ACCESS_RESEARCH)
		if("Technical Assistant")
			out_list += list(ACCESS_ENGINE)
		if("Medical Orderly")
			out_list += list(ACCESS_MEDICAL)
	return out_list

/obj/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/job/visitor
	title = "Off-Duty Crew Member"
	flag = VISITOR
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /obj/outfit/job/visitor
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/visitor
	name = "Off-Duty Crew Member"
	jobtype = /datum/job/visitor

	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/sneakers/black

/obj/outfit/job/visitor/passenger
	name = "Passenger"
	jobtype = /datum/job/passenger

/datum/job/passenger
	title = "Passenger"
	flag = PASSENGER
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "any authority figure"
	selection_color = "#949494"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit = /obj/outfit/job/visitor/passenger
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)
