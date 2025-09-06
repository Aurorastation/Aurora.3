/obj/machinery/audioconsola
	name = "jukebox 2"
	desc = "A classic music player."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox-nopower"
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

/obj/machinery/audioconsola/Initialize(mapload)
	. = ..()
	music_player = new(src)

/obj/machinery/audioconsola/Destroy()
	stop_music()
	QDEL_NULL(music_player)
	return ..()

/obj/machinery/audioconsola/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(music_player.active_song_sound)
		. += "Now playing: [music_player.selection.song_name]"

/obj/machinery/audioconsola/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/audioconsola/attackby(obj/item/attacking_item, mob/user)
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
	return ..()

/obj/machinery/audioconsola/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		return ..()
	if(!anchored)
		balloon_alert(user, "must be anchored!")
		return UI_CLOSE
	if(!allowed(user))
		balloon_alert(user, "access denied!")
		return UI_CLOSE
	if(!length(music_player.songs))
		to_chat(user,SPAN_WARNING("Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue."))
		return UI_CLOSE
	return ..()

/obj/machinery/audioconsola/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/machinery/audioconsola/ui_data(mob/user)
	return music_player.get_ui_data()

/obj/machinery/audioconsola/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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

			var/datum/track/new_song = music_player.songs[params["track"]]
			if(QDELETED(src) || !istype(new_song, /datum/track))
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
/obj/machinery/audioconsola/proc/toggle_playing(mob/user)
	if(!isnull(music_player.active_song_sound))
		stop_music()
		return
	if(COOLDOWN_FINISHED(src, jukebox_song_cd))
		activate_music()
		return
	balloon_alert(user, "on cooldown for [DisplayTimeText(COOLDOWN_TIMELEFT(src, jukebox_song_cd))]!")
	if(COOLDOWN_FINISHED(src, jukebox_error_cd))
		COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)

/obj/machinery/audioconsola/proc/activate_music()
	if(!isnull(music_player.active_song_sound))
		return FALSE

	music_player.start_music()
	if(!music_player.sound_loops)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(stop_music)), music_player.selection.song_length, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)
	return TRUE

/obj/machinery/audioconsola/proc/stop_music()
	if(!isnull(song_timerid))
		deltimer(song_timerid)

	music_player.unlisten_all()

	return TRUE
