/datum/map_template/ruin/exoplanet/miners_guild_outpost
	name = "Miners' Guild Outpost"
	id = "miners_guild_outpost"
	description = "A Miners' Guild mining outpost on one of Uueoa-Esa's minor celestial bodies."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "miners_guild_outpost.dmm"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	spawn_cost = 2
	ban_ruins = list(/datum/map_template/ruin/exoplanet/heph_mining_station)

	unit_test_groups = list(1)

/area/miners_guild_outpost
	name = "Miners' Guild Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	ambience = AMBIENCE_EXPOUTPOST

/area/miners_guild_outpost/entry
	name = "Miners' Guild Outpost - Entrance"
	icon_state = "exit"

/area/miners_guild_outpost/eva
	name = "Miners' Guild Outpost - EVA Storage"
	icon_state = "eva"

/area/miners_guild_outpost/mining
	name = "Miners' Guild Outpost - Processing"
	icon_state = "mining"

/area/miners_guild_outpost/quarters
	name = "Miners' Guild Outpost - Crew Quarters"
	icon_state = "crew_quarters"

/area/miners_guild_outpost/mess
	name = "Miners' Guild Outpost - Mess Hall"
	icon_state = "cafeteria"

/area/miners_guild_outpost/engineering
	name = "Miners' Guild Outpost - Engineering"
	icon_state = "engineering"

/datum/ghostspawner/human/miners_guild_outpost
	short_name = "miners_guild_outpost"
	name = "Unathi Guild Miner"
	desc = "Crew a Miners' Guild outpost on one of Uueoa-Esa's minor celestial bodies. Break rocks, earn your paycheck."
	tags = list("External")
	welcome_message = "You are a guildsman of the Miners' Guild, working in a small outpost on one of the myriad moons or asteroids of Uueoa-Esa. Mine the location, for honor and profit."

	spawnpoints = list("miners_guild_outpost")
	max_count = 3

	outfit = /obj/outfit/admin/miners_guild
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Guild Miner"
	special_role = "Guild Miner"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/ghostspawner/human/miners_guild_outpost/foreman
	short_name = "miners_guild_outpost_boss"
	name = "Unathi Guild Foreman"
	desc = "Command a Miners' Guild outpost on one of Uueoa-Esa's minor celestial bodies. Break rocks, manage your crew, earn your paycheck."
	max_count = 1
	uses_species_whitelist = TRUE
	assigned_role = "Guild Foreman"
	special_role = "Guild Foreman"
