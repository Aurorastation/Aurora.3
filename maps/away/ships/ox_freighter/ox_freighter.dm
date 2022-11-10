/datum/map_template/ruin/away_site/ox_freighter
	name = "Orion Express Freighter"
	id = "ox_freighter"
	description = "The XYZ-class freighter is a standardized container carrier ship, with the carrying capacity of eight medium size containers. This one's transponder identifies it as an Orion Express freighter."
	suffix = "ships/ox_freighter/ox_freighter.dmm"
	spawn_cost = 1
	spawn_weight = 1000000
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA)

/obj/effect/overmap/visitable/ship/ox_freighter
	name = "Orion Express Freighter"
	class = "OEV"
	desc = "The XYZ-class freighter is a standardized container carrier ship, with the carrying capacity of eight medium size containers. This one's transponder identifies it as an Orion Express freighter."
	icon_state = "ship"
	moving_state = "ship_moving"
	vessel_mass = 3000
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_ox_freighter_1",
		"nav_ox_freighter_2",
		"nav_ox_freighter_3",
	)

/obj/effect/overmap/visitable/ship/ox_freighter/New()
	designation = "[pick("Messenger", "Traveler", "Highspeed", "Punctual", "Unstoppable", "Pony Express", "Courier", "Telegram", "Carrier Pigeon", "Fuel Stop", "Convenience")]"
	..()

/obj/effect/shuttle_landmark/ox_freighter/nav1
	name = "Orion Express Freighter Navpoint #1"
	landmark_tag = "nav_ox_freighter_1"

/obj/effect/shuttle_landmark/ox_freighter/nav2
	name = "Orion Express Freighter Navpoint #2"
	landmark_tag = "nav_ox_freighter_2"

/obj/effect/shuttle_landmark/ox_freighter/nav3
	name = "Orion Express Freighter Navpoint #3"
	landmark_tag = "nav_ox_freighter_3"

/obj/effect/dungeon_generic_landmark/ox_freighter_container
	name = "Orion Express Freighter Container Dungeon Landmark"
	spawn_chance = 100
	unique = TRUE
	map_files = "maps/away/ships/ox_freighter/containers/"
