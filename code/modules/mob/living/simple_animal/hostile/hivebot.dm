#define NORMAL 1
#define RANGED 2
#define RAPID  3

/obj/item/projectile/hivebotbullet
	damage = 10
	damage_type = BRUTE

/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A small robot"
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = "clawed"
	projectilesound = 'sound/weapons/gunshot/gunshot1.ogg'
	projectiletype = /obj/item/projectile/hivebotbullet
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

/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A smallish robot, this one is armed!"
	ranged = 1
	smart = TRUE

/mob/living/simple_animal/hostile/hivebot/range/rapid
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/range/strong
	name = "Strong Hivebot"
	desc = "A robot, this one is armed and looks tough!"
	health = 80

/mob/living/simple_animal/hostile/hivebot/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	spark(src, 3, alldirs)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebot/tele//this still needs work
	name = "Beacon"
	desc = "Some odd beacon thing"
	icon_state = "def_radar-off"
	icon_living = "def_radar-off"
	health = 200
	maxHealth = 200
	status_flags = 0
	anchored = 1
	stop_automated_movement = 1
	var/bot_type = NORMAL // type of bot, 1 is normal, 2 is ranged, 3 is rapid rnaged.
	var/bot_amt = 10
	var/spawn_delay = 600

/mob/living/simple_animal/hostile/hivebot/tele/New()
	..()
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(5, 0, src.loc)
	smoke.start()
	visible_message("<span class='danger'>\The [src] warps in!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/hivebot/tele/proc/warpbots()

	if(!bot_amt)
		qdel(src)
		return

	icon_state = "def_radar"
	visible_message("<span class='warning'>\The [src] turns on!</span>")

	switch(bot_type)
		if(NORMAL)
			new /mob/living/simple_animal/hostile/hivebot(get_turf(src))
		if(RANGED)
			new /mob/living/simple_animal/hostile/hivebot/range(get_turf(src))
		if(RAPID)
			new /mob/living/simple_animal/hostile/hivebot/range/rapid(get_turf(src))

	if(prob(30))
		if(prob(20))
			bot_type = RAPID
		else
			bot_type = RANGED
	else
		bot_type = NORMAL
	bot_amt--
	addtimer(CALLBACK(src, .proc/warpbots, spawn_delay))


/mob/living/simple_animal/hostile/hivebot/tele/Life()
	..()
	if(stat == 0)
		if(prob(2))//Might be a bit low, will mess with it likely
			warpbots()

#undef NORMAL
#undef RANGED
#undef RAPID
