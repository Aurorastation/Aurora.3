//	Observer Pattern Implementation: Sight Set
//		Registration type: /mob
//
//		Raised when: A mob's sight value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its sight set
//			/old_sight: sight before the change
//			/new_sight: sight after the change

GLOBAL_DATUM_INIT(sight_set_event, /singleton/observ/sight_set, new)


/singleton/observ/sight_set
	name = "Sight Set"
	expected_type = /mob

/*********************
* Sight Set Handling *
*********************/

/mob/proc/set_sight(var/new_sight)
	var/old_sight = sight
	if(old_sight != new_sight)
		sight = new_sight
		GLOB.sight_set_event.raise_event(src, old_sight, new_sight)
		SEND_SIGNAL(src, COMSIG_MOB_SIGHT_CHANGE, new_sight, old_sight)

/mob/proc/add_sight(new_sight)
	set_sight(sight | new_sight)

/mob/proc/clear_sight(old_sight)
	set_sight(sight & ~old_sight)
