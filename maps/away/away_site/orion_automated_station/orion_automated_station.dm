
// -------------------------------- map and station defs

/datum/map_template/ruin/away_site/orion_automated_station
	name = "Orion Express Automated Station"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "Orion Express Automated Station."//Not visible ingame
	unit_test_groups = list(1)

	id = "orion_automated_station"//Arbitrary tag to make things work. This should be lowercase and unique
	spawn_cost = 1
	spawn_weight = 1
	suffixes = list("away_site/abandoned_industrial/orion_automated_station.dmm")

	sectors = list(ALL_POSSIBLE_SECTORS)

/singleton/submap_archetype/orion_automated_station//Arbitrary duplicates of the above name/desc
	map = "Orion Express Automated Station"
	descriptor = "Orion Express Automated Station."

/obj/effect/overmap/visitable/sector/orion_automated_station//This is the actual overmap object that spawns at roundstart
	name = "Orion Express Automated Station"//This and desc is visible ingame when the object is scanned by any scanner
	desc = "Industrial station of unknown designation or origin. Scanners detect it to be mostly cold, likely no movement or life inside, although appears to be pressurized."
	icon_state = "outpost"

	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost"
	color = "#bbb186"
	designer = "Unknown"
	volume = "78 meters length, 133 meters beam/width, 24 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Industrial Station"

	initial_generic_waypoints = list(
		"nav_ox_auto_station_dock_west",
		"nav_ox_auto_station_dock_east",
		"nav_ox_auto_station_dock_north_1",
		"nav_ox_auto_station_dock_north_2",
		"nav_ox_auto_station_dock_south_1",
		"nav_ox_auto_station_dock_south_2",
		"nav_ox_auto_station_catwalk_north",
		"nav_ox_auto_station_catwalk_south",
		"nav_ox_auto_station_space_north_east",
		"nav_ox_auto_station_space_north_west",
		"nav_ox_auto_station_space_south_east",
		"nav_ox_auto_station_space_south_west",
	)

// -------------------------------- landmarks docks

/obj/effect/shuttle_landmark/orion_automated_station
	name = "orion_automated_station parent landmark"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/orion_automated_station/dock/west
	name = "Dock, West"
	landmark_tag = "nav_ox_auto_station_dock_west"
	docking_controller = "airlock_ox_auto_station_dock_west"

/obj/effect/shuttle_landmark/orion_automated_station/dock/east
	name = "Dock, East"
	landmark_tag = "nav_ox_auto_station_dock_east"
	docking_controller = "airlock_ox_auto_station_dock_east"

/obj/effect/shuttle_landmark/orion_automated_station/dock/north_1
	name = "Dock, North 1"
	landmark_tag = "nav_ox_auto_station_dock_north_1"
	docking_controller = "airlock_ox_auto_station_dock_north_1"

/obj/effect/shuttle_landmark/orion_automated_station/dock/north_2
	name = "Dock, North 2"
	landmark_tag = "nav_ox_auto_station_dock_north_2"
	docking_controller = "airlock_ox_auto_station_dock_north_2"

/obj/effect/shuttle_landmark/orion_automated_station/dock/south_1
	name = "Dock, South 1"
	landmark_tag = "nav_ox_auto_station_dock_south_1"
	docking_controller = "airlock_ox_auto_station_dock_south_1"

/obj/effect/shuttle_landmark/orion_automated_station/dock/south_2
	name = "Dock, South 2"
	landmark_tag = "nav_ox_auto_station_dock_south_2"
	docking_controller = "airlock_ox_auto_station_dock_south_2"

// -------------------------------- landmarks catwalks

/obj/effect/shuttle_landmark/orion_automated_station/catwalk/north
	name = "Catwalk, North"
	landmark_tag = "nav_ox_auto_station_catwalk_north"

/obj/effect/shuttle_landmark/orion_automated_station/catwalk/south
	name = "Catwalk, South"
	landmark_tag = "nav_ox_auto_station_catwalk_south"

// -------------------------------- landmarks space

/obj/effect/shuttle_landmark/orion_automated_station/space/north_east
	name = "Space, North East"
	landmark_tag = "nav_ox_auto_station_space_north_east"

/obj/effect/shuttle_landmark/orion_automated_station/space/north_west
	name = "Space, North West"
	landmark_tag = "nav_ox_auto_station_space_north_west"

/obj/effect/shuttle_landmark/orion_automated_station/space/south_east
	name = "Space, South East"
	landmark_tag = "nav_ox_auto_station_space_south_east"

/obj/effect/shuttle_landmark/orion_automated_station/space/south_west
	name = "Space, South West"
	landmark_tag = "nav_ox_auto_station_space_south_west"

// -------------------------------- areas

/area/orion_automated_station
	name = "orion_automated_station parent area"

/area/orion_automated_station/center
	name = "Central Hallway/Docks"
	icon_state = "hallC"

/area/orion_automated_station/east
	name = "East Hallway/Docks"
	icon_state = "arrivals_dock"

/area/orion_automated_station/west
	name = "West Hallway/Docks"
	icon_state = "arrivals_dock"

/area/orion_automated_station/storage
	name = "Crates/Canisters Storage"
	icon_state = "storage"

/area/orion_automated_station/packages
	name = "Packages Storage"
	icon_state = "storage"

/area/orion_automated_station/engineering
	name = "Engineering"
	icon_state = "engineering"

/area/orion_automated_station/atmos
	name = "Atmospherics"
	icon_state = "atmos"

