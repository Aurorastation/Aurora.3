var/datum/controller/process/explosives/bomb_processor

// yes, let's move the laggiest part of the game to a process
// nothing could go wrong -- Lohikar
/datum/controller/process/explosives
	var/list/work_queue
	var/ticks_without_work = 0
	var/powernet_rebuild_was_deferred_already

/datum/controller/process/explosives/setup()
	name = "explosives"
	schedule_interval = 5 // every half-second
	work_queue = list()
	bomb_processor = src

/datum/controller/process/explosives/doWork()
	if (!(work_queue.len))
		ticks_without_work++
		if (ticks_without_work > 5)
			if(defer_powernet_rebuild)
				makepowernets()
				defer_powernet_rebuild = 0
		return

	ticks_without_work = 0

	for (var/datum/explosiondata/data in work_queue)
		SCHECK
		var/turf/epicenter = data.epicenter
		var/devastation_range = data.devastation_range
		var/heavy_impact_range = data.heavy_impact_range
		var/light_impact_range = data.light_impact_range
		var/flash_range = data.flash_range
		var/adminlog = data.adminlog
		var/z_transfer = data.z_transfer

		var/power = max(0,devastation_range) * 2 + max(0,heavy_impact_range) + max(0,light_impact_range)
		if(config.use_recursive_explosions)
			explosion_rec(epicenter, power)
			return

		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return

		// Handles recursive propagation of explosions.
		if(devastation_range > 2 || heavy_impact_range > 2)
			if(HasAbove(epicenter.z) && z_transfer & UP)
				explosion(GetAbove(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, UP)
			if(HasBelow(epicenter.z) && z_transfer & DOWN)
				explosion(GetAbove(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, DOWN)

		var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)

		// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
		// Stereo users will also hear the direction of the explosion!
		// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
		// 3/7/14 will calculate to 80 + 35
		var/far_dist = 0
		far_dist += heavy_impact_range * 5
		far_dist += devastation_range * 20
		// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.

		// Stereo users will also hear the direction of the explosion!

		// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.

		// 3/7/14 will calculate to 80 + 35
		var/volume = 10 + (power * 20)

		var/frequency = get_rand_frequency()
		var/closedist = round(max_range + world.view - 2, 1)

		//Whether or not this explosion causes enough vibration to send sound or shockwaves through the station
		var/vibration = 1
		if (istype(epicenter,/turf/space))
			vibration = 0
			for (var/turf/T in range(src, max_range))
				if (!istype(T,/turf/space))
			//If there is a nonspace tile within the explosion radius
			//Then we can reverberate shockwaves through that, and allow it to be felt in a vacuum
					vibration = 1

		if (vibration)
			for(var/mob/M in player_list)
				SCHECK
				// Double check for client
				var/reception = 2//Whether the person can be shaken or hear sound
				//2 = BOTH
				//1 = shockwaves only
				//0 = no effect
				if(M && M.client)
					var/turf/M_turf = get_turf(M)



					if(M_turf && M_turf.z == epicenter.z)
						if (istype(M_turf,/turf/space))
						//If the person is standing in space, they wont hear
							//But they may still feel the shaking
							reception = 0
							for (var/turf/T in range(M, 1))
								if (!istype(T,/turf/space))
								//If theyre touching the hull or on some extruding part of the station
									reception = 1//They will get screenshake
									break

						if (!reception)
							continue

						var/dist = get_dist(M_turf, epicenter)
						if (reception == 2 && (M.ear_deaf <= 0 || !M.ear_deaf))//Dont play sounds to deaf people
							// If inside the blast radius + world.view - 2
							if(dist <= closedist)
								M.playsound_local(epicenter, get_sfx("explosion"), min(100, volume), 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
								//You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.

							else
								volume = M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', volume, 1, frequency, usepressure = 0, falloff = 1000)
								//Playsound local will return the final volume the sound is actually played at
								//It will return 0 if the sound volume falls to 0 due to falloff or pressure
								//Also return zero if sound playing failed for some other reason

						//Deaf people will feel vibrations though
						if (volume > 0)//Only shake camera if someone was close enough to hear it
							shake_camera(M, min(60,max(2,(power*18) / dist)), min(3.5,((power*3) / dist)),0.05)
							//Maximum duration is 6 seconds, and max strength is 3.5
							//Becuse values higher than those just get really silly

		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

		var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range
		powernet_rebuild_was_deferred_already = defer_powernet_rebuild
		// Large enough explosion. For performance reasons, powernets will be rebuilt manually
		if(!defer_powernet_rebuild && (approximate_intensity > 25))
			defer_powernet_rebuild = 1

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x0 = epicenter.x
		var/y0 = epicenter.y
		var/z0 = epicenter.z

		for(var/turf/T in trange(max_range, epicenter))
			var/dist = sqrt((T.x - x0)**2 + (T.y - y0)**2)

			if(dist < devastation_range)		dist = 1
			else if(dist < heavy_impact_range)	dist = 2
			else if(dist < light_impact_range)	dist = 3
			else								continue

			T.ex_act(dist)
			SCHECK
			if(T)
				for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					var/atom/movable/AM = atom_movable
					if(AM && AM.simulated)	AM.ex_act(dist)
					SCHECK

		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(Debug2)	world.log << "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

		//Machines which report explosions.
		for(var/i,i<=doppler_arrays.len,i++)
			var/obj/machinery/doppler_array/Array = doppler_arrays[i]
			if(Array)
				Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,took)

		work_queue -= data

	if(!powernet_rebuild_was_deferred_already && defer_powernet_rebuild)
		makepowernets()
		defer_powernet_rebuild = 0


/datum/controller/process/explosives/proc/queue(var/data)
	work_queue += data

/datum/controller/process/explosives/statProcess()
	..()
	stat(null, "[work_queue.len] items in work queue")


/datum/explosiondata
	var/turf/epicenter
	var/devastation_range
	var/heavy_impact_range
	var/light_impact_range
	var/flash_range
	var/adminlog
	var/z_transfer