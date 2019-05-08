/datum/job/commander
	title = "Commander"
	flag = COMMANDER
	department = "Imperial Army"
	head_position = TRUE
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the King"
	selection_color = "#ffdddd"
	req_admin_notify = TRUE
	outfit = /datum/outfit/job/adhomai/military/commander
	species_blacklist = list("Zhan-Khazan Tajara", "M'sai Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)
	account_allowed = FALSE

/datum/job/supply_officer
	title = "Supply Officer"
	flag = SUPPLYOFFICER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	account_allowed = FALSE

	outfit = /datum/outfit/job/adhomai/military/supply_officer

	species_blacklist = list(HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

/datum/job/levy
	title = "Levy"
	flag = LEVY
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	outfit = /datum/outfit/job/adhomai/military
	alt_titles = list("Culinary Services", "Forward Scouting", "Motor Crewman", "Medical Services")
	account_allowed = FALSE
	alt_outfits = list(
		"Culinary Services"=/datum/outfit/job/adhomai/military/culinaryservices,
		"Forward Scouting"=/datum/outfit/job/adhomai/military/forwardscouting,
		"Medical Services"=/datum/outfit/job/adhomai/military/medicalservices
		)

/datum/job/grenadier
	title = "Royal Grenadier"
	flag = GRENADIER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	outfit = /datum/outfit/job/adhomai/military/grenadier
	species_blacklist = list("Tajara", "M'sai Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	account_allowed = FALSE

/datum/job/sharpshooter
	title = "Sharpshooter"
	flag = SHARPSHOOTER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	outfit = /datum/outfit/job/adhomai/military/sharpshooter
	account_allowed = FALSE

/datum/job/combatengineer
	title = "Combat Engineer"
	flag = COMBATENGINEER
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	alt_titles = list("Sapper", "Motor Repairman")

	outfit = /datum/outfit/job/adhomai/military/combatengineer

	account_allowed = FALSE

/datum/job/amohdanswordsman
	title = "Amohdan Swordsman"
	flag = AMOHDANSWORDSMAN
	department = "Imperial Army"
	department_flag = ADHOMAI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commander"
	selection_color = "#ffeeee"
	species_blacklist = list("Zhan-Khazan Tajara", "Tajara", HUMAN_SPECIES, UNATHI_SPECIES, SKRELL_SPECIES, VAURCA_SPECIES, DIONA_SPECIES, IPC_SPECIES)

	outfit = /datum/outfit/job/adhomai/amohdanswordsman

	account_allowed = FALSE
