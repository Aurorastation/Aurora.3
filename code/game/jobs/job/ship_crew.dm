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

/datum/job/assistant/get_access(selected_title)
	if(GLOB.config.assistant_maint && selected_title == "Assistant")
		return list(ACCESS_MAINT_TUNNELS)
	else
		return list()

/obj/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

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
