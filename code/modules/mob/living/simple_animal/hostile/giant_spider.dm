
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

/datum/ai_holder/simple_animal/giant_spider
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	can_flee = FALSE

/datum/ai_holder/simple_animal/giant_spider/handle_special_strategical()
	if(stance != AI_STANCE_IDLE || !prob(1))
		return
	var/turf/skitter_target = get_turf(pick(orange(20, holder)))
	if(skitter_target)
		give_destination(skitter_target, 1)

/datum/ai_holder/simple_animal/giant_spider/nurse
	var/nurse_task = 0
	var/atom/cocoon_target

/datum/ai_holder/simple_animal/giant_spider/nurse/Destroy()
	cocoon_target = null
	return ..()

/datum/ai_holder/simple_animal/giant_spider/nurse/handle_special_tactic()
	if(nurse_task != MOVING_TO_TARGET)
		return
	if(QDELETED(cocoon_target) || !isturf(cocoon_target.loc))
		cancel_nurse_task()
		return
	if(holder.Adjacent(cocoon_target))
		start_cocooning()
	else if(stance != AI_STANCE_MOVE)
		give_destination(get_turf(cocoon_target), 1)

/datum/ai_holder/simple_animal/giant_spider/nurse/handle_special_strategical()
	if(nurse_task || stance != AI_STANCE_IDLE || !prob(30))
		return

	for(var/mob/living/possible_food in view(holder, vision_range))
		if(possible_food.stat && !istype(possible_food, /mob/living/simple_animal/hostile/giant_spider))
			move_to_cocoon_target(possible_food)
			return

	var/mob/living/simple_animal/hostile/giant_spider/nurse/nurse = holder
	if(!locate(/obj/effect/spider/stickyweb) in holder.loc)
		start_timed_nurse_task(SPINNING_WEB, 4 SECONDS, "begins to secrete a sticky substance")
		return

	var/obj/effect/spider/eggcluster/existing_eggs = locate() in get_turf(holder)
	if(!existing_eggs && nurse.fed > 0)
		start_timed_nurse_task(LAYING_EGGS, 5 SECONDS, "begins to lay a cluster of eggs")
		return

	for(var/obj/possible_item in view(holder, vision_range))
		if(possible_item.anchored)
			continue
		if(istype(possible_item, /obj/item) || istype(possible_item, /obj/structure))
			move_to_cocoon_target(possible_item)
			return

/datum/ai_holder/simple_animal/giant_spider/nurse/proc/move_to_cocoon_target(atom/new_target)
	if(QDELETED(new_target) || !isturf(new_target.loc))
		return FALSE
	cocoon_target = new_target
	nurse_task = MOVING_TO_TARGET
	return give_destination(get_turf(new_target), 1)

/datum/ai_holder/simple_animal/giant_spider/nurse/proc/start_cocooning()
	if(QDELETED(cocoon_target) || !holder.Adjacent(cocoon_target))
		return cancel_nurse_task()
	nurse_task = SPINNING_COCOON
	set_busy(TRUE)
	holder.visible_message(SPAN_NOTICE("\The [holder] begins to secrete a sticky substance around \the [cocoon_target]."))
	addtimer(CALLBACK(src, PROC_REF(finish_nurse_task), SPINNING_COCOON), 5 SECONDS, TIMER_DELETE_ME)
	return TRUE

/datum/ai_holder/simple_animal/giant_spider/nurse/proc/start_timed_nurse_task(task, duration, message)
	nurse_task = task
	set_busy(TRUE)
	holder.visible_message(SPAN_NOTICE("\The [holder] [message]."))
	addtimer(CALLBACK(src, PROC_REF(finish_nurse_task), task), duration, TIMER_DELETE_ME)

/datum/ai_holder/simple_animal/giant_spider/nurse/proc/finish_nurse_task(expected_task)
	if(QDELETED(holder) || nurse_task != expected_task)
		return
	var/mob/living/simple_animal/hostile/giant_spider/nurse/nurse = holder
	switch(expected_task)
		if(SPINNING_WEB)
			nurse.AIPlaceWeb()
		if(LAYING_EGGS)
			nurse.AIPlaceEggs()
		if(SPINNING_COCOON)
			nurse.AIWrapCocoon(cocoon_target)
	cancel_nurse_task()

/datum/ai_holder/simple_animal/giant_spider/nurse/proc/cancel_nurse_task()
	nurse_task = 0
	cocoon_target = null
	destination = null
	forget_path()
	set_busy(FALSE)
	if(stance == AI_STANCE_MOVE)
		set_stance(AI_STANCE_IDLE)
	return FALSE

/datum/ai_holder/simple_animal/giant_spider/nurse/react_to_attack(atom/attacker)
	if(nurse_task)
		cancel_nurse_task()
	return ..()

