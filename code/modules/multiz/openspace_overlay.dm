/atom/movable/openspace_overlay
	name = ""
	simulated = FALSE
	anchored = TRUE
	plane = OPENTURF_PLANE

/atom/movable/openspace_overlay/ex_act(ex_sev)
	return

/atom/movable/openspace_overlay/singularity_act()
	return

/atom/movable/openspace_overlay/singularity_pull()
	return

/atom/movable/openspace_overlay/singuloCanEat()
	return

/atom/movable/attackby(obj/item/W, mob/user)
	user << span("notice", "You can't reach that!")

/atom/movable/attack_hand(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/attack_generic(mob/user as mob)
	user << span("notice", "You can't reach that!")
