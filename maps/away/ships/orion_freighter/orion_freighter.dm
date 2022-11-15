/datum/map_template/ruin/away_site/orion_freighter
	name = "Orion Express Freighter"
	id = "orion_freighter"
	description = "The XYZ-Caravel freighter is a standardized container carrier ship, with the carrying capacity of eight medium size containers. This one's transponder identifies it as an Orion Express freighter, although the signal is very faint, and the ship appears to be mostly cold."
	suffix = "ships/orion_freighter/orion_freighter.dmm"
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA)

/obj/effect/overmap/visitable/ship/orion_freighter
	name = "Orion Express Freighter"
	class = "OEV"
	desc = "The XYZ-Caravel freighter is a standardized container carrier ship, with the carrying capacity of eight medium size containers. This one's transponder identifies it as an Orion Express freighter, although the signal is very faint, and the ship appears to be mostly cold."
	icon_state = "ship"
	moving_state = "ship_moving"
	vessel_mass = 3000
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_orion_freighter_0",
		"nav_orion_freighter_1",
		"nav_orion_freighter_2",
		"nav_orion_freighter_3",
		"nav_orion_freighter_4"
	)
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_orion_freighter_0"),
	)

/obj/effect/overmap/visitable/ship/orion_freighter/New()
	designation = "[pick("Traveler", "Highspeed", "Punctual", "Unstoppable", "Express", "Courier", "Speed", "Delivery", "Speedy Delivery", "Freighter", "Carrier", "Heavy Cargo", "Transgalactic", "Peregrine", "Franklin", "Krantz", "Faulkner")]"
	..()

/obj/effect/shuttle_landmark/orion_freighter
	name = "Starboard Dock Intrepid"
	landmark_tag = "nav_orion_freighter_0"

/obj/effect/shuttle_landmark/orion_freighter/nav1
	name = "Navpoint Starboard"
	landmark_tag = "nav_orion_freighter_1"

/obj/effect/shuttle_landmark/orion_freighter/nav2
	name = "Navpoint Port"
	landmark_tag = "nav_orion_freighter_2"

/obj/effect/shuttle_landmark/orion_freighter/nav3
	name = "Navpoint Fore"
	landmark_tag = "nav_orion_freighter_3"

/obj/effect/shuttle_landmark/orion_freighter/nav4
	name = "Starboard Dock"
	landmark_tag = "nav_orion_freighter_4"

/obj/effect/dungeon_generic_landmark/orion_freighter_container
	name = "Orion Express Freighter Container Dungeon Landmark"
	spawn_chance = 100
	unique = TRUE
	map_files = "maps/away/ships/orion_freighter/containers/"
