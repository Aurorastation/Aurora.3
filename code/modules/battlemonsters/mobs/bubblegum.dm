/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum
	name = "Bubblegum"
	short_name = "bubblegum"
	icon = 'icons/mob/96x96megafauna.dmi'
	icon_state = "bubblegum"
	icon_living = "bubblegum"
	icon_dead = ""
	icon_gib = ""

	attack_sound = 'sound/magic/demon_attack1.ogg'

	attack_points = 1000
	defense_points = 3000
	health = 3000
	maxHealth = 3000

	rapid = 1

	speed = 0.5 SECONDS
	move_to_delay = 0.5 SECONDS
	attack_delay = 0.25 SECONDS

	projectilesound = 'sound/magic/enter_blood.ogg'
	projectiletype = /obj/item/projectile/energy/electrode/blood_bolt

	pixel_x = -32

	ranged = 1

	var/next_shoot = 0

	var/next_blood = 0

	var/charging = FALSE

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/think()

	if(charging)
		return

	if(stance == HOSTILE_STANCE_ATTACK && next_blood <= world.time)
		var/blood_view = world.view * 2
		for (var/mob/living/scanned_mob in view(blood_view, get_turf(src)))
			if(scanned_mob == src)
				continue
			if(!CanAquireTarget(scanned_mob))
				continue
			if(!locate(/obj/effect/decal/cleanable/blood/holographic) in get_turf(scanned_mob))
				continue

			new/obj/effect/tendril(get_turf(scanned_mob))

		next_blood = world.time + 1 SECONDS

	if(stance == HOSTILE_STANCE_ATTACK && next_shoot <= world.time)

		var/list/moveset = list(
			"sprayblood" = 1,
			"teleport" = 4
		)

		if(pickweight(moveset) == "sprayblood")
			var/projectiles_to_shoot = rand(3,5)
			var/i_mod = -projectiles_to_shoot*0.5
			var/spread_per_shot = min(rand(5,10),360/projectiles_to_shoot)

			for(var/i=1,i < projectiles_to_shoot,i++)
				var/obj/item/projectile/energy/electrode/blood_bolt/spawned_projectile = new(src.loc)
				spawned_projectile.launch_projectile(target_mob, get_exposed_defense_zone(target_mob), src, 0, Get_Angle(src, target_mob) + (i_mod+i)*spread_per_shot)

			playsound(src, projectilesound, 100, 1)

			return TRUE

		else
			var/list/potential_turfs = list()

			for (var/obj/effect/decal/cleanable/blood/holographic/found_blood in view(world.view, get_turf(src)))
				potential_turfs += get_turf(found_blood)

			if(potential_turfs.len)
				visible_message("<span class='danger'>[src] sinks into the blood...</span>")
				playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 100, 1, -1)
				forceMove(pick(potential_turfs))
				playsound(get_turf(src), 'sound/magic/exit_blood.ogg', 100, 1, -1)
				visible_message("<span class='danger'>... and springs back out!</span>")
				ranged = TRUE

		next_shoot = world.time + 10 SECONDS

	. = ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/AttackingTarget()
	if(charging)
		return
	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/DestroySurroundings()
	if(charging)
		return

	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/follow_target()
	if(charging)
		return

	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/MoveToTarget()
	if(charging)
		return

	. = ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/OpenFire(target_mob)

	if(charging)
		return

	face_atom(target_mob)

	if(prob(50))
		INVOKE_ASYNC(src, .proc/charge, target_mob)
		if(prob(25))
			INVOKE_ASYNC(src, .proc/charge_multi, target_mob)

	return ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/proc/charge_multi(var/target_mob)
	charge(target_mob)
	charge(target_mob)
	charge(target_mob)

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/proc/charge(var/target_mob)
	if(charging)
		return
	var/turf/T = get_turf(target_mob)
	if(!T || T == loc)
		return
	new /obj/effect/temp_visual/dragon_swoop(T)
	charging = TRUE
	DestroySurroundings()
	walk(src, 0)
	set_dir(get_dir(src, T))
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc,src)
	animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 3)
	sleep(3)
	throw_at(T, get_dist(src, T) + 4, 2, src)
	sleep(1)
	charging = FALSE
	if(prob(25) && !ckey)
		ranged = FALSE
	next_shoot = world.time + 2 SECONDS

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/Move()
	if(!stat)
		playsound(src.loc, 'sound/effects/meteorimpact.ogg', 200, 1, 2, 1)
	if(charging)
		new/obj/effect/temp_visual/decoy/fading(loc,src)
		DestroySurroundings()
	else if(!ranged)
		DestroySurroundings()
		if(prob(25))
			INVOKE_ASYNC(src, .proc/charge_multi, target_mob)
			return
	. = ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/bubblegum/throw_impact(atom/A)
	if(!charging)
		return ..()

	else if(isliving(A))
		var/mob/living/L = A
		L.visible_message("<span class='danger'>[src] slams into [L]!</span>", "<span class='danger'>[src] slams into you!</span>")
		L.adjustHalLoss(rand(melee_damage_lower,melee_damage_upper)*2)
		playsound(get_turf(L), 'sound/effects/meteorimpact.ogg', 100, 1)
		shake_camera(L, 4, 3)
		shake_camera(src, 2, 3)
		var/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
		L.throw_at(throwtarget, 3)

/obj/effect/temp_visual/decoy
	desc = "It's a decoy!"
	duration = 15

/obj/effect/temp_visual/decoy/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	alpha = initial(alpha)
	if(mimiced_atom)
		name = mimiced_atom.name
		appearance = mimiced_atom.appearance
		set_dir(mimiced_atom.dir)
		mouse_opacity = 0

/obj/effect/temp_visual/decoy/fading/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/tendril
	name = "tendril"
	icon = 'icons/mob/lavaland_monsters.dmi'
	desc = "This is just like one of my japanese animes!"

/obj/effect/tendril/Initialize()
	. = ..()
	INVOKE_ASYNC(src, .proc/do_tendril)

/obj/effect/tendril/proc/do_tendril()
	icon_state = "Goliath_tentacle_spawn"
	update_icon()
	sleep(7)
	for(var/mob/living/L in get_turf(src))
		L.adjustHalLoss(10)
	icon_state = "Goliath_tentacle_retract"
	update_icon()
	sleep(7)
	qdel(src)