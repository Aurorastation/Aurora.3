/obj/effect/portal
	name = "portal"
	desc = "A bluespace tear in space, reaching directly to another point within this region. Looks unstable. Best to test it carefully."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = TRUE
	unacidable = TRUE //Can't destroy energy portals.
	var/does_teleport = TRUE // Some portals might just be visual
	var/has_lifespan = TRUE // Whether we want to directly control the lifespan or not
	var/failchance = 5
	var/has_failed = FALSE
	var/obj/target
	var/creator
	var/precision = 1
	anchored = TRUE

/obj/effect/portal/Initialize(mapload, turf/set_target, set_creator, lifespan = 300, precise = 1)
	. = ..()

	if(set_target)
		target = set_target
	if(set_creator)
		creator = set_creator
	if(has_lifespan && lifespan > 0)
		QDEL_IN(src, lifespan)
	if(prob(failchance))
		has_failed = TRUE

	precision = precise

/obj/effect/portal/CollidedWith(mob/M)
	set waitfor = FALSE

	if(does_teleport)
		teleport(M)

/obj/effect/portal/Crossed(AM)
	set waitfor = FALSE

	if(does_teleport)
		teleport(AM)

/obj/effect/portal/attack_hand(mob/user)
	set waitfor = FALSE

	if(does_teleport)
		teleport(user)

/obj/effect/portal/proc/teleport(atom/movable/M)
	if(!does_teleport) // just to be safe
		return
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if(!target)
		qdel(src)
		return
	if(istype(M, /atom/movable))
		if(has_failed) //oh dear a problem, put em in deep space
			icon_state = "portal1" // only tell people the portal failed after a teleport has been done
			desc = "A bluespace tear in space, reaching directly to another point within this region. Definitely unstable."
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			do_teleport(M, target, precision)

/obj/effect/portal/Destroy()
	if(istype(creator, /obj/item/hand_tele))
		var/obj/item/hand_tele/HT = creator
		HT.remove_portal(src)
	return ..()

/obj/effect/portal/spawner
	name = "portal"
	desc = "A bluespace tear in space, reaching directly to another point within this region. This one looks like a one-way portal to here, don't come too close."
	desc_info = "This portal is a spawner portal. You cannot enter it to teleport, but it will periodically spawn things."
	does_teleport = FALSE
	has_lifespan = FALSE
	layer = OBJ_LAYER - 0.01
	var/list/spawn_things = list() // The list things to spawn
	var/num_of_spawns			   // How many times we want to spawn them before qdel
	var/next_spawn

/obj/effect/portal/spawner/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	next_spawn = world.time + 5 SECONDS

/obj/effect/portal/spawner/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/portal/spawner/process()
	if(next_spawn < world.time)
		visible_message(SPAN_WARNING("\The [src] spits something out!"))
		for(var/thing in spawn_things)
			var/spawn_path = text2path(thing)
			var/atom/spawned_thing = new spawn_path(get_turf(src))

			if(istype(spawned_thing, /obj/item/stack))
				var/obj/item/stack/stack = spawned_thing
				stack.amount = spawn_things[thing]
				stack.throw_at(get_random_turf_in_range(get_turf(src), 1), 2)
			else
				for(var/i = 1; i < spawn_things[thing]; i++)
					var/atom/movable/A = new spawn_path(get_turf(src))
					A.throw_at(get_random_turf_in_range(get_turf(src), 1), 2)

		next_spawn = world.time + 30 SECONDS
		num_of_spawns--
	if(num_of_spawns <= 0)
		visible_message(SPAN_WARNING("\The [src] collapses in on itself!"))
		qdel(src)

/obj/effect/portal/spawner/metal
	num_of_spawns = 3
	spawn_things = list(
				"/obj/item/stack/material/steel" = 10,
				"/obj/item/stack/material/plasteel" = 5
					   )

/obj/effect/portal/spawner/rare_metal
	num_of_spawns = 4
	spawn_things = list(
				"/obj/item/stack/material/gold" = 2,
				"/obj/item/stack/material/silver" = 2,
				"/obj/item/stack/material/uranium" = 2,
				"/obj/item/stack/material/diamond" = 1
					   )

/obj/effect/portal/spawner/phoron
	num_of_spawns = 3
	spawn_things = list(
				"/obj/item/stack/material/phoron" = 3
					   )

/obj/effect/portal/spawner/monkey_cube
	num_of_spawns = 1
	spawn_things = list(
					"/obj/item/reagent_containers/food/snacks/monkeycube" = 4
						)

/obj/effect/portal/spawner/cow // debug but funny so im keeping it
	num_of_spawns = 1
	spawn_things = list(
					"/mob/living/simple_animal/cow" = 1
	)
