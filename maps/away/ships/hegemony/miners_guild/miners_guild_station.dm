/datum/map_template/ruin/away_site/miners_guild_station
	name = "Miners' Guild Outpost"
	description = "A station constructed by the Unathi Miners' Guild"
	suffixes = list("ships/hegemony/miners_guild/miners_guild_station.dmm")
	spawn_weight = 1
	ship_cost = 1
	sectors = list(SECTOR_BADLANDS, SECTOR_UUEOAESA)
	id = "miners_guild_station"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/miners_guild)

/singleton/submap_archetype/miners_guild_station
	map = "Miners' Guild Outpost"
	descriptor = "A station constructed by the Unathi Miners' Guild"

/obj/effect/overmap/visitable/sector/miners_guild_station
	name = "Miners' Guild Outpost"
	desc = "A Kutah-class mining station, owned and operated by the Hegemony Miners' Guild. These stations are usually temporary, constructed in mineral-rich systems and operated until \
	the local celestial bodies have been stripped of any minerals of value. They have earned a reputation for being slapdash and shoddily-constructed, though this one seems to be in good shape."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost"
	color = "#b07810"
	comms_support = TRUE
	comms_name = "Miners' Guild"
	initial_generic_waypoints = list(
		"miners_guild_nav1",
		"miners_guild_nav2",
		"miners_guild_nav3",
		"miners_guild_nav4"
	)
	initial_restricted_waypoints = list()

/obj/effect/shuttle_landmark/miners_guild
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/miners_guild/nav1
	name = "Miners' Guild Outpost - Fore"
	landmark_tag = "miners_guild_nav1"

/obj/effect/shuttle_landmark/miners_guild/nav2
	name = "Miners' Guild Outpost - Port"
	landmark_tag = "miners_guild_nav2"

/obj/effect/shuttle_landmark/miners_guild/nav3
	name = "Miners' Guild Outpost - Starboard"
	landmark_tag = "miners_guild_nav3"

/obj/effect/shuttle_landmark/miners_guild/nav4
	name = "Miners' Guild Outpost - Aft"
	landmark_tag = "miners_guild_nav4"


//Shuttle

/obj/effect/overmap/visitable/ship/landable/miners_guild
	name = "Miners' Guild Shuttle"
	class = "IHGV" //Izweski Hegemony Guild Vessel
	desc = "Commonly used by the Miners’ Guild, Glizkin-class shuttles are short-range mining vessels, designed for persistent mining of celestial bodies. \
	They are viewed by their crews as small, yet reliable and enduring - much like the Tza Prairie folk hero for which they are named. They are usually found attached to larger stations or mining vessels."
	shuttle = "Miners' Guild Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#b07810"
	designer = "Hegeranzi Starworks"
	volume = "18 meters length, 15 meters beam/width, 7 meters vertical height"
	sizeclass = "Short-range crew transport and mineral extraction pod"
	shiptype = "Short-term industrial prospecting, raw goods transport"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/miners_guild/New()
	designation = "[pick("Stonebreaker", "Son of Kutah", "Asteroid's Bane", "Sinta Pride", "Ancestors' Glory", "Azhal's Blessing", "Fires of Sk'akh", "Pickaxe", "Where's The Phoron", "How Do I Reset The IFF")]"
	..()

/obj/machinery/computer/shuttle_control/explore/miners_guild
	name = "shuttle control console"
	shuttle_tag = "Miners' Guild Shuttle"

/datum/shuttle/autodock/overmap/miners_guild
	name = "Miners' Guild Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/miners_guild)
	current_location = "miners_guild_navhangar"
	landmark_transition = "miners_guild_navtransit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "miners_guild_navhangar"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/miners_guild/hangar
	name = "Miners' Guild Outpost - Hangar"
	landmark_tag = "miners_guild_navhangar"
	base_area = /area/miners_guild/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/miners_guild/transit
	name = "In transit"
	landmark_tag = "miners_guild_navtransit"
	base_turf = /turf/space/transit/north