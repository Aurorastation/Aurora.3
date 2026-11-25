#define SURVEY_TYPE_ATMOSPHERIC "atmospheric"
#define SURVEY_TYPE_GROUND "ground"
#define SURVEY_TYPE_GEOMAGNETIC "geomagnetic"

/obj/structure/survey_probe
	name = "atmosphere probe"
	desc = "\
		An atmospheric survey probe, able to provide preliminary analysis of the atmosphere and weather patterns of planetary bodies. \
		"
	desc_extended = "\
		It has different devices and samplers, as well as internal processing computers, \
		to inspect the atmosphere and other properties and qualities of planetary bodies. \
		Commonly used by surveyors, explorers, pioneers, all over the Spur, looking to determine the suitability of planets for settlement. "
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "surveying_probe"
	density = FALSE
	/// If false, probe is not deployed.
	/// If true, it is deployed and ready to survey.
	anchored = FALSE
	/// Timer of the survey process.
	/// If null, it is not currently surveying.
	var/timer_id = null
	/// The language that the report will output in.
	var/report_language
	/// Should this probe start deployed? Used for mapped-in probes
	var/start_deployed = FALSE
	///Extra information for variant types - manufacturer, faction, etc.
	var/desc_extra = "This probe was manufactured by Orion Express, but it is based on on older model designed by Hephaestus Industries."
	var/survey_type = SURVEY_TYPE_ATMOSPHERIC

/obj/structure/survey_probe/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The probe has to be deployed first before it is used: wrench it to deploy, then click with empty hand to activate."
	. += "When activated on an exoplanet, each probe type can record planetary survey data once per planet, producing a valuable research data disk."

/obj/structure/survey_probe/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += desc_extra
	if(survey_type == SURVEY_TYPE_ATMOSPHERIC)
		. += "When deployed, this probe will read and relay weather data to compatible devices."
	if(survey_type == SURVEY_TYPE_GROUND)
		. += "When deployed, this probe will read and relay seismic data to compatible devices."
	if(survey_type == SURVEY_TYPE_GEOMAGNETIC)
		. += "When deployed, this probe will read and relay geomagnetic data to compatible devices."

	var/obj/effect/overmap/visitable/sector/sector = get_map_sector(src)
	if(istype(sector))
		if(LAZYISIN(sector.surveyed_probe_types, survey_type))
			. += SPAN_NOTICE("The diagnostic display indicates [survey_type] survey data has already been recorded for [sector.name].")
		else
			. += SPAN_NOTICE("The diagnostic display indicates [sector.name] has uncollected [survey_type] survey data.")

/obj/structure/survey_probe/Initialize(mapload)
	. = ..()
	if(start_deployed)
		deploy()

/obj/structure/survey_probe/attackby(obj/item/attacking_item, mob/user, params)
	if(!timer_id && attacking_item.tool_behaviour == TOOL_WRENCH)
		if(!anchored)
			user.visible_message(
				SPAN_NOTICE("\The [user] unfastens the locking bolts on \the [src], deploying it."),
				SPAN_NOTICE("You unfasten the locking bolts on \the [src], and it deploys, lowering its devices and drill bits to the ground. It is ready to survey."),
				)
			attacking_item.play_tool_sound(user, 30)
			deploy()
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] fastens the locking bolts on \the [src], stowing it."),
				SPAN_NOTICE("You fasten the locking bolts \the [src], stowing it. It retracts its devices and drill bits."),
				)
			attacking_item.play_tool_sound(user, 30)
			undeploy()

/obj/structure/survey_probe/attack_hand(mob/user as mob)
	if(timer_id)
		to_chat(user, SPAN_NOTICE("\The [src] is active."))
		return

	if(anchored)
		user.visible_message(
			SPAN_NOTICE("\The [user] activates \the [src], starting the surveying process."),
			SPAN_NOTICE("You activate \the [src], starting the surveying process."),
			)
		timer_id = addtimer(CALLBACK(src, PROC_REF(survey_end)), 20 SECONDS)
		icon_state = "[initial(icon_state)]_active"
	else
		to_chat(user, SPAN_NOTICE("You try to activate \the [src], but it is not deployed yet."))

/obj/structure/survey_probe/proc/deploy()
	anchored = TRUE
	density = TRUE
	icon_state = "[initial(icon_state)]_deployed"
	if(survey_type == SURVEY_TYPE_ATMOSPHERIC)
		RegisterSignal(SSdcs, COMSIG_GLOB_Z_WEATHER_CHANGE, PROC_REF(relay_weather_change))
		addtimer(CALLBACK(src, PROC_REF(read_initial_weather)), 2 SECONDS)
		say("Initializing weather detection subsystem...", message_mods = list(SAY_MOD_VERB = "transmits"))