//basic spider mob, these generally guard nests
/mob/living/simple_animal/hostile/giant_spider
	ai_holder_type = /datum/ai_holder/simple_animal/giant_spider
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
	maxhealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	armor_penetration = 10
	resist_mod = 1.5
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	var/venom_per_bite = 5
	var/venom_type = /singleton/reagent/toxin
	faction = "spiders"
	var/busy = 0
	pass_flags = PASSTABLE
	speed = 6
	mob_size = 6

	attacktext = "bites"
	attack_vis_effect = ATTACK_EFFECT_BITE
	attack_emote = "skitters toward"
	attack_sound = 'sound/weapons/bite.ogg'
	emote_sounds = list('sound/effects/creatures/spider_critter.ogg')
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Tissue sample contains high muscle content")
	footstep_sound = 'sound/effects/creatures/spider_walk.ogg'

//nursemaids - these create webs and eggs
/mob/living/simple_animal/hostile/giant_spider/nurse
	ai_holder_type = /datum/ai_holder/simple_animal/giant_spider/nurse
	name = "greimorian worker"
	desc = "A hideous Greimorian with vestigial wings and an awful stench about it. This one is brown with shimmering, bulbous red eyes."
	icon_state = "greimorian_worker"
	icon_living = "greimorian_worker"
	icon_dead = "greimorian_worker_dead"
	blood_amount = 50
	maxhealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 20
	venom_per_bite = 4
	venom_type = /singleton/reagent/toxin/greimorian_eggs
	var/fed = 0
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular structures indicative of high offspring production")

/mob/living/simple_animal/hostile/giant_spider/nurse/servant
	name = "greimorian servant"
	desc = "A greimorian with a startling intelligence to its bulbous yellow eyes. Its needle-like mandibles look like they could easily punch through armor - or flesh."
	icon_state = "greimorian_servant"
	icon_living = "greimorian_servant"
	icon_dead = "greimorian_servant_dead"
	blood_amount = 150
	maxhealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	armor_penetration = 30
	venom_per_bite = 1
	speed = -2
	venom_type = /singleton/reagent/toxin/greimorian_eggs
	fed = 1
	lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	var/playable = TRUE
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular structures indicative of high offspring production", "Tissue sample contains high neural cell content")

/mob/living/simple_animal/hostile/giant_spider/nurse/servant/Life(seconds_per_tick, times_fired)
	..()
	adjustBruteLoss(-2)

//hunters have the most poison and move the fastest, so they can find prey
/mob/living/simple_animal/hostile/giant_spider/hunter
	ai_holder_type = /datum/ai_holder/simple_animal/melee/evasive
	name = "greimorian hunter"
	desc = "A vicious, hostile red Greimorian. This one holds a mighty stinger to impale its prey."
	icon_state = "greimorian_hunter"
	icon_living = "greimorian_hunter"
	icon_dead = "greimorian_hunter_dead"
	blood_amount = 90
	maxhealth = 120
	health = 120
	melee_damage_lower = 10
	melee_damage_upper = 20
	armor_penetration = 15
	venom_per_bite = 5
	speed = 4
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular biochemistry shows high metabolic capacity")

/mob/living/simple_animal/hostile/giant_spider/emp
	name = "greimorian jackal"
	desc = "A slithering bright blue Greimorian. This one gently buzzes with electrical potential."
	icon_state = "greimorian_jackal"
	icon_living = "greimorian_jackal"
	icon_dead = "greimorian_jackal_dead"
	maxhealth = 100
	health = 100
	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 15
	venom_type = /singleton/reagent/perconol // mildly beneficial for organics
	venom_per_bite = 2
	speed = 5
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Cellular biochemistry geared towards creating strong electrical potential differences")

/mob/living/simple_animal/hostile/giant_spider/bombardier
	ai_holder_type = /datum/ai_holder/simple_animal/ranged/kiting
	name = "greimorian bombardier"
	desc = "A disgusting crawling Greimorian. This one has vents that shoot out acid."
	icon_state = "greimorian_bombardier"
	icon_living = "greimorian_bombardier"
	icon_dead = "greimorian_bombardier_dead"
	maxhealth = 60
	health = 60
	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 5
	ranged = TRUE
	ranged_attack_range = 4
	venom_type = /singleton/reagent/acid/greimorian
	venom_per_bite = 2
	speed = 5
	sample_data = list("Genetic markers identified as being linked with stem cell differentiaton", "Exocrinic acid synthesis detected")

/mob/living/simple_animal/hostile/giant_spider/bombardier/Shoot(var/target, var/start, var/mob/user, var/bullet = 0)
	if(target == start)
		return

	playsound(loc, 'sound/effects/spray2.ogg', 50, 1, -6)

	var/turf/target_turf = get_turf(target)
	var/obj/effect/effect/water/chempuff/pepperspray = new /obj/effect/effect/water/chempuff(get_turf(src))
	pepperspray.create_reagents(10)
	pepperspray.reagents.add_reagent(venom_type, 10)
	pepperspray.set_color()
	pepperspray.set_up(target_turf, 3, 5)

