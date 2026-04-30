/**
 * Component used for the Firearms skill. Mobs with this component will have their weapon handling characteristics modified by their skill rank
 * but only if this component is present. Essentially it provides a penalty to gun accuracy at ranks below the "Skill Diff", and a bonus for ranks above it.
 */
/datum/component/skill/firearms
	/**
	 * Accuracy modifier to fired guns per point of "Skill Diff".
	 * As an "Effective increase" in tiles to the target being shot.
	 */
	var/accuracy_per_skill_diff = 0.5

	/**
	 * Dispersion modifier to fired guns per point of "Skill Diff".
	 * As an arc-length in Degrees.
	 */
	var/dispersion_per_skill_diff = 30

	/// %chance per point of "Skill Diff" to fumble changing a weapon's safety.
	var/safety_fumble_per_skill_diff = 15

	/// %chance for a completely untrained person to shoot themself in the foot accidentally.
	var/footgun_chance = 1

/datum/component/skill/firearms/Initialize(var/level = SKILL_LEVEL_UNFAMILIAR)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_accuracy), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE, PROC_REF(safety_fumble), override = TRUE)

/datum/component/skill/firearms/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE)
	return ..()

/datum/component/skill/firearms/proc/handle_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	var/skill_diff = skill_diff_reference - skill_level

	// Count the target as being one tile further away from the shooter
	// per the difference between a skilled professional, and the shooter's skill level
	*accuracy_decrease = *accuracy_decrease + accuracy_per_skill_diff * skill_diff

	// Unskilled shooters get an increased firing arc for their guns
	// to a maximum of 30 degrees when fully untrained.
	*dispersion_increase = *dispersion_increase + dispersion_per_skill_diff * skill_diff

/datum/component/skill/firearms/proc/safety_fumble(mob/shooter, obj/item/gun/shoota, cancelled)
	SIGNAL_HANDLER
	if (cancelled || skill_level >= skill_diff_reference)
		return // Trained and up will never fumble the safety. Except if morale has anything to say about that...

	if (!prob(safety_fumble_per_skill_diff * (skill_diff_reference - skill_level)))
		return // if they pass the skill check.

	*cancelled = TRUE
	shooter.visible_message(
		SPAN_DANGER("\The [shooter] fumbles with \the [shoota]'s safety!"),
		SPAN_DANGER("You fumble with \the [shoota]'s safety!"))
