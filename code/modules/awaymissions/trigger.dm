/obj/effect/step_trigger/teleport_fancy
	var/locationx
	var/locationy
	var/uses = 1	//0 for infinite uses
	var/entersparks = 0
	var/exitsparks = 0
	var/entersmoke = 0
	var/exitsmoke = 0

/obj/effect/step_trigger/teleport_fancy/Trigger(mob/M as mob)
	var/dest = locate(locationx, locationy, z)
	M.Move(dest)

	if(entersparks)
		spark(src, 4, GLOB.alldirs)

	if(exitsparks)
		spark(dest, 4, GLOB.alldirs)

	if(entersmoke)
		var/datum/effect/effect/system/smoke_spread/s = new /datum/effect/effect/system/smoke_spread
		s.set_up(4, 1, src, 0)
		s.start()
	if(exitsmoke)
		var/datum/effect/effect/system/smoke_spread/s = new /datum/effect/effect/system/smoke_spread
		s.set_up(4, 1, dest, 0)
		s.start()

	uses--
	if(uses == 0)
		qdel(src)
