/datum/ai_holder/simple_animal/retaliate/hivebot_harvester
	pointblank = TRUE
	conserve_ammo = TRUE
	wander = FALSE

/datum/ai_holder/simple_animal/retaliate/hivebot_harvester/handle_special_strategical()
	var/mob/living/simple_animal/hostile/retaliate/hivebotharvester/harvester = holder
	if(harvester.busy || (stance in AI_STANCES_COMBAT))
		return
	if(harvester.last_processed_turf == harvester.loc)
		INVOKE_ASYNC(harvester, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/hivebotharvester, prospect))
	else
		INVOKE_ASYNC(harvester, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/hivebotharvester, process_turf))

/datum/ai_holder/simple_animal/retaliate/hivebot_harvester/react_to_attack(atom/attacker)
	var/mob/living/simple_animal/hostile/retaliate/hivebotharvester/harvester = holder
	if(harvester.busy)
		harvester.AISetHarvestBusy(FALSE)
	return ..()

/mob/living/simple_animal/hostile/retaliate/hivebotharvester
	ai_holder_type = /datum/ai_holder/simple_animal/retaliate/hivebot_harvester
	name = "Hivebot Harvester"
	desc = "An odd and primitive looking machine. It emanates of powerful thermal radiation. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebotharvester"
	health = 100
	maxhealth = 100
	blood_type = COLOR_OIL
	blood_overlay_icon = 'icons/mob/npc/blood_overlay_hivebot.dmi'
	melee_damage_lower = 30
	melee_damage_upper = 30
	destroy_surroundings = 0
	wander = 0
	ranged = 1
	attacktext = "skewers"
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	projectiletype = /obj/projectile/beam/hivebot/incendiary/heavy
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
	pass_flags = PASSTABLE|PASSRAILING
	attack_emote = "focuses on"

	/// Weakref to the beacon that potentially spawned us.
	var/datum/weakref/parent_beacon

	var/turf/last_processed_turf
	var/turf/last_prospect_target
	var/turf/last_prospect_loc
	var/busy

	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = 0

	psi_pingable = FALSE
	sample_data = null

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Initialize(mapload,mob/living/simple_animal/hostile/hivebotbeacon/beacon)
	. = ..()
	if (beacon)
		parent_beacon = WEAKREF(beacon)
		beacon.harvester_amt++
	set_light(3,2,LIGHT_COLOR_RED)
	if(!mapload)
		spark(get_turf(src), 3, GLOB.alldirs)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/death()
	..(null,"teleports away!")
	spark(get_turf(src), 3, GLOB.alldirs)
	QDEL_IN(src, 0)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Destroy()
	var/mob/living/simple_animal/hostile/hivebotbeacon/beacon = parent_beacon?.resolve()
	if (beacon)
		beacon.linked_bots.Remove(src)
		beacon.harvester_amt--

	parent_beacon = null
	return ..()

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/AirflowCanMove(n)
	return 0

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike) || istype(hitting_projectile, /obj/projectile/beam/hivebot))
		return BULLET_ACT_BLOCK
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/emp_act(severity)
	. = ..()

	ai_holder.clear_target()
	visible_message(SPAN_DANGER("[src] suffers a teleportation malfunction!"))
	playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
	var/turf/random_turf = get_turf(pick(orange(src,7)))
	do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/proc/AISetHarvestBusy(new_busy)
	busy = new_busy
	set_AI_busy(!!new_busy)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/proc/process_turf()
	if(busy)
		return
	for(var/obj/O in src.loc)
		if(istype(O, /obj/item))
			var/obj/item/I = O
			for(I in src.loc)

				if(I.matter)
					AISetHarvestBusy(1)
					src.visible_message(SPAN_NOTICE("[src] begins to harvest \the [I]."))
					if(do_after(src, 32))
						src.visible_message(SPAN_WARNING("[src] harvests \the [I]."))
						qdel(I)
					AISetHarvestBusy(FALSE)
					continue

				if(istype(O, /obj/item/storage))
					var/obj/item/storage/S = O
					src.visible_message(SPAN_NOTICE("[src] begins to rip apart \the [S]."))
					AISetHarvestBusy(2)
					if(do_after(src, 32))
						src.visible_message(SPAN_WARNING("[src] rips \the [S] apart."))
						S.spill(3, src.loc)
						qdel(S)
					AISetHarvestBusy(FALSE)
					return

		if(istype(O, /obj/structure/table))
			var/obj/structure/table/TB = O
			src.visible_message(SPAN_NOTICE("[src] starts to dismantle \the [TB]."))
			AISetHarvestBusy(2)
			if(do_after(src, 48))
				src.visible_message(SPAN_WARNING("[src] dismantles \the [TB]."))
				TB.break_to_parts(1)
			AISetHarvestBusy(FALSE)
			return

		if(istype(O, /obj/structure/bed))
			var/obj/structure/bed/B = O
			if(B.can_dismantle)
				src.visible_message(SPAN_NOTICE("[src] starts to dismantle \the [B]."))
				AISetHarvestBusy(2)
				if(do_after(src, 48))
					src.visible_message(SPAN_WARNING("[src] dismantles \the [B]."))
					B.dismantle()
					qdel(B)
				AISetHarvestBusy(FALSE)
				return

		if(istype(O, /obj/structure/bed/stool))
			var/obj/structure/bed/stool/S = O
			src.visible_message(SPAN_NOTICE("[src] starts to dismantle \the [S]."))
			AISetHarvestBusy(2)
			if(do_after(src, 32))
				src.visible_message(SPAN_WARNING("[src] dismantles \the [S]."))
				S.dismantle()
			AISetHarvestBusy(FALSE)
			return

		if(istype(O, /obj/effect/decal/cleanable/blood/gibs/robot))
			src.visible_message(SPAN_NOTICE("[src] starts to recycle \the [O]."))
			AISetHarvestBusy(1)
			if(do_after(src, 48))
				src.visible_message(SPAN_WARNING("[src] recycles \the [O]."))
				qdel(O)
			AISetHarvestBusy(FALSE)
			continue

		if(istype(O, /obj/structure/cable))
			var/turf/simulated/floor/T = src.loc
			if(T.is_plating())
				var/obj/structure/cable/C = O
				src.visible_message(SPAN_NOTICE("[src] starts ripping up \the [C]."))
				AISetHarvestBusy(2)
				if(do_after(src, 32))
					src.visible_message(SPAN_WARNING("[src] rips \the [C]."))
					if(C.powernet && C.powernet.avail)
						spark(src, 3, GLOB.alldirs)
					new/obj/item/stack/cable_coil(T, C.d1 ? 2 : 1, C.color)
					qdel(C)
				AISetHarvestBusy(FALSE)
				return

	if(istype(src.loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = src.loc
		if(!T.is_plating())
			src.visible_message(SPAN_NOTICE("[src] starts ripping up \the [T]."))
			AISetHarvestBusy(2)
			if(do_after(src, 32))
				src.visible_message(SPAN_WARNING("[src] rips up \the [T]."))
				playsound(src.loc, SFX_CROWBAR, 100, 1)
				T.make_plating(1)
			AISetHarvestBusy(FALSE)
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
		destination = pick(GLOB.cardinals)
		T = get_step(src, destination)
		last_prospect_target = T
		last_prospect_loc = src.loc
		AISetHarvestBusy(FALSE)
	else
		T = last_prospect_target

	if(busy)
		return

	if(istype(T, /turf/space) || istype(T, /turf/simulated/mineral))
		last_prospect_target = null
		last_prospect_loc = null
		return

	if(istype(T, /turf/simulated/wall))
		rapid = 1
		OpenFire(T, ignore_visibility = TRUE)
		rapid = 0
		return

	for(var/obj/O in T)
		if(istype(O, /obj/structure/girder))
			var/obj/structure/girder/G = O
			src.visible_message(SPAN_NOTICE("[src] starts to tear \the [O] apart."))
			AISetHarvestBusy(1)
			if(do_after(src, 32))
				src.do_attack_animation(G)
				src.visible_message(SPAN_WARNING("[src] tears \the [O] apart!"))
				G.dismantle()
			AISetHarvestBusy(FALSE)
			continue

		if((istype(O, /obj/structure/machinery/door/firedoor) && O.density) || (istype(O, /obj/structure/machinery/door/airlock) && O.density) || istype(O, /obj/structure/machinery/door/blast) && O.density)
			var/obj/structure/machinery/door/D = O
			if(D.stat & BROKEN)
				src.visible_message(SPAN_NOTICE("[src] starts to tear \the [D] open."))
				AISetHarvestBusy(1)
				if(do_after(src, 48))
					src.visible_message(SPAN_WARNING("[src] tears \the [D] apart!"))
					src.do_attack_animation(D)
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					new /obj/item/stack/material/steel(get_turf(D))
					qdel(D)
				AISetHarvestBusy(FALSE)
			else if(istype(D, /obj/structure/machinery/door/airlock/multi_tile))
				D.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
			else
				rapid = 1
				OpenFire(D)
				rapid = 0
			return

		if(istype(O, /obj/structure/window))
			var/dir = get_dir(T,src.loc)
			var/obj/structure/window/W = O
			if(W.dir == REVERSE_DIR(dir))
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
			AISetHarvestBusy(1)
			if(do_after(src, 48))
				src.do_attack_animation(RD)
				RD.reagents.splash_turf(get_turf(RD.loc), RD.reagents.total_volume)
				src.visible_message(SPAN_DANGER("[RD] gets torn open, spreading its contents all over the area!"))
				new /obj/item/stack/material/steel(get_turf(RD))
				new /obj/item/stack/material/steel(get_turf(RD))
				qdel(RD)
			AISetHarvestBusy(FALSE)
			return

	if(T)
		Move(T)

	last_prospect_target = null
	last_prospect_loc = null

/mob/living/simple_animal/hostile/retaliate/hivebotharvester/shoot_wrapper(target, location, user)
	set_last_found_target(target)
	Shoot(target, location, user)
	unset_last_found_target()
	return
