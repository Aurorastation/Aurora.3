/obj/machinery/media/jukebox
	name = "jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox-nopower"
	var/state_base = "jukebox"
	anchored = 0
	density = 1
	power_channel = AREA_USAGE_EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	clicksound = 'sound/machines/buttonbeep.ogg'
	/// Cooldown between "Error" sound effects being played
	COOLDOWN_DECLARE(jukebox_error_cd)
	/// Cooldown between being allowed to play another song
	COOLDOWN_DECLARE(jukebox_song_cd)
	/// TimerID to when the current song ends
	var/song_timerid
	/// The actual music player datum that handles the music
	var/datum/jukebox/music_player

/obj/machinery/media/jukebox/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(music_player.active_song_sound)
		. += "Now playing: [music_player.selection.song_name]"

// Your classic 50s diner-style jukebox.
/obj/machinery/media/jukebox/classic
	name = "jukebox"
	desc = "A classic music player."

/obj/machinery/media/jukebox/classic/Initialize(mapload)
	. = ..(mapload)
	var/starting_cartridges = list()
	starting_cartridges += new/obj/item/music_cartridge/ss13
	music_player = new(src, parent_cartridges = starting_cartridges, parent_max_cartridges = 3, parent_locked = TRUE)

/obj/machinery/media/jukebox/classic/update_icon()
	ClearOverlays()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(!isnull(song_timerid))
		if(emagged)
			AddOverlays("[state_base]-emagged")
		else
			AddOverlays("[state_base]-running")

// Old-timey phonograph.
/obj/machinery/media/jukebox/phonograph
	name = "phonograph"
	desc = "Play that funky music..."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "record"
	state_base = "record"
	anchored = 0

/obj/machinery/media/jukebox/phonograph/Initialize(mapload)
	. = ..(mapload)
	var/starting_cartridges = list()
	starting_cartridges += new/obj/item/music_cartridge/adhomai_swing
	music_player = new(src, parent_cartridges = starting_cartridges, parent_max_cartridges = 1, parent_locked = TRUE)

/obj/machinery/media/jukebox/phonograph/update_icon()
	ClearOverlays()
	icon_state = state_base
	if(!isnull(song_timerid))
		AddOverlays("[state_base]-running")

/obj/machinery/media/jukebox/audioconsole
	name = "audioconsole"
	desc = "An Idris-designed jukebox for the 25th century. Unfortunately, someone made a mistake setting this one up. It isn't connected to the extranet and only plays the demo music it was pre-programmed with."
	icon = 'icons/obj/audioconsole.dmi'
	icon_state = "audioconsole-nopower"
	state_base = "audioconsole"
	anchored = FALSE

/obj/machinery/media/jukebox/audioconsole/Initialize(mapload)
	. = ..(mapload)
	var/starting_cartridges = list()
	starting_cartridges += new/obj/item/music_cartridge/audioconsole
	music_player = new(src, parent_cartridges = starting_cartridges, parent_max_cartridges = 3)

/obj/machinery/media/jukebox/audioconsole/update_icon()
	ClearOverlays()
	icon_state = state_base
	if(!isnull(song_timerid))
		AddOverlays("[state_base]-running")

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


/obj/machinery/media/jukebox/gramophone/Initialize(mapload)
	. = ..(mapload)
	var/starting_cartridges = list()
	starting_cartridges += new/obj/item/music_cartridge/adhomai_swing
	music_player = new(src, parent_cartridges = starting_cartridges,  parent_max_cartridges = 1, parent_locked = TRUE)

/obj/machinery/media/jukebox/gramophone/update_icon()
	ClearOverlays()
	icon_state = state_base
	if(!isnull(song_timerid))
		AddOverlays("[state_base]-running")

/obj/machinery/media/jukebox/calliope
	name = "calliope"
	desc = "A steam powered music instrument. This one is painted in bright colors."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "calliope"
	state_base = "calliope"
	anchored = FALSE

