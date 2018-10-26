// Updated Jukebox Music aswell, All songs are used are in Fair Use and credit is due to all authors


datum/track

datum/track/New(var/title_name, var/audio)
	title = title_name
	sound = audio

/obj/item/device/boombox
	name = "TuneMaster 5000"
	desc = "A boombox, the annoyance of the jukebox in you're hands"
	icon = 'icons/obj/jukebox.dmi'
	anchored = 0
	icon_state = "boombox-nopower"
	item_state = "boombox"
	var/state_baseoff = "boombox-nopower"
	var/state_base = "boombox"


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
		new/datum/track("Don't Fear The Reaper", 'sound/music/reaper.ogg'),
		new/datum/track("War Time Jive", 'sound/music/jazzjive.ogg'),
		new/datum/track("Somebody To Love", 'sound/music/love.ogg'),
		new/datum/track("Hotel Cubano", 'sound/music/nicarguia.ogg'),
		new/datum/track("Aint I Right", 'sound/music/right.ogg'),
		new/datum/track("Silent Night", 'sound/music/silentnight.ogg'),
		new/datum/track("Mighty Wings", 'sound/music/wings.ogg'),
		new/datum/track("What A Thrill", 'sound/music/eater.ogg'),
		new/datum/track("Power Age", 'sound/music/powerage.ogg'),
		new/datum/track("Outcast", 'sound/music/garbage.ogg'),
		new/datum/track("Danger!", 'sound/music/danger.ogg'),
		new/datum/track("Thriller", 'sound/music/thrill.ogg'),
		new/datum/track("Hound Dog", 'sound/music/hound.ogg'),
		new/datum/track("Suspicious Minds", 'sound/music/minds.ogg'),
		new/datum/track("Long Tall Sally", 'sound/music/sally.ogg'),
		new/datum/track("Don't Worry Baby", 'sound/music/baby.ogg')
	)

/obj/item/device/boombox/Destroy()
	StopPlaying()
	return ..()


/obj/item/device/boombox/update_icon()
	cut_overlays()
	icon_state = state_base
	if(playing)

		add_overlay("[state_base]-running")

/obj/item/device/boombox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || istype(usr, /mob/living/silicon)))
		return

	if(!anchored)
		usr << "<span class='warning'>You must secure \the [src] first.</span>"
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
			usr << "No track selected."
		else
			StartPlaying()

	return 1

/obj/item/device/boombox/interact(mob/user)

	ui_interact(user)

/obj/item/device/boombox/ui_interact(mob/user, ui_key = "jukebox", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data[0]

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

/obj/item/device/boombox/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/item/device/boombox/attack_hand(mob/user as mob)
	if(anchored)
		usr << "<span class='warning'>You must un-secure \the [src] first.</span>"
		return
	..(user)

/obj/item/device/boombox/AltClick(var/mob/user as mob)

	if(!anchored)
		usr << "<span class='warning'>You must secure \the [src] first.</span>"
		return
	if(anchored)
		interact(user)

/obj/item/device/boombox/proc/explode()
	walk_to(src,0)
	visible_message("<span class='danger'>\the [src] blows apart!</span>")

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	spark(src, 3, alldirs)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/item/device/boombox/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

/obj/item/device/boombox/proc/StopPlaying()
	var/area/main_area = get_area(src)
	// Always kill the current sound
	for(var/mob/living/M in mobs_in_area(main_area))
		M << sound(null, channel = 1)

		main_area.forced_ambience = null
	playing = 0
	update_icon()


/obj/item/device/boombox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	var/area/main_area = get_area(src)
	main_area.forced_ambience = list(current_track.sound)
	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)

	playing = 1
	update_icon()

/obj/item/device/boombox/throw_impact(atom/hit_atom, var/speed)
	..()
	var/mob/M = thrower
	if(istype(M) && M.a_intent == I_HURT)
		walk_to(src,0)
		visible_message("<span class='danger'>\the [src] blows apart!</span>")
		spark(src, 3, alldirs)
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
		playsound(loc, 'sound/effects/djscratch.ogg', 50, 1)
		qdel(src)


/obj/item/device/boombox/verb/SettleBox()
	set src in oview(1)
	set category = "Object"
	set name = "Set Boombox Up"
	anchored = 1
	usr.visible_message("<span class='notice'>\the [src] is setup to play music now.</span>")
	


/obj/item/device/boombox/verb/Unsettle()
	set src in oview(1)
	set category = "Object"
	set name = "Pick Boombox Up"
	anchored = 0
	StopPlaying()
	usr.visible_message("<span class='notice'>\the [src] can now be carried.</span>")