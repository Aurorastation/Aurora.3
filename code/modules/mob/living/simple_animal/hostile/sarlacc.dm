//contains:
//~great worm
//~lesser worm
//~great worm king
//~loot tables

////////////////////////////////////////
///////////////Great Worm///////////////
////////////////////////////////////////

/obj/item/trap/sarlacc
	name = "great worm maw"
	desc = "Hop in, the gastrointestinal juices are just fine."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "blank"
	mouse_opacity = 0
	throwforce = 0
	anchored = 1
	deployed = 1
	time_to_escape = 45 SECONDS
	var/mob/living/simple_animal/hostile/greatworm/originator
	var/mob/living/captive

/obj/item/trap/sarlacc/Destroy()
	if(originator)
		originator = null
	return ..()

/obj/item/trap/sarlacc/Crossed(AM as mob|obj)
	if(originator)
		if(deployed && isliving(AM) && !originator.eating)
			var/mob/living/L = AM
			L.visible_message(
				"<span class='danger'>[L] steps into \the [src].</span>",
				"<span class='danger'>You step into \the [src]!</span>",
				"<b>You hear a loud organic snap!</b>"
				)
			attack_mob(L)
			originator.eating = 1
			to_chat(L, "<span class='danger'>\The [src] begins digesting your upper body!</span>")
			addtimer(CALLBACK(src, .proc/devour, L), 50 SECONDS)
	..()

