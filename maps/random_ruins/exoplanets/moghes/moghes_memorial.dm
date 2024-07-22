/datum/map_template/ruin/exoplanet/moghes_memorial
	name = "Contact War Memorial"
	id = "moghes_memorial"
	description = "A memorial site, commemorating the lives lost during the Contact War."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_memorial.dmm"

	unit_test_groups = list(2)

/obj/structure/sign/moghes_memorial
	name = "Contact War memorial"
	desc = "A stone monolith, engraved with the names of Unathi who perished in the Contact War. There are thousands of names upon this stone alone."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "contact_war_memorial"
	density = TRUE
	anchored = TRUE
	pixel_x = -16
	layer = ABOVE_HUMAN_LAYER

/obj/structure/sign/moghes_memorial/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_UNATHI] in user.languages)
		to_chat(user, SPAN_NOTICE("The inscription on the monolith reads as follows: \"This is the fifteen thousand six hundred and eighty-sixth monument erected by the Keepers of Heirlooms, \
		to honor those who perished in the fires of the Contact War. May we remember them, and may we learn the lessons of such a tragedy well, that it might never be repeated.\""))
