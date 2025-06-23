#define NORMAL 0
#define RANGED 1
#define RAPID  2
#define BOMBER 4
#define GUARDIAN 8
#define HARVESTER 16

/mob/living/simple_animal/hostile/hivebotbeacon
	name = "Hivebot beacon"
	desc = "An odd and primitive looking machine. It emanates of strange and powerful energies. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotbeacon_active"
	icon_living = "hivebotbeacon_active"
	health = 300
	maxHealth = 300
	blood_type = COLOR_OIL
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/projectile/beam/hivebot
	wander = 0
	stop_automated_movement = 1
	status_flags = 0
	organ_names = list("head", "core", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	faction = "hivebot"
	ranged = 1
	rapid = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = -10
	destroy_surroundings = 0
	attack_emote = "focuses on"
	psi_pingable = FALSE
	sample_data = null

	/**
	 * Number of total bots that are spawned before the beacon disappears completely
	 *
	 * This gets updated in /Initialize() with a formula based on the
	 * `total_hivebots_to_spawn_to_playing_players_scaling_factor` variable
	 */
	var/total_hivebots_to_spawn = 160

	/**
	 * The scaling factor for the number of total hivebots to spawn respective to playing players
	 *
	 * Eg: scaling factor of 1 would mean that the beacon would spawn 1 additional hivebot per player
	 */
	var/total_hivebots_to_spawn_to_playing_players_scaling_factor = 1

	/**
	 * Number of bots linked to this beacon specifically that can exist, before spawning more is halted
	 *
	 * This gets updated in /Initialize() with a formula based on the
	 * `maximum_linked_and_alive_hivebots_to_playing_players_scaling_factor` variable
	 */
	var/maximum_linked_and_alive_hivebots = 40

	/**
	 * The scaling factor for the maximum number of linked and alive hivebots respective to playing players
	 *
	 * Eg: scaling factor of 1 would mean that the beacon would have one additional linked and alive hivebot per player
	 */
	var/maximum_linked_and_alive_hivebots_to_playing_players_scaling_factor = 1

	///A list of `/mob/living/simple_animal/hostile` hivebots that are linked to this beacon
	var/list/mob/living/simple_animal/hostile/hivebot/linked_bots = list()

	///Amount of hivebots spawned and alive linked to this beacon, guardian type
	var/guard_amt = 0

	///Amount of hivebots spawned and alive linked to this beacon, harvester type
	var/harvester_amt = 0

	///Calculated delay between spawning new bots, internal use only
	VAR_PRIVATE/spawn_delay

	/**
	 * The scaling factor for the subtraction from the calculated `spawn_delay` based on player count
	 *
	 * Eg: scaling factor of 1 would mean that each player reduces the `spawn_delay` by 1 decisecond
	 *
	 * This only works up to a minumum of 80 deciseconds
	 */
	var/spawn_delay_to_playing_players_scaling_factor = 1.8

	/**
	 * The activation state of the beacon
	 *
	 * FALSE (0) -> beacon is off
	 * TRUE (1) -> beacon is on
	 * -1 -> beacon is disabled and should not be activated (usually for mapping purposes)
	 */
	var/activated = 0

	///Boolean, if the maximum number of bots has been reached, internal use only
	VAR_PRIVATE/maximum_linked_and_alive_hivebots_reached

	var/list/destinations = list()
	var/list/close_destinations = list()
	var/area/latest_area

/mob/living/simple_animal/hostile/hivebotbeacon/Initialize(mapload)
	. = ..()

	//Calculate the actual values based on player population, but only if it's on the main map (most likely the Horizon)
	if(is_station_level(src.z))
		total_hivebots_to_spawn = total_hivebots_to_spawn + (length(GLOB.player_list) * total_hivebots_to_spawn_to_playing_players_scaling_factor)
		maximum_linked_and_alive_hivebots = maximum_linked_and_alive_hivebots + (length(GLOB.player_list) * maximum_linked_and_alive_hivebots_to_playing_players_scaling_factor)

	if(!mapload)
		var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
		S.set_up(5, 0, src.loc)
		S.start()
		visible_message(SPAN_DANGER("[src] warps in!"))
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
		addtimer(CALLBACK(src, PROC_REF(activate_beacon)), 450)

	latest_area = get_area(src)
	icon_state = "hivebotbeacon_off"
	addtimer(CALLBACK(src, PROC_REF(generate_warp_destinations)), 10) //So we don't sleep during init
	set_light(6,0.5,LIGHT_COLOR_GREEN)

/mob/living/simple_animal/hostile/hivebotbeacon/Destroy()
	//Remove the reference from all linked bots to us
	for(var/mob/living/simple_animal/hostile/hivebot/latest_child in linked_bots)
		latest_child.linked_parent = null
	linked_bots.Cut()

	//Smoke effect, we disappear in a smoke
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, src.loc)
	S.start()

	. = ..()

