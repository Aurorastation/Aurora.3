
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//basic spider mob, these generally guard nests
/mob/living/simple_animal/hostile/giant_spider
	name = "greimorian warrior"
	desc = "A deep purple carapace covers this vicious Greimorian warrior."
	desc_extended = "Greimorians are a species of arthropods whose evolutionary traits have made them an extremely dangerous invasive species.  \
	They originate from the Badlands planet Greima, once covered in crystalized phoron. A decaying orbit led to its combustion from proximity to its sun, and its dominant inhabitants \
	managed to survive in orbit. Countless years later, they prove to be a menace across the galaxy, having carried themselves within the hulls of Human vessels to spread wildly."
	icon = 'icons/mob/npc/greimorian.dmi'
	icon_state = "greimorian"
	icon_living = "greimorian"
	icon_dead = "greimorian_dead"
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	organ_names = list("thorax", "legs", "head")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	blood_type = "#51C404"
	blood_amount = 150
	stop_automated_movement_when_pulled = 0
	maxHealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	armor_penetration = 10
	resist_mod = 1.5
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	var/poison_per_bite = 5
	var/poison_type = /singleton/reagent/toxin
	faction = "spiders"
	var/busy = 0
	pass_flags = PASSTABLE
	speed = 6
	mob_size = 6
	smart_melee = FALSE

	attacktext = "bitten"
	attack_emote = "skitters toward"
	attack_sound = 'sound/weapons/bite.ogg'
	emote_sounds = list('sound/effects/creatures/spider_critter.ogg')
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Tissue sample contains high muscle content")

//nursemaids - these create webs and eggs
/mob/living/simple_animal/hostile/giant_spider/nurse
	name = "greimorian worker"
	desc = "A hideous Greimorian with vestigial wings and an awful stench about it. This one is brown with shimmering, bulbous red eyes."
	icon_state = "greimorian_worker"
	icon_living = "greimorian_worker"
	icon_dead = "greimorian_worker_dead"
	blood_amount = 50
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 20
	poison_per_bite = 10
	var/atom/cocoon_target
	poison_type = /singleton/reagent/soporific
	var/fed = 0
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular structures indicative of high offspring production")

/mob/living/simple_animal/hostile/giant_spider/nurse/servant
	name = "greimorian servant"
	desc = "A greimorian with a startling intelligence to its bulbous yellow eyes. Its needle-like mandibles look like they could easily punch through armor - or flesh."
	icon_state = "greimorian_servant"
	icon_living = "greimorian_servant"
	icon_dead = "greimorian_servant_dead"
	blood_amount = 150
	maxHealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	armor_penetration = 30
	poison_per_bite = 10
	speed = -2
	poison_type = /singleton/reagent/soporific
	fed = 1
	var/playable = TRUE
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular structures indicative of high offspring production", "Tissue sample contains high neural cell content")

/mob/living/simple_animal/hostile/giant_spider/nurse/servant/Life(seconds_per_tick, times_fired)
	..()
	adjustBruteLoss(-2)

//hunters have the most poison and move the fastest, so they can find prey
/mob/living/simple_animal/hostile/giant_spider/hunter
	name = "greimorian hunter"
	desc = "A vicious, hostile red Greimorian. This one holds a mighty stinger to impale its prey."
	icon_state = "greimorian_hunter"
	icon_living = "greimorian_hunter"
	icon_dead = "greimorian_hunter_dead"
	blood_amount = 90
	maxHealth = 120
	health = 120
	melee_damage_lower = 10
	melee_damage_upper = 20
	armor_penetration = 15
	poison_per_bite = 5
	speed = 4
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular biochemistry shows high metabolic capacity")
	smart_melee = TRUE

/mob/living/simple_animal/hostile/giant_spider/emp
	name = "greimorian jackal"
	desc = "A slithering bright blue Greimorian. This one gently buzzes with electrical potential."
	icon_state = "greimorian_jackal"
	icon_living = "greimorian_jackal"
	icon_dead = "greimorian_jackal_dead"
	maxHealth = 100
	health = 100
	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 15
	poison_type = /singleton/reagent/perconol // mildly beneficial for organics
	poison_per_bite = 2
	speed = 5
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular biochemistry geared towards creating strong electrical potential differences")
	smart_melee = TRUE

/mob/living/simple_animal/hostile/giant_spider/bombardier
	name = "greimorian bombardier"
	desc = "A disgusting crawling Greimorian. This one has vents that shoot out acid."
	icon_state = "greimorian_bombardier"
	icon_living = "greimorian_bombardier"
	icon_dead = "greimorian_bombardier_dead"
	maxHealth = 60
	health = 60
	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 5
	ranged = TRUE
	ranged_attack_range = 4
	poison_type = /singleton/reagent/acid/greimorian
	poison_per_bite = 2
	speed = 5
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Exocrinic acid synthesis detected")
	smart_melee = TRUE

