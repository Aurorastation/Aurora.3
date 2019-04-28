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

/mob/living/simple_animal/hostile/hivebot/death()
	..(null,"blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/hivebot/Destroy()
	..()
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

/mob/living/simple_animal/hostile/hivebot/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, .proc/wakeup), 150)
	if(severity == 1.0)
		apply_damage(10)

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
	smart = 1
	destroy_surroundings = 0
	var/bot_type = NORMAL // type of bot, 1 is normal, 2 is ranged, 3 is rapid ranged
	var/bot_amt = 48 //Number of total bots that are spawned before the beacon disappears completely.
	var/max_bots = 16 //Number of bots linked to this beacon specifically that can exist, before spawning more is halted.
	var/list/linked_bots = list()
	var/spawn_delay = 300
	var/activated = 0
	var/snoozing = 0 //If set to 1, it will be prevented from spawning bots, unless it spots an enemy.
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

	icon_state = "hivebotbeacon_off"
	visible_message("<span class='danger'>[src] warps in!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

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
		visible_message("<span class='warning'>[src] suddenly activates!</span>")
		icon_state = "hivebotbeacon_raising"
		addtimer(CALLBACK(src, .proc/reset_activation), 16)
	else if(activated == 1)
		icon_state = "hivebotbeacon_active"

/mob/living/simple_animal/hostile/hivebotbeacon/proc/reset_activation()
	icon_state = "hivebotbeacon_active"
	activated = 1
	snoozing = 0

/mob/living/simple_animal/hostile/hivebotbeacon/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, .proc/wakeup), 200)
	if(severity == 1.0)
		apply_damage(80)
	icon_state = "hivebotbeacon_off"
	activated = -1

/mob/living/simple_animal/hostile/hivebotbeacon/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE
	activated = 0

/mob/living/simple_animal/hostile/hivebotbeacon/proc/warpbots()
	if(!bot_amt)
		visible_message("<span class='danger'>[src] disappears in a cloud of smoke!</span>")
		playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
		new /obj/effect/decal/cleanable/greenglow(src.loc)
		qdel(src)
		return

	if(activated != 1)
		if(activated == -1)
			return
		else
			icon_state = "hivebotbeacon_raising"
			sleep(16)
			icon_state = "hivebotbeacon_active"
			sleep(4)
			activated = 1

	if(linked_bots.len < max_bots)
		visible_message("<span class='warning'>[src] radiates with energy!</span>")
		var/mob/living/simple_animal/hostile/hivebot/latest_child
		switch(bot_type)
			if(NORMAL)
				latest_child = new /mob/living/simple_animal/hostile/hivebot(get_turf(src), src)
			if(RANGED)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/range(get_turf(src), src)
			if(RAPID)
				latest_child = new /mob/living/simple_animal/hostile/hivebot/range/rapid(get_turf(src), src)
		linked_bots += latest_child //Adds the spawned hivebot to the list of the beacon's children.
		if(prob(30))
			if(prob(65))
				bot_type = RANGED
			else
				bot_type = RAPID
		else
			bot_type = NORMAL
		bot_amt--
	if(bot_amt>0 && linked_bots.len < max_bots)
		addtimer(CALLBACK(src, .proc/warpbots), spawn_delay)

/mob/living/simple_animal/hostile/hivebotbeacon/Life()
	..()
	if(stat == 0)
		if((!snoozing) && (prob(2)))
			warpbots()

#undef NORMAL
#undef RANGED
#undef RAPID
