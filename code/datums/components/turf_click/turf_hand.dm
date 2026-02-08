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
	. = ..()
	if (!parent)
		return

	UnregisterSignal(parent, COMSIG_HANDLE_HAND_INTERCEPTION)

/datum/component/turf_hand/proc/OnHandInterception(var/atom/origin, var/mob/attacker, var/turf/turf)
	if (!isatom(parent))
		qdel(src) // Invalid parent. Make the component kill itself.
		return

	var/atom/owner = parent
	return owner.attack_hand(attacker)
