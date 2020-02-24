//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

datum/track
	var/title
	var/sound

datum/track/New(var/title_name, var/audio)
	title = title_name
	sound = audio

/obj/machinery/media/jukebox/
	name = "space jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = 0
	density = 1
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	clicksound = 'sound/machines/buttonbeep.ogg'

	var/playing = 0

	var/datum/track/current_track
	var/list/datum/track/tracks = list(
		new/datum/track("Beyond", 'sound/ambience/ambispace.ogg'),
		new/datum/track("Clouds of Fire", 'sound/music/clouds.s3m'),
		new/datum/track("D`Bert", 'sound/music/title2.ogg'),
		new/datum/track("D`Fort", 'sound/ambience/song_game.ogg'),
		new/datum/track("Floating", 'sound/music/main.ogg'),
		new/datum/track("Endless Space", 'sound/music/space.ogg'),
		new/datum/track("Part A", 'sound/misc/TestLoop1.ogg'),
		new/datum/track("Scratch", 'sound/music/title1.ogg'),
		new/datum/track("Trai`Tor", 'sound/music/traitor.ogg'),
		new/datum/track("Thunderdome", 'sound/music/THUNDERDOME.ogg'),
		new/datum/track("Space Oddity", 'sound/music/space_oddity.ogg'),
		new/datum/track("Space Asshole", 'sound/music/space_asshole.ogg'),
		new/datum/track("Velvet Rose", 'sound/music/Velvet-Rose.ogg')
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
					if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
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
	var/title = "RetroBox - Space Style"
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
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	visible_message("<span class='danger'>\the [src] blows apart!</span>")

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	spark(src, 3, alldirs)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/forensics))
		src.add_fingerprint(user)

	if(W.iswrench())
		if(playing)
			StopPlaying()
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		playsound(src.loc, W.usesound, 50, 1)
		power_change()
		update_icon()
		return
	return ..()

/obj/machinery/media/jukebox/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
		visible_message("<span class='danger'>\The [src] makes a fizzling sound.</span>")
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	var/area/main_area = get_area(src)
	// Always kill the current sound
	for(var/mob/living/M in mobs_in_area(main_area))
		M << sound(null, channel = 1)

		main_area.forced_ambience = null
	playing = 0
	update_use_power(1)
	update_icon()


/obj/machinery/media/jukebox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	var/area/main_area = get_area(src)
	main_area.forced_ambience = list(current_track.sound)
	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)

	playing = 1
	update_use_power(2)
	update_icon()

/obj/machinery/media/jukebox/phonograph
	name = "phonograph"
	desc = "Play that funky music..."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "record"
	state_base = "record"
	anchored = 0
	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/recordplayer/BooleanSisters.ogg'),
		new/datum/track("Posin'", 'sound/music/recordplayer/Posin.ogg'),
		new/datum/track("Jazz Instrumental", 'sound/music/recordplayer/JazzInstrumental.ogg'),
		new/datum/track("Le Swing", 'sound/music/recordplayer/LeSwing.ogg'),
		new/datum/track("Cosmorot", 'sound/music/recordplayer/Cosmorot.ogg')
	)

/obj/machinery/media/jukebox/phonograph/update_icon()
	cut_overlays()
	icon_state = state_base
	if(playing)
		add_overlay("[state_base]-running")