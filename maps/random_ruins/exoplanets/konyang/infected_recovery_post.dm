/datum/map_template/ruin/exoplanet/infected_recovery_post
	name = "Infected Recovery Post"
	id = "infected_recovery_post"
	description = "A post established to research and recover infected IPCs."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/infected_recovery_post.dmm")

/area/konyang/infected_recovery_post
	name = "Konyang Infected Recovery Post"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_env = ROOM
	requires_power = TRUE

/datum/ghostspawner/human/konyang_infected_recovery_cop
	short_name = "konyang_infected_recovery_cop"
	name = "KRC Infected Recovery Police Patrolman"
	desc = "Recover any infected IPCs in the area alive (if possible) and assist the researcher in examining them."
	welcome_message = "You are a Infected Recovery Police Patrolman."
	tags = list("External")
	spawnpoints = list("konyang_infected_recovery_cop")
	max_count = 2

	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /datum/outfit/admin/konyang_cop
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Infected Recovery Police Patrolman"
	special_role = "Infected Recovery Police Patrolman"
	respawn_flag = null

	uses_species_whitelist = FALSE

	culture_restriction = list(/singleton/origin_item/culture/solarian)
	origin_restriction = list(/singleton/origin_item/origin/konyang)

/datum/ghostspawner/human/konyang_infected_recovery_researcher
	short_name = "konyang_infected_recovery_researcher"
	name = "KRC Infected Recovery Researcher"
	desc = "Reserach and cure the infected on behalf of the Konyang Robotics Corporation, help out your police colleagues, help stop the apocalypse."
	welcome_message = "You are a Infected Recovery Researcher."
	max_count = 1
	tags = list("External")
	spawnpoints = list("konyang_infected_recovery_researcher")
	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /datum/outfit/admin/konyang_clinic
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang Infected Recovery Researcher"
	special_role = "Konyang Infected Recovery Researcher"
	respawn_flag = null

	uses_species_whitelist = FALSE

	culture_restriction = list(/singleton/origin_item/culture/solarian)
	origin_restriction = list(/singleton/origin_item/origin/konyang)
