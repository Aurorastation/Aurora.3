/*
	Earphones that use our sound_player system to play sounds from a music cartridge to their wearer.

	Current Features:
	- All earphones have a cartridge slot. Cartridges can be inserted by clicking an earphone, and removed via an eject_music_cartridge() verb.
	- Inserting a cartridge will load a playlist containing /datum/tracks, where track names and sound files are loaded.
	- Shift+Clicking will Start/Stop a playlist, creating or deleting an active sound_player token.
	- Alt+Clicking with Pause/Unpause the current track, preserving an active sound_player token.
	- attack_self will eject the music cartridge. Ejecting a music cartridge also terminates the sound_player token.
	- Volume controllable via verb.

	Missing features i am too weak to figure out:
	- There is no auto—next song, and a user must manually use next_song() or previous_song() verbs to iterate through a playlist.
	- Part and parcel with no auto-next: Tracks automatically loop due to using the PlayLoopingSound() proc. Ideally, tracks should not loop.
	- There is no accomodation for user-uploaded sound files.
	- There are no UI implementations of earphone controls, which could be more user friendly.
*/

/obj/item/clothing/ears/earphones
	name = "earphones"
	desc = "A pair of wireless earphones. Includes a little slot for a music cartridge."
	desc_mechanics = "Shift+Click to Start/Stop a playlist. Alt+Click to Pause/Resume the current track. Click character to eject cartridge. Alternatively, use verbs."
	icon = 'icons/obj/clothing/ears/earmuffs.dmi'
	icon_state = "earphones"
	item_state = "earphones"
	slot_flags = SLOT_EARS
	contained_sprite = TRUE
	build_from_parts = TRUE
	/// List of music cartridges. For earphones, will generally only be a single entry.
	var/list/cartridges = list()
	/// Cooldown between "Error" sound effects being played
	COOLDOWN_DECLARE(jukebox_error_cd)
	/// Cooldown between being allowed to play another song
	COOLDOWN_DECLARE(jukebox_song_cd)
	/// TimerID to when the current song ends
	var/song_timerid
	/// The actual music player datum that handles the music
	var/datum/jukebox/music_player

/obj/item/clothing/ears/earphones/Initialize(mapload)
	. = ..(mapload)
	music_player = new(src, 0)

/obj/item/clothing/ears/earphones/Destroy()
	stop_music()
	QDEL_NULL(music_player)
	return ..()

/*
	Music Cartridge Procs:
*/

/obj/item/clothing/ears/earphones/verb/interface()
	set name = "Interface"
	set category = "Object.Earphones"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(ismob(src.loc))
		usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
		playsound(usr, /singleton/sound_category/button_sound, 10)

		ui_interact(usr)

/obj/item/clothing/ears/earphones/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		return ..()
	if(!length(music_player.playlist))
		to_chat(user,SPAN_WARNING("Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue."))
		return UI_CLOSE
	return ..()

/obj/item/clothing/ears/earphones/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/item/clothing/ears/earphones/ui_data(mob/user)
	return music_player.get_ui_data()

/obj/item/clothing/ears/earphones/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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
/obj/item/clothing/ears/earphones/proc/toggle_playing(mob/user)
	if(!isnull(music_player.active_song_sound))
		stop_music()
		return
	if(COOLDOWN_FINISHED(src, jukebox_song_cd))
		activate_music()
		return
	balloon_alert(user, "on cooldown for [DisplayTimeText(COOLDOWN_TIMELEFT(src, jukebox_song_cd))]!")
	if(COOLDOWN_FINISHED(src, jukebox_error_cd))
		COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)

/obj/item/clothing/ears/earphones/proc/activate_music()
	if(!isnull(music_player.active_song_sound))
		return FALSE

	music_player.start_music()
	if(!music_player.sound_loops)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(stop_music)), music_player.selection.song_length, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)
	return TRUE

/obj/item/clothing/ears/earphones/proc/stop_music()
	if(!isnull(song_timerid))
		deltimer(song_timerid)

	music_player.unlisten_all()

	return TRUE

/*
	Click Controls:

	Shift+Click to Pause/Unpause
	Alt+Click to Start/Stop



/obj/item/clothing/ears/earphones/AltClick(mob/user)
	pause_unpause()

/obj/item/clothing/ears/earphones/ShiftClick(mob/user)
	play_stop()


	Generic Earwear Procs
*/

/obj/item/clothing/ears/earphones/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_l_ear()
		M.update_inv_r_ear()

/*
Earphone Variants
*/

/obj/item/clothing/ears/earphones/headphones
	name = "headphones"
	desc = "A pair of headphones. Cushioned but not quite sound-cancelling. Includes a little slot for a music cartridge."
	desc_extended = "Unce unce unce unce."
	icon_state = "headphones"
	item_state = "headphones"

	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earphones/headphones/update_icon()
	..()
	AddOverlays(overlay_image(icon, "[icon_state]_overlay", flags=RESET_COLOR))

/obj/item/clothing/ears/earphones/earbuds
	name = "earbuds"
	desc = "A pair of wireless earbuds. Don't lose them. Includes a little slot for a music cartridge."
	icon_state = "earbuds"
	item_state = "earbuds"
