/**
 * Conditions are a system for long-term damage effects that are also more immersive than simply "this organ has 80 damage so it's broken."
 * We use them to represent different types of damage conditions that aren't easily representable otherwise, such as broken spines on a human, or a destroyed kidney in the case of the kidney organ.
 * Conditions can apply to humans or organs individually. This means that they do NOT have specific parents by default - these parents are defined in the subtypes.
 */
/datum/condition
	/// The name of the condition.
	var/name
	/// The description of the condition. Shows up in scans, gives a better idea of what the condition does, should still be IC.
	var/desc
	/// Condition flags. Used to determine, for example, if a condition needs self-processing without stages.
	var/flags
	/// Severity of the condition. Totally relative, mostly used for sounds.
	var/severity = CONDITION_SEVERITY_LOW
	/// The generic parent of this condition. Don't use this in the subtypes- use the specific parent designated there. This is only for generic operations in the base type.
	var/atom/movable/parent

	/// A list of traits that this condition is connected with. Remember that you will need to apply and clear them manually in condition subtypes.
	var/list/traits

	/// These are generic sounds that play when all conditions are applied. You shouldn't change this unless you want a totally silent condition, like a virus - they're used for combat responsiveness SFX. Plays as a playsound.
	var/should_play_severity_sound = TRUE
	/// Sound played when this specific  condition is applied. Plays as a playsound, not just as a sound effect only to the person.
	var/apply_sound

	/// How many times this condition can be applied. Should be checked individually on human/organ level.
	var/max_condition_amount = 1

	/// If this condition has a stage. On CONDITION_STAGE_NONE it doesn't have any stages; set to CONDITION_STAGE_INITIAL if you want to have stages.
	var/stage = CONDITION_STAGE_NONE
	/// The maximum stage we can reach.
	var/stage_max_level = 0
	/// Current ticker of the stage. Resets to 0 when the stage changes.
	var/stage_progress = 0
	/// How much stage_progress is incremented per process tick.
	var/stage_progress_per_tick = 0
	/// The maximum ticker of the stage. When stage_progress reaches this value, the stage increases by 1 and stage_progress resets to 0.
	var/stage_progress_max = 0
	/// Stage_progress_max is multiplied by this every time the stage progresses. Use this if you want the stage progression to get faster or slower as the stage increases.
	var/stage_progress_mod = 0

/datum/condition/New(atom/movable/new_parent, ...)
	if(!pre_apply(arglist(args)))
		qdel(src)
		return FALSE
	parent = new_parent
	on_apply()
	return TRUE

/datum/condition/Destroy()
	SHOULD_CALL_PARENT(TRUE)
	STOP_PROCESSING(SSprocessing, src) //theoretically dont need to check if condition is processing, also need to account for conditions manually processing for w/e reason
	on_clear()
	parent = null
	return ..()

/datum/condition/process()
	if(stage != CONDITION_STAGE_NONE && stage < stage_max_level)
		stage_progress = min(stage_progress + stage_progress_per_tick, stage_progress_max)
		if(stage_progress >= stage_progress_max)
			stage_progress = 0
			stage_advance()
			if(stage_progress_mod != 0)
				stage_progress_max *= stage_progress_mod

/**
 * By default, conditions will always apply.
 * If you want to have a condition that can be blocked, shouldn't apply due to organ/human traits, or has a chance to fail application, override this and return FALSE if the condition shouldn't be applied.
 */
/datum/condition/proc/pre_apply(atom/movable/new_parent)
	return TRUE

/**
 * Called when a condition is created and initially applied to something.
 */
/datum/condition/proc/on_apply()
	SHOULD_CALL_PARENT(TRUE)
	if(stage != CONDITION_STAGE_NONE || flags & CONDITION_FLAG_PROCESS)
		START_PROCESSING(SSprocessing, src)
	if(should_play_severity_sound)
		switch(severity)
			if(CONDITION_SEVERITY_LOW)
				var/list/low_sounds = list('sound/effects/conditions/condition_low_1.ogg')
				playsound(parent, pick(low_sounds), 100, 1)
			if(CONDITION_SEVERITY_MEDIUM)
				var/list/medium_sounds = list('sound/effects/conditions/condition_medium_1.ogg', 'sound/effects/conditions/condition_medium_2.ogg')
				playsound(parent, pick(medium_sounds), 100, 1)
			if(CONDITION_SEVERITY_HIGH)
				var/list/high_sounds = list('sound/effects/conditions/condition_high_1.ogg')
				playsound(parent, pick(high_sounds), 100, 1)
	if(apply_sound)
		playsound(parent, apply_sound, 100, 1)
	if(length(traits))
		for(var/trait in traits)
			ADD_TRAIT(parent, trait, TRAIT_ORIGIN_CONDITION)

/**
 * Called when a condition is removed from something.
 * Also called in Destroy.
 */
/datum/condition/proc/on_clear()
	SHOULD_CALL_PARENT(TRUE)
	if(parent && length(traits))
		for(var/trait in traits)
			REMOVE_TRAIT(parent, trait, TRAIT_ORIGIN_CONDITION)
/**
 * Called when a stage progresses to the next level.
 */
/datum/condition/proc/stage_advance()
	SHOULD_CALL_PARENT(TRUE)
	stage++
