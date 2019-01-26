#define TESLA_DEFAULT_POWER 1738260
#define TESLA_MINI_POWER 869130

/obj/singularity/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	pixel_x = -32
	pixel_y = -32
	current_size = STAGE_TWO
	move_self = 1
	grav_pull = 0
	contained = 0
	density = 1
	energy = 0
	dissipate = 1
	dissipate_delay = 5
	dissipate_strength = 1
	layer = LIGHTING_LAYER + 0.1
	blend_mode = BLEND_ADD
	var/failed_direction = 0
	var/list/orbiting_balls = list()
	var/produced_power
	var/energy_to_raise = 32
	var/energy_to_lower = -20

/obj/singularity/energy_ball/ex_act(severity, target)
	return

/obj/singularity/energy_ball/Destroy()
	if(orbiting && istype(orbiting.orbiting, /obj/singularity/energy_ball))
		var/obj/singularity/energy_ball/EB = orbiting.orbiting
		EB.orbiting_balls -= src

	for(var/ball in orbiting_balls)
		var/obj/singularity/energy_ball/EB = ball
		qdel(EB)

	. = ..()

/obj/singularity/energy_ball/process()
	if(!orbiting)
		handle_energy()

		move_the_basket_ball(rand(1,4 + orbiting_balls.len * 1.5))

		playsound(src.loc, 'sound/magic/lightningbolt.ogg', 100, 1, extrarange = 30)

		pixel_x = 0
		pixel_y = 0

		dir = tesla_zap(src, 7, TESLA_DEFAULT_POWER, TRUE)

		pixel_x = -32
		pixel_y = -32
		for (var/ball in orbiting_balls)
			var/range = rand(1, Clamp(orbiting_balls.len, 3, 7))
			tesla_zap(ball, range, TESLA_MINI_POWER/7*range, TRUE)
	else
		energy = 0 // ensure we dont have miniballs of miniballs
	if(energy < 0)
		qdel(src)

/obj/singularity/energy_ball/examine(mob/user)
	..()
	if(orbiting_balls.len)
		user << "There are [orbiting_balls.len] energy balls orbiting \the [src]."


/obj/singularity/energy_ball/proc/move_the_basket_ball(var/move_amount)

	var/list/valid_directions = alldirs.Copy()

	var/can_zmove = !(locate(/obj/machinery/containment_field) in view(12,src))
	if(can_zmove && prob(10))
		valid_directions.Add(UP)
		valid_directions.Add(DOWN)

	valid_directions.Remove(failed_direction)

	var/move_dir = 0
	if(target && prob(75))
		move_dir = get_dir(src,target)
	else
		valid_directions.Remove(dir)
		move_dir = (prob(50) && (dir != failed_direction)) ? dir : pick(valid_directions)

	if(move_dir & (UP | DOWN) )
		move_amount = 0

	for(var/i in 0 to move_amount)
		do_single_move(move_dir)

/obj/singularity/energy_ball/proc/do_single_move(var/move_dir)
	var/z_move = 0
	var/turf/T
	switch(move_dir)
		if(UP)
			T = GetAbove(src)
			z_move = 1
		if(DOWN)
			T = GetBelow(src)
			z_move = -1
		else
			T = get_step(src, move_dir)

	if(can_move(T) && can_dunk(get_turf(src),T,move_dir))
		switch(z_move)
			if(1)
				visible_message(span("danger","\The [src] gravitates upwards!"))
				forceMove(T)
				visible_message(span("danger","\The [src] gravitates from below!"))
			if(0)
				forceMove(T)
			if(-1)
				visible_message(span("danger","\The [src] gravitates downwards!"))
				forceMove(T)
				visible_message(span("danger","\The [src] gravitates from above!"))

		if(dir in alldirs)
			dir = move_dir
		else
			dir = pick(alldirs)

		for(var/mob/living/carbon/C in loc)
			dust_mobs(C)
		failed_direction = 0
	else
		failed_direction = move_dir

/obj/singularity/energy_ball/proc/can_dunk(var/turf/old_turf,var/turf/new_turf,var/move_direction)

	if(istype(new_turf,/turf/simulated/wall/r_wall))
		return FALSE

	if(istype(old_turf,/turf/simulated/floor/reinforced) && (move_direction & DOWN))
		return FALSE

	if(istype(new_turf,/turf/simulated/floor/reinforced) && (move_direction & UP))
		return FALSE

	return TRUE

