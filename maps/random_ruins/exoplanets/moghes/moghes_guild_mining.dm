/datum/map_template/ruin/exoplanet/moghes_guild_mining
	name = "Miners' Guild Camp"
	id = "moghes_guild_mining"
	description = "A Miners' Guild mining facility in the Untouched Lands"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_guild_mining.dmm"
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_heph_mining)

	unit_test_groups = list(3)

/area/moghes_guild_mining
	name = "Miners' Guild Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The faint sounds of heavy machinery can be heard - the whirring of drills, the quiet noise of conveyor belts, and the electrical hum of power cables."

/datum/ghostspawner/human/moghes_guild_miner
	short_name = "moghes_guild_miner"
	name = "Unathi Guild Miner"
	desc = "Work as a miner for the Miners' Guild on Moghes."
	tags = list("External")
	welcome_message = "You are a guildsman of the Miners' Guild, working in the Untouched Lands of Moghes. Break rocks, earn your paycheck."

	spawnpoints = list("moghes_guild_miner")
	max_count = 3

	outfit = /obj/outfit/admin/miners_guild
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Guild Miner"
	special_role = "Guild Miner"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_guild_miner/foreman
	short_name = "moghes_miners_guild_boss"
	name = "Unathi Guild Foreman"
	desc = "Lead a team of Miners' Guild guildsmen on Moghes."
	max_count = 1
	uses_species_whitelist = TRUE
	assigned_role = "Guild Foreman"
	special_role = "Guild Foreman"
