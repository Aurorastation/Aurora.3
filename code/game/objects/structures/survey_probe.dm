/obj/structure/survey_probe
	name = "atmosphere probe"
	desc = "\
		An atmospheric survey probe, able to provide preliminary analysis of the atmosphere and weather patterns of planetary bodies. \
		"
	desc_extended = "\
		It has different devices and samplers, as well as internal processing computers, \
		to inspect the atmosphere and other properties and qualities of planetary bodies. \
		Commonly used by surveyors, explorers, pioneers, all over the Spur, looking to determine the suitability of planets for settlement. "
	desc_info = "\
		The probe has to be deployed first before it is used. Wrench it to deploy, then click with empty hand to activate.\
		"
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
	var/survey_type = "atmospheric"

/obj/structure/survey_probe/Initialize(mapload)
	. = ..()
	desc_extended += desc_extra
	if(start_deployed)
		deploy()

/obj/structure/survey_probe/attackby(obj/item/item, mob/living/user)
	if(!timer_id && item.iswrench())
		if(!anchored)
			user.visible_message(
				SPAN_NOTICE("\The [user] unfastens the locking bolts on \the [src], deploying it."),
				SPAN_NOTICE("You unfasten the locking bolts on \the [src], and it deploys, lowering its devices and drill bits to the ground. It is ready to survey."),
				)
			item.play_tool_sound(user, 30)
			deploy()
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] fastens the locking bolts on \the [src], stowing it."),
				SPAN_NOTICE("You fasten the locking bolts \the [src], stowing it. It retracts its devices and drill bits."),
				)
			item.play_tool_sound(user, 30)
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

/obj/structure/survey_probe/proc/undeploy()
	anchored = FALSE
	density = FALSE
	icon_state = initial(icon_state)

/obj/structure/survey_probe/proc/survey_end()
	if(timer_id)
		// message
		src.visible_message(
			SPAN_NOTICE("\The [src] finishes the surveying process, and prints out a report."),
			)

		// turf
		var/turf/turf = get_turf(src)
		var/turf_is_exoplanet = istype(turf, /turf/simulated/floor/exoplanet)
		var/turf_is_asteroid = istype(turf, /turf/unsimulated/floor/asteroid)

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

		// fin
		timer_id = null
		icon_state = "[initial(icon_state)]_deployed"

/obj/structure/survey_probe/proc/get_report(var/turf/T, var/is_exoplanet, var/is_asteroid)
	. = "<b>Atmospheric survey results:</b>"
	var/datum/gas_mixture/air = T.return_air()
	if(air && air.total_moles>0)
		. += "<br><small>[english_list(atmosanalyzer_scan(T, air))]</small>"
		if((is_exoplanet || is_asteroid) && SSatlas.current_map.use_overmap)
			var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = GLOB.map_sectors["[z]"]
			if(istype(exoplanet))
				. += "<br><b>Apparent Weather Data: </b>[exoplanet.weather]"
			else
				. += "<br>No local weather patterns detected"
		else
			. += "<br>No atmospheric data available"
	else
		. += "<br>No atmosphere detected"

/obj/structure/survey_probe/proc/get_location()
	var/obj/effect/overmap/visitable/sector/sector = GLOB.map_sectors["[z]"]
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
	desc_info = "\
		The probe has to be deployed first before it is used. Wrench it to deploy, then click with empty hand to activate."

	icon_state = "ground_probe"
	survey_type = "ground"

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
		var/obj/effect/overmap/visitable/sector/sector = GLOB.map_sectors["[z]"]
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

/obj/structure/survey_probe/magnet
	name = "geomagnetic probe"
	desc = "\
		An geomagnetic survey probe, able to provide preliminary analysis of the magnetic field of planetary bodies. \
		"
	desc_extended = "\
		It has different devices and instruments bits, as well as internal processing computers, \
		to inspect the magnetic field and magnetosphere of planetary bodies. \
		Commonly used by surveyors, explorers, pioneers, all over the Spur, looking to determine the sefety and comfort of planets for settlement. "
	desc_info = "\
		The probe has to be deployed first before it is used. Wrench it to deploy, then click with empty hand to activate."

	icon_state = "magnet_probe"
	survey_type = "geomagnetic"

/obj/structure/survey_probe/magnet/get_report(T, is_exoplanet, is_asteroid)
	. = "<b>Geomagnetic survey results:</b>"
	// survey from sector / exoplanet
	if((is_exoplanet || is_asteroid) && SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/sector = GLOB.map_sectors["[z]"]
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