/mob/living/simple_animal/hostile/hivebotbeacon/proc/generate_warp_destinations()

	destinations.Cut()
	for(var/turf/simulated/floor/T in circle_range(src,10))
		if(turf_clear(T))
			destinations += T
	var/area/A = get_area(src)
	if(!!is_station_level(A.z))
		var/list/area_turfs = get_area_turfs(A)
		var/list/floor_turfs = list()
		for(var/turf/simulated/floor/T in (area_turfs))
			if(turf_clear(T))
				floor_turfs += T
		if(floor_turfs.len)
			destinations |= floor_turfs

	close_destinations.Cut()
	for(var/turf/simulated/floor/T in oview(src,5))
		if(turf_clear(T))
			close_destinations += T
	if(!close_destinations.len)
		close_destinations += src.loc

	latest_area = get_area(src)

/mob/living/simple_animal/hostile/hivebotbeacon/death()
	..(null,"blows apart and erupts in a cloud of noxious smoke!")
	new /obj/effect/decal/cleanable/greenglow(src.loc)
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, GLOB.alldirs)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebotbeacon/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE && activated == 0)
		activate_beacon()
	else if(activated == 1 && icon_state != "hivebotbeacon_active")
		icon_state = "hivebotbeacon_active"

/mob/living/simple_animal/hostile/hivebotbeacon/MoveToTarget()
	if(!stop_automated_movement)
		stop_automated_movement = 1
	if(QDELETED(last_found_target) || SA_attackable(last_found_target))
		LoseTarget()
	if(!see_target(last_found_target))
		LoseTarget()
	if(last_found_target in targets)
		if(get_dist(src, last_found_target) <= 6)
			GLOB.move_manager.stop_looping(src)
			OpenFire(last_found_target)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/activate_beacon()
	if(activated != 1)
		if(activated == -1)
			return
		else
			visible_message(SPAN_WARNING("[src] suddenly activates!"))
			icon_state = "hivebotbeacon_raising"
			sleep(16)
			icon_state = "hivebotbeacon_active"
			sleep(4)
			activated = 1
			warpbots()

/mob/living/simple_animal/hostile/hivebotbeacon/AirflowCanMove(n)
	return 0

/mob/living/simple_animal/hostile/hivebotbeacon/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike) || istype(hitting_projectile, /obj/projectile/beam/hivebot))
		return BULLET_ACT_BLOCK
	else
		. = ..()

/mob/living/simple_animal/hostile/hivebotbeacon/emp_act(severity)
	. = ..()

	if(activated != -1)
		LoseTarget()
		change_stance(HOSTILE_STANCE_TIRED)
		icon_state = "hivebotbeacon_off"
		activated = -1
		addtimer(CALLBACK(src, PROC_REF(wakeup)), 900)

	var/area/random_area = random_station_area(TRUE)
	var/turf/random_turf = random_area.random_space()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, src.loc)
	S.start()

	if(random_turf)
		visible_message(SPAN_DANGER("[src] disappears in a cloud of smoke!"))
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/wakeup()
	change_stance(HOSTILE_STANCE_IDLE)
	activated = 0
	activate_beacon()

