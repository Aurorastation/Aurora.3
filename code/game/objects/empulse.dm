// #define EMPDEBUG 10

/**
 * Produces an EMP pulse from `epicenter` up to `light_range`
 *
 * Calls `emp_act()` with a value of `EMP_HEAVY` up to `heavy_range`, with 50% probability between `EMP_HEAVY` and `EMP_LIGHT` at the exact `heavy_range`,
 * and with `EMP_LIGHT` up to and including `light_range`
 *
 *
 * * epicenter - A `/turf` where to start the explosion from
 * * heavy_range - The range in which `EMP_HEAVY` is applied, as a number
 * * light_range - The range, higher or equal than `heavy_range`, where `EMP_LIGHT` is applied, as a number
 * * log - Boolean, if you want this call to be logged
 * * exclude - A `/list` of objects to exclude, and/or paths to exclude
 *
 */
/proc/empulse(turf/epicenter, heavy_range, light_range, log = FALSE, list/exclude = null)
	if(!epicenter)
		return FALSE

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	//Ensure we got an actual location, no nullspace or error or other shit
	if(!(epicenter.x && epicenter.y && epicenter.z))
		return FALSE

	if(log)
		message_admins("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")
		log_game("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse = new /obj/effect/overlay(epicenter)
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = 1
		QDEL_IN(pulse, 2 SECONDS)

	if(heavy_range > light_range)
		light_range = heavy_range

	var/list/connected_z_levels = GetConnectedZlevels(epicenter.z) //Get every zlevel that is part of the current location
	for(var/z in connected_z_levels)

		//We obtain a virtual epicenter for each connected zlevel
		var/virtual_epicenter = locate(epicenter.x, epicenter.y, z)

		//We assume each zlevel to be 9 meters tall, and apply the pythagorean theorem to obtain the radius of the sphere at that vertical distance from the epicenter
		var/virtual_heavy_range = abs(epicenter.z - z) ? ( sqrt(abs((heavy_range*heavy_range)-((9*(epicenter.z - z))*(9*(epicenter.z - z))))) ) : heavy_range
		var/virtual_light_range = abs(epicenter.z - z) ? ( sqrt(abs((light_range*light_range)-((9*(epicenter.z - z))*(9*(epicenter.z - z))))) ) : light_range

		#ifdef EMPDEBUG
		log_and_message_admins("EMPDEBUG: Heavy range for explosion at Z-level [z] is [virtual_heavy_range]")
		log_and_message_admins("EMPDEBUG: Light range for explosion at Z-level [z] is [virtual_light_range]")
		#endif //EMPDEBUG

		if(virtual_light_range < 0 && virtual_heavy_range < 0)
			continue

		if(virtual_heavy_range > 1)
			for(var/mob/M in range(virtual_heavy_range, virtual_epicenter))
				sound_to(M, 'sound/effects/EMPulse.ogg')
				CHECK_TICK

		loop_apply_emp:
			for(var/atom/A in spiral_range(max(virtual_light_range, virtual_heavy_range) , virtual_epicenter))

				#ifdef EMPDEBUG
				var/time = world.timeofday
				#endif

				if(exclude && length(exclude)) //We have a list with at least one element to exclude

					for(var/element in exclude)
						if(ispath(element))
							if(istype(A, element))
								continue loop_apply_emp
						else
							if(A == element)
								continue loop_apply_emp

				var/distance = get_dist(epicenter, A)
				if(distance < 0)
					distance = 0


				if(distance < virtual_heavy_range)
					A.emp_act(EMP_HEAVY)

				else if(distance == virtual_heavy_range)
					if(prob(50)) //50% probability it's heavy or light, at the exact heavy range
						A.emp_act(EMP_HEAVY)
					else
						A.emp_act(EMP_LIGHT)

				else if(distance <= virtual_light_range)
					A.emp_act(EMP_LIGHT)

				#ifdef EMPDEBUG
				if((world.timeofday - time) >= EMPDEBUG)
					log_and_message_admins("EMPDEBUG: [A.name] - [A.type] - took [world.timeofday - time]ds to process emp_act()!")
				#endif //EMPDEBUG

				CHECK_TICK

	return TRUE
