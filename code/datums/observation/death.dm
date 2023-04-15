//	Observer Pattern Implementation: Death
//		Registration type: /mob
//
//		Raised when: A mob is added to the dead_mob_list
//
//		Arguments that the called proc should expect:
//			/mob/dead: The mob that was added to the dead_mob_list

var/singleton/observ/death/death_event = new()

/singleton/observ/death
	name = "Death"
	expected_type = /mob

/*****************
* Death Handling *
*****************/

/mob/living/add_to_dead_mob_list()
	. = ..()
	if(.)
		death_event.raise_event(src)
