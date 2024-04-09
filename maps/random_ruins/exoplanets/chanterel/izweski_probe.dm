/datum/map_template/ruin/exoplanet/izweski_probe
	name = "Izweski Probe"
	id = "izweski_probe"
	description = "An ancient Izweski Hegemony space probe."
	sectors = list(SECTOR_UUEOAESA)
	suffixes = list("chanterel/izweski_probe.dmm")
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

/obj/structure/survey_probe/hegemony
	name = "\improper Hegemony space probe"
	desc = "An unmanned probe, clearly a very old and unsophisticated design. The flag of the Izweski Hegemony is displayed on the side, and a fading screen displays a readout in Sinta'Unathi"
	desc_extended = "This model of survey probe seems to be very old. A plaque on the side bears some words in Sinta'Unathi beneath the seal of the Izweski Hegemony."
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "surveying_probe_deployed"

/obj/structure/survey_probe/hegemony/examine(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_UNATHI] in user.languages)
		to_chat(user, SPAN_NOTICE("The probe's plaque identifies it as property of the Izweski Hegemony Extraterrestrial Surveying Guild - a space exploration guild dissolved shortly following First Contact. The date displayed on the ancient screen would read as 2361 by the common human calendar."))

/obj/structure/survey_probe/hegemony/printout(var/report_contents, var/report_name)
	var/languagetext = "\[lang=o\]"
	languagetext += report_contents
	languagetext += "\[/lang]"
	playsound(get_turf(src), 'sound/machines/dotprinter.ogg', 30, 1)
	new/obj/item/paper/(get_turf(src), languagetext, report_name)