/mob/living/simple_animal/hostile/giant_spider/bombardier/Shoot(var/target, var/start, var/mob/user, var/bullet = 0)
	if(target == start)
		return

	playsound(loc, 'sound/effects/spray2.ogg', 50, 1, -6)

	var/turf/target_turf = get_turf(target)
	var/obj/effect/effect/water/chempuff/pepperspray = new /obj/effect/effect/water/chempuff(get_turf(src))
	pepperspray.create_reagents(10)
	pepperspray.reagents.add_reagent(poison_type, 10)
	pepperspray.set_color()
	pepperspray.set_up(target_turf, 3, 5)

/mob/living/simple_animal/hostile/giant_spider/Initialize(mapload, atom/parent)
	. = ..()
	get_light_and_color(parent)
	add_language(LANGUAGE_GREIMORIAN)
	add_language(LANGUAGE_GREIMORIAN_HIVEMIND)

/mob/living/simple_animal/hostile/giant_spider/nurse/servant/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/ventcrawl)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	if(playable && !ckey && !client)
		SSghostroles.add_spawn_atom("servant", src)

/mob/living/simple_animal/hostile/giant_spider/nurse/servant/Destroy()
	. = ..()
	SSghostroles.remove_spawn_atom("servant", src)

/mob/living/simple_animal/hostile/giant_spider/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(isliving(hit_mob) && istype(limb) && !BP_IS_ROBOTIC(limb))
		var/mob/living/target = hit_mob
		if(!target.reagents)
			return
		var/inject_probability = 100
		var/list/armors = target.get_armors_by_zone(limb.limb_name, DAMAGE_BRUTE, DAMAGE_FLAG_SHARP)
		for(var/armor in armors)
			var/datum/component/armor/armor_datum = armor
			inject_probability -= armor_datum.armor_values[MELEE] * 1.8
		if(prob(inject_probability))
			to_chat(target, SPAN_WARNING("You feel a tiny prick."))
			target.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_animal/hostile/giant_spider/nurse/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(ishuman(hit_mob) && istype(limb) && !BP_IS_ROBOTIC(limb) && prob(poison_per_bite))
		var/eggs = new /obj/effect/spider/eggcluster(limb, src)
		limb.implants += eggs
		to_chat(hit_mob, SPAN_WARNING("\The [src] injects something into your [limb.name]!"))

/mob/living/simple_animal/hostile/giant_spider/emp/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(ishuman(hit_mob))
		var/mob/living/carbon/human/H = hit_mob
		if(prob(20))
			var/obj/item/organ/internal/cell/cell_holder = locate() in H.internal_organs
			if(cell_holder)
				var/obj/item/cell/C = cell_holder.cell
				if(C)
					to_chat(H, SPAN_WARNING("\The [src] saps some of your energy!"))
					C.use(C.maxcharge / 15)
			if(istype(limb) && (limb.status & ORGAN_ROBOT|ORGAN_ADV_ROBOT))
				H.visible_message(SPAN_WARNING("\The [src] bites down onto \the [H]'s [limb.name]!"), SPAN_WARNING("\The [src] bites down onto your [limb.name]!"))
				limb.emp_act(EMP_LIGHT)

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
				GLOB.move_manager.move_to(src, pick(orange(20, src)), 1, speed)
				addtimer(CALLBACK(src, PROC_REF(stop_walking)), 50, TIMER_UNIQUE)

/mob/living/simple_animal/hostile/giant_spider/proc/stop_walking()
	stop_automated_movement = 0
	GLOB.move_manager.stop_looping(src)