/mob/living/simple_animal/hostile/hivebotbeacon/proc/warpbots()
	if(!total_hivebots_to_spawn)
		visible_message(SPAN_DANGER("[src] disappears in a cloud of smoke!"))
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		new /obj/effect/decal/cleanable/greenglow(src.loc)
		qdel(src)
		return

	if(activated == -1)
		return

	if(linked_bots.len < maximum_linked_and_alive_hivebots)
		visible_message(SPAN_WARNING("[src] radiates with energy!"))

		var/bot_type

		if(guard_amt < 4 && prob(50))
			bot_type = GUARDIAN
		else
			var/selection = rand(1,100)
			switch(selection)
				if(1 to 70)
					bot_type = NORMAL
				if(71 to 82)
					bot_type = RANGED
				if(83 to 92)
					bot_type = RAPID
				if(93 to 100)
					bot_type = BOMBER

		if(guard_amt == 4 && !harvester_amt && stance == HOSTILE_STANCE_IDLE && prob(10))
			bot_type = HARVESTER

		if(latest_area != get_area(src))
			generate_warp_destinations()

		var/turf/Destination
		if(stance == HOSTILE_STANCE_IDLE && !(linked_bots.len < 10))
			Destination = pick(destinations)
		else
			Destination = pick(close_destinations)

		var/mob/living/simple_animal/hostile/hivebot/latest_child
		switch(bot_type)
			if(NORMAL)
				latest_child = new /mob/living/simple_animal/hostile/hivebot(Destination, src)
			if(RANGED)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/range(Destination, src)
			if(RAPID)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/range/rapid(Destination, src)
			if(BOMBER)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/bomber(Destination, src)
			if(GUARDIAN)
				Destination = null
				for(var/check_dir in GLOB.cardinals)
					var/turf/T = get_step(src, check_dir)
					if(turf_clear(T))
						Destination = T
						break
				if(!Destination)
					Destination = pick(close_destinations)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/guardian(Destination, src)
			if(HARVESTER)
				Destination = pick(close_destinations)
				latest_child = new /mob/living/simple_animal/hostile/retaliate/hivebotharvester(Destination, src)

		linked_bots += latest_child //Adds the spawned hivebot to the list of the beacon's children.
		latest_child.faction = faction
		total_hivebots_to_spawn--

	if(total_hivebots_to_spawn>0 && linked_bots.len < maximum_linked_and_alive_hivebots)
		calc_spawn_delay()
		addtimer(CALLBACK(src, PROC_REF(warpbots)), spawn_delay)
	else
		maximum_linked_and_alive_hivebots_reached = 1

/mob/living/simple_animal/hostile/hivebotbeacon/proc/calc_spawn_delay()
	spawn_delay = 80 * (1.085 ** (linked_bots.len + 1))

	//Adapt the value based on player population, but only if it's on the main map (most likely the Horizon)
	if(is_station_level(src.z))
		spawn_delay = min(80, spawn_delay - (length(GLOB.player_list) * spawn_delay_to_playing_players_scaling_factor))

	return

/mob/living/simple_animal/hostile/hivebotbeacon/Life(seconds_per_tick, times_fired)
	..()
	if(wander)
		wander = 0
		stop_automated_movement = 1
	if(maximum_linked_and_alive_hivebots_reached && activated == 1 && linked_bots.len < maximum_linked_and_alive_hivebots)
		maximum_linked_and_alive_hivebots_reached = 0
		calc_spawn_delay()
		addtimer(CALLBACK(src, PROC_REF(warpbots)), spawn_delay)

/*################
	SUBTYPES
################*/

/mob/living/simple_animal/hostile/hivebotbeacon/incendiary
	projectiletype = /obj/projectile/beam/hivebot/incendiary
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	rapid = 0

#undef NORMAL
#undef RANGED
#undef RAPID
#undef BOMBER
#undef GUARDIAN
#undef HARVESTER