/mob/living/simple_animal/hostile/giant_spider/bombardier/AICheckRangedAttack(atom/target)
	// The bombardier uses its custom acid-spray Shoot() implementation instead of a projectile type.
	return ranged

/mob/living/simple_animal/hostile/giant_spider/Initialize(mapload, atom/parent)
	. = ..()
	get_light_and_color(parent)
	add_language(LANGUAGE_GREIMORIAN)
	add_language(LANGUAGE_GREIMORIAN_HIVEMIND)
	remove_language(LANGUAGE_TCB)
	default_language = GLOB.all_languages[LANGUAGE_GREIMORIAN]
	ADD_TRAIT(src, TRAIT_MC_SPACE_FAUNA, TRAIT_SOURCE_MOB_CATEGORY)

/mob/living/simple_animal/hostile/giant_spider/nurse/servant/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/ventcrawl)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	if(playable && !ckey && !client)
		SSghostroles.add_spawn_atom("servant", src)

/mob/living/simple_animal/hostile/giant_spider/nurse/servant/Destroy()
	SSghostroles.remove_spawn_atom("servant", src)
	return ..()

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
		if(prob(inject_probability) && !BP_IS_ROBOTIC(limb))
			to_chat(target, SPAN_WARNING("You feel a tiny prick."))
			target.reagents.add_reagent(venom_type, venom_per_bite)

/mob/living/simple_animal/hostile/giant_spider/nurse/on_attack_mob(var/mob/living/carbon/human/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(istype(limb))
		if(BP_IS_ROBOTIC(limb))
			to_chat(hit_mob, SPAN_WARNING("\The [src] tries to inject something into your [limb.name], but fortunately it finds no living flesh!"))
		else
			to_chat(hit_mob, SPAN_WARNING("\The [src] injects something into your [limb.name]!"))

/mob/living/simple_animal/hostile/giant_spider/emp/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(ishuman(hit_mob))
		var/mob/living/carbon/human/H = hit_mob
		if(prob(20))
			var/obj/item/organ/internal/machine/power_core/cell_holder = locate() in H.internal_organs
			if(cell_holder)
				var/obj/item/cell/C = cell_holder.cell
				if(C)
					to_chat(H, SPAN_WARNING("\The [src] saps some of your energy!"))
					C.use(C.maxcharge / 15)
			if(istype(limb) && (limb.status & ORGAN_ROBOT|ORGAN_ADV_ROBOT))
				H.visible_message(SPAN_WARNING("\The [src] bites down onto \the [H]'s [limb.name]!"), SPAN_WARNING("\The [src] bites down onto your [limb.name]!"))
				limb.emp_act(EMP_LIGHT)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/AIPlaceEggs()
	if(fed > 0 && !(locate(/obj/effect/spider/eggcluster) in get_turf(src)))
		new /obj/effect/spider/eggcluster(loc, src)
		fed--

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/AIPlaceWeb()
	if(!locate(/obj/effect/spider/stickyweb) in loc)
		new /obj/effect/spider/stickyweb(loc)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/AIWrapCocoon(atom/target)
	if(!target || !isturf(target.loc) || get_dist(src, target) > 1)
		return FALSE
	var/obj/effect/spider/cocoon/C = new(target.loc)
	var/large_cocoon = FALSE
	C.pixel_x = target.pixel_x
	C.pixel_y = target.pixel_y
	for(var/atom/movable/contents in C.loc)
		if(ismob(contents))
			var/mob/mob_contents = contents
			if(istype(mob_contents, /mob/living/simple_animal/hostile/giant_spider) && mob_contents.stat != DEAD)
				continue
			large_cocoon = TRUE
			fed++
			visible_message(SPAN_WARNING("\The [src] sticks a proboscis into \the [target] and sucks a viscous substance out."))
			playsound(get_turf(src), 'sound/effects/lingabsorbs.ogg', 50, TRUE)
			mob_contents.forceMove(C)
			C.pixel_x = mob_contents.pixel_x
			C.pixel_y = mob_contents.pixel_y
			break
		if(istype(contents, /obj/item))
			contents.forceMove(C)
		if(istype(contents, /obj/structure) && !contents.anchored)
			contents.forceMove(C)
			large_cocoon = TRUE
	if(large_cocoon)
		C.icon_state = pick("cocoon_large1", "cocoon_large2", "cocoon_large3")
	return TRUE

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
			if(large_cocoon)
				C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")


/mob/living/simple_animal/hostile/giant_spider/nurse/verb/eggs()
	set name = "Lay Eggs"
	set desc = "Lay a clutch of eggs to make new spiderlings. This will cost one food point."
	set category = "Greimorian"

	if(fed <= 0)
		to_chat(src, SPAN_WARNING("You do not have the nutrients to do this. Try cocooning a corpse!"))
		return

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

	if(fed <= 0)
		to_chat(src, SPAN_WARNING("You do not have the nutrients to do this. Try cocooning a corpse!"))
		return

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
