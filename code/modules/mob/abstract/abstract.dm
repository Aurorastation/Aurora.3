/mob/abstract
	name = "abstract mob"
	status_flags = GODMODE
	invisibility = INVISIBILITY_ABSTRACT

	density = FALSE
	anchored = TRUE
	simulated = FALSE

	mob_thinks = FALSE

	var/allow_falling = FALSE

/mob/abstract/dust()
	return

/mob/abstract/gib()
	return

/mob/abstract/can_fall()
	. = allow_falling ? ..() : FALSE

/mob/abstract/conveyor_act()
	return

/mob/abstract/ex_act(var/severity = 2.0)
	return

/mob/abstract/singularity_act()
	return

/mob/abstract/singularity_pull()
	return

/mob/abstract/singuloCanEat()
	return FALSE
