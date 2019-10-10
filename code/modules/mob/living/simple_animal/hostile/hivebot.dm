/obj/item/projectile/bullet/pistol/hivebotspike
	name = "spike"
	damage = 10
	sharp = 1
	embed = 0

/obj/item/projectile/bullet/pistol/hivebotspike/needle
	name = "needle"
	damage = 5

/obj/item/projectile/beam/hivebotdischarge
	name = "electrical discharge"
	damage = 3
	damage_type = HALLOSS
	taser_effect = 1
	agony = 20
	nodamage = 1
	armor_penetration = 30
	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/hivebotbeam
	name = "concentrated gamma burst"
	damage = 12
	damage_type = TOX
	irradiate = 30
	agony = 30
	armor_penetration = 30
	muzzle_type = /obj/effect/projectile/muzzle/bfg
	tracer_type = /obj/effect/projectile/tracer/bfg
	impact_type = /obj/effect/projectile/impact/bfg

/obj/item/projectile/beam/hivebotincendiary
	name = "archaic energy welder"
	damage = 10
	incinerate = 3
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue

/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebot"
	health = 10
	maxHealth = 10
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
	icon_state = "hivebotguardian"

/mob/living/simple_animal/hostile/hivebot/guardian/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	.=..()
	if(hivebotbeacon && linked_parent)
		linked_parent.guard_amt++

/mob/living/simple_animal/hostile/hivebot/guardian/Destroy()
	if(linked_parent)
		linked_parent.guard_amt--
	..()

/mob/living/simple_animal/hostile/hivebot/bomber
	desc = "Placeholder"
	icon_state = "hivebotbomber"
	attacktext = "bumped"
	move_to_delay = 8

/mob/living/simple_animal/hostile/hivebot/bomber/AttackingTarget()
	..()
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	stop_automated_movement = 1
	wander = 0

	playsound(src.loc, 'sound/items/countdown.ogg', 125, 1)
	spawn(20)
		fragem(src,10,30,2,3,5,1,0)
		src.gib()

/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with a simple looking launcher sticking out of it. It bears no manufacturer markings of any kind."
	icon_state = "hivebotranged"
	ranged = 1
	smart = TRUE

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

/mob/living/simple_animal/hostile/hivebot/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/hivebot/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/hivebot/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, .proc/wakeup), 150)
	if(severity == 1.0)
		apply_damage(10)

#define NORMAL 0
#define RANGED 1
#define RAPID  2
#define BOMBER 4
#define GUARDIAN 8

/mob/living/simple_animal/hostile/hivebotbeacon
	name = "Hivebot beacon"
	desc = "An odd and primitive looking machine. It emanates of strange and powerful energies. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotbeacon_active"
	icon_living = "hivebotbeacon_active"
	health = 200
	maxHealth = 200
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/hivebotdischarge
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
	var/bot_type = GUARDIAN
	var/bot_amt = 96 //Number of total bots that are spawned before the beacon disappears completely.
	var/max_bots = 48 //Number of bots linked to this beacon specifically that can exist, before spawning more is halted.
	var/list/linked_bots = list()
	var/guard_amt = 0
	var/spawn_delay
	var/activated = 0
	var/max_bots_reached
	var/list/destinations = list()
	var/list/close_destinations = list()
	var/area/latest_area
	attack_emote = "focuses on"

/mob/living/simple_animal/hostile/hivebotbeacon/toxic
	projectiletype = /obj/item/projectile/beam/hivebotbeam
	projectilesound = 'sound/weapons/laser3.ogg'
	rapid = 0

/mob/living/simple_animal/hostile/hivebotbeacon/incendiary
	projectiletype = /obj/item/projectile/beam/hivebotincendiary
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	rapid = 0

/mob/living/simple_animal/hostile/hivebotbeacon/Initialize(mapload)
	.=..()
	if(!mapload)
		var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
		S.set_up(5, 0, src.loc)
		S.start()
		visible_message("<span class='danger'>[src] warps in!</span>")
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
		addtimer(CALLBACK(src, .proc/activate_beacon), 300)
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
	for(var/turf/simulated/floor/T in oview(src,3))
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
			visible_message("<span class='warning'>[src] suddenly activates!</span>")
			icon_state = "hivebotbeacon_raising"
			sleep(16)
			icon_state = "hivebotbeacon_active"
			sleep(4)
			activated = 1
			warpbots()

/mob/living/simple_animal/hostile/hivebotbeacon/emp_act()
	if(activated != -1)
		LoseTarget()
		stance = HOSTILE_STANCE_TIRED
		icon_state = "hivebotbeacon_off"
		activated = -1
		addtimer(CALLBACK(src, .proc/wakeup), 600)

	var/area/random_area = random_station_area(TRUE)
	var/turf/random_turf = random_area.random_space()

	if(random_turf)
		do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE
	activated = 0
	activate_beacon()

/mob/living/simple_animal/hostile/hivebotbeacon/proc/warpbots()
	if(!bot_amt)
		visible_message("<span class='danger'>[src] disappears in a cloud of smoke!</span>")
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		new /obj/effect/decal/cleanable/greenglow(src.loc)
		qdel(src)
		return

	if(activated == -1)
		return

	if(linked_bots.len < max_bots)
		visible_message("<span class='warning'>[src] radiates with energy!</span>")

		if(latest_area != get_area(src))
			generate_warp_destinations()

		var/turf/Destination = pick(destinations)

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
				Destination = pick(close_destinations)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/guardian(Destination, src)

		linked_bots += latest_child //Adds the spawned hivebot to the list of the beacon's children.

		if(guard_amt < 4)
			bot_type = GUARDIAN
		else
			var/selection = rand(1,100)
			switch(selection)
				if(1 to 65)
					bot_type = NORMAL
				if(66 to 77)
					bot_type = RANGED
				if(78 to 89)
					bot_type = RAPID
				if(90 to 100)
					bot_type = BOMBER

		message_admins("[bot_type]")
		bot_amt--

	if(bot_amt>0 && linked_bots.len < max_bots)
		calc_spawn_delay()
		message_admins("[spawn_delay]")
		addtimer(CALLBACK(src, .proc/warpbots), spawn_delay)
	else
		max_bots_reached = 1

/mob/living/simple_animal/hostile/hivebotbeacon/proc/calc_spawn_delay()
	spawn_delay = 30*1.075**(linked_bots.len + 1)
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