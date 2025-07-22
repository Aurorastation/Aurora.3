#define ORGAN_CAN_FEEL_PAIN(organ) !BP_IS_ROBOTIC(organ) && (!organ.species || !(organ.species.flags & NO_PAIN))
#define ORGAN_IS_DISLOCATED(organ) (organ.dislocated > 0)
#define SOCKET_UNSHIELDED 0
#define SOCKET_SHIELDED 1
#define SOCKET_FULLSHIELDED 2

// Heart signals
/**
 * Raised on an entity whose heart is attempting to pump blood.
 * The original heart is passed in and null checked, so Registers won't need to check it elsewhere.
 * I have no way of making the heart variables private set, so the onus is on you dear contributor not to set them by event. I've set aside three variables for you to touch instead.
 * "recent_pump" controls interactions with things like CPR, stabilizer harness
 * "pulse_mod" at this step is equal to 1x, use this to insert any desired pump rate modifications.
 * "min_efficiency" controls the Floor of heart pump rate, particularly when its stopped. Default is 0.5x with CPR, 0.3x without
 */
#define COMSIG_HEART_PUMP_EVENT "heart_pump_event"

/**
 * Raised on an entity whose blood is attempting to circulate oxygen through the body.
 * "blood_volume" is the percentage of blood vs max blood, between 0 and 100. Don't put it outside those bounds.
 * "blood_volume_mod" is the ratio of oxygen loss to health loss, representing how damaged the circulatory system is as a whole. You can safely multiply against this to include your own modifiers.
 * "oxygenated_add" represents the ratio of internal blood oxygenation to external oxygenation. Such as from Dexalin and Dexplus. Defaults to 0, so additive identity applies.
 */
#define COMSIG_BLOOD_OXYGENATION_EVENT "blood_oxygenation_event"

/**
 * Raised on a heart that is calculating its pulse.
 * "pulse_mod" Additive modifier on the pulse rate, which is an integer. Tightly control this and use it miserly.
 * "is_stable" boolean used by Inaprovaline, but can be used here by anything you want.
 * "oxy" ratio of blood oxygenation to blood volume.
 * "circulation" the percentage of blood remaining in the body from 0 to 100.
 */
#define COMSIG_HEART_PULSE_EVENT "heart_pulse_event"

/**
 * Raised on a heart that is calculating the effects of bleeds.
 */
#define COMSIG_HEART_BLEED_EVENT "heart_bleed_event"

// Liver signals
/**
 * Raised on an entity whose liver is attempting to filter blood.
 */
#define COMSIG_LIVER_FILTER_EVENT "liver_filter_event"
