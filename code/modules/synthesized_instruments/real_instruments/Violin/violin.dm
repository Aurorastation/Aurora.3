/datum/sound_player/violin
	volume = 25
	range = 10 //Kinda don't want this horrible thing to be heard from far away

// This is based on an obsolete violin implementation, but we don't have anything better to use
/obj/item/device/synthesized_instrument/violin
	name = "violin"
	desc = "A wooden musical instrument with four strings and a bow, it is quite old"
	icon_state = "violin"
	sound_player = /datum/sound_player/violin
	path = /datum/instrument/obsolete/violin

/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !(src && in_range(src, user))