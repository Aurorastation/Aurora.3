/datum/track
	var/title
	var/sound

/datum/track/New(var/title_name, var/audio)
	title = title_name
	sound = audio

/obj/machinery/media/jukebox
	name = "jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox-nopower"
	var/state_base = "jukebox"
	anchored = 0
	density = 1
	power_channel = EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	clicksound = 'sound/machines/buttonbeep.ogg'
	var/token = null

	var/playing = 0

	var/datum/track/current_track
	var/list/datum/track/tracks = list(
		new/datum/track("Beyond", 'sound/music/ambispace.ogg'),
		new/datum/track("Clouds of Fire", 'sound/music/lobby/clouds.s3m'),
		new/datum/track("D`Bert", 'sound/music/lobby/title2.ogg'),
		new/datum/track("D`Fort", 'sound/music/song_game.ogg'),
		new/datum/track("Floating", 'sound/music/main.ogg'),
		new/datum/track("Endless Space", 'sound/music/lobby/space.ogg'),
		new/datum/track("Scratch", 'sound/music/title1.ogg'),
		new/datum/track("Suspenseful", 'sound/music/lobby/traitor.ogg'),
		new/datum/track("Thunderdome", 'sound/music/THUNDERDOME.ogg'),
		new/datum/track("Velvet Rose", 'sound/music/velvet_rose.ogg')
	)


/obj/machinery/media/jukebox/Destroy()
	StopPlaying()
	return ..()

/obj/machinery/media/jukebox/power_change()
	..()
	if(!anchored)
		stat &= ~NOPOWER

	if(stat & (NOPOWER|BROKEN) && playing)
		StopPlaying()
	update_icon()

/obj/machinery/media/jukebox/update_icon()
	cut_overlays()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			add_overlay("[state_base]-emagged")
		else
			add_overlay("[state_base]-running")

/obj/machinery/media/jukebox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || istype(usr, /mob/living/silicon)))
		return

	if(!anchored)
		to_chat(usr, "<span class='warning'>You must secure \the [src] first.</span>")
		return

	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
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
		if(emagged)
			playsound(src.loc, 'sound/items/AirHorn.ogg', 100, 1)
			for(var/mob/living/carbon/M in ohearers(6, src))
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(H.get_hearing_protection() >= EAR_PROTECTION_MAJOR)
						continue
				M.sleeping = 0
				M.stuttering += 20
				M.ear_deaf += 30
				M.Weaken(3)
				if(prob(30))
					M.Stun(10)
					M.Paralyse(4)
				else
					M.make_jittery(500)
			spawn(15)
				explode()
		else if(current_track == null)
			to_chat(usr, "No track selected.")
		else
			StartPlaying()

	return 1

/obj/machinery/media/jukebox/interact(mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	ui_interact(user)

/obj/machinery/media/jukebox/ui_interact(mob/user, ui_key = "jukebox", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "Music Player"
	var/data[0]

	if(!(stat & (NOPOWER|BROKEN)))
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

/obj/machinery/media/jukebox/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	visible_message("<span class='danger'>\the [src] blows apart!</span>")

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	spark(src, 3, GLOB.alldirs)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)

	if(attacking_item.iswrench())
		if(playing)
			StopPlaying()
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		attacking_item.play_tool_sound(get_turf(src), 50)
		power_change()
		update_icon()
		return TRUE
	return ..()

/obj/machinery/media/jukebox/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
		visible_message("<span class='danger'>\The [src] makes a fizzling sound.</span>")
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	QDEL_NULL(token)

	playing = 0
	update_use_power(POWER_USE_IDLE)
	update_icon()


/obj/machinery/media/jukebox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	token = GLOB.sound_player.PlayLoopingSound(src, src, current_track.sound, 30, 7, 1, prefer_mute = TRUE, sound_type = ASFX_MUSIC)

	playing = 1
	update_use_power(POWER_USE_ACTIVE)
	update_icon()

/obj/machinery/media/jukebox/phonograph
	name = "phonograph"
	desc = "Play that funky music..."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "record"
	state_base = "record"
	anchored = 0
	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/phonograph/boolean_sisters.ogg'),
		new/datum/track("Electro Swing", 'sound/music/phonograph/electro_swing.ogg'),
		new/datum/track("Jazz Instrumental", 'sound/music/phonograph/jazz_instrumental.ogg'),
		new/datum/track("Le Swing", 'sound/music/phonograph/le_swing.ogg'),
		new/datum/track("Posin'", 'sound/music/phonograph/posin.ogg')
	)

/obj/machinery/media/jukebox/phonograph/update_icon()
	cut_overlays()
	icon_state = state_base
	if(playing)
		add_overlay("[state_base]-running")

/obj/machinery/media/jukebox/audioconsole
	name = "audioconsole"
	desc = "An Idris-designed jukebox for the 25th century. Unfortunately, someone made a mistake setting this one up. It isn't connected to the extranet and only plays the demo music it was pre-programmed with."
	icon = 'icons/obj/audioconsole.dmi'
	icon_state = "audioconsole-nopower"
	state_base = "audioconsole"
	anchored = FALSE
	tracks = list(
		new/datum/track("Butterflies", 'sound/music/audioconsole/Butterflies.ogg'),
		new/datum/track("That Ain't Chopin", 'sound/music/audioconsole/ThatAintChopin.ogg'),
		new/datum/track("Don't Rush", 'sound/music/audioconsole/DontRush.ogg'),
		new/datum/track("Phoron Will Make Us Rich", 'sound/music/audioconsole/PhoronWillMakeUsRich.ogg'),
		new/datum/track("Amsterdam", 'sound/music/audioconsole/Amsterdam.ogg'),
		new/datum/track("When", 'sound/music/audioconsole/When.ogg'),
		new/datum/track("Number 0", 'sound/music/audioconsole/Number0.ogg'),
		new/datum/track("The Pianist", 'sound/music/audioconsole/ThePianist.ogg'),
		new/datum/track("Lips", 'sound/music/audioconsole/Lips.ogg'),
		new/datum/track("Childhood", 'sound/music/audioconsole/Childhood.ogg')
	)

/obj/machinery/media/jukebox/audioconsole/update_icon()
	cut_overlays()
	icon_state = state_base
	if(playing)
		add_overlay("[state_base]-running")

/obj/machinery/media/jukebox/audioconsole/wall
	icon = 'icons/obj/audioconsole_wall.dmi'
	density = FALSE
	anchored = TRUE

/obj/machinery/media/jukebox/gramophone
	name = "gramophone"
	desc = "Play that vintage music!"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "gramophone"
	state_base = "gramophone"
	anchored = 0
	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/phonograph/boolean_sisters.ogg'),
		new/datum/track("Electro Swing", 'sound/music/phonograph/electro_swing.ogg'),
		new/datum/track("Jazz Instrumental", 'sound/music/phonograph/jazz_instrumental.ogg'),
		new/datum/track("Le Swing", 'sound/music/phonograph/le_swing.ogg'),
		new/datum/track("Posin'", 'sound/music/phonograph/posin.ogg')
	)

/obj/machinery/media/jukebox/gramophone/update_icon()
	cut_overlays()
	icon_state = state_base
	if(playing)
		add_overlay("[state_base]-running")
