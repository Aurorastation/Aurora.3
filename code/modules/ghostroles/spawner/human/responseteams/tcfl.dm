/datum/ghostspawner/human/ert/tcfl
	name = "TCFL Volunteer"
	short_name = "tcflr"
	desc = "The Tau Ceti Foreign Legion's rank and file."
	welcome_message = "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect the place you're heading to and fix the problem. You can be a Volunteer (Vol.), Legionnaire (Lgn.) or Prefect (Pfct.). The first option is recommended for new players."
	max_count = 3
	outfit = /datum/outfit/admin/ert/legion
	spawnpoints = list("TCFLERTSpawn")
	possible_species = list(SPECIES_HUMAN, SPECIES_OFFWORLDER_HUMAN, SPECIES_TAJARA, SPECIES_TAJARA, SPECIES_MSAI_TJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_AUTAKH_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_HEPHAESTUS_G1_IPC, SPECIES_HEPHAESTUS_G2_IPC, SPECIES_XION_IPC, SPECIES_ZENGHU_IPC, SPECIES_BISHOP_IPC, SPECIES_SHELL_IPC, SPECIES_DIONA)
	mob_name_prefix = "Vol. "

/datum/ghostspawner/human/ert/tcfl/specialist
	name = "TCFL Legionnaire"
	short_name = "tcfls"
	max_count = 2
	desc = "An experienced Legionnaire of the TCFL."
	outfit = /datum/outfit/admin/ert/legion/specialist
	mob_name_prefix = "Lgn. "

/datum/ghostspawner/human/ert/tcfl/leader
	name = "TCFL Prefect"
	short_name = "tcfll"
	max_count = 1
	desc = "A leader of Task Force XIII - Fortune."
	outfit = /datum/outfit/admin/ert/legion/leader
	mob_name_prefix = "Pfct. "
	spawnpoints = list("TCFLERTSpawn - Prefect")

/datum/ghostspawner/human/ert/tcfl/pilot
	name = "TCFL Dropship Pilot"
	short_name = "tcflpl"
	max_count = 1
	desc = "A dropship pilot of the TCFL."
	welcome_message = "As a pilot of the Tau Ceti Foreign Legion, your job is to pilot your assigned dropship and keep it safe from any hostile forces. You may also have to assist the main task force in a supporting role if the need arises."
	outfit = /datum/outfit/admin/ert/legion/pilot
	mob_name_prefix = "PL. "
	spawnpoints = list("TCFLERTSpawn - Pilot")
