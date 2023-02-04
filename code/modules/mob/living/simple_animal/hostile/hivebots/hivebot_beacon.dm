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
	projectiletype = /obj/item/projectile/beam/hivebot
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
	see_in_dark = 8
	destroy_surroundings = 0
	var/bot_type
	var/bot_amt = 160 //Number of total bots that are spawned before the beacon disappears completely.
	var/max_bots = 40 //Number of bots linked to this beacon specifically that can exist, before spawning more is halted.
	var/list/linked_bots = list()
	var/guard_amt = 0
	var/harvester_amt = 0
	var/spawn_delay
	var/activated = 0
	var/max_bots_reached
	var/list/destinations = list()
	var/list/close_destinations = list()
	var/area/latest_area
	attack_emote = "focuses on"
	psi_pingable = FALSE

/mob/living/simple_animal/hostile/hivebotbeacon/incendiary
	projectiletype = /obj/item/projectile/beam/hivebot/incendiary
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	rapid = 0

/mob/living/simple_animal/hostile/hivebotbeacon/Initialize(mapload)
	.=..()
	if(!mapload)
		var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
		S.set_up(5, 0, src.loc)
		S.start()
		visible_message(SPAN_DANGER("[src] warps in!"))
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
		addtimer(CALLBACK(src, PROC_REF(activate_beacon)), 450)
	latest_area = get_area(src)
	icon_state = "hivebotbeacon_off"
	generate_warp_destinations()
	set_light(6,0.5,LIGHT_COLOR_GREEN)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/generate_warp_destinations()

	destinations.Cut()
	for(var/turf/simulated/floor/T in circle_range(src,10))
		if(turf_clear(T))
			destinations += T
	var/area/A = get_area(src)
	if(!isNotStationLevel(A.z))
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
	spark(T, 3, alldirs)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebotbeacon/Destroy()
	for (var/mob/living/simple_animal/hostile/hivebot/latest_child in linked_bots)
		latest_child.linked_parent = null
	linked_bots.Cut()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, src.loc)
	S.start()
	.=..()

/mob/living/simple_animal/hostile/hivebotbeacon/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE && activated == 0)
		activate_beacon()
	else if(activated == 1 && icon_state != "hivebotbeacon_active")
		icon_state = "hivebotbeacon_active"

/mob/living/simple_animal/hostile/hivebotbeacon/MoveToTarget()
	if(!stop_automated_movement)
		stop_automated_movement = 1
	if(QDELETED(target_mob) || SA_attackable(target_mob))
		LoseTarget()
	if(!see_target())
		LoseTarget()
	if(target_mob in targets)
		if(get_dist(src, target_mob) <= 6)
			walk(src, 0)
			OpenFire(target_mob)

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

/mob/living/simple_animal/hostile/hivebotbeacon/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else
		..(Proj)

/mob/living/simple_animal/hostile/hivebotbeacon/emp_act()
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
	if(!bot_amt)
		visible_message(SPAN_DANGER("[src] disappears in a cloud of smoke!"))
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		new /obj/effect/decal/cleanable/greenglow(src.loc)
		qdel(src)
		return

	if(activated == -1)
		return

	if(linked_bots.len < max_bots)
		visible_message(SPAN_WARNING("[src] radiates with energy!"))

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
				for(var/check_dir in cardinal)
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
		bot_amt--

	if(bot_amt>0 && linked_bots.len < max_bots)
		calc_spawn_delay()
		addtimer(CALLBACK(src, PROC_REF(warpbots)), spawn_delay)
	else
		max_bots_reached = 1

/mob/living/simple_animal/hostile/hivebotbeacon/proc/calc_spawn_delay()
	spawn_delay = 80*1.085**(linked_bots.len + 1)
	return

/mob/living/simple_animal/hostile/hivebotbeacon/Life()
	..()
	if(wander)
		wander = 0
		stop_automated_movement = 1
	if(max_bots_reached && activated == 1 && linked_bots.len < max_bots)
		max_bots_reached = 0
		calc_spawn_delay()
		addtimer(CALLBACK(src, PROC_REF(warpbots)), spawn_delay)

#undef NORMAL
#undef RANGED
#undef RAPID
#undef BOMBER
#undef GUARDIAN
#undef HARVESTER
