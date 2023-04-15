/*
	This component is used on airlocks and cult runes.
	When a mob [attack_hand]s a turf, it will look for objects in itself containing this component.
	If such is found, it will call attack_hand on that atom

	When multiple of these components are in the tile, the one with the highest priority wins it.
*/
/datum/component/turf_hand
	var/priority = 1
	var/atom/our_owner

/datum/component/turf_hand/Initialize(var/priority = 1)
	..()
	if(isatom(parent))
		our_owner = parent
	src.priority = priority

/datum/component/turf_hand/proc/OnHandInterception(var/mob/user)
	return our_owner.attack_hand(user)