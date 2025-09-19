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
			var/sound/sound_to_play = current_playlist[playlist_index].sound
			soundplayer_token = GLOB.sound_player.PlayLoopingSound(src, src, sound_to_play, volume, range, 20, prefer_mute = FALSE, sound_type = ASFX_MUSIC)

			//addtimer(CALLBACK(src, PROC_REF(next_song), user), (sound_to_play.len SECOND)) // Queue the next_song() proc when the current song ends. Clean up handled under next_song() which also calls stopplaying() to end this token
			// If someone gets ^this^ to work, you can switch out PlayLoopingSound for PlayNonloopingSound
			// the sound's len variable doesn't seem to actually store a length :/

			// Chat Display
			var/current_track_name = current_playlist[playlist_index].title
			to_chat(user,SPAN_NOTICE("Now Playing: Track [playlist_index] — '[current_track_name]'."))

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

	if(!music_cartridge || (current_playlist.len == 0))
		to_chat(user, SPAN_WARNING("No playlist loaded."))
		return

	StopPlaying() // Stop & Cleanup previous sound token

	// Sound iteration
	if(playlist_index + 1 <= current_playlist.len)
		playlist_index++
	else
		playlist_index = 1

	StartPlaying(user) // New sound token created here

/obj/item/clothing/ears/earphones/proc/previous_song(mob/user)
	if(use_check_and_message(usr))
		return
	if(!music_cartridge || (current_playlist.len == 0))
		to_chat(user, SPAN_WARNING("No playlist loaded."))
		return

	StopPlaying() // Stop & Cleanup previous sound token

	// Sound iteration
	if(playlist_index - 1 < 1)
		playlist_index = 1
	else
		playlist_index--

	StartPlaying(user) // New sound token created here

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
		playsound(usr, /singleton/sound_category/button_sound, 10)

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

/obj/item/clothing/ears/earphones/verb/pause_unpause()
	set name = "Pause/Unpause"
	set category = "Object.Earphones"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(ismob(src.loc))
		usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
		playsound(usr, /singleton/sound_category/button_sound, 10)
		if(soundplayer_token)
			if(soundplayer_token.status != SOUND_PAUSED)
				soundplayer_token.Pause()
				to_chat(usr, SPAN_NOTICE("Music paused."))

				// Icon/Overlay stuff for the music notes
				ClearOverlays()
				worn_overlay = null
				update_icon()
				update_clothing_icon()

			else if (soundplayer_token.status == SOUND_PAUSED)
				soundplayer_token.Unpause()
				to_chat(usr, SPAN_NOTICE("Music unpaused."))

				// Icon/Overlay stuff for the music notes
				worn_overlay = "music" // this is rather annoying but prevents the music notes on getting colored
				update_icon()
				update_clothing_icon()
		else
			play_stop() //No soundtoken? They probably meant to use the other verb instead.

/obj/item/clothing/ears/earphones/verb/next_song_verb()
	set name = "Next Song"
	set category = "Object.Earphones"
	set src in usr

	usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
	playsound(usr, /singleton/sound_category/button_sound, 10)
	next_song(usr)

/obj/item/clothing/ears/earphones/verb/previous_song_verb()
	set name = "Previous Song"
	set category = "Object.Earphones"
	set src in usr

	usr.visible_message(SPAN_NOTICE("[usr] clicks a button on [usr.get_pronoun("his")] [src]."))
	playsound(usr, /singleton/sound_category/button_sound, 10)
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
	pause_unpause()

/obj/item/clothing/ears/earphones/ShiftClick(mob/user)
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

/*
	Music Cartridges
*/

/obj/item/music_cartridge
	name = "music cartridge"
	desc = "A music cartridge."
	icon = 'icons/obj/item/music_cartridges.dmi'
	icon_state = "generic"
	w_class = WEIGHT_CLASS_SMALL

	var/list/datum/track/tracks = list()

/obj/item/music_cartridge/ss13
	name = "Spacer Classics Vol. 1"
	desc = "An old music cartridge with a cheap-looking label."

	tracks = list(
		new/datum/track("Title 1", 'sound/music/title1.ogg'),
		new/datum/track("Title 2", 'sound/music/title2.ogg'),
		new/datum/track("Title 3", 'sound/music/title3.ogg'),
		new/datum/track("Traitor", 'sound/music/traitor.ogg'),
		new/datum/track("Space", 'sound/music/space.ogg'),
		new/datum/track("Title 3 Mk2", 'sound/music/title3mk2.ogg')
	)

