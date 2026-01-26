/*
	Earphones that use our sound_player system to play sounds from a music cartridge to their wearer.

	Current Features:
	- All earphones have a cartridge slot. Cartridges can be inserted by clicking an earphone, and removed via an eject_music_cartridge() verb.
	- Inserting a cartridge will load a playlist containing /datum/tracks, where track names and sound files are loaded.
	- Alt+Clicking will Start/Stop a playlist, creating or deleting an active sound_player token.
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
	icon = 'icons/obj/clothing/ears/earmuffs.dmi'
	icon_state = "earphones"
	item_state = "earphones"
	slot_flags = SLOT_EARS
	contained_sprite = TRUE
	build_from_parts = TRUE

	/// The music cartridge loaded into the earphones. The source of which sound files to play.
	var/obj/item/music_cartridge/music_cartridge

	/// The active sound_token for the sound_player. Created per track and deleted when a song is stopped.
	var/datum/sound_token/soundplayer_token = null

	/// A list of /datum/tracks the earphones will iterate through to select sound files. /datum/tracks supplied by a music cartridge item.
	var/list/datum/track/current_playlist = list()

	/// For iterating through current_player() to select new sounds
	var/playlist_index = 1

	/// Volume. Affected by change_volume() proc/verb so users may control the volume.
	var/volume = 25

	/// Range. No use for this yet, but maybe someone will want to make a boombox or something that has a larger range.
	var/range = 0

	/// Is a track playing? For icon updates.
	var/playing = FALSE

	/// The current song's timer to play the next song.
	var/autoplay_timer

	/// How much time is left on the autoplay timer, for handling pausing/unpausing.
	var/autoplay_timeleft

/obj/item/clothing/ears/earphones/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Full controls can be found in the Verbs list, under <b>Object</b> tab -> <b>Earphones</b>."
	. += "ALT-click \the [src] to quickly Play/Stop the current track."
	. += "Use \the [src] while in-hand to eject the cartridge."

/obj/item/clothing/ears/earphones/Destroy()
	StopPlaying()
	QDEL_NULL(music_cartridge)
	. = ..()

/*
	Music Cartridge Procs:
*/

// Cartridge Insertion
/obj/item/clothing/ears/earphones/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/music_cartridge))
		if(attacking_item == user.get_active_hand())
			if(!music_cartridge) // Making sure there is no track in there already
				user.drop_from_inventory(attacking_item, src)
				music_cartridge = attacking_item
				read_music_cartridge(attacking_item, user) // This is where tracks will actually get loaded
				to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]"))
			else
				to_chat(user, SPAN_WARNING("There's already a music cartridge in there."))
				..()

/obj/item/clothing/ears/earphones/proc/read_music_cartridge(obj/item/music_cartridge/cartridge, mob/user)
	StopPlaying() // New cartridge in, so clean up our sound token if it hasn't already been for some reason

	playlist_index = 1 // Back to the beginning
	if(music_cartridge.tracks)
		for(var/datum/track/track in music_cartridge.tracks)
			current_playlist += track // Move all the tracks stored on the music_cartridge to our current_playlist

		to_chat(user, SPAN_NOTICE("Now listening to: [music_cartridge.name]."))

/obj/item/clothing/ears/earphones/proc/eject_music_cartridge(mob/user)
	if(!music_cartridge)
		to_chat(user,SPAN_WARNING("There is no music cartridge in \the [src]!"))
		return

	StopPlaying() // Stop & Clean Up
	current_playlist.Cut()
	user.put_in_hands(music_cartridge)
	music_cartridge = null

	to_chat(user,SPAN_NOTICE("You eject the music cartridge from \the [src]."))

/obj/item/clothing/ears/earphones/attack_self(mob/user)
	eject_music_cartridge(user)
	..()

/*
	Starting and Stopping Procs
*/

/obj/item/clothing/ears/earphones/proc/StopPlaying()
	if(!soundplayer_token)
		return

	soundplayer_token.Stop()
	QDEL_NULL(soundplayer_token) // A sound token is created per-song, so we'll be liberal with cleaning up old tokens.

	reset_autoplay_timer()


	// Icon/Overlay stuff for the music notes
	ClearOverlays()
	worn_overlay = null
	update_icon()
	update_clothing_icon()

