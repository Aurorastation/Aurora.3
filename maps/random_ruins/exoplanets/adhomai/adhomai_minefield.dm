/datum/map_template/ruin/exoplanet/adhomai_minefield
	name = "Adhomai Minefield"
	id = "adhomai_hunting"
	description = "A cruel and dangerous vestige of the previous wars."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffix = "adhomai/adhomai_minefield.dmm"

/obj/structure/adhomai_minefield
	name = "siik'maas sign"
	desc = "A sign with something written in Siik'maas."
	icon = 'icons/obj/gravestone.dmi'
	icon_state = "wood"
	anchored = TRUE

/obj/structure/adhomai_minefield/examine(mob/user)
	. = ..()
	if(all_languages[LANGUAGE_SIIK_MAAS] in user.languages)
		to_chat(user, SPAN_WARNING("The sign says: \"WARNING! MINEFIELD!\"."))