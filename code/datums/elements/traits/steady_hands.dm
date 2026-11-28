/// Element used by the Steady Hands quirk to improve firearm handling and surgery precision.
/datum/element/steady_hands
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Effective tile distance bonus subtracted from firearm accuracy penalty.
	var/accuracy_bonus = 0.75
	/// Arc-length dispersion in degrees subtracted from firearm dispersion.
	var/dispersion_bonus = 10
	/// Multiplier applied to surgery success rate.
	var/surgery_success_mult = 1.1
	/// Multiplier applied to surgery step duration.
	var/surgery_duration_mult = 0.9

/datum/element/steady_hands/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_gun_accuracy))
	RegisterSignal(target, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers))

/datum/element/steady_hands/Detach(datum/target)
	UnregisterSignal(target, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(target, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	return ..()

/datum/element/steady_hands/proc/handle_gun_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	*accuracy_decrease = *accuracy_decrease - accuracy_bonus
	*dispersion_increase = *dispersion_increase - dispersion_bonus

/datum/element/steady_hands/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	*success_rate = *success_rate * surgery_success_mult
	*duration = *duration * surgery_duration_mult
