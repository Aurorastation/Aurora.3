/**
 * ## Jukebox datum
 *
 * Plays music to nearby mobs when hosted in a movable or a turf.
 */
/datum/jukebox
	/// Atom that hosts the jukebox. Can be a turf or a movable.
	VAR_FINAL/atom/parent
	/// List of /datum/tracks we can play.
	var/list/datum/track/playlist = list()
	/// Current song track selected
	var/datum/track/selection
	/// Whether we're playing a track or not
	var/playing = FALSE
	/// Range at which the sound plays to players
	var/sound_range = 7
	/// The sound token being played.
	var/token = null
	/// Volume to play at.
	var/volume = 20

/**
 * In the future, the music_cartridge item should be able to be inserted into jukeboxes, just like they are with earphones, to be able to control
 * what songs are available on the playlist - i.e. crew members should be able to use their personal music cartridges in classic jukeboxes, etc.
 * Further, earphones should be refactored to create datum/jukebox/single_mob instances and be otherwise interacted w/ just like freestanding jukeboxes.
 *
 * In practice, this turned out to be a gigantic pain in the ass due to difficulties in passing references to cartridge objs in and out of the component
 * through TGUI- they kept getting nulled. Therefore, for the present, all jukeboxes have their available tracks set in their definitions, whereas
 * earphones remain able to slot in and out cartridges. The old cartridge-based code for jukeboxes has been largely commented out.
 */

/datum/jukebox/New(atom/new_parent, var/list/datum/track/parent_playlist, var/parent_sound_range, var/parent_volume)
	if(!ismovable(new_parent) && !isturf(new_parent))
		stack_trace("[type] created on non-turf or non-movable: [new_parent ? "[new_parent] ([new_parent.type])" : "null"])")
		qdel(src)
		return

	parent = new_parent

	for(var/datum/track/track in parent_playlist)
		var/datum/track/new_track = new()
		new_track.song_name = track.song_name
		new_track.song_path = file(track.song_path)
		new_track.song_length = track.song_length
		playlist[new_track.song_name] = new_track

	sound_range = parent_sound_range
	volume = parent_volume

	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(parent_delete))

/datum/jukebox/Destroy()
	QDEL_NULL(token)
	parent = null
	selection = null
	token = null
	playing = FALSE
	playlist.Cut()
	return ..()

/// When our parent is deleted, we should go too.
/datum/jukebox/proc/parent_delete(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/jukebox/proc/StopPlaying()
	playing = FALSE
	QDEL_NULL(token)

/datum/jukebox/proc/StartPlaying()
	StopPlaying()
	if(!selection)
		return
	token = GLOB.sound_player.PlayLoopingSound(parent, src, selection.song_path, volume, sound_range, 1, prefer_mute = TRUE, sound_type = ASFX_MUSIC)
	playing = TRUE

/**
 * Returns a set of general data relating to the jukebox for use in TGUI.
 *
 * Returns
 * * A list of UI data
 */
/datum/jukebox/proc/get_ui_data()
	var/list/data = list()
	var/list/songs_data = list()
	for(var/entry in playlist)
		var/datum/track/one_song = playlist[entry]
		var/song_name = one_song.song_name
		var/song_length = one_song.song_length
		UNTYPED_LIST_ADD(songs_data, list( \
			"name" = song_name, \
			"length" = DisplayTimeTextDense(song_length)
		))
	data["active"] = !!playing
	data["playlist"] = songs_data
	data["selection"] = selection?.song_name
	return data

