// Reasons for appling STATUS_MUTE to a mob's sound status
/// The mob is deaf
#define MUTE_DEAF (1<<0)
/// The mob is out of range of the jukebox
#define MUTE_RANGE (1<<1)

/**
 * ## Jukebox datum
 *
 * Plays music to nearby mobs when hosted in a movable or a turf.
 */
/datum/jukebox
	/// Atom that hosts the jukebox. Can be a turf or a movable.
	VAR_FINAL/atom/parent
	/// List of /datum/tracks we can play.
	var/list/playlist = list()
	/// Current song track selected
	var/datum/track/selection
	/// Current song datum playing
	var/sound/active_song_sound
	/// Whether the jukebox requires a connect_range component to check for new listeners
	VAR_PROTECTED/requires_range_check = TRUE
	/// Assoc list of all mobs listening to the jukebox to their sound status.
	VAR_PRIVATE/list/mob/listeners = list()
	/// Volume of the songs played. Also serves as the max volume.
	/// Do not set directly, use set_new_volume() instead.
	VAR_PROTECTED/volume = 80
	/// Whether the music loops when done.
	/// If FALSE, you must handle ending music yourself.
	var/sound_loops = FALSE
	/// Range at which the sound plays to players, can also be a view "XxY" string
	var/sound_range
	/// How far away horizontally from the jukebox can you be before you stop hearing it
	VAR_PRIVATE/x_cutoff
	/// How far away vertically from the jukebox can you be before you stop hearing it
	VAR_PRIVATE/z_cutoff
	/// Music cartridge in the jukebox.
	var/list/cartridges = list()
	/// Maximum number of cartridges that can be loaded.
	var/max_cartridges = 1
	/// Whether or not cartridges can be inserted or ejected by players.
	var/locked = FALSE

/datum/jukebox/New(atom/new_parent, var/parent_sound_range, var/parent_cartridges, var/parent_max_cartridges, var/parent_locked)
	if(!ismovable(new_parent) && !isturf(new_parent))
		stack_trace("[type] created on non-turf or non-movable: [new_parent ? "[new_parent] ([new_parent.type])" : "null"])")
		qdel(src)
		return

	parent = new_parent

	if(isnull(parent_sound_range))
		sound_range = world.view
		var/list/worldviewsize = getviewsize(sound_range)
		x_cutoff = ceil(worldviewsize[1] * 1.25 / 2) // * 1.25 gives us some extra range to fade out with
		z_cutoff = ceil(worldviewsize[2] * 1.25 / 2) // and / 2 is because world view is the whole screen, and we want the centre

	if(length(parent_cartridges))
		cartridges = parent_cartridges

	if(isnull(parent_max_cartridges))
		max_cartridges = parent_max_cartridges

	if(parent_locked)
		locked = TRUE

	if(requires_range_check)
		var/static/list/connections = list(COMSIG_ATOM_ENTERED = PROC_REF(check_new_listener))
		AddComponent(/datum/component/connect_range, parent, connections, max(x_cutoff, z_cutoff))

	for (var/obj/item/music_cartridge/cartridge in cartridges)
		LOG_DEBUG("/datum/jukebox/New(), first cartridge is [cartridge]")
		playlist += add_songs(cartridge)
	if(length(playlist))
		selection = playlist[pick(playlist)]

	RegisterSignal(parent, COMSIG_ENTER_AREA, PROC_REF(on_enter_area))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(parent_delete))

/datum/jukebox/Destroy()
	unlisten_all()
	parent = null
	selection = null
	playlist.Cut()
	active_song_sound = null
	return ..()

