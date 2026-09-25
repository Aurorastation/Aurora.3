//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machinery/particle_accelerator.dmi'
	icon_state = "particle"//Need a new icon for this
	anchored = TRUE
	density = FALSE
	var/active = FALSE
	var/movement_range = 10
	var/energy = 10		//energy in eV
	var/mega_energy = 0	//energy in MeV
	var/frequency = 1
	var/ionizing = 0
	var/particle_type
	var/additional_particles = 0
	var/turf/target
	var/turf/source
	var/movetotarget = 1
	var/list/irradiated_mobs

/obj/effect/accelerated_particle/weak
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	movement_range = 15
	energy = 15

// Can only be obtained by hacking the machine
/obj/effect/accelerated_particle/powerful
	movement_range = 20
	energy = 50

/obj/effect/accelerated_particle/Initialize(maploading, dir = 2)
	. = ..()
	set_dir(dir)
	if(movement_range > 20)
		movement_range = 20
	active = TRUE
	irradiate_living_on_turf()
	move(1)

/obj/effect/accelerated_particle/Destroy()
	active = FALSE
	target = null
	source = null
	irradiated_mobs = null
	return ..()

/obj/effect/accelerated_particle/Collide(atom/A)
	if (!active)
		return
	if (A)
		if(isliving(A))
			toxmob(A)
		if((istype(A,/obj/structure/machinery/the_singularitygen))||(istype(A,/obj/singularity)))
			var/obj/singularity/singulo = A
			singulo.energy += energy
		else if(istype(A, /obj/structure/machinery/power/fusion_core))
			var/obj/structure/machinery/power/fusion_core/collided_core = A
			if(particle_type && particle_type != "neutron")
				if(collided_core.AddParticles(particle_type, 12 + additional_particles))
					collided_core.owned_field.plasma_temperature += mega_energy
					collided_core.owned_field.energy += energy
					qdel(src)
		else if(istype(A, /obj/effect/fusion_particle_catcher))
			var/obj/effect/fusion_particle_catcher/PC = A
			if(particle_type && particle_type != "neutron")
				if(PC.parent.owned_core.AddParticles(particle_type, 12 + additional_particles))
					PC.parent.plasma_temperature += mega_energy
					PC.parent.energy += energy
					qdel(src)

/obj/effect/accelerated_particle/CollidedWith(atom/bumped_atom)
	. = ..()
	if (!active)
		return
	if(isliving(bumped_atom))
		toxmob(bumped_atom)

/obj/effect/accelerated_particle/ex_act(severity)
	if (!active)
		return
	qdel(src)

/obj/effect/accelerated_particle/proc/toxmob(mob/living/M)
	if (!active || !istype(M))
		return
	LAZYINITLIST(irradiated_mobs)
	var/datum/weakref/mob_ref = WEAKREF(M)
	if(irradiated_mobs[mob_ref])
		return
	irradiated_mobs[mob_ref] = TRUE
	var/radiation = (energy*2)
	M.apply_damage((radiation*3), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	M.updatehealth()

/obj/effect/accelerated_particle/proc/irradiate_living_on_turf()
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return
	for(var/mob/living/M in current_turf)
		toxmob(M)

/obj/effect/accelerated_particle/proc/move(lag)
	set waitfor = FALSE
	if(QDELETED(src))
		return
	if (!active)
		return
	var/destination
	if(target)
		destination = movetotarget ? get_step_towards(src, target) : get_step_away(src, source)
	else
		destination = get_step(src, dir)
	if(!step_towards(src, destination))
		if(QDELETED(src))
			return
		forceMove(destination)
	irradiate_living_on_turf()
	if(target && movetotarget && (get_dist(src,target) < 1))
		movetotarget = FALSE
	movement_range--
	if(movement_range <= 0)
		qdel(src)
		return
	sleep(lag)
	move(lag)
