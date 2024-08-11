/datum/ghostspawner/human/ert/tcaf
	name = "Republican Fleet Legionary"
	short_name = "erttcaf"
	desc = "A soldier of the Republican Fleet response team."
	max_count = 2
	outfit = /obj/outfit/admin/ert/tcaf
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	mob_name_prefix = "Lgn. "
	welcome_message = "You are a soldier of the Tau Ceti Republican Fleet, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Republican Fleet Legionary"

/datum/ghostspawner/human/ert/tcaf/medic
	name = "Republican Fleet Medic"
	short_name = "erttcafm"
	desc = "The assigned medic of the Republican Fleet response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/tcaf/medic
	welcome_message = "You are a medical specialist of the Tau Ceti Republican Fleet, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Republican Fleet Medic"

/datum/ghostspawner/human/ert/tcaf/engi
	name = "Republican Fleet Sapper"
	short_name = "erttcafe"
	desc = "The assigned sapper and engineering specialist of the Republican Fleet response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/tcaf/engi
	welcome_message = "You are an engineering specialist of the Tau Ceti Republican Fleet, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Republican Fleet Engineer"

/datum/ghostspawner/human/ert/tcaf/officer
	name = "Republican Fleet Officer"
	short_name = "erttcaflead"
	desc = "The commanding officer of the Republican Fleet response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/tcaf/officer
	welcome_message = "You are the commanding officer of a Tau Ceti Republican Fleet squadron, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Republican Fleet Officer"
	mob_name_prefix = "Dec. "