/// When our parent is deleted, we should go too.
/datum/jukebox/proc/parent_delete(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/**
 * Called by the attackby() of the atom containing the datum/jukebox.
 *
 * Returns
 * * An assoc list of track names to /datum/track. Track names must be unique.
 */
/datum/jukebox/proc/load_cartridge(obj/item/music_cartridge/cartridge, mob/user)
	LOG_DEBUG("/datum/jukebox/proc/load_cartridge([cartridge],[user])")
	if(cartridge == user.get_active_hand())
		if((length(cartridges) + 1) >= max_cartridges)
			to_chat(user, SPAN_WARNING("\The [parent] cannot hold any more cartridges."))
			return FALSE
		else
			user.drop_from_inventory(cartridge, parent)
			cartridges |= cartridge
			playlist += add_songs(cartridge)
			to_chat(user, SPAN_NOTICE("You insert \the [cartridge] into \the [parent]"))

/// Adds songs on the provided cartridge to our current playlist.
/datum/jukebox/proc/add_songs(obj/item/music_cartridge/cartridge)
	LOG_DEBUG("/datum/jukebox/proc/add_songs([cartridge])")
	var/static/list/config_songs
	if(isnull(config_songs))
		config_songs = list()
		LOG_DEBUG("about to start adding tracks from cartridge [cartridge]")
		if(cartridge.tracks)
			for(var/datum/track/track in cartridge.tracks)
				LOG_DEBUG("adding track [track.song_name]")
				config_songs += track
		if(!length(config_songs))
			var/datum/track/default/default_track = new()
			config_songs[default_track.song_name] = default_track

	// returns a copy so it can mutate if desired.
	return config_songs.Copy()

/// Removes songs on the provided cartridge from our current playlist.
/datum/jukebox/proc/remove_songs(obj/item/music_cartridge/cartridge)
	if(!isnull(playlist))
		for(var/datum/track/track in cartridge.tracks)
			if(istype(track.source, cartridge))
				LAZYREMOVE(track, playlist)

	return playlist

/**
 * Returns a set of general data relating to the jukebox for use in TGUI.
 *
 * Returns
 * * A list of UI data
 */
/datum/jukebox/proc/get_ui_data()
	var/list/data = list()
	var/list/songs_data = list()
	for(var/song_name in playlist)
		var/datum/track/one_song = playlist[song_name]
		UNTYPED_LIST_ADD(songs_data, list( \
			"name" = song_name, \
			"length" = DisplayTimeText(one_song.song_length), \
		))

	data["active"] = !!active_song_sound
	data["playlist"] = songs_data
	data["track_selected"] = selection?.song_name
	data["sound_loops"] = sound_loops
	data["volume"] = volume
	return data

/**
 * Sets the sound's range to a new value. This can be a number or a view size string "XxY".
 * Then updates any mobs listening to it.
 */
/datum/jukebox/proc/set_sound_range(new_range)
	if(sound_range == new_range)
		return
	sound_range = new_range
	var/list/worldviewsize = getviewsize(sound_range)
	x_cutoff = ceil(worldviewsize[1] / 2)
	z_cutoff = ceil(worldviewsize[2] / 2)
	update_all()

/**
 * Sets the sound's volume to a new value.
 * Then updates any mobs listening to it.
 */
/datum/jukebox/proc/set_new_volume(new_vol)
	new_vol = clamp(new_vol, 0, initial(volume))
	if(volume == new_vol)
		return
	volume = new_vol
	if(!active_song_sound)
		return
	active_song_sound.volume = volume
	update_all()

/// Sets volume to the maximum possible value, the initial volume value.
/datum/jukebox/proc/set_volume_to_max()
	set_new_volume(initial(volume))

/**
 * Sets the sound's environment to a new value.
 * Then updates any mobs listening to it.
 */
/datum/jukebox/proc/set_new_environment(new_env)
	if(!active_song_sound || active_song_sound.environment == new_env)
		return
	active_song_sound.environment = new_env
	update_all()

/// Helper to stop the music for all mobs listening to the music.
/datum/jukebox/proc/unlisten_all()
	for(var/mob/listening as anything in listeners)
		deregister_listener(listening)
	active_song_sound = null

/// Helper to update all mobs currently listening to the music.
/datum/jukebox/proc/update_all()
	for(var/mob/listening as anything in listeners)
		update_listener(listening)

/// Helper to kickstart the music for all mobs in hearing range of the jukebox.
/datum/jukebox/proc/start_music()
	for(var/mob/nearby in hearers(sound_range, parent))
		register_listener(nearby)

/// Helper to get all mobs currently, ACTIVELY listening to the jukebox.
/datum/jukebox/proc/get_active_listeners()
	var/list/all_listeners = list()
	for(var/mob/listener as anything in listeners)
		if(listeners[listener] & SOUND_MUTE)
			continue
		all_listeners += listener
	return all_listeners

/// Registers the passed mob as a new listener to the jukebox.
/datum/jukebox/proc/register_listener(mob/new_listener)
	PROTECTED_PROC(TRUE)

	listeners[new_listener] = NONE
	RegisterSignal(new_listener, COMSIG_QDELETING, PROC_REF(listener_deleted))

	if(isnull(new_listener.client))
		RegisterSignal(new_listener, COMSIG_MOB_LOGIN, PROC_REF(listener_login))
		return

	RegisterSignals(new_listener, list(COMSIG_MOVABLE_MOVED), PROC_REF(listener_moved))
	if(new_listener.ear_deaf)
		listeners[new_listener] |= SOUND_MUTE

	if(isnull(active_song_sound))
		var/area/juke_area = get_area(parent)
		active_song_sound = sound(selection.song_path)
		active_song_sound.channel = CHANNEL_JUKEBOX
		active_song_sound.priority = 255
		active_song_sound.falloff = 2
		active_song_sound.volume = volume
		active_song_sound.y = 1
		active_song_sound.environment = juke_area.sound_environment || SOUND_ENVIRONMENT_NONE
		active_song_sound.repeat = sound_loops

	update_listener(new_listener)
	// if you have a sound with status SOUND_UPDATE,
	// and try to play it to a client who is not listening to the sound already,
	// it will not work.
	// so we only add this status AFTER the first update, which plays the first sound.
	// and after that it's fine to keep it on the sound so it updates as the x/z does.
	listeners[new_listener] |= SOUND_UPDATE

/// Deregisters mobs on deletion.
/datum/jukebox/proc/listener_deleted(mob/source)
	SIGNAL_HANDLER
	deregister_listener(source)

/// Updates the sound's position on mob movement.
/datum/jukebox/proc/listener_moved(mob/source)
	SIGNAL_HANDLER
	update_listener(source)

/// Allows mobs who are clientless when the music starts to hear it when they log in.
/datum/jukebox/proc/listener_login(mob/source)
	SIGNAL_HANDLER
	deregister_listener(source)
	register_listener(source)

/**
 * Unmutes the passed mob's sound from the passed reason.
 *
 * Arguments
 * * mob/listener - The mob to unmute.
 * * reason - The reason to unmute them for. Can be a combination of MUTE_DEAF, MUTE_RANGE.
 */
/datum/jukebox/proc/unmute_listener(mob/listener, reason)
	// We need to check everything BUT the reason we're unmuting for
	// Because if we're muted for a different reason we don't wanna touch it
	reason = ~reason

	if((reason & MUTE_DEAF) && listener.ear_deaf)
		return FALSE

	if(reason & MUTE_RANGE)
		var/turf/sound_turf = get_turf(parent)
		var/turf/listener_turf = get_turf(listener)
		if(isnull(sound_turf) || isnull(listener_turf))
			return FALSE
		if(sound_turf.z != listener_turf.z)
			return FALSE
		if(abs(sound_turf.x - listener_turf.x) > x_cutoff)
			return FALSE
		if(abs(sound_turf.y - listener_turf.y) > z_cutoff)
			return FALSE

	listeners[listener] &= ~SOUND_MUTE
	return TRUE

/// Deregisters the passed mob as a listener to the jukebox, stopping the music.
/datum/jukebox/proc/deregister_listener(mob/no_longer_listening)
	PROTECTED_PROC(TRUE)

	listeners -= no_longer_listening
	no_longer_listening.stop_sound_channel(CHANNEL_JUKEBOX)
	UnregisterSignal(no_longer_listening, list(
		COMSIG_MOB_LOGIN,
		COMSIG_QDELETING,
		COMSIG_MOVABLE_MOVED,
	))

/// Updates the passed mob's sound in according to their position and status.
/datum/jukebox/proc/update_listener(mob/listener)
	PROTECTED_PROC(TRUE)

	active_song_sound.status = listeners[listener] || NONE

	var/turf/sound_turf = get_turf(parent)
	var/turf/listener_turf = get_turf(listener)
	if(isnull(sound_turf) || isnull(listener_turf)) // ??
		active_song_sound.x = 0
		active_song_sound.z = 0

	else if(sound_turf.z != listener_turf.z) // Could MAYBE model multi-z jukeboxes but that's too complex for now
		listeners[listener] |= SOUND_MUTE

	else
		// keep in mind sound XYZ is different to world XYZ. sound +-z = world +-y
		var/new_x = sound_turf.x - listener_turf.x
		var/new_z = sound_turf.y - listener_turf.y

		if((abs(new_x) > x_cutoff || abs(new_z) > z_cutoff))
			listeners[listener] |= SOUND_MUTE

		else if(listeners[listener] & SOUND_MUTE)
			unmute_listener(listener, MUTE_RANGE)

		active_song_sound.x = new_x
		active_song_sound.z = new_z
		active_song_sound.volume = volume

	SEND_SOUND(listener, active_song_sound)

/// When the jukebox moves, we need to update all listeners.
/datum/jukebox/proc/on_moved(datum/source, ...)
	SIGNAL_HANDLER
	update_all()

/// When the jukebox enters a new area entirely, we need to update the environment to the new area's.
/datum/jukebox/proc/on_enter_area(datum/source, area/area_to_register)
	SIGNAL_HANDLER
	set_new_environment(area_to_register.sound_environment || SOUND_ENVIRONMENT_NONE)

/// Check for new mobs entering the jukebox's range.
/datum/jukebox/proc/check_new_listener(datum/source, atom/movable/entered)
	SIGNAL_HANDLER

	if(isnull(active_song_sound))
		return
	if(!ismob(entered))
		return
	if(entered in listeners)
		return
	register_listener(entered)

/**
 * Subtype which only plays the music to the mob you pass in via start_music().
 *
 * Multiple mobs can still listen at once, but you must register them all manually via start_music().
 */
/datum/jukebox/single_mob
	requires_range_check = FALSE

/datum/jukebox/single_mob/start_music(mob/solo_listener)
	register_listener(solo_listener)

#undef MUTE_DEAF
#undef MUTE_RANGE

/// Track datums, used in jukeboxes
/datum/track
	/// Readable name, used in the jukebox menu
	var/song_name
	/// Filepath of the song
	var/song_path
	/// How long is the song in deciseconds. Default is an arbitrary low value, should be overwritten.
	var/song_length
	/// What cartridge (if any) this song came from. Don't hate me okay? This works.
	var/source

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
	var/list/datum/track/tracks = list()
	/// Whether or not this cartridge can be removed from the datum/jukebox it belongs to.
	var/hardcoded = FALSE

/obj/item/music_cartridge/ss13
	name = "Spacer Classics Vol. 1"
	desc = "An old music cartridge with a cheap-looking label."
	tracks = list(
		new/datum/track("Scratch", 'sound/music/ingame/ss13/title1.ogg', 2 MINUTES + 30 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("D`Bert", 'sound/music/ingame/ss13/title2.ogg', 1 MINUTES + 58 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Uplift", 'sound/music/ingame/ss13/title3.ogg', 3 MINUTES + 52 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Uplift II", 'sound/music/ingame/ss13/title3mk2.ogg', 3 MINUTES + 59 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Suspenseful", 'sound/music/ingame/ss13/traitor.ogg', 5 MINUTES + 30 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Beyond", 'sound/music/ingame/ss13/ambispace.ogg', 3 MINUTES + 15 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("D`Fort", 'sound/music/ingame/ss13/song_game.ogg', 3 MINUTES + 50 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Endless Space", 'sound/music/ingame/ss13/space.ogg', 3 MINUTES + 33 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Thunderdome", 'sound/music/ingame/ss13/THUNDERDOME.ogg', 3 MINUTES + 22 SECONDS, /obj/item/music_cartridge/ss13)
	)
// Hardcoded variant
/obj/item/music_cartridge/ss13/demo
	hardcoded = TRUE

/obj/item/music_cartridge/audioconsole
	name = "SCC Welcome Package"
	desc = "A music cartridge with some company-selected songs. Nothing special, everyone got one of these in their welcome boxes..."
	tracks = list(
		new/datum/track("Butterflies", 'sound/music/ingame/scc/Butterflies.ogg', 3 MINUTES + 37 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("That Ain't Chopin", 'sound/music/ingame/scc/ThatAintChopin.ogg', 3 MINUTES + 29 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Don't Rush", 'sound/music/ingame/scc/DontRush.ogg', 3 MINUTES + 56 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Phoron Will Make Us Rich", 'sound/music/ingame/scc/PhoronWillMakeUsRich.ogg', 2 MINUTES + 14 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Amsterdam", 'sound/music/ingame/scc/Amsterdam.ogg', 3 MINUTES + 42 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("When", 'sound/music/ingame/scc/When.ogg', 2 MINUTES + 41 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Number 0", 'sound/music/ingame/scc/Number0.ogg', 2 MINUTES + 37 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("The Pianist", 'sound/music/ingame/scc/ThePianist.ogg', 4 MINUTES + 25 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Lips", 'sound/music/ingame/scc/Lips.ogg', 3 MINUTES + 20 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Childhood", 'sound/music/ingame/scc/Childhood.ogg', 2 MINUTES + 13 SECONDS, /obj/item/music_cartridge/audioconsole)
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