/obj/item/clothing/ears/earphones/proc/StartPlaying(mob/user)
	if(!music_cartridge)
		to_chat(user, SPAN_WARNING("No cartridge loaded."))
		return

	// Make sure we aren't doubling up on soundtokens
	if(!soundplayer_token)
		if(current_playlist && (current_playlist.len > 0))
			var/sound/sound_to_play = current_playlist[playlist_index].song_path
			soundplayer_token = GLOB.sound_player.PlayNonloopingSound(src, src, sound_to_play, volume, range, 20, prefer_mute = FALSE, sound_type = ASFX_MUSIC)

			// Queue the next_song() proc when the current song ends. Clean up handled under next_song() which also calls stopplaying() to end this token
			autoplay_timeleft = current_playlist[playlist_index].song_length
			autoplay_timer = addtimer(CALLBACK(src, PROC_REF(next_song), user), autoplay_timeleft, TIMER_UNIQUE|TIMER_STOPPABLE)

			// Chat Display
			var/current_track_name = current_playlist[playlist_index].song_name
			var/current_track_length = current_playlist[playlist_index].song_length
			var/current_track_length_text = DisplayTimeText(current_track_length)
			to_chat(user,SPAN_NOTICE("Now Playing: Track [playlist_index] — '[current_track_name]' ([current_track_length_text])."))

			// Icon/Overlay stuff for the music notes
			worn_overlay = "music" // this is rather annoying but prevents the music notes on getting colored
			update_icon()
			update_clothing_icon()

/*
	Song Iteration Procs
*/

/obj/item/clothing/ears/earphones/proc/next_song(mob/user)
	if(use_check_and_message(user))
		return

	var/playlist_length = current_playlist.len
	if(!music_cartridge || !playlist_length)
		to_chat(user, SPAN_WARNING("No playlist loaded."))
		return

	StopPlaying() // Stop & Cleanup previous sound token

	// Sound iteration
	if(playlist_index + 1 <= playlist_length)
		playlist_index++
	else
		playlist_index = 1

	StartPlaying(user) // New sound token created here

/obj/item/clothing/ears/earphones/proc/previous_song(mob/user)
	if(use_check_and_message(usr))
		return

	var/playlist_length = current_playlist.len
	if(!music_cartridge || !playlist_length)
		to_chat(user, SPAN_WARNING("No playlist loaded."))
		return

	StopPlaying() // Stop & Cleanup previous sound token

	// Sound iteration
	if(playlist_index == 1)
		playlist_index = playlist_length
	else
		playlist_index--

	StartPlaying(user) // New sound token created here

/**
 * Saves the current timer's timeleft as autoplay_timeleft before deleting and nulling the timer.
 */
/obj/item/clothing/ears/earphones/proc/reset_autoplay_timer()
	if(autoplay_timer)
		autoplay_timeleft = timeleft(autoplay_timer)
		deltimer(autoplay_timer)
		autoplay_timer = null
		return TRUE
	return FALSE

/*
	Verbs:

	play_stop()
	change_volume()
	pause_unpause()
	next_song()
	previous_song()

*/

/obj/item/clothing/ears/earphones/verb/play_stop()
	set name = "Play/Stop"
	set category = "Object.Earphones"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(ismob(src.loc))
		usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
		playsound(usr, SFX_BUTTON, 10)

		if(soundplayer_token)
			StopPlaying()
		else
			if(!music_cartridge)
				to_chat(usr, SPAN_WARNING("You need to slot a music cartridge in first!"))
				return
			StartPlaying(usr)

/obj/item/clothing/ears/earphones/verb/change_volume()
	set name = "Change Volume"
	set category = "Object.Earphones"
	set src in usr

	if(use_check_and_message(usr))
		return

	usr.visible_message(SPAN_NOTICE("[usr] swipes at [usr.get_pronoun("his")] [src]."))

	// Volume Control
	var/volume_input = tgui_input_number(usr,"Change the volume (0 - 100)","Volume", volume, 100, 0)
	if(volume_input == null)
		return
	if(volume_input > 100)
		volume_input = 100
	if(volume_input < 0)
		volume_input = 0
	volume = volume_input

	// If a soundtoken is already active/a song playing, we can adjust the volume mid-token.
	if(!soundplayer_token)
		return
	else
		soundplayer_token.SetVolume(volume)

