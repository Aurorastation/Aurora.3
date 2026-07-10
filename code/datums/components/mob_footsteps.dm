// This component handles dynamically playing mob footsteps.
/datum/component/mob_footsteps
	/// Our parent human mob.
	VAR_FINAL/mob/living/mob_parent
	/// The sound effects we'll play on each movement. Lazylist.
	var/list/sound_effects_to_play
	/// Sound effect volumes. Assoc list, source -> volume.
	var/list/sound_effects_volumes
	/// If this mob has a barefoot sound. Fuck whoever added this, by the way.
	var/barefoot_sound
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
	UnregisterSignal(mob_parent, COMSIG_MOB_ADD_FOOTSTEP_SOUND)
	UnregisterSignal(mob_parent, COMSIG_MOB_REMOVE_FOOTSTEP_SOUND)
	mob_parent = null
	LAZYNULL(sound_effects_to_play)
	LAZYNULL(sound_effects_volumes)
	return ..()

/**
 * Adds a footstep sound to the list of footsteps to play.
 */
/datum/component/mob_footsteps/proc/add_footstep_sound(comp_source, source, list/footstep_sounds, volume)
	SIGNAL_HANDLER
	if(!length(footstep_sounds))
		return

	LAZYSET(sound_effects_to_play, source, footstep_sounds)
	if(volume)
		LAZYSET(sound_effects_volumes, source, volume)

/**
 * Removes a footstep sound to the list of footsteps to play.
 */
/datum/component/mob_footsteps/proc/remove_footstep_sound(comp_source, source, list/footstep_sounds)
	SIGNAL_HANDLER
	if(!length(footstep_sounds))
		return

	LAZYREMOVE(sound_effects_to_play, source)
	LAZYREMOVE(sound_effects_volumes, source)

/**
 * Finally, play the sound when we need to.
 */
/datum/component/mob_footsteps/proc/play_footstep_sounds()
	SIGNAL_HANDLER

	if(mob_parent.buckled_to)
		return

	footsteps++
	if(footsteps < footsteps_until_sound)
		return

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
	var/barefoot_sound = get_barefoot_sounds()
	playsound(mob_parent, barefoot_sound ? barefoot_sound : turf_walk_sound, 40, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, required_asfx_toggles = ASFX_FOOTSTEPS)

	// next, sourced sounds
	for(var/source in sound_effects_to_play)
		var/list/sounds_to_play = sound_effects_to_play[source]

		var/volume = 40
		if(source in sound_effects_volumes)
			volume = sound_effects_volumes[source]

		if(mob_parent.m_intent == M_RUN)
			volume = min(volume + 30, 100)

		playsound(mob_parent, length(sounds_to_play) > 1 ? pick(sounds_to_play) : sounds_to_play[1], volume, FALSE, required_asfx_toggles = ASFX_FOOTSTEPS)
	footsteps = 0

/**
 * If the mob has barefoot sounds, this is where you check if they should be played in lieu of the normal turf sound.
 */
/datum/component/mob_footsteps/proc/get_barefoot_sounds()
	return

/datum/component/mob_footsteps/human
	/// The human parent of this component. A bit shit but what can you do.
	VAR_FINAL/mob/living/carbon/human/human_parent

/datum/component/mob_footsteps/human/Initialize(parent)
	. = ..()
	if(!ishuman(mob_parent))
		log_debug("Human footstep component initialized without an actual human on [mob_parent].")
		return COMPONENT_INCOMPATIBLE

	human_parent = mob_parent
	if(human_parent.species.footsound != SFX_FOOTSTEP_BLANK)
		barefoot_sound = human_parent.species.footsound

/datum/component/mob_footsteps/human/Destroy()
	human_parent = null
	return ..()

/datum/component/mob_footsteps/human/get_barefoot_sounds()
	var/obj/item/clothing/shoes/shoes = human_parent.shoes
	if(shoes)
		return shoes.silent ? SFX_FOOTSTEP_BLANK : human_parent.is_noisy ? null : barefoot_sound
	else
		return human_parent.is_noisy ? null : barefoot_sound
