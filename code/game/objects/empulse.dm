// Uncomment this define to check for possible lengthy processing of emp_act()s.
// If emp_act() takes more than defined deciseconds (1/10 seconds) an admin message and log is created.
// I do not recommend having this uncommented on main server, it probably causes a bit more lag, espicially with larger EMPs.

// #define EMPDEBUG 10

proc/empulse(turf/epicenter, heavy_range, light_range, log = FALSE, list/exclude = null)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")
		log_game("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse = new /obj/effect/overlay(epicenter)
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = 1
		QDEL_IN(pulse, 20)

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/mob/M in range(heavy_range, epicenter))
		to_chat(M, 'sound/effects/EMPulse.ogg')

	for(var/atom/A in range(light_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		if(exclude && (A in exclude))
			continue
		var/distance = get_dist(epicenter, A)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			A.emp_act(1)
		else if(distance == heavy_range)
			if(prob(50))
				A.emp_act(1)
			else
				A.emp_act(2)
		else if(distance <= light_range)
			A.emp_act(2)
		#ifdef EMPDEBUG
		if((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: [A.name] - [A.type] - took [world.timeofday - time]ds to process emp_act()!")
		#endif
	return 1