/// Pain in the ass. This paused all sound in the game; when resuming, all queued sounds (bags, doors, etc.) would play at once. Not a useful enough feature to burn time on.
/*
/obj/item/clothing/ears/earphones/verb/pause_unpause()
	set name = "Pause/Unpause"
	set category = "Object.Earphones"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(ismob(src.loc))
		usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
		playsound(usr, SFX_BUTTON, 10)
		if(soundplayer_token)
			if(soundplayer_token.status != SOUND_PAUSED)
				soundplayer_token.Pause()
				to_chat(usr, SPAN_NOTICE("Music paused."))
				// Save the time remaining on the song and delete the current autoplay timer.
				reset_autoplay_timer()
				// Icon/Overlay stuff for the music notes
				ClearOverlays()
				worn_overlay = null
				update_icon()
				update_clothing_icon()

			else if (soundplayer_token.status == SOUND_PAUSED)
				soundplayer_token.Unpause()
				to_chat(usr, SPAN_NOTICE("Music unpaused."))

				// Re-create the autoplay timer with autoplay_timeleft length.
				autoplay_timer = addtimer(CALLBACK(src, PROC_REF(next_song), usr), autoplay_timeleft, TIMER_UNIQUE|TIMER_STOPPABLE)

				// Icon/Overlay stuff for the music notes
				worn_overlay = "music" // this is rather annoying but prevents the music notes on getting colored
				update_icon()
				update_clothing_icon()
		else
			play_stop() //No soundtoken? They probably meant to use the other verb instead.
*/

/obj/item/clothing/ears/earphones/verb/next_song_verb()
	set name = "Next Song"
	set category = "Object.Earphones"
	set src in usr

	usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
	playsound(usr, SFX_BUTTON, 10)
	next_song(usr)

/obj/item/clothing/ears/earphones/verb/previous_song_verb()
	set name = "Previous Song"
	set category = "Object.Earphones"
	set src in usr

	usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
	playsound(usr, SFX_BUTTON, 10)
	previous_song(usr)

/obj/item/clothing/ears/earphones/verb/eject_music_cartridge_verb()
	set name = "Eject Music Cartridge"
	set category = "Object.Earphones"
	set src in usr

	eject_music_cartridge(usr)

/*
	Click Controls:

	Shift+Click to Pause/Unpause
	Alt+Click to Start/Stop

*/

/obj/item/clothing/ears/earphones/AltClick(mob/user)
	play_stop()

