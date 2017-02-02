// -- Spark Procs --
/proc/spark(var/turf/loc, var/amount = 1, var/spread_dirs = null)
	if (!spread_dirs)
		spread_dirs = cardinal
	new /datum/effect_system/sparks(loc, TRUE, amount, spread_dirs)

/proc/get_spark(var/amount = 1, var/spread_dirs = alldirs)
	return new /datum/effect_system/sparks(src, FALSE, amount, spread_dirs)

// -- Spark Datum --
/datum/effect_system/sparks
	var/amount = 1 				// How many sparks should we make
	var/list/spread = list()	// Which directions we should create sparks.
	var/turf/location 			// Where the effect is

// Using the spark procs is preferred to directly instancing this.
/datum/effect_system/sparks/New(var/atom/movable/loc, var/start_immediately = TRUE, var/amt = 1, var/list/spread_dirs = list())
	if(!loc || loc.gcDestroyed)
		return

	if (istype(loc, /turf))
		location = loc
	else
		location = get_turf(loc)
		holder = loc

	if (amt)
		amount = amt

	if (spread_dirs.len)
		spread = spread_dirs
		
	..(start_immediately)

/datum/effect_system/sparks/process()
	if (!effect_master)
		CRASH("Effect created without a master!")

	var/total_sparks = 1
	if (holder)
		location = get_turf(holder)

	if (location)
		var/obj/visual_effect/sparks/S = getFromPool(/obj/visual_effect/sparks, location, src, 0) //Trigger one on the tile it's on
		effects_visuals += S	// Queue it.

		while (total_sparks <= amount)
			playsound(location, "sparks", 100, 1)
			var/direction = 0

			if(!spread.len)
				direction = 0
			else
				direction = pick(spread)

			S = getFromPool(/obj/visual_effect/sparks, location, src)
			S.move(direction)	
			effects_visuals += S
			total_sparks++

	return ..()	// Let parent decide if we die or not.

// -- Spark visual_effect --
/obj/visual_effect/sparks
	name = "sparks"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = 1
	mouse_opacity = 0

/obj/visual_effect/sparks/New(var/turf/loc)
	..(loc)
	life_ticks = rand(2,10)

/obj/visual_effect/sparks/tick()
	. = ..()

	var/turf/T = loc
	if(T)
		T.hotspot_expose(1000, 100)

/obj/visual_effect/sparks/proc/move(var/direction)
	spawn (5)
		step(src, direction)
