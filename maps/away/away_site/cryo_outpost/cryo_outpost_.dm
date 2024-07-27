
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/cryo_outpost
	name = "Desert Oasis Planet"
	description = "Desert Oasis Planet."
	prefix = "away_site/cryo_outpost/"
	suffixes = list("cryo_outpost.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "cryo_outpost"
	exoplanet_themes = list(
		/turf/unsimulated/marker/khaki = /datum/exoplanet_theme/desert/cryo_outpost,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/desert/cryo_outpost/mountain,
		/turf/unsimulated/marker/green = /datum/exoplanet_theme/grass/cryo_outpost
	)
	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED // TODO REMOVE THIS

/singleton/submap_archetype/cryo_outpost
	map = "Desert Oasis Planet"
	descriptor = "Desert Oasis Planet."

// /obj/abstract/weather_marker/cryo_outpost
// 	weather_type = /singleton/state/weather/calm/desert_planet

// --------------------------------------------------- mapmanip

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/crew_quarters_room
	name = "Crew Quarters Room"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/crew_quarters_room
	name = "Crew Quarters Room"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/warehouse
	name = "Warehouse"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/warehouse
	name = "Warehouse"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/river
	name = "River"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/river
	name = "River"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/landing_pads
	name = "Landing Pads"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/landing_pads
	name = "Landing Pads"

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/cryo_outpost
	name = "Desert Oasis Planet"
	desc = "\
		Temperate planet, mostly dry and covered in sand dunes, but with river and lake oases scattered around the equator. \
		Scans show a somewhat rich biosphere with flora and fauna, and the planet holds a standard breathable atmosphere. \
		Landing site is in a small valley with a small river running through it.\
		"
	icon_state = "globe1"
	color = "#f1c86f"
	initial_generic_waypoints = list(
		"nav_cryo_outpost_dock_outpost_1",
		"nav_cryo_outpost_dock_outpost_2",
		"nav_cryo_outpost_dock_outpost_3",
		"nav_cryo_outpost_dock_outpost_4",
		"nav_cryo_outpost_dock_outpost_5",
		"nav_cryo_outpost_surface_outpost_1",
		"nav_cryo_outpost_surface_outpost_2",
		"nav_cryo_outpost_surface_outpost_3",
		"nav_cryo_outpost_surface_outpost_4",
		"nav_cryo_outpost_surface_outpost_5",
		"nav_cryo_outpost_surface_far_1",
		"nav_cryo_outpost_surface_far_2",
		"nav_cryo_outpost_surface_far_3",
		"nav_cryo_outpost_surface_far_4",
	)

/obj/effect/overmap/visitable/sector/cryo_outpost/generate_ground_survey_result()
	..()
	if(prob(60))
		ground_survey_result += "<br>Analysis indicates sands rich in silica and oxygen"
	if(prob(40))
		ground_survey_result += "<br>High nitrogen and phosphorus contents of the soil"
	if(prob(40))
		ground_survey_result += "<br>Chemical extraction indicates soil is rich in major and secondary nutrients for agriculture"
	if(prob(40))
		ground_survey_result += "<br>Analysis indicates low contaminants of the soil"
	if(prob(40))
		ground_survey_result += "<br>Soft clays detected, composed of quartz and calcites"
	if(prob(40))
		ground_survey_result += "<br>Muddy dirt rich in organic material"
	if(prob(40))
		ground_survey_result += "<br>Stratigraphy indicates low risk of tectonic activity in this region"
	if(prob(60))
		ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
	if(prob(10))
		ground_survey_result += "<br>Traces of fissile material"

// --------------------------------------------------- misc

#define NETWORK_CRYO_OUTPOST "Desert Oasis Planet Outpost"

/obj/machinery/camera/network/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/machinery/computer/security/terminal/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/item/research_slip/cryo_outpost
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data. This one is covered in Zeng-Hu Pharmaceuticals logos."
	icon_state = "slip_zeng"
	origin_tech = list(TECH_BIO = 8, TECH_MATERIAL = 7, TECH_MAGNET = 7, TECH_DATA = 7)

/*
/obj/item/paper/fluff/cryo_outpost
	name = "Captain's Report"
	desc = "A printed and filled."

/obj/item/paper/fluff/cryo_outpost/generate_text_contents()
	name = "Captain's Report"
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
*/