/obj/item/trap/sarlacc/proc/devour(var/mob/living/C)
	if(!C)
		if(!deployed)
			deployed = 1
		return
	if(!originator)
		return
	if(!originator.eating)
		return
	var/mob/living/L = C
	if(istype(L,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		H.visible_message(
			"<span class='danger'>\The [src] snaps tight across [H]'s upper body, swallowing it in three grisly gulps.</span>",
			"<span class='danger'>You feel a searing pain as \the [src] severs your lower body and sends you careening into its grotesque gullet!</span>",
			"<b>You hear a sick crunch!</b>"
			)
		var/obj/item/organ/external/G = H.get_organ("groin")
		G.droplimb(0,DROPLIMB_EDGE)
		if(SSmob.greatasses.len)
			var/obj/structure/greatworm/S = pick(SSmob.greatasses)
			H.forceMove(S.loc)
		else
			H.gib()
		originator.sated += 200+H.mob_size //instantly sates the originator
	else if(istype(L,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = L
		L.visible_message(
			"<span class='danger'>\The [src] spits [R] out with a frustrated screech after failing to swallow.</span>",
			"<span class='danger'>\The [src] scrapes and gnashes against your exoskeleton before spitting you out!</span>",
			"<b>You hear several metallic scrapes!</b>"
			)
		R.apply_damage(60,BRUTE)
	else
		L.visible_message(
			"<span class='danger'>\The [src] eviscerates [L] with its teeth, swallowing what little remains whole!</span>",
			"<span class='danger'>\The [src] turns you into a slightly viscuous and very bloody paste.</span>",
			"<b>You hear a grisly splat!</b>"
			)
		L.gib()
		originator.sated += L.mob_size*2
	unbuckle_mob()
	captive = null
	deployed = 1
	originator.eating = 0

/mob/living/simple_animal/hostile/greatworm
	name = "great worm"
	desc = "The gaping maw opens and closes eternally, insatiably... Rumours however tell that those who can sate it are rewarded."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "sarlacc"
	see_in_dark = 8
	health = 100
	maxHealth = 100
	gender = NEUTER
	status_flags = 0
	anchored = 1
	density = 0
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	layer = 2.1
	var/eating = 0
	var/sated = 0
	var/asleep = 0
	var/tentacles = 6
	var/list/active_tentacles = list()
	var/obj/item/trap/sarlacc/sarlacc
	var/loot_count
	var/spawn_delay = 0
	var/spawn_time = 5

	faction = "worms"

/mob/living/simple_animal/hostile/greatworm/Initialize()
	. = ..()
	SSmob.greatworms += src
	loot_count = 4+(rand(0,4))
	var/obj/item/trap/sarlacc/L = new /obj/item/trap/sarlacc(src.loc)
	L.originator = src
	sarlacc = L

/mob/living/simple_animal/hostile/greatworm/Destroy()
	SSmob.greatworms -= src
	if(sarlacc)
		qdel(sarlacc)
		sarlacc = null
	return ..()

/mob/living/simple_animal/hostile/greatworm/Life()
	..()
	if(!sarlacc)
		var/obj/item/trap/sarlacc/L = new /obj/item/trap/sarlacc(src.loc)
		L.originator = src
		sarlacc = L
	if(sarlacc && sarlacc.loc != src.loc) //if the sarlacc is not located on us, move it back onto us.
		sarlacc.forceMove(src.loc)
	if(sated < 0)
		sated = 0
	if(sated == 0 && asleep)
		asleep = 0
		icon_state = "sarlacc"
		visible_message(
			"<span class='danger'>\The [src] awakens!</span>",
			"<span class='danger'>You awaken! You're so HUNGRY!</span>",
			"<b>You hear a deep, rumbling roar in the earth!</b>"
			)
		sarlacc.deployed = 1
	if(sated >= 200)
		Sandman()
	if(asleep)
		if(icon_state != "sarlacc_asleep")
			icon_state = "sarlacc_asleep"
		if(prob(50))
			sated -= 1
		if(prob(5) && tentacles < 6)
			tentacles += 1
		if(health < maxHealth)
			health += 1
			sated -= 1
			if(health >= maxHealth)
				health = maxHealth
		if(sarlacc && sarlacc.deployed)
			sarlacc.deployed = 0
	else
		if(eating)
			if(sarlacc && !sarlacc.deployed && sarlacc.captive) //if the sarlacc is not deployed but IS captivating, that means its captive escaped
				sarlacc.captive = null
				sarlacc.deployed = 1
				eating = 0
			else
				if(prob(50))
					var/mob/living/L = sarlacc.captive
					if(L)
						L.apply_damage(rand(3,10),BRUTE)
						L.visible_message(
							"<span class='danger'>\The [src] tears at [L]'s flesh with its gruesome jaws.</span>",
							"<span class='danger'>You feel a searing pain as \the [src] tears at your flesh!</span>",
							"<b>You hear a sick tear!</b>"
							)


/mob/living/simple_animal/hostile/greatworm/death()
	..()
	visible_message("<span class='danger'>With a frenzy of tooth and tendril, \the [src] slides deep into the earth, leaving a gaping hole in its place!</span>")
	var/turf/T = src.loc
	T.ChangeTurf(/turf/space)
	qdel(src)

/mob/living/simple_animal/hostile/greatworm/proc/Sandman()
	set waitfor = FALSE
	if(!asleep)
		asleep = 1
	icon_state = "sarlacc_asleep"
	sarlacc.deployed = 0
	visible_message("<span class='danger'>With a contented heave, \the [src] slides into the earth and begins regurgitating several treasures before shutting tight.</span>")
	new/obj/random/loot(get_turf(src))

/mob/living/simple_animal/hostile/greatworm/FindTarget()
	if(eating)
		return
	if(asleep)
		return
	..()

/mob/living/simple_animal/hostile/greatworm/FoundTarget()
	if(target_mob.faction != "syndicate")
		spawn_tentacle(target_mob)
	LoseTarget()
	return

/mob/living/simple_animal/hostile/greatworm/proc/spawn_tentacle(var/mob/living/target)
	if(active_tentacles.len >= tentacles)
		return 0
	if(spawn_delay > world.time)
		return 0
	if(target.loc == src.loc)
		return 0
	var/turf/T = get_turf(target.loc)
	if(!istype(T,/turf/unsimulated/floor/asteroid))
		return 0
	if(locate(/mob/living/simple_animal/hostile/lesserworm) in T)
		return 0
	spawn_delay = world.time + spawn_time
	var/turf/unsimulated/floor/asteroid/A = T
	var/mob/living/simple_animal/hostile/lesserworm/L = new /mob/living/simple_animal/hostile/lesserworm(A)
	if(A.dug < 1)
		A.gets_dug()
	active_tentacles += L
	L.originator = src
	L.faction = src.faction
	visible_message("<span class='danger'>\The [L] bursts from the earth under [target].</span>")

/mob/living/simple_animal/hostile/greatworm/Move()
	return


////////////////////////////////////////
////////Not So Great Worm///////////////
////////////////////////////////////////

/mob/living/simple_animal/hostile/lesserworm
	name = "lesser worm"
	desc = "The maw on this creature is substantially smaller than the one on it's master, but it still hurts like hell."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "sarlacctentacle"
	health = 25
	maxHealth = 25
	gender = NEUTER
	status_flags = 0
	anchored = 1
	density = 0
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/mob/living/simple_animal/hostile/greatworm/originator

	faction = "worms"

/mob/living/simple_animal/hostile/lesserworm/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/Penetrate), 6)
	QDEL_IN(src, 15)

/mob/living/simple_animal/hostile/lesserworm/Destroy()
	if(originator)
		originator.active_tentacles -= src
	return ..()

/mob/living/simple_animal/hostile/lesserworm/proc/Penetrate()
	playsound(src.loc, 'sound/effects/blobattack.ogg', 100, 1)
	var/list/possible_targets = list()
	for(var/mob/living/L in src.loc)
		if(L != src)
			L.apply_damage(15,BRUTE)
			possible_targets += L
			to_chat(L, "<span class='danger'>\The [src] wraps around you tightly with its spiny teeth+!</span>")
	if(Adjacent(originator) && possible_targets.len)
		var/mob/living/L = pick(possible_targets)
		to_chat(L, "<span class='danger'>\The [src] flings you into \the [originator]'s maw!</span>")
		L.Move(originator.loc)

/mob/living/simple_animal/hostile/lesserworm/Move()
	return

////////////////////////////////////////
////////Really Quite Great Worm/////////
////////////////////////////////////////

/mob/living/simple_animal/hostile/greatwormking
	name = "great worm king"
	desc = "This pulsating brain seems somehow connected to all the other orifices in this room..."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "sarlaccbrain"
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	universal_speak = 1
	universal_understand = 1

	health = 450
	maxHealth = 450

	gender = MALE
	status_flags = 0
	anchored = 1
	density = 1
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	ranged = 1
	projectilesound = 'sound/magic/WandODeath.ogg'
	projectiletype = /obj/item/projectile/energy/thoughtbubble
	speak_emote = list("gargles")
	emote_hear = list("gargles")
	emote_see = list("ooozes","pulses","drips","pumps")

	faction = "worms"

/mob/living/simple_animal/hostile/greatwormking/Destroy()
	playsound(src.loc, 'sound/hallucinations/wail.ogg', 200, 1, usepressure = 0)
	for(var/mob/living/L in SSmob.greatworms)
		L.death()
	for(var/obj/structure/S in SSmob.greatasses)
		qdel(S)
	return ..()

/mob/living/simple_animal/hostile/greatwormking/Move()
	return

/obj/item/projectile/energy/thoughtbubble
	name = "psionic blast"
	icon_state = "ion"
	nodamage = 1
	taser_effect = 1
	agony = 20
	check_armour = "energy"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	var/list/thoughts = list(
		"You hear a cacophany of alien sounds.",
		"You see a field of black stars.",
		"You feel the sound of light.",
		"You feel the zap of an electric probe.",
		"You taste the iron blood of death.",
		"You feel time stop, and then suddenly begin again.",
		"Your brain is crying. Make it stop.",
		"You want more!",
		"You hear a whisper: \"Come closer...\"",
		"You feel a burning sensation; you miss home.",
		"You feel a burning sensation; you feel so alone.",
		"You feel a burning sensation; you're nothing to your peers.",
		"You feel a burning sensation; why do bad things happen to good people?",
		"You feel a burning sensation; time is moving so fast, and you feel so old.",
		"You feel like a stranger in a strange land.",
		"Colors swim before you, and you feel like you can touch each one.",
		"You feel like you're going to die here. It makes you happy.",
		"You feel like you could take a nap right here...",
		"You feel so tired.",
		"You scream and scream, but there is no sound.",
		"You feel like a prisoner of time, trying fruitlessly to break free.",
		"Today must be a Thursday. You could never quite get the hang of Thursdays.",
		"You've got a bad feeling about this."
	)

/obj/item/projectile/energy/thoughtbubble/on_impact(var/atom/A)
	..()
	if(istype(A, /mob/living))
		var/mob/living/L = A
		if(L.reagents)
			var/madhouse = pick("psilocybin","mindbreaker","impedrezene","cryptobiolin","stoxin","mutagen")
			var/madhouse_verbal_component = pick(thoughts)
			L.reagents.add_reagent("[madhouse]", 3)
			to_chat(L, "<span class='alium'><b><i>[madhouse_verbal_component]</i></b></span>")

/obj/structure/greatworm
	name = "great worm rectum"
	desc = "The intestinal length of the great worm this end belongs to travels for what looks like miles."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "sarlaccend"
	anchored = 1
	density = 0
	layer = 2.1

/obj/structure/greatworm/Initialize()
	. = ..()
	SSmob.greatasses += src

/obj/structure/greatworm/Destroy()
	SSmob.greatasses -= src
	return ..()