/// Reads the current weather status aloud when deployed on a planet with weather
/obj/structure/survey_probe/proc/read_initial_weather()
	var/turf/current_turf = get_turf(src)

	var/obj/abstract/weather_system/weather = current_turf.weather || SSweather.weather_by_z["[current_turf.z]"]
	if(!weather)
		say("No weather conditions detected.", message_mods = list(SAY_MOD_VERB = "transmits"))
		return

	var/singleton/state/weather/current_weather_state = weather.weather_system.current_state
	if(current_weather_state)
		say("Reading current weather conditions as \"[current_weather_state.name]\".", message_mods = list(SAY_MOD_VERB = "transmits"))

/obj/structure/survey_probe/proc/undeploy()
	anchored = FALSE
	density = FALSE
	icon_state = initial(icon_state)
	if(survey_type == SURVEY_TYPE_ATMOSPHERIC)
		UnregisterSignal(SSdcs, COMSIG_GLOB_Z_WEATHER_CHANGE)

/// When a weather transition (see weather_fsm.dm) starts on this z_level, this will speak it aloud, and then broadcast it to any other devices listening to the broadcast global signal
/obj/structure/survey_probe/proc/relay_weather_change(var/datum/source, var/z_level, var/singleton/state_transition/weather/weather_transition, var/time_to_transition)
	SIGNAL_HANDLER

	var/turf/current_turf = get_turf(src)
	var/list/connected_z_levels = GetConnectedZlevels(current_turf.z)
	if(!(z_level in connected_z_levels))
		return

	var/singleton/state/weather/expected_weather_state = weather_transition.target
	var/broadcast_message = "Expecting shift to new weather condition, \"[expected_weather_state.name]\", in approximately [DisplayTimeText(time_to_transition)]."
	say(broadcast_message, message_mods = list(SAY_MOD_VERB = "transmits"))

	// received the message, now broadcast it to receivers
	// also send over other data, so unique receivers can have their own handling
	// think of it as the probe sending not just a radio message, but a broad band of data
	// yes, this does mean repeated messages if multiple atmospheric probes are set up
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_Z_WEATHER_BROADCAST, z_level, weather_transition, time_to_transition, broadcast_message)

/obj/structure/survey_probe/proc/survey_end()
	if(timer_id)
		// message
		src.visible_message(
			SPAN_NOTICE("\The [src] finishes the surveying process, and prints out a report."),
			visible_message_flags = LOCAL_MESSAGE,
			)

		// turf
		var/turf/turf = get_turf(src)
		var/turf_is_exoplanet = istype(turf, /turf/simulated/floor/exoplanet)
		var/turf_is_asteroid = istype(turf, /turf/simulated/floor/exoplanet/asteroid)

		// report vars and default vals
		var/report_location = get_location()
		var/report = get_report(turf, turf_is_exoplanet, turf_is_asteroid)

		// report text
		var/timestamp = "[GLOB.game_year]-[time2text(world.realtime, "MM-DD")] [worldtime2text()]"
		var/report_name = "[survey_type] survey report - [report_location]"
		var/report_contents = "\
			<br><large><b>Survey target: </b>[report_location]</large>\
			<br><b>Timestamp of survey: </b>[timestamp]\
			<br><b>Signature of surveyor: </b><span class=\"paper_field\"></span>\
			<br><br>\
			<br>[report]\
			<br><br>\
			<br><b>Additional notes: </b><span class=\"paper_field\"></span>\
			<br><span class=\"paper_field\"></span>\
			<br><br>"
		// Translate to a specific written language
		if(report_language)
			var/datum/language/L = GLOB.all_languages[report_language]
			if(L && L.written_style)
				var/languagetext = "\[lang=[L.key]]"
				languagetext += "[report_contents]\[/lang]"
				report_contents = languagetext

		// print the report
		playsound(get_turf(src), 'sound/machines/dotprinter.ogg', 30, 1)
		new /obj/item/paper/(get_turf(src), report_contents, report_name)

		// planetary survey data disk handling
		var/obj/effect/overmap/visitable/sector/sector = get_map_sector(src)
		var/disk_ejected = FALSE
		if(can_survey_planet(turf, turf_is_exoplanet, turf_is_asteroid, sector))
			if(!LAZYISIN(sector.surveyed_probe_types, survey_type))
				LAZYADD(sector.surveyed_probe_types, survey_type)
				give_survey_disk(get_turf(src), sector, report)
				disk_ejected = TRUE
				playsound(get_turf(src), 'sound/machines/ping.ogg', 30, 1)
			else
				visible_message(SPAN_NOTICE("\The [src] reports that [survey_type] survey data for [sector.name] has already been logged."))
		else if(istype(sector, /obj/effect/overmap/visitable/sector/exoplanet) && survey_type == SURVEY_TYPE_GROUND)
			visible_message(SPAN_WARNING("\The [src] was unable to penetrate the ground to collect planetary survey data."))

		if(disk_ejected)
			src.visible_message(
				SPAN_NOTICE("\The [src] finishes the surveying process, prints out a report, and ejects a planetary survey data disk."),
			)
		else
			src.visible_message(
				SPAN_NOTICE("\The [src] finishes the surveying process, and prints out a report."),
			)

		// fin
		timer_id = null
		icon_state = "[initial(icon_state)]_deployed"

