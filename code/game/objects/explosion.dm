//TODO: Flash range does nothing currently

///// Z-Level Stuff
proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = 1)
///// Z-Level Stuff
	src = null	//so we don't abort once src is deleted
	spawn(0)
		var/power = max(0,devastation_range) * 2 + max(0,heavy_impact_range) + max(0,light_impact_range)
		if(config.use_recursive_explosions)
			explosion_rec(epicenter, power)
			return

		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return

///// Z-Level Stuff
		if(z_transfer && (devastation_range > 0 || heavy_impact_range > 0))
			//transfer the explosion in both directions
			explosion_z_transfer(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
///// Z-Level Stuffis

		var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)
		//playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(devastation_range*2,1) )
		//playsound(epicenter, "explosion", 100, 1, round(devastation_range,1) )

// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.

// Stereo users will also hear the direction of the explosion!

// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.

// 3/7/14 will calculate to 80 + 35
		var/volume = 10 + (power * 20)
		var/frequency = get_rand_frequency()
		var/closedist = round(max_range + world.view - 2, 1)
		for(var/mob/M in player_list)
			// Double check for client
			if(M && M.client)
				var/turf/M_turf = get_turf(M)
				if(M_turf && M_turf.z == epicenter.z)
					var/dist = get_dist(M_turf, epicenter)
					if (M.ear_deaf <= 0 || !M.ear_deaf)//Dont play sounds to deaf people
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
						shake_camera(M, min(60,max(2,(power*30) / dist)), min(3.5,((power*7) / dist)))
						//Maximum duration is 6 seconds, and max strength is 3.5
						//Becuse values higher than those just get really silly

		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

//		var/lighting_controller_was_processing = lighting_controller.processing	//Pause the lighting updates for a bit
//		lighting_controller.processing = 0


		var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range
		var/powernet_rebuild_was_deferred_already = defer_powernet_rebuild
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
			if(T)
				for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					var/atom/movable/AM = atom_movable
					if(AM && AM.simulated)	AM.ex_act(dist)

		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(Debug2)	world.log << "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

		//Machines which report explosions.
		for(var/i,i<=doppler_arrays.len,i++)
			var/obj/machinery/doppler_array/Array = doppler_arrays[i]
			if(Array)
				Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,took)

		sleep(8)

//		if(!lighting_controller.processing)	lighting_controller.processing = lighting_controller_was_processing
		if(!powernet_rebuild_was_deferred_already && defer_powernet_rebuild)
			makepowernets()
			defer_powernet_rebuild = 0

	return 1

/mob/verb/camerashake(strength as num)
	shake_camera(src, 30, strength)

proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2)

///// Z-Level Stuff
proc/explosion_z_transfer(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, up = 1, down = 1)
	var/turf/controllerlocation = locate(1, 1, epicenter.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			//start the child explosion, no admin log and no additional transfers
			explosion(locate(epicenter.x, epicenter.y, controller.down_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 0, 0)
			if(devastation_range - 2 > 0 || heavy_impact_range - 2 > 0) //only transfer further if the explosion is still big enough
				explosion(locate(epicenter.x, epicenter.y, controller.down_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 0, 1)

		if(controller.up)
			//start the child explosion, no admin log and no additional transfers
			explosion(locate(epicenter.x, epicenter.y, controller.up_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 0, 0)
			if(devastation_range - 2 > 0 || heavy_impact_range - 2 > 0) //only transfer further if the explosion is still big enough
				explosion(locate(epicenter.x, epicenter.y, controller.up_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 1, 0)
///// Z-Level Stuff
