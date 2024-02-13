/obj/structure/survey_probe
	name = "survey probe"
	desc = "\
		All-in-one survey probe, able to provide preliminary analysis of planetary bodies. \
		"
	desc_extended = "\
		It has different devices, samplers, and drill bits, as well as internal processing computers, \
		to inspect the atmosphere, ground, soil, crust, and many other properties and qualities of planetary bodies. \
		Commonly used by surveyors, explorers, pioneers, all over the Spur, looking for planets that are actually worth settling or exploiting for resources. \
		This probe was manufactured by Orion Express, but it is based on on older model designed by Hephaestus Industries.\
		"
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

/obj/structure/survey_probe/attackby(obj/item/item, mob/living/user)
	if(!timer_id && item.iswrench())
		if(!anchored)
			user.visible_message(
				SPAN_NOTICE("\The [user] unfastens the locking bolts on \the [src], deploying it."),
				SPAN_NOTICE("You unfasten the locking bolts on \the [src], and it deploys, lowering its devices and drill bits to the ground. It is ready to survey."),
				)
			item.play_tool_sound(user, 30)
			anchored = TRUE
			density = TRUE
			icon_state = "surveying_probe_deployed"
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] fastens the locking bolts on \the [src], stowing it."),
				SPAN_NOTICE("You fasten the locking bolts \the [src], stowing it. It retracts its devices and drill bits."),
				)
			item.play_tool_sound(user, 30)
			anchored = FALSE
			density = FALSE
			icon_state = "surveying_probe"

/obj/structure/survey_probe/attack_hand(mob/user as mob)
	if(timer_id)
		to_chat(user, SPAN_NOTICE("\The [src] is active, sampling the ground and atmosphere."))
		return

	if(anchored)
		user.visible_message(
			SPAN_NOTICE("\The [user] activates \the [src], starting the surveying process."),
			SPAN_NOTICE("You activate \the [src], starting the surveying process. It begins drilling into the ground and sampling the atmosphere."),
			)
		timer_id = addtimer(CALLBACK(src, PROC_REF(survey_end)), 20 SECONDS)
		icon_state = "surveying_probe_active"
	else
		to_chat(user, SPAN_NOTICE("You try to activate \the [src], but its devices and drill bits are not deployed yet."))

/obj/structure/survey_probe/proc/survey_end()
	if(timer_id)
		// message
		src.visible_message(
			SPAN_NOTICE("\The [src] finishes the surveying process, and prints out a report."),
			)

		// report vars and default vals
		var/report_location = "unknown/invalid"
		var/ground_report = "Invalid or insufficient data, ground survey unsuccessful. "
		var/atmos_report = "Invalid or insufficient data, atmospheric survey unsuccessful. "

		// turf
		var/turf/turf = get_turf(src)
		var/turf_is_exoplanet = istype(turf, /turf/simulated/floor/exoplanet)
		var/turf_is_asteroid = istype(turf, /turf/unsimulated/floor/asteroid)
		var/turf_is_hard_floor = istype(turf, /turf/simulated/floor/tiled)
		var/turf_is_fake_grass = istype(turf, /turf/simulated/floor/grass)

		// atmos
		var/datum/gas_mixture/air = turf.return_air()
		if(air.total_moles>0)
			atmos_report = english_list(atmosanalyzer_scan(turf, air))

		// not exoplanet turf
		if(turf_is_hard_floor)
			ground_report += "The probe cannot penetrate the hard metal floor."
		else if(turf_is_fake_grass)
			ground_report += "The probe detects soft soil, but it cannot penetrate the ground deep enough to get any meaningful data."
		else if(!(turf_is_exoplanet || turf_is_asteroid))
			ground_report += "The probe cannot penetrate the ground deep enough to get any meaningful data."

		// ground survey from sector / exoplanet
		if((turf_is_exoplanet || turf_is_asteroid) && SSatlas.current_map.use_overmap)
			var/obj/effect/overmap/visitable/sector/sector = GLOB.map_sectors["[z]"]
			var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = sector
			if(istype(sector))
				report_location = sector.name
				ground_report = ""
				if(istype(exoplanet))
					ground_report += "<b>Estimated Mass and Volume: </b>[exoplanet.massvolume]BSS(Biesels)"
					ground_report += "<br><b>Surface Gravity: </b>[exoplanet.surfacegravity]Gs"
					ground_report += "<br><b>Geological Variables: </b>[exoplanet.geology]"
					ground_report += "<br><b>Surface Water Coverage: </b>[exoplanet.surfacewater]"
					ground_report += "<br><b>Apparent Weather Data: </b>[exoplanet.weather]"
					ground_report += "<br>"
				if(sector.ground_survey_result)
					ground_report += sector.ground_survey_result

		// report text
		var/timestamp = "[GLOB.game_year]-[time2text(world.realtime, "MM-DD")] [worldtime2text()]"
		var/report_name = "surveying report - [report_location]"
		var/report_contents = "\
			<br><large><b>Survey target: </b>[report_location]</large>\
			<br><b>Timestamp of survey: </b>[timestamp]\
			<br><b>Signature of surveyor: </b><span class=\"paper_field\"></span>\
			<br><br>\
			<br><b>Ground survey results:</b>\
			<br><small>[ground_report]</small>\
			<br><br>\
			<br><b>Atmospheric survey results:</b>\
			<br><small>[atmos_report]</small>\
			<br><br>\
			<br><b>Additional notes: </b><span class=\"paper_field\"></span>\
			<br><span class=\"paper_field\"></span>\
			<br><br>\
		"

		// print the report
		playsound(get_turf(src), 'sound/machines/dotprinter.ogg', 30, 1)
		new/obj/item/paper/(get_turf(src), report_contents, report_name)

		// fin
		timer_id = null
		icon_state = "surveying_probe_deployed"

