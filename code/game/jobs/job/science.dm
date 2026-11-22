/datum/job/rd
	title = "Research Director"
	flag = RD
	departments = list(DEPARTMENT_SCIENCE = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#a44799"
	economic_modifier = 15

	minimum_character_age = list(
		SPECIES_HUMAN = 35,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	job_access = list(
		/datum/access/rd::id, /datum/access/heads::id, /datum/access/tox::id, /datum/access/genetics::id, /datum/access/morgue::id, /datum/access/eva::id, /datum/access/external_airlocks::id, /datum/access/tox_storage::id,
		/datum/access/teleporter::id, /datum/access/sec_doors::id, /datum/access/medical::id, /datum/access/engine::id, /datum/access/ship_weapons::id, /datum/access/construction::id, /datum/access/mining::id, /datum/access/mailsorting::id, /datum/access/research::id,
		/datum/access/xenobiology::id, /datum/access/xenobotany::id, /datum/access/ai_upload::id, /datum/access/tech_storage::id, /datum/access/RC_announce::id, /datum/access/keycard_auth::id, /datum/access/tcomsat::id, /datum/access/gateway::id,
		/datum/access/xenoarch::id, /datum/access/network::id, /datum/access/maint_tunnels::id, /datum/access/tech_support::id, /datum/access/intrepid::id, /datum/access/spark::id, /datum/access/quark::id, /datum/access/canary::id
	)
	minimal_player_age = 14
	outfit = /obj/outfit/job/rd

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_BREEDER, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK)

	skill_requirements = alist(
		/singleton/skill/pilot_spacecraft = SKILL_LEVEL_FAMILIAR
	)

/obj/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/rd

	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/sneakers/brown
	id = /obj/item/card/id/scc/silver
	l_hand = /obj/item/clipboard

	headset = /obj/item/radio/headset/heads/rd
	bowman = /obj/item/radio/headset/heads/rd/alt
	double_headset = /obj/item/radio/headset/alt/double/rd
	wrist_radio = /obj/item/radio/headset/wrist/rd
	clipon_radio = /obj/item/radio/headset/wrist/clip/rd

	tab_pda = /obj/item/modular_computer/handheld/pda/research/rd
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research/rd
	tablet = /obj/item/modular_computer/handheld/preset/research/rd

	backpack = /obj/item/storage/backpack/rd
	satchel = /obj/item/storage/backpack/satchel/rd
	dufflebag = /obj/item/storage/backpack/duffel/rd
	messengerbag = /obj/item/storage/backpack/messenger/rd

/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	job_access = list(/datum/access/tox::id, /datum/access/tox_storage::id, /datum/access/research::id, /datum/access/intrepid::id, /datum/access/spark::id, /datum/access/quark::id, /datum/access/canary::id)

	minimal_player_age = 14
	outfit = /obj/outfit/job/scientist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/sneakers/medsci
	id = /obj/item/card/id/white

	headset = /obj/item/radio/headset/headset_sci
	bowman = /obj/item/radio/headset/headset_sci/alt
	double_headset = /obj/item/radio/headset/alt/double/sci
	wrist_radio = /obj/item/radio/headset/wrist/sci
	clipon_radio = /obj/item/radio/headset/wrist/clip/sci

	tab_pda = /obj/item/modular_computer/handheld/pda/research
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research
	tablet = /obj/item/modular_computer/handheld/preset/research

	backpack = /obj/item/storage/backpack/toxins
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/tox
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/tox
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/tox
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

/datum/job/xenoarchaeologist
	title = "Xenoarchaeologist"
	flag = XENOARCHEOLOGIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	alt_titles = list("Anomalist")
	alt_outfits = list("Anomalist" = /obj/outfit/job/scientist/anomalist)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	job_access = list(/datum/access/research::id, /datum/access/xenoarch::id, /datum/access/tox::id, /datum/access/tox_storage::id, /datum/access/intrepid::id, /datum/access/spark::id, /datum/access/quark::id, /datum/access/canary::id)

	minimal_player_age = 14
	outfit = /obj/outfit/job/scientist/xenoarchaeologist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

	skill_requirements = alist(
		/singleton/skill/pilot_spacecraft = SKILL_LEVEL_FAMILIAR
	)

/obj/outfit/job/scientist/xenoarchaeologist
	name = "Xenoarchaeologist"
	jobtype = /datum/job/xenoarchaeologist

	uniform = /obj/item/clothing/under/rank/scientist/xenoarchaeologist

	headset = /obj/item/radio/headset/headset_xenology
	bowman = /obj/item/radio/headset/headset_xenology/alt
	double_headset = /obj/item/radio/headset/alt/double/xenology
	wrist_radio = /obj/item/radio/headset/wrist/xenology
	clipon_radio = /obj/item/radio/headset/wrist/clip/xenology

/obj/outfit/job/scientist/anomalist
	name = "Anomalist"
	jobtype = /datum/job/xenoarchaeologist

	uniform = /obj/item/clothing/under/rank/scientist/anomalist

	headset = /obj/item/radio/headset/headset_anom
	bowman = /obj/item/radio/headset/headset_anom/alt
	double_headset = /obj/item/radio/headset/alt/double/anom
	wrist_radio = /obj/item/radio/headset/wrist/anom
	clipon_radio = /obj/item/radio/headset/wrist/clip/anom

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	job_access = list(/datum/access/tox::id, /datum/access/research::id, /datum/access/xenobiology::id, /datum/access/tox_storage::id, /datum/access/intrepid::id, /datum/access/spark::id, /datum/access/quark::id, /datum/access/canary::id)

	minimal_player_age = 14

	outfit = /obj/outfit/job/scientist/xenobiologist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	jobtype = /datum/job/xenobiologist

	uniform = /obj/item/clothing/under/rank/scientist/xenobio

	headset = /obj/item/radio/headset/headset_xenology
	bowman = /obj/item/radio/headset/headset_xenology/alt
	double_headset = /obj/item/radio/headset/alt/double/xenology
	wrist_radio = /obj/item/radio/headset/wrist/xenology
	clipon_radio = /obj/item/radio/headset/wrist/clip/xenology

/datum/job/xenobotanist
	title = "Xenobotanist"
	flag = XENOBOTANIST
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#a44799"
	economic_modifier = 7

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	job_access = list(/datum/access/tox::id, /datum/access/tox_storage::id, /datum/access/research::id, /datum/access/xenobotany::id, /datum/access/intrepid::id, /datum/access/spark::id, /datum/access/quark::id, /datum/access/canary::id)

	minimal_player_age = 14

	outfit = /obj/outfit/job/scientist/xenobotanist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)