/obj/structure/survey_probe/proc/can_survey_planet(turf/T, is_exoplanet, is_asteroid, obj/effect/overmap/visitable/sector/sector)
	if(!istype(sector))
		return FALSE
	if(!istype(sector, /obj/effect/overmap/visitable/sector/exoplanet) && !is_exoplanet && !is_asteroid)
		return FALSE
	return TRUE

/obj/structure/survey_probe/proc/give_survey_disk(turf/T, obj/effect/overmap/visitable/sector/sector, report_contents)
	return new /obj/item/disk/survey_data(T, sector, survey_type, report_contents)

/obj/structure/survey_probe/proc/get_report(var/turf/T, var/is_exoplanet, var/is_asteroid)
	. = "<b>Atmospheric survey results:</b>"
	var/datum/gas_mixture/air = T.return_air()
	if(air && air.total_moles>0)
		. += "<br><small>[english_list(atmosanalyzer_scan(T, air))]</small>"
		if((is_exoplanet || is_asteroid) && SSatlas.current_map.use_overmap)
			var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = get_map_sector(src)
			if(istype(exoplanet))
				. += "<br><b>Apparent Weather Data: </b>[exoplanet.weather]"
			else
				. += "<br>No local weather patterns detected"
		else
			. += "<br>No atmospheric data available"
	else
		. += "<br>No atmosphere detected"

/obj/structure/survey_probe/proc/get_location()
	var/obj/effect/overmap/visitable/sector/sector = get_map_sector(src)
	if(istype(sector))
		return sector.name
	return "Unknown location"

// Language-specific probe versions for mapping.
/obj/structure/survey_probe/sol
	desc_extra = "This probe is an older model, manufactured by Hephaestus Industries. A small emblem on the side bears the flag of the Solarian Alliance."
	report_language = LANGUAGE_SOL_COMMON

/obj/structure/survey_probe/pra
	desc_extra = "This probe is manufactured by NanoTrasen, based on an older Hephaestus design. A small emblem on the side bears the flag of the People's Republic of Adhomai."
	report_language = LANGUAGE_SIIK_MAAS

/obj/structure/survey_probe/elyra
	desc_extra = "This probe is a newer model manufactured by the Elyra-based Elco corporation for phoron deposit survey. A small emblem on the side bears the flag of the Republic of Elyra."
	report_language = LANGUAGE_ELYRAN_STANDARD

/obj/structure/survey_probe/coc
	desc_extra = "This probe was manufactured by Orion Express, but it is based on on older model designed by Hephaestus Industries. A small emblem on the side bears the flag of the Coalition of Colonies."
	report_language = LANGUAGE_GUTTER

/obj/structure/survey_probe/hegemony
	desc_extra = "This probe is a newer model designed and manufactured by Hephaestus Industries. A small emblem on the side bears the flag of the Izweski Hegemony."
	report_language = LANGUAGE_UNATHI

/obj/structure/survey_probe/dominia
	desc_extra = "This probe is a newer model designed and manufactured by the Imperial Engineering and Shipbuilding Conglomerate, in collaboration with Zavodskoi Interstellar. A small emblem on the side bears the flag of the Empire of Dominia."
	report_language = LANGUAGE_TRADEBAND

/obj/structure/survey_probe/skrell
	desc_extra = "This probe is a newer model designed and manufactured by Tuz'qlip Researchers, in collaboration with Einstein Engines. A small emblem on the side bears the flag of the Nralakk Federation."
	report_language = LANGUAGE_SKRELLIAN

