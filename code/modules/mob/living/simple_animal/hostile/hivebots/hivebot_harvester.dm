/mob/living/simple_animal/hostile/retaliate/hivebotharvester
	name = "Hivebot Harvester"
	desc = "An odd and primitive looking machine. It emanates of powerful thermal radiation. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotharvester"
	health = 100
	maxHealth = 100
	blood_type = COLOR_OIL
	blood_overlay_icon = 'icons/mob/npc/blood_overlay_hivebot.dmi'
	melee_damage_lower = 30
	melee_damage_upper = 30
	destroy_surroundings = 0
	wander = 0
	ranged = 1
	attacktext = "skewered"
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	projectiletype = /obj/item/projectile/beam/hivebot/incendiary/heavy
	organ_names = list("head", "core", "side thruster", "harvesting array")
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
	mob_size = MOB_LARGE
	see_in_dark = 8
	pass_flags = PASSTABLE|PASSRAILING
	attack_emote = "focuses on"
	var/mob/living/simple_animal/hostile/hivebotbeacon/linked_parent = null
	var/turf/last_processed_turf
	var/turf/last_prospect_target
	var/turf/last_prospect_loc
	var/busy

	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = 0
	
	psi_pingable = FALSE

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	if(hivebotbeacon)
		linked_parent = hivebotbeacon
		linked_parent.harvester_amt ++
	.=..()
	set_light(3,2,LIGHT_COLOR_RED)
	if(!mapload)
		new /obj/effect/effect/smoke(src.loc,30)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/death()
	..(null,"teleports away!")
	if(linked_parent)
		linked_parent.harvester_amt --
	new /obj/effect/effect/smoke(src.loc,30)
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Destroy()
	. = ..()
	if(linked_parent)
		linked_parent.linked_bots -= src

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/AirflowCanMove(n)
	return 0

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else
		return ..(Proj)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	visible_message(SPAN_DANGER("[src] suffers a teleportation malfunction!"))
	playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
	var/turf/random_turf = get_turf(pick(orange(src,7)))
	do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/think()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			if(last_processed_turf == src.loc)
				INVOKE_ASYNC(src, PROC_REF(prospect))
			else
				INVOKE_ASYNC(src, PROC_REF(process_turf))
		else if(busy)
			busy = 0
			update_icon()
	if(wander)
		wander = 0

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/proc/process_turf()
	if(busy)
		return
	for(var/obj/O in src.loc)
		if(istype(O, /obj/item))
			var/obj/item/I = O
			for(I in src.loc)

				if(I.matter)
					busy = 1
					update_icon()
					src.visible_message(SPAN_NOTICE("[src] begins to harvest \the [I]."))
					if(do_after(src, 32))
						src.visible_message(SPAN_WARNING("[src] harvests \the [I]."))
						qdel(I)
					busy = 0
					update_icon()
					continue

				if(istype(O, /obj/item/storage))
					var/obj/item/storage/S = O
					src.visible_message(SPAN_NOTICE("[src] begins to rip apart \the [S]."))
					busy = 2
					update_icon()
					if(do_after(src, 32))
						src.visible_message(SPAN_WARNING("[src] rips \the [S] apart."))
						S.spill(3, src.loc)
						qdel(S)
					busy = 0
					update_icon()
					return

		if(istype(O, /obj/structure/table))
			var/obj/structure/table/TB = O
			src.visible_message(SPAN_NOTICE("[src] starts to dismantle \the [TB]."))
			busy = 2
			update_icon()
			if(do_after(src, 48))
				src.visible_message(SPAN_WARNING("[src] dismantles \the [TB]."))
				TB.break_to_parts(1)
			busy = 0
			update_icon()
			return

		if(istype(O, /obj/structure/bed))
			var/obj/structure/bed/B = O
			if(B.can_dismantle)
				src.visible_message(SPAN_NOTICE("[src] starts to dismantle \the [B]."))
				busy = 2
				update_icon()
				if(do_after(src, 48))
					src.visible_message(SPAN_WARNING("[src] dismantles \the [B]."))
					B.dismantle()
					qdel(B)
				busy = 0
				update_icon()
				return

		if(istype(O, /obj/structure/bed/stool))
			var/obj/structure/bed/stool/S = O
			src.visible_message(SPAN_NOTICE("[src] starts to dismantle \the [S]."))
			busy = 2
			update_icon()
			if(do_after(src, 32))
				src.visible_message(SPAN_WARNING("[src] dismantles \the [S]."))
				S.dismantle()
			busy = 0
			update_icon()
			return

		if(istype(O, /obj/effect/decal/cleanable/blood/gibs/robot))
			src.visible_message(SPAN_NOTICE("[src] starts to recycle \the [O]."))
			busy = 1
			update_icon()
			if(do_after(src, 48))
				src.visible_message(SPAN_WARNING("[src] recycles \the [O]."))
				qdel(O)
			busy = 0
			update_icon()
			continue

		if(istype(O, /obj/structure/cable))
			var/turf/simulated/floor/T = src.loc
			if(T.is_plating())
				var/obj/structure/cable/C = O
				src.visible_message(SPAN_NOTICE("[src] starts ripping up \the [C]."))
				busy = 2
				update_icon()
				if(do_after(src, 32))
					src.visible_message(SPAN_WARNING("[src] rips \the [C]."))
					if(C.powernet && C.powernet.avail)
						spark(src, 3, alldirs)
					new/obj/item/stack/cable_coil(T, C.d1 ? 2 : 1, C.color)
					qdel(C)
				busy = 0
				update_icon()
				return

	if(istype(src.loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = src.loc
		if(!T.is_plating())
			src.visible_message(SPAN_NOTICE("[src] starts ripping up \the [T]."))
			busy = 2
			update_icon()
			if(do_after(src, 32))
				src.visible_message(SPAN_WARNING("[src] rips up \the [T]."))
				playsound(src.loc, /decl/sound_category/crowbar_sound, 100, 1)
				T.make_plating(1)
			busy = 0
			update_icon()
			return

	last_processed_turf = src.loc

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/update_icon()
	if(busy)
		if(busy == 1)
			icon_state = "hivebotharvester_harvesting"
		else
			icon_state = "hivebotharvester_ripping"
	else
		icon_state = "hivebotharvester"
	if(resting || stat == DEAD || busy)
		blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	else
		blood_overlay_icon = initial(blood_overlay_icon)
	handle_blood(TRUE)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/proc/prospect()

	var/destination
	var/turf/T

	if((!last_prospect_target) || (last_prospect_loc != src.loc))
		destination = pick(cardinal)
		T = get_step(src, destination)
		last_prospect_target = T
		last_prospect_loc = src.loc
		busy = 0
	else
		T = last_prospect_target

	if(busy)
		return

	if(istype(T, /turf/space) || istype(T, /turf/simulated/mineral))
		last_prospect_target = null
		last_prospect_loc = null
		return

	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		rapid = 1
		OpenFire(W)
		rapid = 0
		return

	for(var/obj/O in T)
		if(istype(O, /obj/structure/girder))
			var/obj/structure/girder/G = O
			src.visible_message(SPAN_NOTICE("[src] starts to tear \the [O] apart."))
			busy = 1
			if(do_after(src, 32))
				src.do_attack_animation(G)
				src.visible_message(SPAN_WARNING("[src] tears \the [O] apart!"))
				G.dismantle()
			busy = 0
			continue

		if((istype(O, /obj/machinery/door/firedoor) && O.density) || (istype(O, /obj/machinery/door/airlock) && O.density) || istype(O, /obj/machinery/door/blast) && O.density)
			var/obj/machinery/door/D = O
			if(D.stat & BROKEN)
				src.visible_message(SPAN_NOTICE("[src] starts to tear \the [D] open."))
				busy = 1
				if(do_after(src, 48))
					src.visible_message(SPAN_WARNING("[src] tears \the [D] apart!"))
					src.do_attack_animation(D)
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					qdel(D)
				busy = 0
			else if(istype(D, /obj/machinery/door/airlock/multi_tile))
				D.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			else
				rapid = 1
				OpenFire(D)
				rapid = 0
			return

		if(istype(O, /obj/structure/window))
			var/dir = get_dir(T,src.loc)
			var/obj/structure/window/W = O
			if(W.dir == reverse_dir[dir])
				W.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			else
				W.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			return

		if(istype(O, /obj/structure/grille))
			var/obj/structure/grille/G = O
			G.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			return

		if(istype(O, /obj/structure/blocker) || istype(O, /obj/structure/closet) || istype(O, /obj/structure/inflatable))
			var/obj/structure/S = O
			rapid = 1
			OpenFire(S)
			rapid = 0
			return

		if(istype(O, /obj/structure/reagent_dispensers))
			var/obj/structure/reagent_dispensers/RD = O
			src.visible_message(SPAN_NOTICE("[src] starts taking apart \the [RD]."))
			busy = 1
			if(do_after(src, 48))
				src.do_attack_animation(RD)
				RD.reagents.splash_turf(get_turf(RD.loc), RD.reagents.total_volume)
				src.visible_message(SPAN_DANGER("[RD] gets torn open, spreading its contents all over the area!"))
				new /obj/item/stack/material/steel(get_turf(RD))
				new /obj/item/stack/material/steel(get_turf(RD))
				qdel(RD)
			busy = 0
			return

	if(T)
		Move(T)

	last_prospect_target = null
	last_prospect_loc = null

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/shoot_wrapper(target, location, user)
	target_mob = target
	if(see_target())
		Shoot(target, location, user)
	target_mob = null
	return