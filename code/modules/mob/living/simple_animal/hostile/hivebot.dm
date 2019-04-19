#define NORMAL 1
#define RANGED 2
#define RAPID  3

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
	agony = 30
	nodamage = 1
	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/hivebotbeam
	name = "toxic particle burst"
	damage = 7
	damage_type = TOX
	irradiate = 30
	weaken = 3
	stutter = 3
	muzzle_type = /obj/effect/projectile/muzzle/bfg
	tracer_type = /obj/effect/projectile/tracer/bfg
	impact_type = /obj/effect/projectile/impact/bfg

/obj/item/projectile/beam/hivebotincendiary
	name = "archaic energy cutter"
	damage = 5
	incinerate = 3
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue

/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebot"
	health = 15
	maxHealth = 15
	melee_damage_lower = 4
	melee_damage_upper = 5
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
	attack_emote = "focuses on"

/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with a simple looking launcher sticking out of it. It bears no manufacturer markings of any kind."
	icon_state = "hivebotranged"
	ranged = 1
	smart = TRUE

/mob/living/simple_animal/hostile/hivebot/range/rapid
	projectiletype = /obj/item/projectile/bullet/pistol/hivebotspike/needle
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/death()
	..(null,"blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, alldirs)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebot/think()
	. =..()
	if(stance == HOSTILE_STANCE_IDLE)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_armed"

/mob/living/simple_animal/hostile/hivebot/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/hivebot/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, .proc/wakeup), 150)
	if(severity == 1.0)
		apply_damage(5)

/mob/living/simple_animal/hostile/hivebotbeacon
	name = "Hivebot beacon"
	desc = "An odd and primitive looking machine. It emanates of strange and powerful energies. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotbeacon_active"
	icon_living = "hivebotbeacon_active"
	health = 150
	maxHealth = 150
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/hivebotdischarge
	status_flags = 0
	anchored = 1
	stop_automated_movement = 1
	faction = "hivebot"
	ranged = 1
	smart = 1
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
	var/bot_type = NORMAL // type of bot, 1 is normal, 2 is ranged, 3 is rapid ranged
	var/bot_amt = 32
	var/spawn_delay = 10
	var/activated = 0
	attack_emote = "focuses on"
	var/

/mob/living/simple_animal/hostile/hivebotbeacon/toxic
	projectiletype = /obj/item/projectile/beam/hivebotbeam
	projectilesound = 'sound/weapons/laser3.ogg'
	rapid = 0

/mob/living/simple_animal/hostile/hivebotbeacon/incendiary
	projectiletype = /obj/item/projectile/beam/hivebotincendiary
	projectilesound = 'sound/weapons/resonator_blast.ogg'
	rapid = 0

/mob/living/simple_animal/hostile/hivebotbeacon/death()
	..(null,"blows apart and erupts in a cloud of noxious smoke!"
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(10, 0, src.loc)
	S.start()
	new /obj/effect/decal/cleanable/greenglow(src.loc)
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, alldirs)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebotbeacon/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE && activated == 0)
		visible_message("<span class='warning'>\ [src] radiates with energy!</span>")
		icon_state = "hivebotbeacon_raising"
		spawn(16)
		icon_state = "hivebotbeacon_active"
		activated = 1
	else
		if(activated == 1)
			icon_state = "hivebotbeacon_active"

/mob/living/simple_animal/hostile/hivebotbeacon/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/hivebotbeacon/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, .proc/wakeup), 150)
	if(severity == 1.0)
		apply_damage(100)

/mob/living/simple_animal/hostile/hivebotbeacon/New()
	..()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, src.loc)
	S.start()
	icon_state = "hivebotbeacon_off"
	visible_message("<span class='danger'>\ [src] warps in!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/hivebotbeacon/proc/warpbots()

	if(!bot_amt)
		visible_message("<b>The Beacon</b> disappears in a cloud of smoke!")
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
		S.set_up(5, 0, src.loc)
		S.start()
		new /obj/effect/decal/cleanable/greenglow(src.loc)
		qdel(src)

	if(activated != 1)
		icon_state = "hivebotbeacon_raising"
		sleep(16)
		icon_state = "hivebotbeacon_active"
		sleep(4)
		activated = 1

	visible_message("<span class='warning'>\ [src] radiates with energy!</span>")
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(1, 0, src.loc)
	S.start()

	switch(bot_type)
		if(NORMAL)
			new /mob/living/simple_animal/hostile/hivebot(get_turf(src))
		if(RANGED)
			new /mob/living/simple_animal/hostile/hivebot/range(get_turf(src))
		if(RAPID)
			new /mob/living/simple_animal/hostile/hivebot/range/rapid(get_turf(src))

	if(prob(30))
		if(prob(70))
			bot_type = RANGED
		else
			bot_type = RAPID
	else
		bot_type = NORMAL
	bot_amt--
	if(bot_amt>0)
		addtimer(CALLBACK(src, .proc/warpbots), spawn_delay)


/mob/living/simple_animal/hostile/hivebotbeacon/Life()
	..()
	if(stat == 0)
		if(prob(2))//Might be a bit low, will mess with it likely
			warpbots()

#undef NORMAL
#undef RANGED
#undef RAPID
