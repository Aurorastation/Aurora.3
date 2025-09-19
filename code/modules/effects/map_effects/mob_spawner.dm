/obj/effect/fauna_spawner
	name = "Mob spawner"
	desc = "A mob spawner you're not supposed to see"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "ghostspawpoint"

	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

	var/first_spawn_done = FALSE // Keeping this false will make it so that it always spawns the first mob on the list first
	var/spawning_enabled = FALSE
	var/list/active_mobs = list()
	var/max_active_mobs = 5
	var/list/mob_choices = list() // List of mobs it'll spawn
	var/obj/effect/landmark/mob_waypoint/waypoint = null // The spawner automatically detects a waypoint on the same z-level, no need to set this manually

/obj/effect/fauna_spawner/Initialize()
	. = ..()
	var/obj/effect/landmark/mob_waypoint/W = locate(/obj/effect/landmark/mob_waypoint) in world
	RegisterSignal(GLOB, COMSIG_GLOB_MOB_DEATH, PROC_REF(mob_died))
	if (W && W.z == src.z)
		waypoint = W
	if(!islist(GLOB.fauna_spawners))
		GLOB.fauna_spawners = list()
	GLOB.fauna_spawners |= src

/obj/effect/fauna_spawner/Destroy()
	UnregisterSignal(GLOB, COMSIG_GLOB_MOB_DEATH, PROC_REF(mob_died))
	if(islist(GLOB.fauna_spawners))
		GLOB.fauna_spawners -= src
	return ..()

/obj/effect/fauna_spawner/proc/start_spawning()
	if (spawning_enabled)
		return
	spawning_enabled = TRUE
	spawn()
		while (spawning_enabled && src)
			for (var/i = length(active_mobs); i >= 1; i--)
				var/mob/living/M = active_mobs[i]
				if (!M || QDELETED(M) || M.stat == DEAD)
					active_mobs.Cut(i, i+1)
			if (length(active_mobs) < max_active_mobs)
				spawn_mob()
			sleep(rand(5 SECONDS, 10 SECONDS))

/obj/effect/fauna_spawner/proc/spawn_mob()
	if (!mob_choices || !length(mob_choices))
		return
	var/mob_type
	var/move_speed = 5
	var/choice
	if (!first_spawn_done)
		choice = mob_choices[1]
		first_spawn_done = TRUE
	else
		choice = pick(mob_choices)
	if (islist(choice))
		mob_type = choice["type"]
		move_speed = choice["speed"]
	else
		mob_type = choice
	var/mob/living/new_mob = new mob_type(src.loc)
	if (!new_mob)
		return
	active_mobs += new_mob
	RegisterSignal(new_mob, COMSIG_GLOB_MOB_DEATH, PROC_REF(mob_died))
	if (src.waypoint && istype(new_mob, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = new_mob
		H.target_waypoint = src.waypoint
		spawn()
			if (isturf(src.waypoint.loc))
				GLOB.move_manager.move_towards(H, src.waypoint.loc, move_speed, TRUE)

/obj/effect/fauna_spawner/proc/mob_died(var/mob/living/mob_ref, gibbed)
	for (var/i = length(active_mobs); i >= 1; i--)
		var/mob/living/M = active_mobs[i]
		if (!M || QDELETED(M) || M.stat == DEAD)
			active_mobs.Cut(i, i+1)
	if (mob_ref in active_mobs)
		active_mobs -= mob_ref

/obj/effect/fauna_spawner/proc/stop_spawning()
	spawning_enabled = FALSE

/proc/activate_fauna_spawners(var/z)
	if(!islist(GLOB.fauna_spawners) || !length(GLOB.fauna_spawners))
		return
	for(var/obj/effect/fauna_spawner/S in GLOB.fauna_spawners)
		if(S?.loc?.z == z)
			S.start_spawning()

//Make your subtypes here
/obj/effect/fauna_spawner/phoron_deposit
	name = "Phoron Deposit Spawner"
	mob_choices = list(
		list(type = /mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit, speed = 5), //Speed refers only to the speed that the mobs will move to the waypoint at. Lower values = faster
		list(type = /mob/living/simple_animal/hostile/carp/shark/phoron_deposit, speed = 4),
		list(type = /mob/living/simple_animal/hostile/carp/shark/reaver/phoron_deposit, speed = 5),
		list(type = /mob/living/simple_animal/hostile/gnat/phoron_deposit, speed = 1),
		list(type = /mob/living/simple_animal/hostile/carp, speed = 2)
	)

/obj/effect/landmark/mob_waypoint
	name = "mob waypoint"
