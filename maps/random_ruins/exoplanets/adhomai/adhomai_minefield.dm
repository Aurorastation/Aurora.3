/datum/map_template/ruin/exoplanet/adhomai_minefield
	name = "Adhomai Minefield"
	id = "adhomai_hunting"
	description = "A cruel and dangerous vestige of the previous wars."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_minefield.dmm")

/obj/structure/adhomai_minefield
	name = "siik'maas sign"
	desc = "A sign with something written in Siik'maas."
	icon = 'icons/obj/minefield.dmi'
	icon_state = "landmine_post"
	anchored = TRUE

/obj/structure/adhomai_minefield/examine(mob/user)
	. = ..()
	if(all_languages[LANGUAGE_SIIK_MAAS] in user.languages)
		to_chat(user, SPAN_WARNING("The sign says: \"WARNING: MINEFIELD\"."))
