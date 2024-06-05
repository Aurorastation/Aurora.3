/*

	Hull Surveyor

*/
/obj/item/device/hull_surveyor
	name = "hull surveyor"
	desc = "The Hephaestus 'Cronos' Hull Degradation Analysis Device is designed to be attached to the hull of wrecked ships or stations, using reconstructive modelling to estimate the time of incident."
	icon = 'icons/obj/item/tools/hull_analyser.dmi'
	icon_state = "hull_analyser"
	item_state = "hull_analyser"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL

/obj/item/device/hull_surveyor/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target, /turf/simulated/wall))
		var/obj/effect/overmap/visitable/sector/wreck = GLOB.map_sectors["[target.z]"]
		if(!wreck.is_wreck())
			to_chat(user, SPAN_NOTICE("\The [src] beeps as it fails to scan \the [target]. The structure is either not a wreck, or was wrecked too recently to analyse."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] begins scanning the hull of \the [wreck] with \the [src]."), SPAN_NOTICE("You begin scanning the hull of \the [wreck] with \the [src]."))
		if(do_after(user, rand(5,20) SECONDS))
			user.visible_message(SPAN_NOTICE("\The [user] finishes scanning the hull of \the [wreck]."), SPAN_NOTICE("You finish scanning the hull of \the [wreck]."))
			var/list/results = wreck.wreck_details
			var/report_name = "hull survey - [results[WRECK_NAME]]"
			var/report_contents = "\
			<br><large><b>Hull Survey of: </b>[results[WRECK_NAME]]</large>\
			<br><b>Timestamp of survey: </b>[GLOB.game_year]-[time2text(world.realtime, "MM-DD")] [worldtime2text()]\
			<br><b>Signature of surveyor: </b><span class=\"paper_field\"></span>\
			<br><br>\
			<br><b>Reconstructive Modelling Results:</b>\
			<br><small>[results[WRECK_AGE]]</small>\
			<br><br>\
			<br><b>Probable Damage Source(s):</b>\
			<br><small>[results[WRECK_DAMAGE]]</small>\
			<br><br>\
			<br><b>Additional notes: </b><span class=\"paper_field\"></span>\
			<br><span class=\"paper_field\"></span>\
			<br><br>"
			playsound(get_turf(src), 'sound/machines/dotprinter.ogg', 30, 1)
			new/obj/item/paper/(get_turf(src), report_contents, report_name)
