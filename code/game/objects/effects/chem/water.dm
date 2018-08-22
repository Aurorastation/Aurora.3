/obj/effect/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = 0
	pass_flags = PASSTABLE | PASSGRILLE

/obj/effect/effect/water/New(loc)
	..()
	QDEL_IN(src, 15 SECONDS)	// In case whatever made it forgets to delete it

/obj/effect/effect/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/effect/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5, var/lifespan = 10)
	if(!target)
		return
	for(var/i = 1 to step_count)
		if(!loc)
			return
		step_towards(src, target)
		var/turf/T = get_turf(src)
		if(T && reagents)

			if (wet_things(T))
				break

			if(T == get_turf(target))
				break
		sleep(delay)
	sleep(lifespan)
	qdel(src)

//Wets everything in the tile
//A return value of 1 means that the wetting should stop. Either the water ran out or some error ocurred
/obj/effect/effect/water/proc/wet_things(var/turf/T)

	if (!reagents || reagents.total_volume <= 0)
		return 1


	reagents.touch_turf(T)
	var/list/mobshere = list()
	for (var/mob/living/L in T)
		mobshere.Add(L)


	for (var/atom/B in T)
		if (!ismob(B))
			reagents.touch(B)

	if (mobshere.len)
		var/portion = 1 / mobshere.len
		var/total = reagents.total_volume
		for (var/mob/living/L in mobshere)
			reagents.splash(L, total * portion)
		return 1

	return 0



/obj/effect/effect/water/Move(turf/newloc)
	if(newloc.density)
		return 0
	. = ..()

/obj/effect/effect/water/Collide(atom/A)
	var/turf/T = get_turf(A)
	wet_things(T)
	return ..()

//Used by spraybottles.
/obj/effect/effect/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	icon_state = ""

//used by evil things
/obj/effect/effect/water/firewater
	name = "napalm gel"
	icon_state = "mustard"
