
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//basic spider mob, these generally guard nests
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "Furry and brown, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	stop_automated_movement_when_pulled = 0
	maxHealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	var/poison_per_bite = 5
	var/poison_type = "toxin"
	faction = "spiders"
	var/busy = 0
	pass_flags = PASSTABLE
	move_to_delay = 6
	speed = 3
	mob_size = 6

	attack_emote = "skitters toward"
	emote_sounds = list('sound/effects/creatures/spider_critter.ogg')

//nursemaids - these create webs and eggs
/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "Furry and beige, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 10
	var/atom/cocoon_target
	poison_type = "stoxin"
	var/fed = 0

//hunters have the most poison and move the fastest, so they can find prey
/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	maxHealth = 120
	health = 120
	melee_damage_lower = 10
	melee_damage_upper = 20
	poison_per_bite = 5
	move_to_delay = 4

/mob/living/simple_animal/hostile/giant_spider/Initialize(mapload, atom/parent)
	get_light_and_color(parent)
	target_type_validator_map[/obj/effect/energy_field] = CALLBACK(src, .proc/validator_e_field)
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/AttackingTarget()
	. = ..()
	if(isliving(.))
		var/mob/living/L = .
		if(L.reagents)
			L.reagents.add_reagent("toxin", poison_per_bite)
			if(prob(poison_per_bite) && (!issilicon(L) && !isipc(L)))
				to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
				L.reagents.add_reagent(poison_type, 5)

/mob/living/simple_animal/hostile/giant_spider/nurse/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(prob(poison_per_bite))
			var/obj/item/organ/external/O = pick(H.organs)
			if(!(O.status & (ORGAN_ROBOT|ORGAN_ADV_ROBOT)) && !O.cannot_amputate)
				var/eggs = new /obj/effect/spider/eggcluster(O, src)
				O.implants += eggs
				to_chat(H, "<span class='warning'>The [src] injects something into your [O.name]!</span>")

/mob/living/simple_animal/hostile/giant_spider/think()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			//1% chance to skitter madly away
			if(!busy && prob(1))
				/*var/list/move_targets = list()
				for(var/turf/T in orange(20, src))
					move_targets.Add(T)*/
				stop_automated_movement = 1
				walk_to(src, pick(orange(20, src)), 1, move_to_delay)
				addtimer(CALLBACK(src, .proc/stop_walking), 50, TIMER_UNIQUE)

/mob/living/simple_animal/hostile/giant_spider/proc/stop_walking()
	stop_automated_movement = 0
	walk(src, 0)

/mob/living/simple_animal/hostile/giant_spider/proc/validator_e_field(var/obj/effect/energy_field/E, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	if(get_dist(src, E) < get_dist(src, current))
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/hostile/giant_spider/nurse/think()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			//30% chance to stop wandering and do something
			if(!busy && prob(30))
				//first, check for potential food nearby to cocoon
				for(var/mob/living/C in view(src, world.view))
					if(C.stat)
						cocoon_target = C
						busy = MOVING_TO_TARGET
						walk_to(src, C, 1, move_to_delay)
						//give up if we can't reach them after 10 seconds
						addtimer(CALLBACK(src, .proc/GiveUp, C), 100, TIMER_UNIQUE)
						return

				//second, spin a sticky spiderweb on this tile
				var/obj/effect/spider/stickyweb/W = locate() in get_turf(src)
				if(!W)
					busy = SPINNING_WEB
					src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance.</span>")
					stop_automated_movement = 1
					addtimer(CALLBACK(src, .proc/finalize_web), 40, TIMER_UNIQUE)
				else
					//third, lay an egg cluster there
					var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
					if(!E && fed > 0)
						busy = LAYING_EGGS
						src.visible_message("<span class='notice'>\The [src] begins to lay a cluster of eggs.</span>")
						stop_automated_movement = 1
						addtimer(CALLBACK(src, .proc/finalize_eggs), 50, TIMER_UNIQUE)
					else
						//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
						for(var/obj/O in view(src, world.view))
							if(O.anchored)
								continue

							if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
								cocoon_target = O
								busy = MOVING_TO_TARGET
								stop_automated_movement = 1
								walk_to(src, O, 1, move_to_delay)
								//give up if we can't reach them after 10 seconds
								GiveUp(O)

			else if(busy == MOVING_TO_TARGET && cocoon_target)
				if(get_dist(src, cocoon_target) <= 1)
					busy = SPINNING_COCOON
					src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance around \the [cocoon_target].</span>")
					stop_automated_movement = 1
					walk(src,0)
					addtimer(CALLBACK(src, .proc/finalize_cocoon), 50, TIMER_UNIQUE)

		else
			busy = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/GiveUp(var/C)
	if(busy == MOVING_TO_TARGET)
		if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
			cocoon_target = null
		busy = 0
		stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/finalize_eggs()
	if(busy == LAYING_EGGS)
		if(!(locate(/obj/effect/spider/eggcluster) in get_turf(src)))
			new /obj/effect/spider/eggcluster(loc, src)
			fed--
		busy = 0
		stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/finalize_web()
	if(busy == SPINNING_WEB)
		new /obj/effect/spider/stickyweb(src.loc)
		busy = 0
		stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/finalize_cocoon()
	if(busy == SPINNING_COCOON)
		if(cocoon_target && istype(cocoon_target.loc, /turf) && get_dist(src,cocoon_target) <= 1)
			var/obj/effect/spider/cocoon/C = new(cocoon_target.loc)
			var/large_cocoon = 0
			C.pixel_x = cocoon_target.pixel_x
			C.pixel_y = cocoon_target.pixel_y
			for (var/A in C.loc)
				var/atom/movable/aa = A
				if (ismob(aa))
					var/mob/M = aa
					if(istype(M, /mob/living/simple_animal/hostile/giant_spider) && M.stat != DEAD)
						continue
					large_cocoon = 1
					fed++
					src.visible_message("<span class='warning'>\The [src] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out.</span>")
					playsound(get_turf(src), 'sound/effects/lingabsorbs.ogg', 50, 1)
					M.forceMove(C)
					C.pixel_x = M.pixel_x
					C.pixel_y = M.pixel_y
					break
				if (istype(aa, /obj/item))
					var/obj/item/I = aa
					I.forceMove(C)
				if (istype(aa, /obj/structure))
					var/obj/structure/S = aa
					if(!S.anchored)
						S.forceMove(C)
						large_cocoon = 1
				if (istype(aa, /obj/machinery))
					var/obj/machinery/M = aa
					if(!M.anchored)
						M.forceMove(C)
						large_cocoon = 1
			if(large_cocoon)
				C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
		busy = 0
		stop_automated_movement = 0

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