/obj/singularity/energy_ball/proc/handle_energy()
	if(energy >= energy_to_raise)
		energy_to_lower = energy_to_raise - 20
		energy_to_raise = energy_to_raise * 1.25

		playsound(src.loc, 'sound/magic/lightning_chargeup.ogg', 100, 1, extrarange = 30)
		addtimer(CALLBACK(src, .proc/new_mini_ball), 100)

	else if(energy < energy_to_lower && orbiting_balls.len)
		energy_to_raise = energy_to_raise / 1.25
		energy_to_lower = (energy_to_raise / 1.25) - 20

		var/Orchiectomy_target = pick(orbiting_balls)
		qdel(Orchiectomy_target)

	else if(orbiting_balls.len)
		dissipate() //sing code has a much better system.
	else // that is when we have no balls but our energy is less
		energy_to_raise = energy_to_raise / 1.25
		energy_to_lower = (energy_to_raise / 1.25) - 20

/obj/singularity/energy_ball/proc/new_mini_ball()
	if(!loc)
		return
	var/obj/singularity/energy_ball/EB = new(loc, 0)

	EB.transform *= pick(0.3, 0.4, 0.5, 0.6, 0.7)
	var/icon/I = icon(icon,icon_state,dir)

	var/orbitsize = (I.Width() + I.Height()) * pick(0.4, 0.5, 0.6, 0.7, 0.8)
	orbitsize -= (orbitsize / world.icon_size) * (world.icon_size * 0.25)

	EB.orbit(src, orbitsize, pick(FALSE, TRUE), rand(10, 25), pick(3, 4, 5, 6, 36))


/obj/singularity/energy_ball/Collide(atom/A)
	. = ..()
	dust_mobs(A)

/obj/singularity/energy_ball/CollidedWith(atom/A)
	. = ..()
	dust_mobs(A)

/obj/singularity/energy_ball/orbit(obj/singularity/energy_ball/target)
	if (istype(target))
		target.orbiting_balls += src
		target.dissipate_strength = target.orbiting_balls.len

	. = ..()

/obj/singularity/energy_ball/stop_orbit()
	if (orbiting && istype(orbiting.orbiting, /obj/singularity/energy_ball))
		var/obj/singularity/energy_ball/orbitingball = orbiting.orbiting
		orbitingball.orbiting_balls -= src
		orbitingball.dissipate_strength = orbitingball.orbiting_balls.len
	. = ..()
	if (!loc && !QDELETED(src))
		qdel(src)

/obj/singularity/energy_ball/proc/dust_mobs(atom/A)
	if(!iscarbon(A))
		return
	for(var/obj/machinery/power/grounding_rod/GR in orange(src, 2))
		if(GR.anchored)
			return
	var/mob/living/carbon/C = A
	C.dust()

