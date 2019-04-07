/obj/machinery/media/jukebox/phonograph
	name = "phonograph"
	desc = "Play that funky music..."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "record"
	state_base = "record"
	tracks = list(
		new/datum/track("Catgroove", 'maps/adhomai/sound/catgroove.ogg'),
		new/datum/track("Lay Down", 'maps/adhomai/sound/laydown.ogg'),
		new/datum/track("Lone Digger", 'maps/adhomai/sound/lonedigger.ogg'),
		new/datum/track("Shoot Him Down", 'maps/adhomai/sound/shoothimdown.ogg'),
		new/datum/track("Midnight", 'maps/adhomai/sound/midnight.ogg'),
		new/datum/track("Black Betty", 'maps/adhomai/sound/blackbetty.ogg'),
		new/datum/track("Out Of My Mind", 'maps/adhomai/sound/outofmymind.ogg'),
		new/datum/track("Posin'", 'maps/adhomai/sound/posin.ogg'),
		new/datum/track("Everybody Wants To Be A Cat", 'maps/adhomai/sound/everybodywantstocat.ogg'),
		new/datum/track("Beatophone", 'maps/adhomai/sound/beatophone.ogg'),
		new/datum/track("The Same Song", 'maps/adhomai/sound/thesamesong.ogg')
	)

/obj/machinery/media/jukebox/phonograph/update_icon()
	return