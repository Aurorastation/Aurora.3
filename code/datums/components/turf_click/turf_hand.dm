/**
 *	This component is used on airlocks and cult runes.
 *	When a mob [attack_hand]s a turf, it will look for objects in itself containing this component.
 *	If such is found, it will call attack_hand on that atom
 */
#define TURF_HAND_COMPONENT /datum/component/turf_hand
/datum/component/turf_hand

/datum/component/turf_hand/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_HANDLE_HAND_INTERCEPTION, PROC_REF(OnHandInterception), override = TRUE)

/datum/component/turf_hand/Destroy()
	if (parent)
		UnregisterSignal(parent, COMSIG_HANDLE_HAND_INTERCEPTION)

	return ..()

/datum/component/turf_hand/proc/OnHandInterception(var/atom/origin, var/mob/attacker, var/turf/turf)
	// SIGNAL_HANDLER
	// For the record you shouldn't comment out SIGNAL_HANDLER on signals for your code.
	// But StrongDMM doesn't care that I'm calling a proc on ASYNC.
	if (!isatom(parent))
		qdel(src) // Invalid parent. Make the component kill itself.
		return

	if (!attacker)
		return

	var/atom/owner = parent
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/atom, attack_hand), attacker)