/area/orion_automated_station/exterior
	name = "Exterior Catwalks/Lattices"
	icon_state = "exterior"

// -------------------------------- items

/obj/item/paper/orion_automated_station
	name = "orion_automated_station paper parent object"
	desc = DESC_PARENT

/obj/item/paper/orion_automated_station/report_1
	name = "Captain's Report"
	desc = "A printed situation report."
	info = "\
		TO: COMPANY SECTOR MANAGEMENT <br>\
		FROM: CAPTAIN DENISA HRUSKA <br>\
		SUBJECT: SITUATION REPORT <br>\
		DATE: 2464-02-12<br>\
		<br>\
		<br>\
		We are running out of asteroids we can exploit. Or at least with the personnel and supplies that we have. <br>\
		We are lacking competent engineers, and our systems are constantly broken or running at reduced capacity. <br>\
		We need tools, food, air, fuel. A second fusion reactor. Solar panels. Electronics. Spare shuttle parts. <br>\
		<br>\
		<br>\
		Crew manifest as of today: <br>\
		- Denisa Hruska - Captain <br>\
		- Anna Jelinek - Miner Specialist <br>\
		- Frantisek Bartos - Miner <br>\
		- Tomas Hruby - Pilot <br>\
		- Fiala Dvorakova - Atmospherics Engineer <br>\
		- Jiri Ruzicka - Cook <br>\
		<br>\
		<br>\
		I am aware it is even smaller crew than last week. <br>\
		Crew is not happy about all of this. And so, more and more are just leaving, even before their contracts end. <br>\
		"

/obj/item/paper/orion_automated_station/report_2
	name = "Captain's Report"
	desc = "A printed situation report."
	info = "\
		TO: COMPANY SECTOR MANAGEMENT <br>\
		FROM: CAPTAIN DENISA HRUSKA <br>\
		SUBJECT: SITUATION REPORT <br>\
		DATE: 2464-02-12<br>\
		<br>\
		<br>\
		We are running out of asteroids we can exploit. Or at least with the personnel and supplies that we have. <br>\
		We are lacking competent engineers, and our systems are constantly broken or running at reduced capacity. <br>\
		We need tools, food, air, fuel. A second fusion reactor. Solar panels. Electronics. Spare shuttle parts. <br>\
		<br>\
		<br>\
		Crew manifest as of today: <br>\
		- Denisa Hruska - Captain <br>\
		- Anna Jelinek - Miner Specialist <br>\
		- Frantisek Bartos - Miner <br>\
		- Tomas Hruby - Pilot <br>\
		- Fiala Dvorakova - Atmospherics Engineer <br>\
		- Jiri Ruzicka - Cook <br>\
		<br>\
		<br>\
		I am aware it is even smaller crew than last week. <br>\
		Crew is not happy about all of this. And so, more and more are just leaving, even before their contracts end. <br>\
		"

/obj/item/paper/orion_automated_station/report_3
	name = "Captain's Report"
	desc = "A printed situation report."
	info = "\
		TO: COMPANY SECTOR MANAGEMENT <br>\
		FROM: CAPTAIN DENISA HRUSKA <br>\
		SUBJECT: SITUATION REPORT <br>\
		DATE: 2464-02-12<br>\
		<br>\
		<br>\
		We are running out of asteroids we can exploit. Or at least with the personnel and supplies that we have. <br>\
		We are lacking competent engineers, and our systems are constantly broken or running at reduced capacity. <br>\
		We need tools, food, air, fuel. A second fusion reactor. Solar panels. Electronics. Spare shuttle parts. <br>\
		<br>\
		<br>\
		Crew manifest as of today: <br>\
		- Denisa Hruska - Captain <br>\
		- Anna Jelinek - Miner Specialist <br>\
		- Frantisek Bartos - Miner <br>\
		- Tomas Hruby - Pilot <br>\
		- Fiala Dvorakova - Atmospherics Engineer <br>\
		- Jiri Ruzicka - Cook <br>\
		<br>\
		<br>\
		I am aware it is even smaller crew than last week. <br>\
		Crew is not happy about all of this. And so, more and more are just leaving, even before their contracts end. <br>\
		"

/obj/item/paper/orion_automated_station/empty_storage_unit
	name = "Captain's Report"
	desc = "A printed situation report."
	info = "\
		TO: COMPANY SECTOR MANAGEMENT <br>\
		FROM: CAPTAIN DENISA HRUSKA <br>\
		SUBJECT: SITUATION REPORT <br>\
		DATE: 2464-02-12<br>\
		<br>\
		<br>\
		We are running out of asteroids we can exploit. Or at least with the personnel and supplies that we have. <br>\
		We are lacking competent engineers, and our systems are constantly broken or running at reduced capacity. <br>\
		We need tools, food, air, fuel. A second fusion reactor. Solar panels. Electronics. Spare shuttle parts. <br>\
		<br>\
		<br>\
		Crew manifest as of today: <br>\
		- Denisa Hruska - Captain <br>\
		- Anna Jelinek - Miner Specialist <br>\
		- Frantisek Bartos - Miner <br>\
		- Tomas Hruby - Pilot <br>\
		- Fiala Dvorakova - Atmospherics Engineer <br>\
		- Jiri Ruzicka - Cook <br>\
		<br>\
		<br>\
		I am aware it is even smaller crew than last week. <br>\
		Crew is not happy about all of this. And so, more and more are just leaving, even before their contracts end. <br>\
		"