/obj/structure/survey_probe/ground
	name = "ground probe"
	desc = "\
		An ground survey probe, able to provide preliminary analysis of the surface of planetary bodies. \
		"
	desc_extended = "\
		It has different devices and drill bits, as well as internal processing computers, \
		to inspect the ground, soil and crust of planetary bodies. \
		Commonly used by surveyors, explorers, pioneers, all over the Spur, looking to determine the mineral value of planets for settlement. "

	icon_state = "ground_probe"
	survey_type = SURVEY_TYPE_GROUND

/obj/structure/survey_probe/ground/get_report(T, is_exoplanet, is_asteroid)
	// turf
	var/is_hard_floor = istype(T, /turf/simulated/floor/tiled)
	var/is_fake_grass = istype(T, /turf/simulated/floor/grass)

	. = "<b>Ground survey results:</b>"
	// not exoplanet turf
	if(is_hard_floor)
		. += "The probe cannot penetrate the hard metal floor."
	else if(is_fake_grass)
		. += "The probe detects soft soil, but it cannot penetrate the ground deep enough to get any meaningful data."
	else if(!(is_exoplanet || is_asteroid))
		. += "The probe cannot penetrate the ground deep enough to get any meaningful data."

	// survey from sector / exoplanet
	if((is_exoplanet || is_asteroid) && SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/sector = get_map_sector(src)
		var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = sector
		if(istype(sector))
			if(istype(exoplanet))
				. += "<br><b>Estimated Mass and Volume: </b>[exoplanet.massvolume]BSS(Biesels)"
				. += "<br><b>Surface Gravity: </b>[exoplanet.surfacegravity]Gs"
				. += "<br><b>Geological Variables: </b>[exoplanet.geology]"
				. += "<br><b>Surface Water Coverage: </b>[exoplanet.surfacewater]"
			if(sector.ground_survey_result)
				. += sector.ground_survey_result
		else
			. += "<br>No data available from ground analysis"

/obj/structure/survey_probe/ground/can_survey_planet(turf/T, is_exoplanet, is_asteroid, obj/effect/overmap/visitable/sector/sector)
	if(!..())
		return FALSE
	var/is_hard_floor = istype(T, /turf/simulated/floor/tiled)
	var/is_fake_grass = istype(T, /turf/simulated/floor/grass)
	if(is_hard_floor || is_fake_grass || !(is_exoplanet || is_asteroid))
		return FALSE
	return TRUE

/obj/structure/survey_probe/magnet
	name = "geomagnetic probe"
	desc = "\
		An geomagnetic survey probe, able to provide preliminary analysis of the magnetic field of planetary bodies. \
		"
	desc_extended = "\
		It has different devices and instruments bits, as well as internal processing computers, \
		to inspect the magnetic field and magnetosphere of planetary bodies. \
		Commonly used by surveyors, explorers, pioneers, all over the Spur, looking to determine the sefety and comfort of planets for settlement. "

	icon_state = "magnet_probe"
	survey_type = SURVEY_TYPE_GEOMAGNETIC

/obj/structure/survey_probe/magnet/get_report(T, is_exoplanet, is_asteroid)
	. = "<b>Geomagnetic survey results:</b>"
	// survey from sector / exoplanet
	if((is_exoplanet || is_asteroid) && SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/sector = get_map_sector(src)
		var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = sector
		if(istype(sector))
			if(istype(exoplanet))
				. += "<br><b>Magnetic Field Strength: </b>[exoplanet.magnet_strength]"
				. += "<br><b>True North/Magnetic North Differential: </b>[exoplanet.magnet_difference]"
				. += "<br><b>Detected Magnetosphere Particles: </b>[exoplanet.magnet_particles]"
				. += "<br><b>Planetary Cycle Period: </b>[exoplanet.day_length]"
			if(sector.magnet_survey_result)
				. += sector.magnet_survey_result
		else
			. += "<br>No data available from geomagnetic analysis"
	else
		. += "<br>No data available from geomagnetic analysis"

/*
 * Planetary Survey Data Disk
 */
/obj/item/disk/survey_data
	name = "planetary survey data disk"
	desc = "A high-capacity research data disk containing comprehensive planetary survey telemetry."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/planet_name = "Unknown"
	var/survey_type = ""
	var/survey_details = ""

/obj/item/disk/survey_data/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This disk contains valuable planetary survey data. It can be deconstructed in a destructive analyzer to gain research points, or sold via cargo export."

/obj/item/disk/survey_data/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(planet_name)
		. += "Target Planet: [planet_name]"
	if(survey_type)
		. += "Survey Category: [capitalize(survey_type)]"
	if(distance <= 1 && length(origin_tech))
		. += "Stored Research Disciplines:"
		for(var/tech_id in origin_tech)
			var/tname = CallTechName(tech_id) || tech_id
			. += " - [tname]: Level [origin_tech[tech_id]]"

/obj/item/disk/survey_data/Initialize(mapload, obj/effect/overmap/visitable/sector/sector, survey_category, report_text)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

	if(istype(sector))
		planet_name = sector.name
	if(survey_category)
		survey_type = survey_category
	if(report_text)
		survey_details = report_text

	setup_survey_data(sector)

/obj/item/disk/survey_data/proc/setup_survey_data(obj/effect/overmap/visitable/sector/sector)
	var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = sector
	var/is_exo = istype(exoplanet)

	switch(survey_type)
		if(SURVEY_TYPE_ATMOSPHERIC)
			icon_state = "datadisk0"
			name = "planetary survey data - '[planet_name]' (Atmosphere)"
			desc = "A high-capacity research data disk storing atmospheric, climate, and meteorological survey data from [planet_name]."
			origin_tech = list(
				TECH_BIO = 4,
				TECH_DATA = 3,
				TECH_ENGINEERING = 3,
			)
			if(is_exo)
				if(exoplanet.atmosphere && exoplanet.atmosphere.gas[GAS_PHORON] >= 0.1)
					origin_tech[TECH_PHORON] = 3
				if(exoplanet.weather && exoplanet.weather != "No substantial meteorological readings")
					origin_tech[TECH_DATA] = 4

		if(SURVEY_TYPE_GROUND)
			icon_state = "datadisk2"
			name = "planetary survey data - '[planet_name]' (Ground)"
			desc = "A high-capacity research data disk storing geological, seismic, and mineralogical survey data from [planet_name]."
			origin_tech = list(
				TECH_MATERIAL = 4,
				TECH_ENGINEERING = 3,
				TECH_DATA = 3,
			)
			if(is_exo)
				if(istype(exoplanet, /obj/effect/overmap/visitable/sector/exoplanet/crystal) || istype(exoplanet, /obj/effect/overmap/visitable/sector/exoplanet/barren) || istype(exoplanet, /obj/effect/overmap/visitable/sector/exoplanet/lava))
					origin_tech[TECH_MATERIAL] = 5
				if(sector.ground_survey_result && (findtext(sector.ground_survey_result, "fissile") || findtext(sector.ground_survey_result, "fusile")))
					origin_tech[TECH_POWER] = 3

		if(SURVEY_TYPE_GEOMAGNETIC)
			icon_state = "datadisk1"
			name = "planetary survey data - '[planet_name]' (Geomagnetic)"
			desc = "A high-capacity research data disk storing geomagnetic, magnetospheric, and radiation survey data from [planet_name]."
			origin_tech = list(
				TECH_MAGNET = 4,
				TECH_POWER = 3,
				TECH_DATA = 3,
			)
			if(is_exo)
				if(sector.magnet_survey_result && (findtext(sector.magnet_survey_result, "Major energy flux") || findtext(sector.magnet_survey_result, "ferromagnetic") || findtext(sector.magnet_survey_result, "Magnetic resonance")))
					origin_tech[TECH_MAGNET] = 5
					origin_tech[TECH_POWER] = 4
		else
			name = "planetary survey data - '[planet_name]'"
			origin_tech = list(TECH_DATA = 3)

/obj/item/disk/survey_data/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("<b>[name]</b>"))
	to_chat(user, SPAN_NOTICE("Target Sector: [planet_name]"))
	to_chat(user, SPAN_NOTICE("Survey Category: [survey_type ? capitalize(survey_type) : "General"]"))
	if(length(origin_tech))
		var/list/tech_names = list()
		for(var/tech_id in origin_tech)
			var/tname = CallTechName(tech_id) || tech_id
			tech_names += "[tname] (Level [origin_tech[tech_id]])"
		to_chat(user, SPAN_NOTICE("Stored Research Potential: [english_list(tech_names)]."))

#undef SURVEY_TYPE_ATMOSPHERIC
#undef SURVEY_TYPE_GROUND
#undef SURVEY_TYPE_GEOMAGNETIC
