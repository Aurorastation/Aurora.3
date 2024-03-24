
// -------------------------------- map and station defs

/datum/map_template/ruin/away_site/orion_automated_station
	name = "Orion Express Automated Station" // not visible ingame, but this should be unique for visibility purposes
	description = "Orion Express Automated Station" // not visible ingame
	unit_test_groups = list(3)

	id = "orion_automated_station" // arbitrary tag to make things work, this should be lowercase and unique
	spawn_cost = 1
	spawn_weight = 1
	suffixes = list("away_site/orion/orion_automated_station.dmm")

	sectors = list(ALL_CORPORATE_SECTORS)
	sectors_blacklist = list(ALL_DANGEROUS_SECTORS)

/singleton/submap_archetype/orion_automated_station // arbitrary duplicates of the above name/desc
	map = "Orion Express Automated Station"
	descriptor = "Orion Express Automated Station"

/obj/effect/overmap/visitable/sector/orion_automated_station // this is the actual overmap object that spawns at roundstart
	name = "Orion Express Automated Station (replaced in /New())" // this and desc is visible ingame when the object is scanned by any scanner
	desc = "\
		Orion Express Automated Station, common sight all around the Spur. \
		But especially so in the outer edges of the Coalition and the Frontier, \
		where the Orion Express service depends on ordinary people and ships picking up and delivering packages for each other, \
		with Orion Express only delivering to the automated stations and other distribution points. \
		This particular station is of the smaller variety, with very few facilities.\
		"
	icon_state = "ox_auto_station"

	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "ox_auto_station"
	color = "#a1a8e2"
	designer = "Orion Express"
	volume = "26 meters length, 58 meters beam/width, 20 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Drummer-type Automated Station"

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

/obj/effect/overmap/visitable/sector/orion_automated_station/New()
	if(prob(10))
		designation = "Orion Express Automated Station [pick("Zeta", "Kilo", "Uniform", "Whiskey", "Alpha", "Gamma", "Romeo", "Tango")]"
	else
		designation = "Orion Express Automated Station #[rand(100, 999)]"
	..()

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
	area_blurb = "A female, robotic voice announces from the cheap ceiling-mounted speakers: \
	\"Welcome to the Orion Express Automated Station, where you may rest, exchange packages, and use any other of our facilities.\" <br><br>\
	The voice stops, and shortly after played is a short jingle, with the same robotic voice speaking: \
	\"Faster than light. Orion Express. No better choice here or anywhere.\" <br><br>\
	After a longer pause, the voice announces yet again: \
	\"Please keep in mind that any attempts to vandalize this station WILL have a bounty placed on your ship. Your IFF was logged upon docking.\""

/area/orion_automated_station/east
	name = "East Hallway/Docks"
	icon_state = "arrivals_dock"

/area/orion_automated_station/west
	name = "West Hallway/Docks"
	icon_state = "arrivals_dock"

/area/orion_automated_station/storage
	name = "Crates/Canisters Storage"
	icon_state = "storage"
	area_blurb = "A female, robotic voice announces: \
	\"You may borrow any of the crates or canisters here, and return them later, free of charge. \
	Any damages will be deducted from your Orion Express account.\""

/area/orion_automated_station/packages
	name = "Packages Storage"
	icon_state = "storage"
	area_blurb = "A female, robotic voice announces: \
	\"You may leave your packages here, or take the packages to deliver elsewhere. \
	Remember, you get a TWO percent tip on successful delivery based on the value of the package. \
	Without you, there is no Orion Express.\""

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
	name = "Site Inspection Report #090"
	desc = "A printed site inspection report."
	info = "\
		TO: ORION EXPRESS BRANCH MANAGEMENT <br>\
		FROM: MAINTENANCE TECHNICIAN ANDRZEJ KRZYSZTOFIAK <br>\
		SUBJECT: SITE INSPECTION REPORT <br>\
		DATE: 2465-02-02<br>\
		<br>\
		<br>\
		the station looks in order, I just had to change some broken lights cause they were smashed <br>\
		probably just some punks though trashing orion stuff for no reason <br>\
		no damage to packages or the long-term storage units <br>\
		though someone did try to get into one of them cause one is all scratched up like with a knife of screwdriver but <br>\
		seems they gave up so all is good <br>\
		"

/obj/item/paper/orion_automated_station/report_2
	name = "Site Inspection Report #124"
	desc = "A printed site inspection report. This one is stained with coffee."
	info = "\
		TO: ORION EXPRESS BRANCH MANAGEMENT <br>\
		FROM: JUNIOR MAINTENANCE TECHNICIAN HUNTER MEADOW <br>\
		SUBJECT: SITE INSPECTION REPORT <br>\
		DATE: 2465-05-27<br>\
		<br>\
		<br>\
		I accidentally spilled coffee on a RTG unit but it appears it was not damaged in any way <br>\
		I cleaned it up though and gave it a quick systems check <br>\
		the north dock right side interior door had its wires burned, no idea why, but I fixed it <br>\
		everything else seems ok <br>\
		"

/obj/item/paper/orion_automated_station/report_3
	name = "Site Inspection Report #159"
	desc = "A printed site inspection report."
	info = "\
		TO: ORION EXPRESS BRANCH MANAGEMENT <br>\
		FROM: MAINTENANCE TECHNICIAN OX-AB2137 <br>\
		SUBJECT: SITE INSPECTION REPORT <br>\
		DATE: 2466-01-07<br>\
		<br>\
		<br>\
		Dirty floor. Cleaned. <br>\
		Potted plant dying. Watered. <br>\
		Firedoor stuck closed. Fixed. <br>\
		Air tank running close to empty. Filled. <br>\
		Air vent clogged. Unclogged. <br>\
		Long-term storage unit #5 broken into. Notified authorities. <br>\
		Everything else is nominal. Departing. <br>\
		"

/obj/item/paper/orion_automated_station/ox_storage_unit_ad
	name = "Orion Express Long-Term Storage Unit Ad"
	desc = "A printed and colorful advertisement."
	info = "\
		Running out of space on your ship? <br>\
		Coming to visit the Automated Station often? <br>\
		<br>\
		Rent this Long-Term Storage Unit to solve all your storage problems. <br>\
		You get a 20% discount if delivering one Orion Express Courier Package in a month. <br>\
		You get another 10% discount if using Orion Express services regularly. <br>\
		<br>\
		This Long-Term Storage Unit could be yours! <br>\
		Terms and conditions apply. <br>\
		"
