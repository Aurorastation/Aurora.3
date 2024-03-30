/datum/map_template/ruin/exoplanet/konyang_lostcop
	name = "Lost Police Patrol"
	id = "konyang_lostcop"
	description = "A lost National Police patrol."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/stranded_police.dmm")

/datum/ghostspawner/human/konyang_lostcop
	short_name = "konyang_lostcop"
	name = "Konyang Lost Police Patrolman"
	desc = "Wander the countryside and try to find help."
	tags = list("External")
	welcome_message = "You are a lost patrolman."

	spawnpoints = list("konyang_lost_cop")
	max_count = 2

	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /obj/outfit/admin/konyang/cop
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Konyang Lost Patrolman"
	special_role = "Konyang Lost Patrolman"
	respawn_flag = null

	uses_species_whitelist = FALSE

	culture_restriction = list(/singleton/origin_item/culture/solarian)
	origin_restriction = list(/singleton/origin_item/origin/konyang)
