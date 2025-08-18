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

	/// Cooldown for spawning mobs. A value between min and max will be defined as seconds.
	var/min_spawn_cooldown = 5
	var/max_spawn_cooldown = 10

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
			sleep(rand(min_spawn_cooldown, max_spawn_cooldown) SECONDS)

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

/**
 * Opposed to `fauna_spawner`, this spawner allows further customization and checks over spawned mobs, such as:
 * * Having multiple spawn points, randomly chosen to spawn mobs.
 * * Keeping track of total mob counts inside a single object.
 *
 * How does it work?
 * * This type serves as a single spawner, it detects the spawn points in the same Z level and randomly chooses
 */
/obj/effect/fauna_spawner/organized
	name = "Organized mob spawner"
	desc = "You are not supposed to see this!"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "beam_point"

	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 101

	min_spawn_cooldown = 20
	max_spawn_cooldown = 25
	max_active_mobs = 15

	/// Integer, fixed number of mobs that'll be spawned before spawner enters cooldown.
	var/spawn_points_to_pick

	/// The number range of mobs that can spawn before spawner enters cooldown. Ignored if 'spawn_points_to_pick' isn't null.
	var/min_spawn = 2
	var/max_spawn = 3

	/// If true, object will avoid spawning multiple mobs on the same point.
	var/one_spawn_per_point = FALSE

/obj/effect/fauna_spawner/organized/spawn_mob()
	if (!mob_choices || !length(mob_choices))
		return
	var/obj/effect/landmark/organized_spawn_point/SP
	var/list/available_points = GLOB.organized_spawn_points.Copy() // we make a copy so 'pick_n_take()' doesn't get rid of instances in global list
	var/list/chosen_group = list()
	if(LAZYLEN(available_points))
		var/loop_amount
		var/obj/effect/spawn_point
		loop_amount = !spawn_points_to_pick ? rand(1, 3) : spawn_points_to_pick // if no value is set we will randomly pick a number for each spawn time
		for(var/i in 1 to loop_amount)
			spawn_point = one_spawn_per_point ? pick_n_take(available_points) : pick(available_points)
			if(spawn_point.z == src.z)
				chosen_group += spawn_point

	for(SP in chosen_group) //---- spawning mobs on chosen points
		if(length(active_mobs) >= max_active_mobs) // double check if we exceeded the threshold
			return
		var/turf/T = get_turf(SP)
		var/mob_type
		var/move_speed = 5
		var/choice
		choice = pick(mob_choices)
		if (islist(choice))
			mob_type = choice["type"]
			move_speed = choice["speed"]
		else
			mob_type = choice
		var/mob/living/new_mob = new mob_type(T)
		active_mobs += new_mob

		RegisterSignal(new_mob, COMSIG_GLOB_MOB_DEATH, PROC_REF(mob_died))
		if(src.waypoint && istype(new_mob, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = new_mob
			H.target_waypoint = src.waypoint
			spawn()
				if(isturf(src.waypoint.loc))
					GLOB.move_manager.move_towards(H, src.waypoint.loc, move_speed, TRUE)

// ---- Put your subtypes here

/obj/effect/fauna_spawner/organized/quarantined_outpost
	name = "Quarantined Outpost Spawner"
	mob_choices = list(
		list(type = /mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/horde, speed = 5),
		list(type = /mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/horde, speed = 5)
	)
	one_spawn_per_point = TRUE

/obj/effect/landmark/organized_spawn_point
	name = "spawn point"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "ghostspawpoint"

/obj/effect/landmark/organized_spawn_point/Initialize()
	. = ..()
	GLOB.organized_spawn_points += src

/obj/effect/landmark/organized_spawn_point/Destroy()
	GLOB.organized_spawn_points -= src
	return ..()

/obj/effect/landmark/mob_waypoint
	name = "mob waypoint"
