/datum/job/commoner
	title = "Commoner"
	flag = ASSISTANT
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Lumberjack","Farmer", "Farmhand", "Migrant", "Tourist", "Steward", "Laborer", "Entertainer", "Herbalist", "Sculptor")
	outfit = /datum/outfit/job/adhomai/commoner
	alt_outfits = list(
		"Lumberjack"=/datum/outfit/job/adhomai/commoner/lumberjack,
		"Farmer"=/datum/outfit/job/adhomai/commoner/farmer,
		"Sculptor"=/datum/outfit/job/adhomai/commoner/sculptor,
		"Herbalist"=/datum/outfit/job/adhomai/commoner/herbalist
		)
	is_assistant = TRUE

	account_allowed = FALSE

/datum/job/mayor
	title = "Governor"
	flag = MAYOR
	department = "Village"
	head_position = TRUE
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the King"
	selection_color = "#dddddd"
	req_admin_notify = TRUE
	alt_titles = list("Mayor")

	outfit = /datum/outfit/job/adhomai/mayor

	species_blacklist = list("Zhan-Khazan Tajara", "M'sai Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	account_allowed = FALSE

/datum/job/barkeeper
	title = "Barkeeper"
	flag = BARKEEPER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Innkeeper")

	outfit = /datum/outfit/job/adhomai/barkeeper

	account_allowed = FALSE
	alt_outfits = list(
		"Innkeeper"=/datum/outfit/job/adhomai/innkeeper
		)

/datum/job/hunter
	title = "Hunter"
	flag = HUNTER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Outdoorsman", "Tanner", "Furrier", "Hermit")

	outfit = /datum/outfit/job/adhomai/hunter

	account_allowed = FALSE

/datum/job/priest
	title = "Priest"
	flag = PRIEST
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the laws of the Gods and Men"
	selection_color = "#ddddff"

	alt_titles = list("Missionary", "Investigator", "Sun Sister", "Sun Daughter", "Priest of S'rrendar", "Sapling", "Mistling", "Suns Penitent")
	outfit = /datum/outfit/job/adhomai/priest

	account_allowed = FALSE

/datum/job/physician
	title = "Physician"
	flag = MEDIC
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land, and possibly an ethical code"
	selection_color = "#ddddff"
	alt_titles = list("IAC Field Doctor")

	outfit = /datum/outfit/job/adhomai/physician

	account_allowed = FALSE
	alt_outfits = list(
		"IAC Field Doctor"=/datum/outfit/job/adhomai/physician/iacfielddoctor
		)

/datum/job/nurse
	title = "Nurse"
	flag = NURSE
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the attending doctor or physician"
	selection_color = "#ddddff"
	alt_titles = list("IAC Volunteer")
	alt_outfits = list(
		"IAC Volunteer"=/datum/outfit/job/adhomai/nurse/iacvolunteer
		)


	outfit = /datum/outfit/job/adhomai/nurse

	account_allowed = FALSE

/datum/job/prospector
	title = "Prospector"
	flag = PROSPECTOR
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Miner", "Surveyor", "Drill Technician", "Geological Specialist", "Spelunker")

	outfit = /datum/outfit/job/adhomai/prospector

	account_allowed = FALSE

/datum/job/blacksmith
	title = "Blacksmith"
	flag = BLACKSMITH
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Craftsman")

	outfit = /datum/outfit/job/adhomai/blacksmith

	account_allowed = FALSE

/datum/job/archeologist
	title = "Archeologist"
	flag = ARCHEO
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land, and whatever institution or code drives you"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/adhomai/archeologist

	account_allowed = FALSE

/datum/job/trader
	title = "Trader"
	flag = TRADER
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the laws of the land"
	selection_color = "#ddddff"
	alt_titles = list("Shopkeep")

	outfit = /datum/outfit/job/adhomai/trader

	account_allowed = FALSE

/datum/job/chief_constable
	title = "Chief Constable"
	flag = CHIEFCONSTABLE
	department = "Village"
	head_position = TRUE
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the city governance"
	selection_color = "#dddddd"
	req_admin_notify = TRUE
	species_blacklist = list("Zhan-Khazan Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	outfit = /datum/outfit/job/adhomai/chief_constable

	account_allowed = FALSE

/datum/job/constable
	title = "Constable"
	flag = CONSTABLE
	department = "Village"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief constable"
	selection_color = "#ddddff"
	species_blacklist = list(HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)
	outfit = /datum/outfit/job/adhomai/constable

	account_allowed = FALSE
