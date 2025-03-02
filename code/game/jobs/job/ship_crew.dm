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
	alt_outfits = list("Lab Assistant" = /obj/outfit/job/assistant/lab_assistant, "Technical Assistant" = /obj/outfit/job/assistant/tech_assistant, "Medical Orderly" = /obj/outfit/job/assistant/med_assistant, "Wait Staff" = /obj/outfit/job/assistant/waiter)
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
			out_list += list(ACCESS_MEDICAL, ACCESS_MORGUE)
	return out_list

/obj/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/obj/outfit/job/assistant/lab_assistant
	name = "Lab Assistant"
	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	glasses = /obj/item/clothing/glasses/safety/goggles/science
	headset = /obj/item/device/radio/headset/headset_sci
	bowman = /obj/item/device/radio/headset/headset_sci/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sci
	wrist_radio = /obj/item/device/radio/headset/wrist/sci
	clipon_radio = /obj/item/device/radio/headset/wrist/clip/sci

/obj/outfit/job/assistant/tech_assistant
	name = "Technical Assistant"
	uniform = /obj/item/clothing/under/color/yellowgreen
	suit = /obj/item/clothing/suit/storage/hazardvest
	backpack_contents = list(/obj/item/device/debugger = 1)
	headset = /obj/item/device/radio/headset/headset_eng
	bowman = /obj/item/device/radio/headset/headset_eng/alt
	double_headset = /obj/item/device/radio/headset/alt/double/eng
	wrist_radio = /obj/item/device/radio/headset/wrist/eng
	clipon_radio = /obj/item/device/radio/headset/wrist/clip/eng

/obj/outfit/job/assistant/med_assistant
	name = "Medical Orderly"
	uniform = /obj/item/clothing/under/color/blue
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	backpack_contents = list(/obj/item/reagent_containers/spray/sterilizine = 1)
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	double_headset = /obj/item/device/radio/headset/alt/double/med
	wrist_radio = /obj/item/device/radio/headset/wrist/med
	clipon_radio = /obj/item/device/radio/headset/wrist/clip/med

/obj/outfit/job/assistant/waiter
	name = "Wait Staff"
	uniform = /obj/item/clothing/under/waiter
	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service
	clipon_radio = /obj/item/device/radio/headset/wrist/clip/service

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