/proc/tesla_zap(atom/source, zap_range = 3, power, explosive = FALSE, stun_mobs = TRUE)
	. = source.dir
	if(power < 1000)
		return

	var/closest_dist = 0
	var/closest_atom
	var/obj/machinery/power/tesla_coil/closest_tesla_coil
	var/obj/machinery/power/grounding_rod/closest_grounding_rod
	var/mob/living/closest_mob
	var/obj/machinery/closest_machine
	var/obj/structure/closest_structure
	var/obj/machinery/power/emitter/closest_emitter // Use only if Tesla is too grown with 10 ore more balls. Will escape.
	var/static/list/blacklisted_types = typecacheof(list(
		/obj/machinery/atmospherics,
		/obj/machinery/power/emitter,
		/obj/machinery/field_generator,
		/mob/living/simple_animal,
		/obj/machinery/particle_accelerator/control_box,
		/obj/structure/particle_accelerator/fuel_chamber,
		/obj/structure/particle_accelerator/particle_emitter/center,
		/obj/structure/particle_accelerator/particle_emitter/left,
		/obj/structure/particle_accelerator/particle_emitter/right,
		/obj/structure/particle_accelerator/power_box,
		/obj/structure/particle_accelerator/end_cap,
		/obj/machinery/containment_field,
		/obj/structure/disposalpipe,
		/obj/structure/sign,
		/obj/machinery/gateway,
		/obj/structure/lattice,
		/obj/structure/grille,
		/obj/machinery/the_singularitygen/tesla,
		/obj/machinery/atmospherics/pipe
	))
	var/static/list/things_to_shock = typecacheof(list(
		/obj/machinery,
		/mob/living,
		/obj/structure
	))
	var/melt = FALSE
	if(istype(source, /obj/singularity/energy_ball))
		var/obj/singularity/energy_ball/E = source
		melt = (E.orbiting_balls.len >= 9)
		if(E.orbiting_balls.len >= 10)
			blacklisted_types -= /obj/machinery/power/emitter

	for(var/A in typecache_filter_multi_list_exclusion(oview(source, zap_range+2), things_to_shock, blacklisted_types))
		
		if(istype(A, /obj/machinery/power/tesla_coil))
			var/dist = get_dist(source, A)
			var/obj/machinery/power/tesla_coil/C = A
			if(dist <= zap_range && (dist < closest_dist || !closest_tesla_coil) && !C.being_shocked)
				closest_dist = dist

				//we use both of these to save on istype and typecasting overhead later on
				//while still allowing common code to run before hand
				closest_tesla_coil = C
				closest_atom = C

		else if(closest_tesla_coil)
			continue //no need checking these other things

		else if(istype(A, /obj/machinery/power/grounding_rod))
			var/dist = get_dist(source, A)-2
			if(dist <= zap_range && (dist < closest_dist || !closest_grounding_rod))
				closest_grounding_rod = A
				closest_atom = A
				closest_dist = dist

		else if(closest_grounding_rod)
			continue

		else if(melt && istype(A, /obj/machinery/power/emitter))
			var/obj/machinery/power/emitter/e = A
			closest_emitter = e
		
		else if(closest_emitter)
			continue

		else if(isliving(A))
			var/dist = get_dist(source, A)
			var/mob/living/L = A
			if(dist <= zap_range && (dist < closest_dist || !closest_mob) && L.stat != DEAD && !L.tesla_ignore)
				closest_mob = L
				closest_atom = A
				closest_dist = dist

		else if(closest_mob)
			continue

		else if(istype(A, /obj/machinery))
			var/obj/machinery/M = A
			var/dist = get_dist(source, A)
			if(dist <= zap_range && (dist < closest_dist || !closest_machine) && !M.being_shocked)
				closest_machine = M
				closest_atom = A
				closest_dist = dist

		else if(closest_mob)
			continue

		else if(istype(A, /obj/structure))
			var/obj/structure/S = A
			var/dist = get_dist(source, A)
			if(dist <= zap_range && (dist < closest_dist || !closest_tesla_coil) && !S.being_shocked)
				closest_structure = S
				closest_atom = A
				closest_dist = dist

	//Alright, we've done our loop, now lets see if was anything interesting in range
	if(closest_atom)
		//common stuff
		source.Beam(closest_atom, icon_state="lightning[rand(1,12)]", icon = 'icons/effects/effects.dmi', time=5)
		var/zapdir = get_dir(source, closest_atom)
		if(zapdir)
			. = zapdir

	//per type stuff:
	if(closest_tesla_coil)
		closest_tesla_coil.tesla_act(power, melt)

	else if(closest_grounding_rod)
		closest_grounding_rod.tesla_act(power, melt)
	
	else if(closest_emitter)
		closest_emitter.tesla_act(power, melt)

		// Sacraficing three balls to escape the containment.

		energy_to_raise = energy_to_raise / 1.25
		energy_to_lower = (energy_to_raise / 1.25) - 20

		var/Orchiectomy_target = pick(orbiting_balls)
		qdel(Orchiectomy_target)

	else if(closest_mob)
		var/shock_damage = Clamp(round(power/400), 10, 90) + rand(-5, 5)
		closest_mob.electrocute_act(shock_damage, source, 1, tesla_shock = 1)
		if(issilicon(closest_mob))
			var/mob/living/silicon/S = closest_mob
			if(stun_mobs)
				S.emp_act(2)
			tesla_zap(S, 7, power / 1.5, explosive, stun_mobs) // metallic folks bounce it further
		else
			tesla_zap(closest_mob, 5, power / 1.5, explosive, stun_mobs)

	else if(closest_machine)
		closest_machine.tesla_act(power)

	else if(closest_structure)
		closest_structure.tesla_act(power)
