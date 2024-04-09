/datum/map_template/ruin/exoplanet/moghes_wasteland_bomb
	name = "Unexploded Nuclear Bomb"
	id = "moghes_wasteland_bomb"
	description = "An unexploded atomic bomb from the days of the Contact War"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	suffixes = list("moghes/moghes_wasteland_bomb.dmm")

/obj/structure/moghes_fakenuke
	name = "unexploded nuclear bomb"
	desc = "This bomb looks like it's been here for decades. You probably shouldn't touch it. Something is written in Sinta'Unathi on the side."
	icon = 'icons/obj/nuke.dmi' //replace this with something else if we sprite it
	icon_state = "greenlight"
	anchored = 1
	density = 1

/obj/structure/moghes_fakenuke/examine(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_UNATHI] in user.languages)
		to_chat(user, SPAN_NOTICE("The inscription reads: \"WARNING - FISSILE MATERIAL HANDLE WITH CARE.\" Underneath are a few words, scratched into the metal. They read \"If Found, Return To Darakath At High Velocity\""))