/mob/living/simple_animal/hostile/giant_spider/nurse/think()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			//30% chance to stop wandering and do something
			if(!busy && prob(30))
				//first, check for potential food nearby to cocoon
				for(var/mob/living/C in view(src, world.view))
					if(C.stat && !istype(C, /mob/living/simple_animal/hostile/giant_spider))
						cocoon_target = C
						busy = MOVING_TO_TARGET
						GLOB.move_manager.move_to(src, C, 1, speed)
						//give up if we can't reach them after 10 seconds
						addtimer(CALLBACK(src, PROC_REF(GiveUp), C), 100, TIMER_UNIQUE)
						return

				//second, spin a sticky spiderweb on this tile if there isn't already a spiderweb there
				if(!locate(/obj/effect/spider/stickyweb) in src.loc)
					busy = SPINNING_WEB
					src.visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance."))
					stop_automated_movement = 1
					addtimer(CALLBACK(src, PROC_REF(finalize_web)), 40, TIMER_UNIQUE)
				else
					//third, lay an egg cluster there
					var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
					if(!E && fed > 0)
						busy = LAYING_EGGS
						src.visible_message(SPAN_NOTICE("\The [src] begins to lay a cluster of eggs."))
						stop_automated_movement = 1
						addtimer(CALLBACK(src, PROC_REF(finalize_eggs)), 50, TIMER_UNIQUE)
					else
						//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
						for(var/obj/O in view(src, world.view))
							if(O.anchored)
								continue

							if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
								cocoon_target = O
								busy = MOVING_TO_TARGET
								stop_automated_movement = 1
								GLOB.move_manager.move_to(src, O, 1, speed)
								//give up if we can't reach them after 10 seconds
								GiveUp(O)

			else if(busy == MOVING_TO_TARGET && cocoon_target)
				if(get_dist(src, cocoon_target) <= 1)
					busy = SPINNING_COCOON
					src.visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance around \the [cocoon_target]."))
					stop_automated_movement = 1
					GLOB.move_manager.stop_looping(src)
					addtimer(CALLBACK(src, PROC_REF(finalize_cocoon)), 50, TIMER_UNIQUE)

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
	if(busy == SPINNING_WEB && !locate(/obj/effect/spider/stickyweb) in src.loc) // Additional check, to be extra-sure they don't stack webs.
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
					src.visible_message(SPAN_WARNING("\The [src] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out."))
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

/mob/living/simple_animal/hostile/giant_spider/verb/web()
	set name = "Spin Web"
	set desc = "Create a web that slows down movement."
	set category = "Greimorian"

	if(!locate(/obj/effect/spider/stickyweb) in src.loc)
		src.visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance."))
		if(!do_after(src, 20) || locate(/obj/effect/spider/stickyweb) in src.loc) // Additional check so you can't queue it multiple times at once to stack webs.
			return
		new /obj/effect/spider/stickyweb(get_turf(src))
	else
		to_chat(usr, SPAN_WARNING("You cannot secrete webs on a turf that is already webbed!"))


/mob/living/simple_animal/hostile/giant_spider/nurse/verb/cocoon()
	set name = "Cocoon and Feed"
	set desc = "Cocoon an incapacitated mob so you can feed upon it. This will give you one food point."
	set category = "Greimorian"


	var/list/available_mobs = list()

	for(var/mob/living/A in range(1, src))
		if(A.stat && !istype(A,/mob/living/simple_animal/hostile/giant_spider) && !A.isSynthetic())
			available_mobs += A
	var/mob/P = tgui_input_list(usr, "Choose a mob to cocoon.", "Cocoon", available_mobs)
	if(get_dist(src, P) <= 1)
		src.visible_message("\The [src] begins to secrete a sticky substance around \the [P].")
		if(!do_after(src, 80))
			return

		if(P && isturf(P.loc) && get_dist(src, P) <= 1)
			var/obj/effect/spider/cocoon/C = new(get_turf(P))
			var/large_cocoon = FALSE
			C.pixel_x = P.pixel_x
			C.pixel_y = P.pixel_y
			for(P in get_turf(C))
				if(istype(P, /mob/living/simple_animal/hostile/giant_spider))
					continue
				large_cocoon = TRUE
				fed++
				src.visible_message("\The [src] sticks a proboscis into \the [P] and sucks a viscous substance out.")
				P.forceMove(C)
				C.pixel_x = P.pixel_x
				C.pixel_y = P.pixel_y
				break
				if(istype(P, /obj/item))
					var/obj/item/I = P
					I.forceMove(C)
				if(istype(P, /obj/structure))
					var/obj/structure/S = P
					if(!S.anchored)
						S.forceMove(C)
						large_cocoon = 1
				if (istype(P, /obj/machinery))
					var/obj/machinery/M = P
					if(!M.anchored)
						M.forceMove(C)
						large_cocoon = 1
			if(large_cocoon)
				C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")


/mob/living/simple_animal/hostile/giant_spider/nurse/verb/eggs()
	set name = "Lay Eggs"
	set desc = "Lay a clutch of eggs to make new spiderlings. This will cost one food point."
	set category = "Greimorian"

	var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
	if(!E && fed > 0)
		src.visible_message("\The [src] begins to lay a cluster of eggs.")
		if(!do_after(src, 50))
			return
		E = locate() in get_turf(src)
		if(!E)
			new /obj/effect/spider/eggcluster(src.loc)
			fed--

/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/verb/servant()
	set name = "Lay Servant"
	set desc = "Lay a greimorian servant, which can be player-controlled. This will cost one food point."
	set category = "Greimorian"


	var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
	if(!E && fed > 0)
		src.visible_message("\The [src] begins to lay a servant.")
		if(!do_after(src, 120))
			return
		E = locate() in get_turf(src)
		if(!E)
			new /mob/living/simple_animal/hostile/giant_spider/nurse/servant(get_turf(src))
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			fed--

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
