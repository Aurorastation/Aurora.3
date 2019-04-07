datum/track/New(var/title_name, var/audio)
	title = title_name
	sound = audio

/obj/machinery/media/phonograph
	name = "phonograph"
	desc = "Play that funky music..."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "record"
	var/state_base = "record"
	anchored = 0
	density = 1
	use_power = 0

	var/playing = 0

	var/datum/track/current_track
	var/list/datum/track/tracks = list(
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


/obj/machinery/media/phonograph/Destroy()
	StopPlaying()
	return ..()

/obj/machinery/media/phonograph/Topic(href, href_list, var/mob/user)
	if(..() || !(Adjacent(usr) || istype(usr, /mob/living/silicon)))
		return

	if(!anchored)
		to_chat(usr, "<span class='warning'>You must secure \the [src] first.</span>")
		return

	if(href_list["change_track"])
		for(var/datum/track/T in tracks)
			if(T.title == href_list["title"])
				current_track = T
				StartPlaying()
				break
	else if(href_list["stop"])
		StopPlaying()
	else if(href_list["play"])
		if(current_track == null)
			to_chat(usr, "No track selected.")
		else
			to_chat(usr, "<span class='warning'>You start cranking \the [src].</span>")
			visible_message("\The [user] starts cranking \the [src].")
			if(do_after(user, 20))
				StartPlaying()

	return 1

/obj/machinery/media/phonograph/interact(mob/user)
	if(stat & (!anchored|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	ui_interact(user)

/obj/machinery/media/phonograph/ui_interact(mob/user, ui_key = "phonograph", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data[0]

	if(!(stat & (!anchored|BROKEN)))
		data["current_track"] = current_track != null ? current_track.title : ""
		data["playing"] = playing

		var/list/nano_tracks = new
		for(var/datum/track/T in tracks)
			nano_tracks[++nano_tracks.len] = list("track" = T.title)

		data["tracks"] = nano_tracks

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/media/phonograph/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/media/phonograph/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/phonograph/proc/explode()
	walk_to(src,0)
	visible_message("<span class='danger'>\the [src] blows apart!</span>")

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	spark(src, 3, alldirs)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/phonograph/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(W.iswrench())
		if(playing)
			StopPlaying()
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		power_change()
		update_icon()
		return
	return ..()

/obj/machinery/media/phonograph/proc/StopPlaying()
	var/area/main_area = get_area(src)
	// Always kill the current sound
	for(var/mob/living/M in mobs_in_area(main_area))
		M << sound(null, channel = 1)

		main_area.forced_ambience = null
	playing = 0
	update_icon()


/obj/machinery/media/phonograph/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	var/area/main_area = get_area(src)
	main_area.forced_ambience = list(current_track.sound)
	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)

	playing = 1