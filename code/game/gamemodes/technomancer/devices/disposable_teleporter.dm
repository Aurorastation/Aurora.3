/datum/technomancer/consumable/disposable_teleporter
	name = "Disposable Teleporter"
	desc = "An ultra-safe teleportation device that can directly teleport you to a number of locations at minimal risk, however \
	it has a limited amount of charges."
	cost = 50
	obj_path = /obj/item/disposable_teleporter

/obj/item/disposable_teleporter
	name = "disposable teleporter"
	desc = "A very compact personal teleportation device.  It's very precise and safe, however it can only be used a few times."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	var/uses = 3.0
	w_class = ITEMSIZE_TINY
	item_state = "paper"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_POWER = 3)

//This one is what the wizard starts with.  The above is a better version that can be purchased.
/obj/item/disposable_teleporter/free
	name = "complimentary disposable teleporter"
	desc = "A very compact personal teleportation device.  It's very precise and safe, however it can only be used once.  This \
	one has been provided to allow you to leave your hideout."
	uses = 1

/obj/item/disposable_teleporter/examine(mob/user)
	..()
	to_chat(user, "[uses] uses remaining.")

/obj/item/disposable_teleporter/attack_self(mob/user as mob)
	if(!uses)
		to_chat(user, "<span class='danger'>\The [src] has ran out of uses, and is now useless to you!</span>")
		return
	else
		var/list/area/valid_areas = list()
		for(var/area/A as anything in the_station_areas)
			if(is_shuttle_area(A))
				continue
			else
				valid_areas += A
		var/area/A = input(user, "Area to teleport to", "Teleportation") as area in valid_areas
		if(!isarea(A) || !(A in the_station_areas))
			return

		if (user.stat || user.restrained())
			return

		if(!((user == loc || (in_range(src, user) && isturf(loc)))))
			return

		spark(src, 5, 0)

		if(user && user.buckled_to)
			user.buckled_to.unbuckle()

		var/list/targets = list()

		//Copypasta
		valid_turfs:
			for(var/turf/simulated/T in A.contents)
				if(T.density || istype(T, /turf/simulated/mineral)) //Don't blink to vacuum or a wall
					continue
				for(var/atom/movable/stuff in T.contents)
					if(stuff.density)
						continue valid_turfs
				targets.Add(T)

		if(!targets.len)
			to_chat(user, "\The [src] was unable to locate a suitable teleport destination, as all the possibilities \
			were nonexistant or hazardous. Try a different area.")
			return
		var/turf/simulated/destination = null

		destination = pick(targets)

		if(destination)
			user.forceMove(destination)
			to_chat(user, "<span class='notice'>You are teleported to \the [A].</span>")
			uses--
			if(uses <= 0)
				to_chat(user, "<span class='danger'>\The [src] has ran out of uses, and disintegrates from your hands.</span>")
				qdel(src)