/obj/item/music_cartridge/audioconsole
	name = "SCC Welcome Package"
	desc = "A music cartridge with some company-selected songs. Nothing special, everyone got one of these in their welcome boxes..."

	tracks = list(
		new/datum/track("Amsterdam", 'sound/music/audioconsole/Amsterdam.ogg'),
		new/datum/track("Butterflies", 'sound/music/audioconsole/Butterflies.ogg'),
		new/datum/track("Childhood", 'sound/music/audioconsole/Childhood.ogg'),
		new/datum/track("Don't Rush", 'sound/music/audioconsole/DontRush.ogg'),
		new/datum/track("Lips", 'sound/music/audioconsole/Lips.ogg'),
		new/datum/track("Number 0", 'sound/music/audioconsole/Number0.ogg'),
		new/datum/track("Phoron Will Make Us Rich", 'sound/music/audioconsole/PhoronWillMakeUsRich.ogg'),
		new/datum/track("That Ain't Chopin", 'sound/music/audioconsole/ThatAintChopin.ogg'),
		new/datum/track("The Pianist", 'sound/music/audioconsole/ThePianist.ogg'),
		new/datum/track("When", 'sound/music/audioconsole/When.ogg')
	)

/*
	Regional Music Cartridges
*/

/obj/item/music_cartridge/konyang_retrowave
	name = "Konyang Vibes 2463"
	desc = "A music cartridge with a Konyang flag on the hololabel."
	icon_state = "konyang"

	tracks = list(
		new/datum/track("Konyang Vibes #1", 'sound/music/lobby/konyang/konyang-1.ogg'),
		new/datum/track("Konyang Vibes #2", 'sound/music/lobby/konyang/konyang-2.ogg'),
		new/datum/track("Konyang Vibes #3", 'sound/music/lobby/konyang/konyang-3.ogg')
	)

/obj/item/music_cartridge/venus_funkydisco
	name = "Top of the Charts 66 (Venusian Hits)"
	desc = "A glitzy, pink music cartridge with more Venusian hits."
	icon_state = "venus"

	tracks = list(
		new/datum/track("dance させる", 'sound/music/regional/venus/dance.ogg'),
		new/datum/track("love sensation", 'sound/music/regional/venus/love_sensation.ogg'),
		new/datum/track("All Night", 'sound/music/regional/venus/all_night.ogg'),
		new/datum/track("#billyocean", 'sound/music/regional/venus/billy_ocean.ogg'),
		new/datum/track("Artificially Sweetened", 'sound/music/regional/venus/artificially_sweetened.ogg'),
		new/datum/track("Real Love", 'sound/music/regional/venus/real_love.ogg'),
		new/datum/track("F U N K Y G I R L <3", 'sound/music/regional/venus/funky_girl.ogg'),
		new/datum/track("Break The System", 'sound/music/regional/venus/break_the_system.ogg')
	)


/obj/item/music_cartridge/xanu_rock
	name = "Indulgence EP (X-Rock)" //feel free to reflavour as a more varied x-rock mixtape, instead of a single EP, if other x-rock tracks are added
	desc = "A music cartridge with a Xanan flag on the hololabel. Some fancy, rainbow text over it reads, 'INDULGENCE'."
	icon_state = "xanu"

	tracks = list(
		new/datum/track("Shimmer", 'sound/music/regional/xanu/xanu_rock_3.ogg'),
		new/datum/track("Rise", 'sound/music/regional/xanu/xanu_rock_1.ogg'),
		new/datum/track("Indulgence", 'sound/music/regional/xanu/xanu_rock_2.ogg')
	)

/obj/item/music_cartridge/adhomai_swing
	name = "Electro-Swing of Adhomai"
	desc = "A red music cartridge holding the most widely-known Adhomian electro-swing songs."
	icon_state = "adhomai"

	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/phonograph/boolean_sisters.ogg'),
		new/datum/track("Electro Swing", 'sound/music/phonograph/electro_swing.ogg'),
		new/datum/track("Le Swing", 'sound/music/phonograph/le_swing.ogg'),
		new/datum/track("Posin", 'sound/music/phonograph/posin.ogg')
	)

/obj/item/music_cartridge/europa_various
	name = "Europa: Best of the 50s"
	desc = "A music cartridge storing the best tracks to listen to on a submarine dive."
	icon_state = "generic"

	tracks = list(
		new/datum/track("Where The Rays Leap", 'sound/music/regional/europa/where_the_dusks_rays_leap.ogg'),
		new/datum/track("Casting Faint Shadows", 'sound/music/regional/europa/casting_faint_shadows.ogg'),
		new/datum/track("Weedance", 'sound/music/regional/europa/weedance.ogg'),
		new/datum/track("Instrumental Park", 'sound/music/regional/europa/instrumental_park.ogg'),
		new/datum/track("Way Between The Shadows", 'sound/music/regional/europa/way_between_the_shadows.ogg'),
		new/datum/track("Deep Beneath the Solemn Waves a Vast Underwater Landscape, Brimming With Bizarre, Eerily Gleaming Cyclopean Structures of, What Must Surely Be, Non-Human Origin, Stretched Out Across the Ocean Floor", 'sound/music/regional/europa/deep_beneath-.ogg'),
	)

