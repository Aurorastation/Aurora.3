/datum/map_template/ruin/exoplanet/pirate_moonshine
	name = "Pirate Moonshine Den"
	id = "konyang_moonshine"
	description = "An outpost in the jungle home to a group of Konyang pirates. These ones spend their time making drugs and alcohol."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/pirate_moonshine.dmm")

/area/konyang_pirate_moonshine
	name = "Konyang Moonshiner Den"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	flags = HIDE_FROM_HOLOMAP

/datum/ghostspawner/human/konyang_moonshine
	short_name = "konyang_moonshine"
	name = "Konyang Pirate Moonshiner"
	desc = "Be a pirate running a drug lab and moonshine operation in the jungles of Konyang - keep the operation going, make a profit, and live another day. NOT AN ANTAGONIST! Do not act as such!"
	tags = list("External")
	welcome_message = "You are a pirate, distilling liquor and cooking narcotics out in the jungles of Konyang. Remember, you are not an antagonist and should not act as such - if you're unsure if something you'd like to do is toeing the line, you should ahelp first."

	extra_languages = list(LANGUAGE_SOL_COMMON)
	spawnpoints = list("konyang_moonshine")
	max_count = 2

	outfit = /datum/outfit/admin/konyang_pirate
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Konyang Pirate Moonshiner"
	special_role = "Konyang Pirate Moonshiner"
	respawn_flag = null