/*
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

/// Track datums, used in jukeboxes
/datum/track
	/// Readable name, used in the jukebox menu
	var/song_name = "Generic"
	/// Filepath of the song
	var/song_path
	/// How long is the song in deciseconds. Default is an arbitrary low value, should be overwritten.
	var/song_length = 10 SECONDS
	/// What cartridge (if any) this song came from.
	var/source

/// Track datums, used in jukeboxes
/datum/track/New(var/new_song_name, var/new_song_path, var/new_song_length, var/new_source)
	. = ..()
	song_name = new_song_name
	song_path = new_song_path
	song_length = new_song_length
	source = new_source

// Default track supplied for testing and also because it's a banger
/datum/track/default
	song_name = "Tintin on the Moon"
	song_path = 'sound/music/ingame/ss13/title3.ogg'
	song_length = 3 MINUTES + 52 SECONDS

/obj/item/music_cartridge
	name = "music cartridge"
	desc = "A music cartridge."
	icon = 'icons/obj/item/music_cartridges.dmi'
	icon_state = "generic"
	w_class = WEIGHT_CLASS_SMALL
	var/list/datum/track/tracks
	/// Whether or not this cartridge can be removed from the datum/jukebox it belongs to.
	var/hardcoded = FALSE

/obj/item/music_cartridge/ss13
	name = "Spacer Classics Vol. 1"
	desc = "An old music cartridge with a cheap-looking label."
	tracks = list(
		new/datum/track("Scratch", 'sound/music/ingame/ss13/title1.ogg', 2 MINUTES + 30 SECONDS),
		new/datum/track("D`Bert", 'sound/music/ingame/ss13/title2.ogg', 1 MINUTES + 58 SECONDS),
		new/datum/track("Uplift", 'sound/music/ingame/ss13/title3.ogg', 3 MINUTES + 52 SECONDS),
		new/datum/track("Uplift II", 'sound/music/ingame/ss13/title3mk2.ogg', 3 MINUTES + 59 SECONDS),
		new/datum/track("Suspenseful", 'sound/music/ingame/ss13/traitor.ogg', 5 MINUTES + 30 SECONDS),
		new/datum/track("Beyond", 'sound/music/ingame/ss13/ambispace.ogg', 3 MINUTES + 15 SECONDS),
		new/datum/track("D`Fort", 'sound/music/ingame/ss13/song_game.ogg', 3 MINUTES + 50 SECONDS),
		new/datum/track("Endless Space", 'sound/music/ingame/ss13/space.ogg', 3 MINUTES + 33 SECONDS),
		new/datum/track("Thunderdome", 'sound/music/ingame/ss13/THUNDERDOME.ogg', 3 MINUTES + 22 SECONDS)
	)
// Hardcoded variant
/obj/item/music_cartridge/ss13/demo
	hardcoded = TRUE

/obj/item/music_cartridge/audioconsole
	name = "SCC Welcome Package"
	desc = "A music cartridge with some company-selected songs. Nothing special, everyone got one of these in their welcome boxes..."
	tracks = list(
		new/datum/track("Butterflies", 'sound/music/ingame/scc/Butterflies.ogg', 3 MINUTES + 37 SECONDS),
		new/datum/track("That Ain't Chopin", 'sound/music/ingame/scc/ThatAintChopin.ogg', 3 MINUTES + 29 SECONDS),
		new/datum/track("Don't Rush", 'sound/music/ingame/scc/DontRush.ogg', 3 MINUTES + 56 SECONDS),
		new/datum/track("Phoron Will Make Us Rich", 'sound/music/ingame/scc/PhoronWillMakeUsRich.ogg', 2 MINUTES + 14 SECONDS),
		new/datum/track("Amsterdam", 'sound/music/ingame/scc/Amsterdam.ogg', 3 MINUTES + 42 SECONDS),
		new/datum/track("When", 'sound/music/ingame/scc/When.ogg', 2 MINUTES + 41 SECONDS),
		new/datum/track("Number 0", 'sound/music/ingame/scc/Number0.ogg', 2 MINUTES + 37 SECONDS),
		new/datum/track("The Pianist", 'sound/music/ingame/scc/ThePianist.ogg', 4 MINUTES + 25 SECONDS),
		new/datum/track("Lips", 'sound/music/ingame/scc/Lips.ogg', 3 MINUTES + 20 SECONDS),
		new/datum/track("Childhood", 'sound/music/ingame/scc/Childhood.ogg', 2 MINUTES + 13 SECONDS)
	)
// Hardcoded variant
/obj/item/music_cartridge/audioconsole/demo
	hardcoded = TRUE

/obj/item/music_cartridge/konyang_retrowave
	name = "Konyang Vibes 2463"
	desc = "A music cartridge with a Konyang flag on the hololabel."
	icon_state = "konyang"
	tracks = list(
		new/datum/track("Konyang Vibes #1", 'sound/music/ingame/konyang/konyang-1.ogg', 2 MINUTES + 59 SECONDS, /obj/item/music_cartridge/konyang_retrowave),
		new/datum/track("Konyang Vibes #2", 'sound/music/ingame/konyang/konyang-2.ogg', 2 MINUTES + 58 SECONDS, /obj/item/music_cartridge/konyang_retrowave),
		new/datum/track("Konyang Vibes #3", 'sound/music/ingame/konyang/konyang-3.ogg', 2 MINUTES + 43 SECONDS, /obj/item/music_cartridge/konyang_retrowave),
		new/datum/track("Konyang Vibes #4", 'sound/music/ingame/konyang/konyang-4.ogg', 3 MINUTES + 8 SECONDS, /obj/item/music_cartridge/konyang_retrowave)
	)
// Hardcoded variant
/obj/item/music_cartridge/konyang_retrowave/demo
	hardcoded = TRUE

/obj/item/music_cartridge/venus_funkydisco
	name = "Top of the Charts 66 (Venusian Hits)"
	desc = "A glitzy, pink music cartridge with more Venusian hits."
	icon_state = "venus"
	tracks = list(
		new/datum/track("dance させる", 'sound/music/ingame/venus/dance.ogg', 3 MINUTES + 19 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("love sensation", 'sound/music/ingame/venus/love_sensation.ogg', 3 MINUTES + 31 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("All Night", 'sound/music/ingame/venus/all_night.ogg', 3 MINUTES + 11 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("#billyocean", 'sound/music/ingame/venus/billy_ocean.ogg', 4 MINUTES + 19 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("Artificially Sweetened", 'sound/music/ingame/venus/artificially_sweetened.ogg', 4 MINUTES + 18 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("Real Love", 'sound/music/ingame/venus/real_love.ogg', 3 MINUTES + 52 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("F U N K Y G I R L <3", 'sound/music/ingame/venus/funky_girl.ogg', 2 MINUTES + 2 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("Break The System", 'sound/music/ingame/venus/break_the_system.ogg', 1 MINUTES + 23 SECONDS, /obj/item/music_cartridge/venus_funkydisco)
	)

/obj/item/music_cartridge/xanu_rock
	name = "Indulgence EP (X-Rock)" //feel free to reflavour as a more varied x-rock mixtape, instead of a single EP, if other x-rock tracks are added
	desc = "A music cartridge with a Xanan flag on the hololabel. Some fancy, rainbow text over it reads, 'INDULGENCE'."
	icon_state = "xanu"
	tracks = list(
		new/datum/track("Rise", 'sound/music/ingame/xanu/xanu_rock_1.ogg', 3 MINUTES + 3 SECONDS, /obj/item/music_cartridge/xanu_rock),
		new/datum/track("Indulgence", 'sound/music/ingame/xanu/xanu_rock_2.ogg', 3 MINUTES + 7 SECONDS, /obj/item/music_cartridge/xanu_rock),
		new/datum/track("Shimmer", 'sound/music/ingame/xanu/xanu_rock_3.ogg', 4 MINUTES + 30 SECONDS, /obj/item/music_cartridge/xanu_rock)
	)

/obj/item/music_cartridge/adhomai_swing
	name = "Electro-Swing of Adhomai"
	desc = "A red music cartridge holding the most widely-known Adhomian electro-swing songs."
	icon_state = "adhomai"
	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/ingame/adhomai/boolean_sisters.ogg', 3 MINUTES + 17 SECONDS, /obj/item/music_cartridge/adhomai_swing),
		new/datum/track("Electro Swing", 'sound/music/ingame/adhomai/electro_swing.ogg', 3 MINUTES + 18 SECONDS, /obj/item/music_cartridge/adhomai_swing),
		new/datum/track("Le Swing", 'sound/music/ingame/adhomai/le_swing.ogg', 2 MINUTES + 11 SECONDS, /obj/item/music_cartridge/adhomai_swing),
		new/datum/track("Posin", 'sound/music/ingame/adhomai/posin.ogg', 2 MINUTES + 50 SECONDS, /obj/item/music_cartridge/adhomai_swing)
	)
// Hardcoded variant
/obj/item/music_cartridge/adhomai_swing/demo
	hardcoded = TRUE

/obj/item/music_cartridge/adhomai_vibes
	name = "Adhomai vibes"
	desc = "A red music cartridge holding various music considered to fit the vibe of Adhomai."
	icon_state = "adhomai"

	tracks = list(
		new/datum/track("Adhomai Vibes #1", 'sound/music/lobby/adhomai/adhomai-1.ogg'),
		new/datum/track("Adhomai Vibes #2", 'sound/music/lobby/adhomai/adhomai-2.ogg'),
		new/datum/track("Adhomai Vibes #3", 'sound/music/lobby/adhomai/adhomai-3.ogg'),
		new/datum/track("Adhomai Vibes #4", 'sound/music/lobby/adhomai/adhomai-4.ogg')
	)

/obj/item/music_cartridge/europa_various
	name = "Europa: Best of the 50s"
	desc = "A music cartridge storing the best tracks to listen to on a submarine dive."
	tracks = list(
		new/datum/track("Where The Rays Leap", 'sound/music/ingame/europa/where_the_dusks_rays_leap.ogg', 3 MINUTES + 41 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Casting Faint Shadows", 'sound/music/ingame/europa/casting_faint_shadows.ogg', 8 MINUTES + 56 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Weedance", 'sound/music/ingame/europa/weedance.ogg', 7 MINUTES + 35 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Instrumental Park", 'sound/music/ingame/europa/instrumental_park.ogg', 5 MINUTES + 39 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Way Between The Shadows", 'sound/music/ingame/europa/way_between_the_shadows.ogg', 8 MINUTES + 21 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Deep Beneath the Solemn Waves a Vast Underwater Landscape, Brimming With Bizarre, Eerily Gleaming Cyclopean Structures of, What Must Surely Be, Non-Human Origin, Stretched Out Across the Ocean Floor", 'sound/music/ingame/europa/deep_beneath-.ogg', 7 MINUTES + 18 SECONDS, /obj/item/music_cartridge/europa_various)
	)
