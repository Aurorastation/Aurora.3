/*
	output_atoms	(list of atoms)			The destination(s) for the sounds

	mid_sounds		(list or soundfile)		Since this can be either a list or a single soundfile you can have random sounds. May contain further lists but must contain a soundfile at the end.
	mid_length		(num)					The length to wait between playing mid_sounds

	start_sound		(soundfile)				Played before starting the mid_sounds loop
	start_length	(num)					How long to wait before starting the main loop after playing start_sound

	end_sound		(soundfile)				The sound played after the main loop has concluded

	chance			(num)					Chance per loop to play a mid_sound
	volume			(num)					Sound output volume
	max_loops		(num)					The max amount of loops to run for.
	direct			(bool)					If true plays directly to provided atoms instead of from them
*/

/datum/looping_sound

	///A `/list` of `/atom`, destinations for the sound
	var/list/atom/output_atoms = list()

	/**
	 * A list with soundfiles, or a soundfile, to play for the intermediate steps
	 *
	 * Must contain at least one sound
	 */
	var/mid_sounds

	///The length to wait between playing mid_sounds
	var/mid_length

	///Volume for the start sound
	var/start_volume

	///A soundfile, played before starting the mid_sounds loop
	var/start_sound

	///How long to wait before starting the main loop after playing start_sound
	var/start_length

	///Volume for the end sound
	var/end_volume

	///A soundfile, the sound played after the main loop has concluded
	var/end_sound

	///Chance per loop to play a mid_sound
	var/chance

	///Sound output volume
	var/volume = 100

	///Whether or not the sounds will vary in pitch when played
	var/vary = FALSE

	///The max amount of loops to run for
	var/max_loops
	var/direct

	///The extra range of the sound in tiles, defaults to 0.
	var/extra_range
	var/falloff

	///The ID of the timer that's used to loop the sounds.
	var/timerid

/datum/looping_sound/New(list/_output_atoms=list(), start_immediately=FALSE, _direct=FALSE)
	if(!mid_sounds)
		crash_with("A looping sound datum was created without sounds to play.")
		return

	output_atoms |= _output_atoms
	direct = _direct

	if(start_immediately)
		start()

/datum/looping_sound/Destroy()
	stop()
	output_atoms = null
	return ..()

/datum/looping_sound/proc/start(atom/add_thing)
	if(add_thing)
		output_atoms |= add_thing
	if(timerid)
		return
	on_start()

/datum/looping_sound/proc/stop(atom/remove_thing)
	if(remove_thing)
		output_atoms -= remove_thing
	if(!timerid)
		return
	on_stop()
	deltimer(timerid)
	timerid = null

/datum/looping_sound/proc/sound_loop(starttime)
	if(max_loops && (world.time >= starttime + mid_length * max_loops))
		stop()
		return
	if(!chance || prob(chance))
		play(get_sound(starttime))
	if(!timerid)
		timerid = addtimer(CALLBACK(src, PROC_REF(sound_loop), world.time), mid_length, TIMER_STOPPABLE | TIMER_LOOP)

/datum/looping_sound/proc/play(soundfile, volume_override)
	var/list/atoms_cache = output_atoms
	var/sound/S = sound(soundfile)
//	if(direct)
	//	S.channel = open_sound_channel() someone could probably make this work but you could probably just delete this with no reprecussions.
	//	S.volume = volume
	for(var/i in 1 to atoms_cache.len)
		var/atom/thing = atoms_cache[i]
	//	if(direct)
	//		SEND_SOUND(thing, S)
	//	else
		playsound(thing, S, volume_override || volume, vary, extra_range, falloff, required_preferences = ASFX_AMBIENCE) // you can turn it off, i guess.

/datum/looping_sound/proc/get_sound(starttime, _mid_sounds)
	. = _mid_sounds || mid_sounds
	while(!isfile(.) && !isnull(.))
		. = pickweight(.)

/datum/looping_sound/proc/on_start()
	var/start_wait = 0
	if(start_sound)
		play(start_sound, start_volume)
		start_wait = start_length
	addtimer(CALLBACK(src, PROC_REF(sound_loop)), start_wait)

/datum/looping_sound/proc/on_stop()
	if(end_sound)
		play(end_sound, end_volume)
