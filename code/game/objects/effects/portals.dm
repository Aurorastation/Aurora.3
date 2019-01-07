/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it carefully."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0

/obj/effect/portal/Bumped(mob/M as mob|obj)
	set waitfor = FALSE
	src.teleport(M)

/obj/effect/portal/Crossed(AM as mob|obj)
	set waitfor = FALSE
	src.teleport(AM)

/obj/effect/portal/attack_hand(mob/user as mob)
	set waitfor = FALSE
	src.teleport(user)

/obj/effect/portal/New(loc, turf/target, creator=null, lifespan=300)
	..()
	src.target = target
	src.creator = creator

	if(lifespan > 0)
		QDEL_IN(src, lifespan)

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			src.icon_state = "portal1"
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon
