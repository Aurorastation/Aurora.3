#define PYLON_IDLE 0				//0 = Idle, the pylon is an inert crystal
#define PYLON_AWAITING_SACRIFICE 1	//1 = Awaiting sacrifice. The pylon is actively tracking a creature to be sacrificed to it
#define PYLON_TURRET 2				//2 = Turret. The pylon has been empowered by a sacrifice and is now a turret permanantly


/obj/structure/cult/pylon
	name = "pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	description_antag = "A pylon can be upgraded into a magical defensive turret that shoots anyone opposing the cult\
	</br>Upgrading a pylon requires a sacrifice. Bring it a small organic creature, like a monkey or rat. Use the creature on the pylon, or drag and drop to present it.\
	</br>Once the sacrifice is accepted, kill it to complete the process. This will gib its body and make a very visible mess. After this point the pylon is fixed to the floor and cant be moved\
	</br>The pylon will fire weak beams that are harmless to the cult. In addition it can be upgraded even more by shooting it with a laser, which will give it a limited number of extra-power shots."

	icon_state = "pylonbase"
	var/isbroken = FALSE
	light_range = 5
	light_color = "#3e0000"
	var/pylonmode = PYLON_IDLE

	var/damagetaken = 0
	var/empowered = FALSE //Number of empowered, higher-damage shots remaining
	var/mob/living/sacrifice //Holds a reference to a mob that is a pending sacrifice
	var/mob/living/sacrificer //A reference to the last mob that attempted to sacrifice something. So we can message them
	//Sacrifier is also used in target handling. the pylon will not bite the hand that feeds it. Noncultist colleagues are fair game though

	var/next_shot = 0 //Absolute world time when we're allowed to fire again
	var/shot_delay = 5 //Minimum delay between shots, in deciseconds
	var/mob/living/target

	var/notarget //Number of times handle_firing has been called without finding anything to shoot at
	//This is used for switching to lower-intensity processing

	var/datum/language/cultcommon/lang
	//An instance of the cult language datum. Used to scramble speech when speaking to noncultists

	var/turf/last_target_loc

	var/process_interval = 1
	var/ticks
	anchored = FALSE


//Just a subtype that starts off in turret mode. For adminbus and debugging. Maybe a future wizard spell
//Spawn them next to ERPers
/obj/structure/cult/pylon/turret
	pylonmode = PYLON_TURRET

/obj/structure/cult/pylon/turret/New()
	..()
	start_process()

/obj/structure/cult/pylon/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

//Another subtype which starts with infinite empower shots. For empowered adminbus
/obj/structure/cult/pylon/turret/empowered
	empowered = 99999999

/obj/structure/cult/pylon/Initialize()
	. = ..()
	lang = new /datum/language/cultcommon()
	update_icon()

/obj/structure/cult/pylon/examine(var/mob/user)
	..()
	if(damagetaken)
		switch(damagetaken)
			if(1 to 8)
				to_chat(user, span("warning", "It has very faint hairline fractures."))
			if(8 to 20)
				to_chat(user, span("warning", "It has several cracks across its surface."))
			if(20 to 30)
				to_chat(user, span("warning", "It is chipped and deeply cracked, it may shatter with much more pressure."))
			if(30 to INFINITY)
				to_chat(user, span("warning", "It is almost cleaved in two, the pylon looks like it will fall to shards under its own weight."))


/obj/structure/cult/pylon/Move()
	..()
	last_target_loc = null

/obj/structure/cult/pylon/proc/start_process()
	process_interval = 1
	START_PROCESSING(SSprocessing, src)


//If the pylon goes a long time without shooting anything, it will consider slowing down processing
/obj/structure/cult/pylon/proc/reconsider_interval()
	var/mindist = INFINITY
	for(var/mob/living/L in player_list)
		if(L.z != z)
			continue
		if(L.stat == DEAD)
			continue
		if(iscult(L))
			continue
		if(L == sacrificer)
			continue
		var/d = get_dist(src, L)
		if(d < mindist)
			mindist = d

	mindist = min(150, mindist)
	process_interval = Ceiling(mindist*0.1)
	process_interval = max(1, process_interval)


//Run each process loop, this function checks if we can stop processing yet.
//Returns 0 if its time to stop. Returns 1 if we should keep going.
/obj/structure/cult/pylon/proc/check_process()
	if(isbroken)
		return FALSE

	if(pylonmode == PYLON_TURRET)
		return TRUE

	if(pylonmode == PYLON_AWAITING_SACRIFICE)
		if(sacrifice)
			return TRUE

	if(empowered)
		return TRUE

	return FALSE

/obj/structure/cult/pylon/process()
	ticks++
	if(!check_process())
		STOP_PROCESSING(SSprocessing, src)
		return

	switch(pylonmode)
		if(1)
			handle_sacrifice()
		if(2)
			if((ticks % process_interval) == 0)
				handle_firing()
				if(damagetaken && prob(50) && empowered > 0)
					damagetaken = max(0, damagetaken-1) //An empowered pylon slowly self repairs
					empowered = max(0, empowered - 0.2)
					if(prob(10))
						visible_message(span("warning", "Cracks in the [src] gradually seal as new crystalline matter grows to fill them."))

	if(empowered && prob(4))
		empowered = max(0, empowered - 1) //Overcharging gradually wears off over time
		if(empowered <= 0)
			update_icon()


//If user is a cultist, speaks message to them with a prefix
//If user is not cultist, then speaks cult-y gibberish
/obj/structure/cult/pylon/proc/speak_to(var/mob/user, var/message)
	if(iscult(user) || (all_languages[LANGUAGE_CULT] in user.languages))
		to_chat(user, "A voice speaks into your mind, <span class='cult'><i>[message]</i></span>")
	else
		to_chat(user, "A voice speaks into your mind, <span class='cult'><i>[lang.scramble(message)]</i></span>")


//Todo: Replace the messages here with better ones. Should display a proper message to cultists
//And nonsensical arcane gibberish to non cultists
/obj/structure/cult/pylon/proc/present_sacrifice(var/mob/living/user, var/mob/living/victim)
	if(!user || !victim)
		return FALSE

	if(isbroken)
		to_chat(user, span("warning", "The pylon lies silent."))
		return FALSE

	if(pylonmode != PYLON_IDLE)
		to_chat(user, span("warning", "This pylon is already tracking a sacrifice."))
		return FALSE

	if(!victim.mob_size || victim.mob_size > 6)
		//toolarge sacrifice, display a message and return
		speak_to(user, "This creature is too large, we only require a lesser sacrifice. A small morsel of life...")
		return

	if(victim.stat == DEAD)
		speak_to(user, "You are too late, the spark of life is already gone from this one. It is naught but an empty husk...")
		return

	var/types = victim.find_type()
	if(!(types & TYPE_ORGANIC) || (types & TYPE_WEIRD))
		//Invalid sacrifice. Display a message and return
		speak_to(user, "This soulless automaton cannot satisfy our hunger. We yearn for life essence, it must have a soul.")
		return

	sacrifice = victim
	sacrificer = user
	//Sacrifice accepted, display message here
	speak_to(user, "Your sacrifice has been deemed worthy, and accepted. End its life now, and liberate its soul, to seal our contract...")
	to_chat(sacrifice, span("danger", "You feel an invisible force grip your soul, as you're drawn inexorably towards the pylon. Every part of you screams to flee from here!"))

	if(istype(sacrifice.loc, /obj/item/holder))
		var/obj/item/holder/H = sacrifice.loc
		H.release_to_floor()
	else
		sacrifice.forceMove(get_turf(sacrifice))
	pylonmode = PYLON_AWAITING_SACRIFICE
	update_icon()
	start_process()

//Runs every proc while there's a pending sacrifice. This checks whether the sacrifice was killed or escaped
/obj/structure/cult/pylon/proc/handle_sacrifice()
	. = 0 //Return value has 3 states.
	//0 = waiting, the sacrifice is still alive
	//1 = Finished, the sacrifice was killed, finalize the process and become a turret
	//-1 = Escape: The sacrifice left the vicinity of the pylon, return to inert mode.

	if(!sacrifice)
		//If the sacrifice was deleted somehow, we cant know exactly what happened. We'll assume it escaped
		. = -1

	else if(get_dist(src, get_turf(sacrifice)) > 5)
		//If the sacrifice gets more than 5 tiles away, it has escaped
		. = -1

	else if (sacrifice.stat == DEAD)
		. = 1

	switch(.)
		if(1)
			finalize_sacrifice()
		if(-1)
			speak_to(sacrificer, "Fool! Your offering has escaped. Bring it back, or find us another...")
			sacrifice = null
			pylonmode = PYLON_IDLE
			update_icon()
			if(sacrifice)
				walk_to(sacrifice, 0)
		else
			if(istype(sacrifice.loc, /turf) && !sacrifice.is_ventcrawling && !sacrifice.buckled)
				//Suck the creature towards the pylon if possible
				walk_towards(sacrifice, src, 10)
			else
				walk_to(sacrifice, 0) //If we're not in a valid situation, cancel walking to prevent bugginess

/obj/structure/cult/pylon/proc/finalize_sacrifice()
	sacrifice.visible_message(span("danger", "\The [sacrifice]'s physical form unwinds as its soul is extracted from the remains, and drawn into the pylon!"))
	if(istype(sacrifice.loc, /obj/item/holder))
		var/obj/item/holder/H = sacrifice.loc
		H.release_to_floor()
	else
		sacrifice.forceMove(get_turf(sacrifice)) //Make sure its on the floor before we gib it
	pylonmode = PYLON_TURRET
	sacrifice.gib()

	update_icon()


//Called every process in turret mode, and also by chaining spawns
/obj/structure/cult/pylon/proc/handle_firing()
	if((world.time < next_shot) || isbroken)
		return
		//Not ready to fire yet

	var/list/stuffcache
	//Stuffcache holds a list of things found by a dview call, so we only need to do it once per proc.

	if(target && target.stat != DEAD)
		if(target.loc == last_target_loc)
		//To minimise expensive DVIEW calls, if the target hasnt moved since the last shot we'll assume they're still in sight
		//This could cause problems in some edge cases (like lowering firelocks or shutters without moving)
		//But it has a major performance gain that makes it worth it
			fire_at(target)
			return
		else
			stuffcache = mobs_in_view(9, src)
			if((target in stuffcache) && isInSight(src, target))
				fire_at(target)
				return
			else
				target = null

	//We may have already populated stuffcache this run, dont repeat work
	if(!stuffcache)
		stuffcache = mobs_in_view(9, src)

	target = null //Either we lost a target or lack one

	for(var/mob/living/L in stuffcache)
		if(L == sacrificer) //A pylon won't shoot the person who created it, regardless of cult status.
			continue		 //This is mainly for xenoarch antags
		if(L.stat == DEAD)  //No point shooting at corpses
			continue
		if(iscult(L))		 //Pylon wont shoot at cultists or constructs
			continue
		if(!isInSight(src, L))
			continue
		if(ismech(L))
			var/mob/living/heavy_vehicle/mech = L
			if(!LAZYLEN(mech.pilots))
				continue
			for(var/mob/M in mech.pilots)
				if(M == sacrificer || iscult(M))
					continue
		target = L
		break

	if(target)
		fire_at(target)
	else
		notarget++
		if(notarget > 60 || process_interval > 1)
			notarget = 0
			reconsider_interval()


/obj/structure/cult/pylon/proc/fire_at(var/atom/target)
	//Only store loc if target is on a turf. Otherwise this bugs out with people in exosuits
	if(istype(target.loc, /turf))
		last_target_loc = target.loc

	process_interval = 1 //Instantly wake up if we found a target
	var/obj/item/projectile/beam/cult/A
	if(empowered > 0)
		A = new /obj/item/projectile/beam/cult/heavy(loc)
		empowered = max(0, empowered-1)
		playsound(loc, 'sound/weapons/laserdeep.ogg', 100, 1)
		if(empowered <= 0)
			update_icon()
	else
		A = new /obj/item/projectile/beam/cult(loc)
		playsound(loc, 'sound/weapons/laserdeep.ogg', 65, 1)
	A.ignore = sacrificer
	A.launch_projectile(target)
	next_shot = world.time + shot_delay
	A = null //So projectiles can GC
	addtimer(CALLBACK(src, .proc/handle_firing), shot_delay + 1)

/obj/structure/cult/pylon/attack_hand(mob/M)
	if (M.a_intent == "help")
		to_chat(M, span("warning", "The pylon feels warm to the touch..."))
	else
		attackpylon(M, 4, M)

/obj/structure/cult/pylon/attack_generic(mob/user, damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	//Artificiers maintain pylons
	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		if(C.can_repair)
			repair(user)
			return
	attackpylon(user, damage, user)

/obj/structure/cult/pylon/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/holder))
		var/obj/item/holder/H = W
		if(H.contained)
			present_sacrifice(user, H.contained)
		return

	attackpylon(user, W.force, W)

//Mousedrop so that constructs can drag rats out of maintenance to make turrets
/obj/structure/cult/pylon/MouseDrop_T(var/atom/movable/C, mob/user)
	if(istype(C, /mob/living))
		present_sacrifice(user, C)
		return
	return ..()

/obj/structure/cult/pylon/bullet_act(var/obj/item/projectile/Proj)
	attackpylon(Proj.firer, Proj.damage, Proj)

//Explosions will usually cause instant shattering, or heavy damage
//Class 3 or lower blast is sometimes survivable. 2 or higher will always shatter
/obj/structure/cult/pylon/ex_act(var/severity)
	if(severity > 0)
		attackpylon(null, (rand(200,400) / severity), null)

/obj/structure/cult/pylon/proc/attackpylon(mob/user, var/damage, var/source)
	var/ranged = 0
	if(user)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(source, /obj/item))
		var/obj/item/I = source
		if(istype(I, /obj/item/nullrod))
			shatter()
			return
		if(I.damtype != BRUTE)
			to_chat(user, span("warning", "You swing at the pylon to no effect."))
			return

	if(istype(source, /obj/item/projectile))
		if(istype(source, /obj/item/projectile/beam/cult))
			return //No feedback loops
		var/obj/item/projectile/proj = source
		if(proj.damage_type == BURN)
			if(empowered <= 0)
				visible_message(span("cult", "The beam refracts inside the pylon, splitting into an indistinct violet glow. The crystal takes on a new, more ominous aura!"))
			empowered += damage * 0.2
			//When shot with a laser, the pylon absorbs the beam, becoming empowered for a while, glowing brighter
			// and firing more powerful blasts which have some armor penetration
			// Using lasers to empower a defensive pylon yields more total damage than directly shooting your enemies
			start_process()
			update_icon()
			return
		else if(proj.damage_type != BRUTE)
			return
		ranged = TRUE

	if(!damage)
		return

	damagetaken += damage

	if(!isbroken)
		if(user)
			user.do_attack_animation(src)
		if(prob(damagetaken * 0.75))
			shatter()
		else
			if(user && !ranged)
				to_chat(user, span("warning", "You hit the pylon!"))
			playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, 1)
	else
		if(prob(damagetaken))
			if(user)
				to_chat(user, span("warning", "You pulverize what was left of the pylon!"))
			qdel(src)
		else if(user && !ranged)
			to_chat(user, span("warning", "You hit the pylon!"))
		playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, 1)

	start_process()

/obj/structure/cult/pylon/proc/shatter()
	visible_message(span("danger", "The pylon shatters into shards of crystal!"), span("warning", "You hear a tinkle of crystal shards."))
	playsound(get_turf(src), "shatter", 75, 1)
	isbroken = TRUE
	if(pylonmode == PYLON_TURRET)
		//If the pylon had a soul in it then it plays a creepy evil sound as the soul is released
		var/list/possibles = list('sound/hallucinations/far_noise.ogg',
		'sound/hallucinations/growl3.ogg',
		'sound/hallucinations/veryfar_noise.ogg',
		'sound/hallucinations/wail.ogg',
		'sound/voice/hiss5.ogg')
		playsound(get_turf(src), pick(possibles), 50, 1)

	pylonmode = PYLON_IDLE //A broken pylon loses its soul. Even if repaired it will need a new sacrifice to re-empower it

	//Make sure we stop it from firing
	target = null
	sacrificer = null
	notarget = 0
	last_target_loc = null
	process_interval = 1
	//It will stop processing after the next check, start of the next process

	empowered = 0
	density = 0
	update_icon()

/obj/structure/cult/pylon/proc/repair(mob/user)
	if(isbroken)
		if(user)
			to_chat(user, span("notice", "You weave forgotten magic, summoning the shards of the crystal and knitting them anew, until it hovers flawless once more."))
		isbroken = 0
		density = 1
	else if(damagetaken > 0)
		to_chat(user, span("notice", "You meld the crystal lattice back into integrity, sealing over the cracks until they never were."))
	else
		to_chat(user, span("notice", "The crystal lights up at your touch."))

	process_interval = 1 //Wake up the crystal
	notarget = 0
	damagetaken = 0
	update_icon()


/obj/structure/cult/pylon/update_icon()
	cut_overlays()
	if(pylonmode == PYLON_TURRET)
		anchored = TRUE
		if(empowered)
			add_overlay("crystal_overcharge")
			set_light(7, 3, l_color = "#a160bf")
		else
			set_light(6, 3, l_color = "#3e0000")
			add_overlay("crystal_turret")
	else if(!isbroken)
		set_light(5, 2, l_color = "#3e0000")
		add_overlay("crystal_idle")
		if(pylonmode == PYLON_AWAITING_SACRIFICE)
			anchored = TRUE
		else
			anchored = FALSE
	else
		anchored = FALSE
		set_light(0)

#undef PYLON_IDLE
#undef PYLON_AWAITING_SACRIFICE
#undef PYLON_TURRET