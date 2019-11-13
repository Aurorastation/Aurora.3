/obj/item/projectile/bullet/pistol/hivebotspike
	name = "spike"
	damage = 10
	sharp = 1
	embed = 0

/obj/item/projectile/bullet/pistol/hivebotspike/needle
	name = "needle"
	damage = 5

/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebot"
	health = 15
	maxHealth = 15
	harm_intent_damage = 3
	melee_damage_lower = 10
	melee_damage_upper = 10
	break_stuff_probability = 25
	attacktext = "slashed"
	projectilesound = 'sound/weapons/bladeslice.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/hivebotspike
	faction = "hivebot"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	tameable = FALSE
	flying = 1
	see_in_dark = 8
	pass_flags = PASSTABLE
	attack_emote = "focuses on"
	var/mob/living/simple_animal/hostile/hivebotbeacon/linked_parent = null

/mob/living/simple_animal/hostile/hivebot/guardian
	health = 80
	maxHealth = 45
	melee_damage_lower = 20
	melee_damage_upper = 20
	wander = 0
	icon_state = "hivebotguardian"
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind. This one seems to be of a larger design."
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = 0


/mob/living/simple_animal/hostile/hivebot/guardian/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	.=..()
	if(hivebotbeacon && linked_parent)
		linked_parent.guard_amt++

/mob/living/simple_animal/hostile/hivebot/guardian/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE)
		wander = 1

/mob/living/simple_animal/hostile/hivebot/guardian/Destroy()
	.=..()
	if(linked_parent)
		linked_parent.guard_amt--

/mob/living/simple_animal/hostile/hivebot/bomber
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind. This one appears round in design and moves slower than its brethren."
	health = 100
	maxHealth = 100
	icon_state = "hivebotbomber"
	attacktext = "bumped"
	move_to_delay = 8
	var/has_exploded = FALSE

/mob/living/simple_animal/hostile/hivebot/bomber/AttackingTarget()
	..()
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	stop_automated_movement = 1
	wander = 0
	if(!has_exploded)
		playsound(src.loc, 'sound/items/countdown.ogg', 125, 1)
		has_exploded = TRUE
		addtimer(CALLBACK(src, .proc/burst), 20)

/mob/living/simple_animal/hostile/hivebot/bomber/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else if(!has_exploded)
		has_exploded = TRUE
		burst()

/mob/living/simple_animal/hostile/hivebot/bomber/proc/burst()
	fragem(src,10,30,2,3,5,1,0)
	src.gib()

/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with a simple looking launcher sticking out of it. It bears no manufacturer markings of any kind."
	icon_state = "hivebotranged"
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/range/rapid
	projectiletype = /obj/item/projectile/bullet/pistol/hivebotspike/needle
	rapid = 1

//Creates a reference to its parent beacon on init.
/mob/living/simple_animal/hostile/hivebot/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	if(hivebotbeacon)
		linked_parent = hivebotbeacon
	.=..()
	if(!mapload)
		new /obj/effect/effect/smoke(src.loc,30)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/hivebot/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else
		return ..(Proj)

/mob/living/simple_animal/hostile/hivebot/death()
	..(null,"blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/hivebot/Destroy()
	. = ..()
	if(linked_parent)
		linked_parent.linked_bots -= src

/mob/living/simple_animal/hostile/hivebot/think()
	. =..()
	if(stance == HOSTILE_STANCE_IDLE)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_armed"

/mob/living/simple_animal/hostile/hivebot/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/hivebot/AirflowCanMove(n)
	return 0

/mob/living/simple_animal/hostile/hivebot/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, .proc/wakeup), 50)
	visible_message(span("danger","[src] suffers a teleportation malfunction!"))
	playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
	var/turf/random_turf = get_turf(pick(orange(src,7)))
	do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/hivebot/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE

//---Hivebot Beacon---//