/obj/machinery/media/jukebox/calliope/Initialize(mapload)
	. = ..(mapload)
	var/starting_cartridges = list()
	starting_cartridges += new/obj/item/music_cartridge/adhomai_swing
	music_player = new(src, parent_cartridges = starting_cartridges, parent_max_cartridges = 2)

/obj/machinery/media/jukebox/calliope/update_icon()
	return

/obj/machinery/media/jukebox/power_change()
	..()
	if(!anchored)
		stat &= ~NOPOWER

	if(stat & (NOPOWER|BROKEN) && !isnull(song_timerid))
		stop_music()
	update_icon()

/obj/machinery/media/jukebox/Destroy()
	stop_music()
	QDEL_NULL(music_player)
	return ..()

/obj/machinery/media/jukebox/attack_hand(mob/user as mob)
	if(!anchored)
		to_chat(usr, SPAN_WARNING("You must secure \the [src] first."))
		return

	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	ui_interact(user)

/obj/machinery/media/jukebox/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)

	if(attacking_item.iswrench())
		if(music_player.active_song_sound)
			stop_music()
		user.visible_message(SPAN_WARNING("[user] has [anchored ? "un" : ""]secured \the [src]."), "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].")
		anchored = !anchored
		attacking_item.play_tool_sound(get_turf(src), 50)
		power_change()
		update_icon()
		return TRUE

	// Inserting cartridges into the machine.
	if(anchored && istype(attacking_item, /obj/item/music_cartridge))
		music_player.load_cartridge(attacking_item, user)

	else
		return ..()

/obj/machinery/media/jukebox/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		return ..()
	if(!anchored)
		balloon_alert(user, "must be anchored!")
		return UI_CLOSE
	if(!allowed(user))
		balloon_alert(user, "access denied!")
		return UI_CLOSE
	if(!length(music_player.playlist))
		to_chat(user,SPAN_WARNING("Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue."))
		return UI_CLOSE
	return ..()

/obj/machinery/media/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/machinery/media/jukebox/ui_data(mob/user)
	return music_player.get_ui_data()

/obj/machinery/media/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("toggle")
			toggle_playing(user)
			return TRUE

		if("select_track")
			if(!isnull(music_player.active_song_sound))
				to_chat(user, SPAN_WARNING("Error: You cannot change the song until the current one is over."))
				return TRUE

			var/datum/track/new_song = music_player.playlist[params["track"]]
			if(QDELETED(src))
				return TRUE

			music_player.selection = new_song
			return TRUE

		if("set_volume")
			var/new_volume = params["volume"]
			if(new_volume == "reset" || new_volume == "max")
				music_player.set_volume_to_max()
			else if(new_volume == "min")
				music_player.set_new_volume(0)
			else if(isnum(text2num(new_volume)))
				music_player.set_new_volume(text2num(new_volume))
			return TRUE

		if("loop")
			music_player.sound_loops = !!params["looping"]
			return TRUE

///If a song is playing, cut it. If none is playing, and the cooldown is up, start the queued track.
/obj/machinery/media/jukebox/proc/toggle_playing(mob/user)
	if(!isnull(music_player.active_song_sound))
		stop_music()
		return
	if(COOLDOWN_FINISHED(src, jukebox_song_cd))
		activate_music()
		return
	balloon_alert(user, "on cooldown for [DisplayTimeText(COOLDOWN_TIMELEFT(src, jukebox_song_cd))]!")
	if(COOLDOWN_FINISHED(src, jukebox_error_cd))
		COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)

/obj/machinery/media/jukebox/proc/activate_music()
	if(!isnull(music_player.active_song_sound))
		return FALSE

	music_player.start_music()
	if(!music_player.sound_loops)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(stop_music)), music_player.selection.song_length, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)
	return TRUE

/obj/machinery/media/jukebox/proc/stop_music()
	if(!isnull(song_timerid))
		deltimer(song_timerid)

	music_player.unlisten_all()

	return TRUE

/obj/machinery/media/jukebox/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	visible_message(SPAN_DANGER("\the [src] blows apart!"))

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	spark(src, 3, GLOB.alldirs)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)
