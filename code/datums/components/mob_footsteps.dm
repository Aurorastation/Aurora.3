// This component handles dynamically playing mob footsteps.
/datum/component/mob_footsteps
	/// Our parent human mob.
	VAR_FINAL/mob/living/mob_parent
	/// The sound effects we'll play on each movement. Lazylist.
	var/list/sound_effects_to_play
	/// Current footstep counter.
	var/footsteps = 0
	/// How many footsteps are needed until a sound is played.
	var/footsteps_until_sound = 2

/datum/component/mob_footsteps/Initialize(...)
	. = ..()
	if(!isliving(parent))
		log_debug("Mob footsteps component created on a non-living mob.")
		return COMPONENT_INCOMPATIBLE

	mob_parent = parent

	RegisterSignal(mob_parent, COMSIG_MOB_ADD_FOOTSTEP_SOUND, PROC_REF(add_footstep_sound))
	RegisterSignal(mob_parent, COMSIG_MOB_REMOVE_FOOTSTEP_SOUND, PROC_REF(remove_footstep_sound))
	RegisterSignal(mob_parent, COMSIG_MOVABLE_MOVED, PROC_REF(play_footstep_sounds))

/datum/component/mob_footsteps/Destroy()
	mob_parent = null
	LAZYNULL(sound_effects_to_play)
	return ..()

/**
 * Adds a footstep sound to the list of footsteps to play.
 */
/datum/component/mob_footsteps/proc/add_footstep_sound(caller, source, list/footstep_sounds)
	SIGNAL_HANDLER
	if(!length(footstep_sounds))
		return

	LAZYSET(sound_effects_to_play, source, footstep_sounds)

/**
 * Removes a footstep sound to the list of footsteps to play.
 */
/datum/component/mob_footsteps/proc/remove_footstep_sound(caller, source, list/footstep_sounds)
	SIGNAL_HANDLER
	if(!length(footstep_sounds))
		return

	sound_effects_to_play -= source

/**
 * Finally, play the sound when we need to.
 */
/datum/component/mob_footsteps/proc/play_footstep_sounds()
	SIGNAL_HANDLER
	//todomatt: remember is_noisy if(mob_parent.is_noisy)
	footsteps++
	if(footsteps < footsteps_until_sound)
		return

		/*if(shoes) TODOMATT check this
			var/obj/item/clothing/shoes/S = shoes
		if (m_intent == M_RUN)
			playsound(src, (is_noisy ? footsound : species.footsound), 70, TRUE, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE, required_asfx_toggles = ASFX_FOOTSTEPS)
		else
			footstep++
			if (footstep % 2)
				playsound(src, (is_noisy ? footsound : species.footsound), 40, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, required_asfx_toggles = ASFX_FOOTSTEPS)*/

	// play the turf sound first, different range and we need to check for barefoot sounds as well
	var/turf/T = get_turf(mob_parent)
	var/top_layer = 0
	var/turf_walk_sound
	if(istype(T))
		for(var/obj/structure/S in T)
			if(S.layer > top_layer && S.footstep_sound)
				top_layer = S.layer
				turf_walk_sound = S.footstep_sound

	if(!turf_walk_sound)
		turf_walk_sound = T.footstep_sound
	playsound(mob_parent, turf_walk_sound, 40, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, required_asfx_toggles = ASFX_FOOTSTEPS)

	// next, sourced sounds
	for(var/source in sound_effects_to_play)
		var/list/sounds_to_play = sound_effects_to_play[source]

		var/volume = 40
		if(mob_parent.m_intent == M_RUN)
			volume = min(volume + 30, 100)

		playsound(mob_parent, length(sounds_to_play) > 1 ? pick(sounds_to_play) : sounds_to_play[1], volume, TRUE, required_asfx_toggles = ASFX_FOOTSTEPS)
	footsteps = 0

