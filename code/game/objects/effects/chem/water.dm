/obj/effect/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
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

			if(!wet_things(T))
				break

			if(T == get_turf(target))
				break
		sleep(delay)
	if(length(reagents))
		var/mob/M = locate() in get_turf(src)
		if(M)
			reagents.trans_to(M, reagents.total_volume * 0.75)
	sleep(lifespan)
	qdel(src)

//Wets everything in the tile
//A return value of 1 means that the wetting should stop. Either the water ran out or some error ocurred
/**
 * Wets everything in the tile
 *
 * Returns `FALSE` if the water ran out or some error ocurred, or we should stop in general
 */
/obj/effect/effect/water/proc/wet_things(var/turf/T)
	SHOULD_NOT_SLEEP(TRUE)

	if (!reagents || reagents.total_volume <= 0)
		return FALSE


	reagents.touch_turf(T)
	var/list/mobshere = list()
	for(var/atom/atom_in_turf as anything in T)
		if(isliving(atom_in_turf))
			mobshere.Add(atom_in_turf)
		else if(!ismob(atom_in_turf))
			reagents.touch(atom_in_turf)

	if(length(mobshere))
		var/portion = 1 / length(mobshere)
		var/total = reagents.total_volume
		for(var/mob/living/mobsphere_living_mob as anything in mobshere)
			reagents.splash(mobsphere_living_mob, total * portion)
		return FALSE

	return TRUE


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
