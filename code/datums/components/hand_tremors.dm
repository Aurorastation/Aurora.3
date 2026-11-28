/// Component used by the Hand Tremors quirk to penalize fine motor tasks and periodically cause spasms that drop held items.
/datum/component/hand_tremors
	/// The human mob this component is attached to.
	var/mob/living/carbon/human/owner
	/// Timestamp (deciseconds) when the next hand tremor spasm will occur.
	var/next_tremor_time = 0
	/// Minimum interval between hand tremor spasms.
	var/min_tremor_time = 1 MINUTE
	/// Maximum interval between hand tremor spasms.
	var/max_tremor_time = 3 MINUTES

	/// Effective tile distance penalty added to firearm shots.
	var/accuracy_penalty = 1.5
	/// Arc-length dispersion in degrees added to firearm shots.
	var/dispersion_penalty = 20
	/// Percent chance to fumble toggling a gun's firing mode.
	var/safety_fumble_chance = 20
	/// Multiplier applied to surgery success rate.
	var/surgery_success_mult = 0.85
	/// Multiplier applied to surgery step duration.
	var/surgery_duration_mult = 1.25

/datum/component/hand_tremors/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	owner = parent
	next_tremor_time = REALTIMEOFDAY + rand(min_tremor_time, max_tremor_time)
	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_gun_accuracy), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE, PROC_REF(handle_safety_fumble), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers), override = TRUE)
	START_PROCESSING(SSprocessing, src)

/datum/component/hand_tremors/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(parent)
		UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
		UnregisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE)
		UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	owner = null
	return ..()

/datum/component/hand_tremors/process(seconds_per_tick)
	if(!owner || owner.stat != CONSCIOUS)
		return
	if(REALTIMEOFDAY < next_tremor_time)
		return

	next_tremor_time = REALTIMEOFDAY + rand(min_tremor_time, max_tremor_time)
	var/dropped_anything = FALSE
	if(owner.l_hand && owner.unEquip(owner.l_hand))
		dropped_anything = TRUE
	if(owner.r_hand && owner.unEquip(owner.r_hand))
		dropped_anything = TRUE

	if(dropped_anything)
		owner.visible_message(
			SPAN_WARNING("[owner]'s hands spasm violently!"),
			SPAN_WARNING("Your hands spasm violently, forcing you to drop what you were holding!")
		)
	else
		owner.visible_message(
			SPAN_NOTICE("[owner]'s hands tremble..."),
			SPAN_NOTICE("Your hands tremble...")
		)

/datum/component/hand_tremors/proc/handle_gun_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	*accuracy_decrease = *accuracy_decrease + accuracy_penalty
	*dispersion_increase = *dispersion_increase + dispersion_penalty

/datum/component/hand_tremors/proc/handle_safety_fumble(mob/shooter, obj/item/gun/shoota, cancelled)
	SIGNAL_HANDLER
	if(cancelled || !prob(safety_fumble_chance))
		return
	*cancelled = TRUE

/datum/component/hand_tremors/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	*success_rate = *success_rate * surgery_success_mult
	*duration = *duration * surgery_duration_mult
