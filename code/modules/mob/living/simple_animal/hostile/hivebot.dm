#define NORMAL 1
#define RANGED 2
#define RAPID  3
#define STRONG 4

/obj/item/projectile/bullet/pistol/hivebotbullet
	name = "hivebot bullet"
	damage = 10
	embed = 0
	sharp = 0
	irradiate = 20

/obj/item/projectile/beam/hivebotlaser
	name = "toxic beam"
	damage = 7
	damage_type = TOX
	irradiate = 20
	stun = 3
	weaken = 3
	stutter = 3
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A small robot"
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebot"
	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = "slashed"
	projectilesound = 'sound/weapons/Gunshot.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/hivebotbullet
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
	desc = "A smallish robot, this one is armed!"
	ranged = 1
	smart = TRUE

/mob/living/simple_animal/hostile/hivebot/range/rapid
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/range/strong
	name = "Armored Hivebot"
	desc = "A robot, this one is armed and looks tough!"
	icon_state = "hivebotstrong"
	health = 90
	maxHealth = 90

/mob/living/simple_animal/hostile/hivebot/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
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
	name = "Beacon"
	desc = "Some odd beacon thing"
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotbeacon_active"
	icon_living = "hivebotbeacon_active"
	health = 200
	maxHealth = 200
	projectilesound = 'sound/weapons/laser3.ogg'
	projectiletype = /obj/item/projectile/beam/hivebotlaser
	status_flags = 0
	anchored = 1
	stop_automated_movement = 1
	faction = "hivebot"
	ranged = 1
	smart = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = -1
	var/bot_type = NORMAL // type of bot, 1 is normal, 2 is ranged, 3 is rapid ranged, 4 is ranged/strong.
	var/bot_amt = 10
	var/spawn_delay = 600
	var/activated = 0
	attack_emote = "focuses on"

/mob/living/simple_animal/hostile/hivebotbeacon/death()
	..()
	visible_message("<b>The Beacon</b> blows apart and erupts in a cloud of noxious smoke!")
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, src.loc)
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
		if(STRONG)
			new /mob/living/simple_animal/hostile/hivebot/range/strong(get_turf(src))

	if(prob(30))
		if(prob(70))
			if(prob(60))
				bot_type = RANGED
			else
				bot_type = RAPID
		else
			bot_type = STRONG
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
#undef STRONG
