/datum/map_template/ruin/exoplanet/ouerea_rev_memorial
	name = "Ouerean Revolution Memorial"
	id = "ouerea_rev_memorial"
	description = "A memorial site, commemorating the blood spilled in the Ouerean Revolution, for the dream of a free Ouerea."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_rev_memorial.dmm"
	unit_test_groups = list(2)

/obj/structure/sign/ouerea_memorial
	name = "Ouerean Revolution memorial"
	desc = "A stone monolith, engraved with the names of revolutionaries who fell in the Ouerean. Revolution. Human, Skrell and Unathi names alike can be seen here."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "ouerea_memorial"
	density = TRUE
	anchored = TRUE
	pixel_x = -16
	layer = ABOVE_HUMAN_LAYER

/obj/structure/sign/ouerea_memorial/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_UNATHI] in user.languages)
		to_chat(user, SPAN_NOTICE("The inscription on the monolith reads as follows. \"Let this monument stand, to honor those of us who fought for a world free from the grasping claws of foreign masters. \
		To you who read these words, honor these dead and remember them, that their revolution may live on.\""))
	if(GLOB.all_languages[LANGUAGE_SKRELLIAN] in user.languages)
		to_chat(user, SPAN_NOTICE("There is a smaller inscription below the main one, in Nral'malic. It reads as follows. \"Mourn us not, we dead, for all that lives must surely die. Wherever our bodies rest, \
		know that there shines a golden star to welcome us home.\""))
