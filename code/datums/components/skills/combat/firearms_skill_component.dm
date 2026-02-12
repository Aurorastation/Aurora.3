/**
 * Component used for the Firearms skill. Mobs with this component will have their weapon handling characteristics modified by their skill rank
 * but only if this component is present.
 */
#define FIREARMS_SKILL_COMPONENT /datum/component/skill/firearms
/datum/component/skill/firearms
	/**
	 * Reference value used for checking "Skill Diff"
	 * "Skill Diff" is the distance from the actual skill level to the reference.
	 */
	var/skill_diff_reference = SKILL_LEVEL_TRAINED

	/**
	 * Accuracy modifier to fired guns per point of "Skill Diff".
	 * As an "Effective increase" in tiles to the target being shot.
	 */
	var/accuracy_per_skill_diff = 1

	/**
	 * Dispersion modifier to fired guns per point of "Skill Diff".
	 * As an arc-length in Degrees.
	 */
	var/dispersion_per_skill_diff = 15

	/// %chance per point of "Skill Diff" to fumble changing a weapon's safety.
	var/safety_fumble_per_skill_diff = 15

	/// %chance for a completely untrained person to shoot themself in the foot accidentally.
	var/footgun_chance = 1

/datum/component/skill/firearms/Initialize(var/level = SKILL_LEVEL_UNFAMILIAR)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_GUN_SPECIAL_CHECK, PROC_REF(handle_footgun), override = TRUE)
	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_accuracy), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE, PROC_REF(safety_fumble), override = TRUE)

/datum/component/skill/firearms/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_GUN_SPECIAL_CHECK)
	UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE)
	return ..()

/datum/component/skill/firearms/proc/handle_footgun(var/mob/shooter, var/footgun_chance)
	SIGNAL_HANDLER
	if (skill_level != SKILL_LEVEL_UNFAMILIAR)
		return

	*footgun_chance += footgun_chance

/datum/component/skill/firearms/proc/handle_accuracy(var/mob/shooter, var/accuracy_decrease, var/dispersion_increase)
	SIGNAL_HANDLER
	var/skill_diff = skill_diff_reference - skill_level

	// Count the target as being one tile further away from the shooter
	// per the difference between a skilled professional, and the shooter's skill level
	*accuracy_decrease += accuracy_per_skill_diff * skill_diff

	// Unskilled shooters get an increased firing arc for their guns
	// to a maximum of 30 degrees when fully untrained.
	*dispersion_increase += dispersion_per_skill_diff * skill_diff

/datum/component/skill/firearms/proc/safety_fumble(var/mob/shooter, var/obj/item/gun/shoota, var/cancelled)
	SIGNAL_HANDLER
	if (skill_level >= skill_diff_reference)
		return // Trained and up will never fumble the safety.

	if (!prob(safety_fumble_per_skill_diff * (skill_diff_reference - skill_level)))
		return // if they pass the skill check.

	*cancelled = TRUE
	shooter.visible_message(
			SPAN_DANGER("<b>\The [shooter] fumbles with \the [shoota]'s safety!</b>"),
			SPAN_DANGER("<b>You fumble with \the [shoota]'s safety!"))