/obj/outfit/job/scientist/xenobotanist
	name = "Xenobotanist"
	jobtype = /datum/job/xenobotanist

	uniform = /obj/item/clothing/under/rank/scientist/botany

	headset = /obj/item/radio/headset/headset_xenology
	bowman = /obj/item/radio/headset/headset_xenology/alt
	double_headset = /obj/item/radio/headset/alt/double/xenology
	wrist_radio = /obj/item/radio/headset/wrist/xenology
	clipon_radio = /obj/item/radio/headset/wrist/clip/xenology

/datum/job/intern_sci
	title = "Research Intern"
	flag = INTERN_SCI
	departments = SIMPLEDEPT(DEPARTMENT_SCIENCE)
	department_flag = MEDSCI
	faction = "Station"
	alt_titles = list("Xenoarchaeology Intern", "Anomalistics Intern", "Xenobiology Intern", "Xenobotany Intern")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Research Director"
	selection_color = "#a44799"

	job_access = list(/datum/access/research::id, /datum/access/tox::id)
	outfit = /obj/outfit/job/intern_sci
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/intern_sci
	name = "Research Intern"
	jobtype = /datum/job/intern_sci

	uniform = /obj/item/clothing/under/rank/scientist/intern
	shoes = /obj/item/clothing/shoes/sneakers/medsci
	headset = /obj/item/radio/headset/headset_sci
	bowman = /obj/item/radio/headset/headset_sci/alt
	double_headset = /obj/item/radio/headset/alt/double/sci
	wrist_radio = /obj/item/radio/headset/wrist/sci
	clipon_radio = /obj/item/radio/headset/wrist/clip/sci

	backpack = /obj/item/storage/backpack/toxins
	backpack_faction = /obj/item/storage/backpack/nt
	satchel = /obj/item/storage/backpack/satchel/tox
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag = /obj/item/storage/backpack/duffel/tox
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag = /obj/item/storage/backpack/messenger/tox
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

	tab_pda = /obj/item/modular_computer/handheld/pda/research
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/research
	tablet = /obj/item/modular_computer/handheld/preset/research