/obj/item/projectile/beam/hivebot
	name = "electrical discharge"
	damage = 10
	damage_type = HALLOSS
	taser_effect = 1
	agony = 40
	armor_penetration = 40
	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/hivebot/toxic
	name = "concentrated gamma burst"
	damage = 15
	damage_type = TOX
	irradiate = 30
	taser_effect = 0
	muzzle_type = /obj/effect/projectile/muzzle/bfg
	tracer_type = /obj/effect/projectile/tracer/bfg
	impact_type = /obj/effect/projectile/impact/bfg

/obj/item/projectile/beam/hivebot/incendiary
	name = "archaic energy welder"
	damage_type = BURN
	damage = 20
	incinerate = 10
	taser_effect = 0
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue

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
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/hivebot
	wander = 0
	stop_automated_movement = 1
	status_flags = 0
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

/mob/living/simple_animal/hostile/hivebotbeacon/toxic
	projectiletype = /obj/item/projectile/beam/hivebot/toxic
	projectilesound = 'sound/weapons/laser3.ogg'
	rapid = 0

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
		visible_message(span("danger","[src] warps in!"))
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
		addtimer(CALLBACK(src, .proc/activate_beacon), 450)
	latest_area = get_area(src)
	icon_state = "hivebotbeacon_off"
	generate_warp_destinations()
	set_light(6,0.5,LIGHT_COLOR_GREEN)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/generate_warp_destinations()

	destinations.Cut()
	for(var/turf/simulated/floor/T in circlerange(src,10))
		if(turf_clear(T))
			destinations += T
	var/area/A = get_area(src)
	if(!isNotStationLevel(A.z))
		var/list/area_turfs = get_area_turfs(A, null, 0, FALSE)
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
			visible_message(span("warning","[src] suddenly activates!"))
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
		stance = HOSTILE_STANCE_TIRED
		icon_state = "hivebotbeacon_off"
		activated = -1
		addtimer(CALLBACK(src, .proc/wakeup), 900)

	var/area/random_area = random_station_area(TRUE)
	var/turf/random_turf = random_area.random_space()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, src.loc)
	S.start()

	if(random_turf)
		visible_message(span("danger","[src] disappears in a cloud of smoke!"))
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE
	activated = 0
	activate_beacon()

/mob/living/simple_animal/hostile/hivebotbeacon/proc/warpbots()
	if(!bot_amt)
		visible_message(span("danger","[src] disappears in a cloud of smoke!"))
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		new /obj/effect/decal/cleanable/greenglow(src.loc)
		qdel(src)
		return

	if(activated == -1)
		return

	if(linked_bots.len < max_bots)
		visible_message(span("warning","[src] radiates with energy!"))

		if(guard_amt < 4)
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
		if(stance == HOSTILE_STANCE_IDLE && !(linked_bots.len < 12))
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
		addtimer(CALLBACK(src, .proc/warpbots), spawn_delay)
	else
		max_bots_reached = 1

/mob/living/simple_animal/hostile/hivebotbeacon/proc/calc_spawn_delay()
	spawn_delay = 60*1.085**(linked_bots.len + 1)
	return

/mob/living/simple_animal/hostile/hivebotbeacon/Life()
	..()
	if(wander)
		wander = 0
		stop_automated_movement = 1
	if(max_bots_reached && activated == 1 && linked_bots.len < max_bots)
		max_bots_reached = 0
		calc_spawn_delay()
		addtimer(CALLBACK(src, .proc/warpbots), spawn_delay)

#undef NORMAL
#undef RANGED
#undef RAPID
#undef BOMBER
#undef GUARDIAN
#undef HARVESTER


//---Hivebot Harvester---//

/obj/item/projectile/beam/hivebot/incendiary/heavy
	name = "archaic mining laser"
	damage = 25
	incinerate = 10

