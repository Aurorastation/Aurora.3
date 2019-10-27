/obj/machinery/media/jukebox/djtable
	name = "\improper DJ table"
	desc = "Sick tunes, bro."
	icon = 'icons/obj/djtable.dmi'
	icon_state = "dj"
	state_base = "dj"
	anchored = 1
	can_be_unanchored = 1

	tracks = list(
		new/datum/track("BotNet", 'sound/music/halloween/AURORABotNet.ogg'),
		new/datum/track("Cantiloupe", 'sound/music/halloween/AURORACantiloupe.ogg'),
		new/datum/track("PhaseLocked", 'sound/music/halloween/AURORAPhaseLocked.ogg'),
		new/datum/track("Pursuit", 'sound/music/halloween/AURORAPursuit.ogg')
	)
	var/curr_state = "ff0000"
	var/possible_icons = list("ff0000", "ffff00", "00ff00", "00ffff", "0000ff", "800080")

/obj/machinery/media/jukebox/djtable/Initialize()
	. = ..()

/obj/machinery/media/jukebox/djtable/update_icon()
	icon_state = state_base
	if(playing)
		icon_state += "_[curr_state]"
		return
	set_light(FALSE)

/obj/machinery/media/jukebox/djtable/machinery_process()
	if(playing) // alternate between colors
		curr_state = pick(possible_icons - curr_state)
		set_light(rand()+2, 1/2 + rand()/2,"#[curr_state]")
		update_icon()