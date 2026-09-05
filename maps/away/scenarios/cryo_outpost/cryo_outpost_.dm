
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/cryo_outpost
	name = "Tatooine"
	description = "Dune Planet."
	id = "cryo_outpost"

	prefix = "scenarios/cryo_outpost/"
	suffix = "cryo_outpost.dmm"

	exoplanet_theme_base = /datum/exoplanet_theme/desert/cryo_outpost
	exoplanet_themes = list(
		/turf/unsimulated/marker/khaki = /datum/exoplanet_theme/desert/cryo_outpost,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/desert/cryo_outpost/mountain,
		/turf/unsimulated/marker/green = /datum/exoplanet_theme/grass/cryo_outpost
	)
	exoplanet_atmospheres = list(/datum/gas_mixture/earth_hot)
	exoplanet_lightlevel = list(5)
	exoplanet_lightcolor = list("#dcebc1") // icky yellow-green

	spawn_weight = 0 // so it does not spawn as ordinary away site
	spawn_cost = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(LEMURIAN_SEA_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(3)

/singleton/submap_archetype/cryo_outpost
	map = "Dune Planet"
	descriptor = "Dune Planet."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/cryo_outpost
	name = "OS/A-622c, Dune Planet"
	desc = "\
		<center><large><b>Scan Details</b></large>\
		<br><large><b>Exoplanet OS/A-622 b</b></center>\
		<br><b>Estimated Mass:</b> 0.39 Biesel Masses\
		<br><b>Surface Gravity:</b> 0.60 Gs\
		<br><b>Governing Body:</b> None\
		<br><b>Charted:</b> 2254 (ASSN)\
		<b>Geological Specifics:</b> Mineral-rich crust.\
		<b>Surface Water Coverage:</b> No measured surface liquid area.\
		<b>Apparent Weather Data:</b> High pressure atmosphere, minimal moisture; frequent sandstorms.\
		<hr>\
		<br><center><b>Visible Light Viewport Magnified</b>\
		<br><img src = desert.png>\
		<br><small>High-Fidelity Image Capture of Exoplanet OS/A-622 b</small></center>\
		<hr>\
		<br><center><b>Native Database Notes</b></center>\
		A temperate planet covered in sand dunes, devoid of surface moisture and macroscopic life. \
		<br>Surveyed in 2254 by the Alliance of Sovereign Solarian Nations. Designated a Class III hazardous near-habitable exoplanet. \
		3 further scientific surveying attempts between 2264—2276 have been registered, all abandoned during the Solarian Great Depression. \
		The planet remains unowned and uninhabited by any permanent populace. \
		<br>Hazardous gases in notable quantity detected in atmosphere (chlorine, sulphur dioxide).\
		Internals are strongly advised to avoid long-term health impacts associated with SO2 and Cl exposure. However, there is minimal risk to short-term health.\
		<br>The Republic of Biesel has raised a 1,000,000电 reward for the complete scientific survey of the exoplanet. \
		<br><br>The flagged away site, Site Oscar, is at the foot of a large, mineral-rich mesa. \
		A Republic of Biesel—chartered Einstein Engines surveying outpost is registered within the area, as of 2452.\
		"
	icon_state = "globe1"
	color = "#f1c86f"
	comms_support = TRUE
	initial_generic_waypoints = list(
		"nav_cryo_outpost_surface_close_1a",
		"nav_cryo_outpost_surface_close_1b",
		"nav_cryo_outpost_surface_close_1c",
		"nav_cryo_outpost_surface_close_1d",
		"nav_cryo_outpost_surface_close_2a",
		"nav_cryo_outpost_surface_close_2b",
		"nav_cryo_outpost_surface_close_2c",
		"nav_cryo_outpost_surface_close_2d",
		"nav_cryo_outpost_surface_far_1a",
		"nav_cryo_outpost_surface_far_1b",
		"nav_cryo_outpost_surface_far_1c",
		"nav_cryo_outpost_surface_far_1d",
		"nav_cryo_outpost_surface_far_2a",
		"nav_cryo_outpost_surface_far_2b",
		"nav_cryo_outpost_surface_far_2c",
		"nav_cryo_outpost_surface_far_2d",
		"nav_cryo_outpost_surface_far_3a",
		"nav_cryo_outpost_surface_far_3b",
		"nav_cryo_outpost_surface_far_3c",
		"nav_cryo_outpost_surface_far_3d",
	)

	soil_data = list(
		"Iron oxide rich",
		"Aluminium rich",
		"Significant concentration of perchlorates.",
		"Trace tritium contamination")

///Sets the given weather state to our planet replacing the old one, and trigger updates. Can be a type path or instance.
/obj/effect/overmap/visitable/sector/cryo_outpost/Initialize()
	. = ..()
	var/initial_weather_state = /singleton/state/weather/calm/desert_planet
	//Tells all our levels exposed to the sky to force change the weather.
	var/obj/abstract/weather_system/new_weather_system = SSweather.setup_weather_system(map_z[length(map_z)], initial_weather_state)
	new_weather_system.has_water_weather = FALSE
	new_weather_system.has_icy_weather = FALSE

/obj/effect/overmap/visitable/sector/cryo_outpost/generate_ground_survey_result()
	..()
	if(prob(50))
		ground_survey_result += "<br>Infertile Regolith — low nitrogen and phosphorus content"
	if(prob(50))
		ground_survey_result += "<br>Minor Radioactive Contamination — trace amounts of tritium and neutron activated fusion byproducts leeched into surface regolith layer"
	if(prob(50))
		ground_survey_result += "<br>Minimal Tectonic Activity — stratigraphy indicates singular tectonic plate spanning planet"
	if(prob(50))
		ground_survey_result += "<br>Microscopic Life Present — non-native but adapted bacterial organisms identified in regolith; no evidence of fossilised macroscopic organisms"
	if(prob(50))
		ground_survey_result += "<br>Mineral Rich — high concentrations of iron, magnesium, aluminum, and titanium in crust layer"
	if(prob(50))
		ground_survey_result += "<br>Toxic Regolith — various perchlorates present in regolith surface layer, deposited by dust storms and ozone interactions; minor to moderate contamination risk"

/obj/effect/overmap/visitable/sector/cryo_outpost/generate_magnet_survey_result()
	..()
	magnet_survey_result += "<br><b>Magnetic Field Strength:</b> Low \
	<br><b>Planetary Cycle Period:</b> ~0.34 Biesel Cycles \
	<br><b>Other Magnetic Specifics:</b> \
	<br>- Magnetic field interacting with strong solar winds originating from red dwarf star. \
	<br>- Weak dipolar magnetic field generated by core dynamo process. \
	<br>- Iron planetary core present."

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

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/outside_building_river
	name = "Outside Building, River"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/outside_building_river
	name = "Outside Building, River"

// ----

/obj/effect/map_effect/marker/mapmanip/submap/insert/cryo_outpost/outside_building_landing_pads
	name = "Outside Building, Landing Pads"

/obj/effect/map_effect/marker/mapmanip/submap/extract/cryo_outpost/outside_building_landing_pads
	name = "Outside Building, Landing Pads"

// --------------------------------------------------- misc

/obj/structure/machinery/camera/network/cryo_outpost
	network = list(NETWORK_CRYO_OUTPOST)

/obj/structure/machinery/computer/security/terminal/cryo_outpost
	console_networks = list(NETWORK_CRYO_OUTPOST)

/obj/item/research_slip/cryo_outpost
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data. This one is covered in Zeng-Hu Pharmaceuticals logos."
	icon_state = "slip_zeng"
	origin_tech = list(TECH_BIO = 8, TECH_MATERIAL = 7, TECH_MAGNET = 7, TECH_DATA = 7)

/// event fluff
/obj/item/paper/fluff/pirate_treasure_note

	name = "laminated note"
	desc = "A dusty, laminated note that has been left here for who knows how long."
	info = "\
		<br>\
		IF YOU ARE READING THIS, I AM PROBABLY DEAD, SO MY TREASURE IS NOW YOURS I SUPPOSE. \
		<br>\
		<br>\
		But if I am not dead, you are in a world of hurt. I will hunt you from one side of the \
		Alliance to the other. You can't even run because I have one of those new-fangled bluespace drives now. \
		And even if you succeed to hide, my reputation is gargantuan - rivalled only by Lincoln Crumm - and \
		you will never be able to trust on anyone to not snitch on you to me. \
		<br>\
		<br>OLD PETE YAPPIN' \
		2414."

/obj/item/paper/fluff/contamination_memo
	name = "EVA contamination risks memo"
	desc = "A memo concerning EVA contamination risks."
	info = "\
		<br>\
		please remember to make sure all entrants are properly decontaminating.\
		the full mile: showering, shedding outer layers, etc. \
		<br>trampling in regolith from outside is a serious contamination risk with long-term health impacts! \
		<br>\
		all EVA requires gas filtration at the VERY LEAST!"

/obj/item/paper/fluff/spacecraft_maintenance_memo
	name = "gunship maintenance memo"
	desc = "A memo concerning a spacecraft awaiting maintenance."
	info = "\
		<br>\
		Passed this onto your shift, sorry! \
		<br>\
		There is 1x Gunship awaiting maintenance on Pad 2. Superficial damage after skirmish with pirate craft. \
		<br> It is also reported to be under-served power? Perhaps buff up PSU with additional coil."

/obj/effect/overmap/scannable_prop
	generic_object = FALSE
	static_vessel = TRUE
	scannable = TRUE
	sensor_range_override = TRUE

/obj/effect/overmap/scannable_prop/ee_station_prop
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "ox_auto_station"
	color = "#DFE4ED"

	name = "EE Orbital Logistics Station OS-022"
	designer = "Einstein Engines"
	weapons = "4x 20mm Ballistic Point Defence Cannons"
	sizeclass = "EE-MOD93 Small Station"
	shiptype = "Orbital Logistics"
	alignment = "Einstein Engines"

	desc = "A small space station in geostationary orbit acting as a logistics hub for facilities on the planet below or in orbit. \
			It is outfitted with a variety of habitaton modules, logistic container ports, as well as a fewed armoured modules mounted with point defence turrets."

/obj/effect/overmap/scannable_prop/ee_ap_patrol
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "himeo_patrol"
	color = "#777700"

	name = "EEPMV Fast Neutron"
	designer = "Einstein Engines"
	weapons = "4x Guided Drone Launchers; 2x 50MW 3mm Long-range Coilgun; 8x 20mm Ballistic Point Defence Cannons; 2x 200MW Decoy Blast Launcher"
	sizeclass = "Becquerel-class Drone Carrier"
	shiptype = "Corporate Asset Protection"
	alignment = "Einstein Engines"

	desc = "A EE asset protection drone carrier, brimming with fly-by-wire drone launchers and long-range coilguns. The design sees use in a variety of roles, from orbital defence to escorts. \
			It's high delta-V drones are capable of creating interception windows with vessels across entire systems, and so it relies on engaging from a distance. It would be unwise to test its capabilities."

/obj/effect/overmap/scannable_prop/colonist_mothership
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "freighter_large"
	color = "#FFAC1C"

	name = "ICV tbd"
	designer = "Hephaestus Industries"
	weapons = "2x Large Mining Blaster"
	sizeclass = "Shepherd-class Class II Vessel"
	shiptype = "Civilian Exploration"
	alignment = "Independent"

	desc = "A medium-sized exploration vessel manufacted by Hephaestus Industries. \
	It is highly modular, fitted with cargo containers, a simple and low-tech sensors array, and a few mining drone bays."