/mob/living/simple_animal/hostile/retaliate/hivebotharvester
	name = "Hivebot Harvester"
	desc = "An odd and primitive looking machine. It emanates of powerful thermal radiation. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotharvester"
	health = 100
	maxHealth = 100
	harm_intent_damage = 3
	melee_damage_lower = 30
	melee_damage_upper = 30
	destroy_surroundings = 0
	wander = 0
	ranged = 1
	rapid = 1
	attacktext = "skewered"
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	projectiletype = /obj/item/projectile/beam/hivebot/incendiary/heavy
	faction = "hivebot"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	tameable = FALSE
	flying = 1
	mob_size = MOB_LARGE
	see_in_dark = 8
	pass_flags = PASSTABLE
	attack_emote = "focuses on"
	var/mob/living/simple_animal/hostile/hivebotbeacon/linked_parent = null
	var/turf/last_processed_turf
	var/turf/last_prospect_target
	var/turf/last_prospect_loc
	var/busy

	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = 0

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	if(hivebotbeacon)
		linked_parent = hivebotbeacon
		linked_parent.harvester_amt ++
	.=..()
	set_light(3,2,LIGHT_COLOR_RED)
	if(!mapload)
		new /obj/effect/effect/smoke(src.loc,30)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/death()
	..(null,"teleports away!")
	if(linked_parent)
		linked_parent.harvester_amt --
	new /obj/effect/effect/smoke(src.loc,30)
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Destroy()
	. = ..()
	if(linked_parent)
		linked_parent.linked_bots -= src

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/AirflowCanMove(n)
	return 0

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else
		return ..(Proj)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	visible_message(span("danger","[src] suffers a teleportation malfunction!"))
	playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
	var/turf/random_turf = get_turf(pick(orange(src,7)))
	do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/think()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			if(last_processed_turf == src.loc)
				INVOKE_ASYNC(src, .proc/prospect)
			else
				INVOKE_ASYNC(src, .proc/process_turf)
		else if(busy)
			busy = 0
			update_icon()
	if(wander)
		wander = 0

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/proc/process_turf()
	if(busy)
		return
	for(var/obj/O in src.loc)
		if(istype(O, /obj/item))
			var/obj/item/I = O
			for(I in src.loc)

				if(I.matter)
					busy = 1
					update_icon()
					src.visible_message(span("notice","[src] begins to harvest \the [I]."))
					if(do_after(src, 32))
						src.visible_message(span("warning","[src] harvests \the [I]."))
						qdel(I)
					busy = 0
					update_icon()
					continue

				if(istype(O, /obj/item/storage))
					var/obj/item/storage/S = O
					src.visible_message(span("notice","[src] begins to rip apart \the [S]."))
					busy = 2
					update_icon()
					if(do_after(src, 32))
						src.visible_message(span("warning","[src] rips \the [S] apart."))
						S.spill(3, src.loc)
						qdel(S)
					busy = 0
					update_icon()
					return

		if(istype(O, /obj/structure/table))
			var/obj/structure/table/TB = O
			src.visible_message(span("notice","[src] starts to dismantle \the [TB]."))
			busy = 2
			update_icon()
			if(do_after(src, 48))
				src.visible_message(span("warning","[src] dismantles \the [TB]."))
				TB.break_to_parts(1)
			busy = 0
			update_icon()
			return

		if(istype(O, /obj/structure/bed))
			var/obj/structure/bed/B = O
			if(B.can_dismantle)
				src.visible_message(span("notice","[src] starts to dismantle \the [B]."))
				busy = 2
				update_icon()
				if(do_after(src, 48))
					src.visible_message(span("warning","[src] dismantles \the [B]."))
					B.dismantle()
					qdel(B)
				busy = 0
				update_icon()
				return

		if(istype(O, /obj/item/stool))
			var/obj/item/stool/S = O
			src.visible_message(span("notice","[src] starts to dismantle \the [S]."))
			busy = 2
			update_icon()
			if(do_after(src, 32))
				src.visible_message(span("warning","[src] dismantles \the [S]."))
				S.dismantle()
			busy = 0
			update_icon()
			return

		if(istype(O, /obj/effect/decal/cleanable/blood/gibs/robot))
			src.visible_message(span("notice","[src] starts to recycle \the [O]."))
			busy = 1
			update_icon()
			if(do_after(src, 48))
				src.visible_message(span("warning","[src] recycles \the [O]."))
				qdel(O)
			busy = 0
			update_icon()
			continue

		if(istype(O, /obj/structure/cable))
			var/turf/simulated/floor/T = src.loc
			if(T.is_plating())
				var/obj/structure/cable/C = O
				src.visible_message(span("notice","[src] starts ripping up \the [C]."))
				busy = 2
				update_icon()
				if(do_after(src, 32))
					src.visible_message(span("warning","[src] rips \the [C]."))
					if(C.powernet && C.powernet.avail)
						spark(src, 3, alldirs)
					new/obj/item/stack/cable_coil(T, C.d1 ? 2 : 1, C.color)
					qdel(C)
				busy = 0
				update_icon()
				return

	if(istype(src.loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = src.loc
		if(!T.is_plating())
			src.visible_message(span("notice","[src] starts ripping up \the [T]."))
			busy = 2
			update_icon()
			if(do_after(src, 32))
				src.visible_message(span("warning","[src] rips up \the [T]."))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
				T.make_plating(1)
			busy = 0
			update_icon()
			return

	last_processed_turf = src.loc

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/update_icon()
	if(busy)
		if(busy == 1)
			icon_state = "hivebotharvester_harvesting"
		else
			icon_state = "hivebotharvester_ripping"
	else
		icon_state = "hivebotharvester"

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/proc/prospect()

	var/destination
	var/turf/T

	if((!last_prospect_target) || (last_prospect_loc != src.loc))
		destination = pick(cardinal)
		T = get_step(src, destination)
		last_prospect_target = T
		last_prospect_loc = src.loc
		busy = 0
	else
		T = last_prospect_target

	if(busy)
		return

	if(istype(T, /turf/space) || istype(T, /turf/simulated/mineral))
		last_prospect_target = null
		last_prospect_loc = null
		return

	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		OpenFire(W)
		return

	for(var/obj/O in T)
		if(istype(O, /obj/structure/girder))
			var/obj/structure/girder/G = O
			src.visible_message(span("notice","[src] starts to tear \the [O] apart."))
			busy = 1
			if(do_after(src, 32))
				src.do_attack_animation(G)
				src.visible_message(span("warning","[src] tears \the [O] apart!"))
				G.dismantle()
			busy = 0
			continue

		if((istype(O, /obj/machinery/door/firedoor) && O.density) || (istype(O, /obj/machinery/door/airlock) && O.density) || istype(O, /obj/machinery/door/blast) && O.density)
			var/obj/machinery/door/D = O
			if(D.stat & BROKEN)
				src.visible_message(span("notice","[src] starts to tear \the [D] open."))
				busy = 1
				if(do_after(src, 48))
					src.visible_message(span("warning","[src] tears \the [D] apart!"))
					src.do_attack_animation(D)
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					qdel(D)
				busy = 0
			else if(istype(D, /obj/machinery/door/airlock/multi_tile))
				D.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			else
				OpenFire(D)
			return

		if(istype(O, /obj/structure/window))
			var/dir = get_dir(T,src.loc)
			var/obj/structure/window/W = O
			if(W.dir == reverse_dir[dir])
				W.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			else
				W.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			return

		if(istype(O, /obj/structure/grille))
			var/obj/structure/grille/G = O
			G.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			return

		if(istype(O, /obj/structure/barricade) || istype(O, /obj/structure/closet) || istype(O, /obj/structure/inflatable))
			var/obj/structure/S = O
			OpenFire(S)
			return

		if(istype(O, /obj/structure/reagent_dispensers))
			var/obj/structure/reagent_dispensers/RD = O
			src.visible_message(span("notice","[src] starts taking apart \the [RD]."))
			busy = 1
			if(do_after(src, 48))
				src.do_attack_animation(RD)
				RD.reagents.splash_turf(get_turf(RD.loc), RD.reagents.total_volume)
				src.visible_message(span("danger","[RD] gets torn open, spreading its contents all over the area!"))
				new /obj/item/stack/material/steel(get_turf(RD))
				new /obj/item/stack/material/steel(get_turf(RD))
				qdel(RD)
			busy = 0
			return

	if(T)
		Move(T)

	last_prospect_target = null
	last_prospect_loc = null

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/shoot_wrapper(target, location, user)
	target_mob = target
	if(see_target())
		Shoot(target, location, user)
	target_mob = null
	return
