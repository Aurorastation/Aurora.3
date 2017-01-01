var/datum/controller/process/explosives/bomb_processor

// yes, let's move the laggiest part of the game to a process
// nothing could go wrong -- Lohikar
/datum/controller/process/explosives
	var/list/work_queue
	var/ticks_without_work = 0
	var/list/explosion_turfs
	var/explosion_in_progress
	var/powernet_update_pending = 0
	var/tiles_per_tick = 10
	// TODO: Move maximum_parallel_explosions and sleep_delay_ticks to config
	var/maximum_parallel_explosions = 4
	var/sleep_delay_ticks = 5
	var/work_index = 0 // which queued explosion we're working on
	var/last_work_index = 0

/datum/controller/process/explosives/proc/idle()
	disable()
	lighting_process.schedule_interval *= 4

/datum/controller/process/explosives/proc/wake()
	enable()
	lighting_process.schedule_interval /= 4

/datum/controller/process/explosives/setup()
	name = "explosives"
	schedule_interval = 5 // every half-second
	tick_allowance = 25	// 25% of a tick
	work_queue = list()
	bomb_processor = src

	// Kill it until we have an explosion to run.
	disable()

/datum/controller/process/explosives/doWork()
	if (!work_queue)
		setup()

	if (!(work_queue.len))
		ticks_without_work++
		if (powernet_update_pending && ticks_without_work > sleep_delay_ticks)
			makepowernets()
			powernet_update_pending = 0

			// All explosions handled, powernet rebuilt.
			// We can sleep now.
			idle()
		return

	if (work_index)
		if (work_queue[work_index].process_many(tiles_per_tick))
			work_queue[work_index].notify_listeners()
			work_queue -= work_queue[work_index]
		last_work_index = work_index
		work_index = 0
	else
		work_index = get_work_index()
		doWorkNew()

/datum/controller/process/explosives/proc/get_work_index()
	if (work_queue.len == 1 || last_work_index == 0)
		return 1

	if (last_work_index < maximum_parallel_explosions)
		return last_work_index + 1
	else
		return 1

// Handle a recursive explosion.
/datum/controller/process/explosives/proc/explosion_rec(turf/epicenter, power)
	if(power <= 0) return
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	message_admins("Explosion with size ([power]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
	log_game("Explosion with size ([power]) in area [epicenter.loc.name] ")

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power*2,1) )
	playsound(epicenter, "explosion", 100, 1, round(power,1) )

	explosion_in_progress = 1
	explosion_turfs = list()

	explosion_turfs[epicenter] = power

	//This steap handles the gathering of turfs which will be ex_act() -ed in the next step. It also ensures each turf gets the maximum possible amount of power dealt to it.
	for(var/direction in cardinal)
		var/turf/T = get_step(epicenter, direction)
		explosion_spread(T, power - epicenter.explosion_resistance, direction)
		SCHECK

	//This step applies the ex_act effects for the explosion, as planned in the previous step.
	for(var/turf/T in explosion_turfs)
		if(explosion_turfs[T] <= 0) continue
		if(!T) continue

		//Wow severity looks confusing to calculate... Fret not, I didn't leave you with any additional instructions or help. (just kidding, see the line under the calculation)
		var/severity = 4 - round(max(min( 3, ((explosion_turfs[T] - T.explosion_resistance) / (max(3,(power/3)))) ) ,1), 1)								//sanity			effective power on tile				divided by either 3 or one third the total explosion power
								//															One third because there are three power levels and I
								//															want each one to take up a third of the crater
		var/x = T.x
		var/y = T.y
		var/z = T.z
		T.ex_act(severity)
		if(!T)
			T = locate(x,y,z)
		for(var/atom/A in T)
			A.ex_act(severity)
			SCHECK

	explosion_in_progress = 0

// A proc used by recursive explosions. (The actually recursive bit.)
/datum/controller/process/explosives/proc/explosion_spread(turf/s, power, direction)
	SCHECK
	if (istype(s, /turf/unsimulated))
		return
	if(power <= 0)
		return

	if(explosion_turfs[s] >= power)
		return //The turf already sustained and spread a power greated than what we are dealing with. No point spreading again.
	explosion_turfs[s] = power

	var/spread_power = power - s.explosion_resistance //This is the amount of power that will be spread to the tile in the direction of the blast
	for(var/obj/O in s)
		if(O.explosion_resistance)
			spread_power -= O.explosion_resistance

	var/turf/T = get_step(s, direction)
	explosion_spread(T, spread_power, direction)
	T = get_step(s, turn(direction,90))
	explosion_spread(T, spread_power, turn(direction,90))
	T = get_step(s, turn(direction,-90))
	explosion_spread(T, spread_power, turn(direction,90))

// Add an explosion to the queue for processing.
/datum/controller/process/explosives/proc/queue(var/datum/explosiondata/data)
	if (!data || !istype(data))
		return

	data.prepare()	// pre-calculate some stuff that only needs to be calculated once
	work_queue += data

	// Wake it up from sleeping if necessary.
	if (disabled)
		wake()

/datum/controller/process/explosives/statProcess()
	..()
	stat(null, "[work_queue.len] items in explosion queue")

// The data datum for explosions.
/datum/explosiondata
	var/turf/epicenter
	var/devastation_range
	var/heavy_impact_range
	var/light_impact_range
	var/flash_range
	var/adminlog
	var/z_transfer
	var/is_rec
	var/rec_pow
	var/fast_process = 0
	var/list/processing_turfs
	var/epi_x
	var/epi_y
	var/epi_z
	var/start_time

/datum/explosiondata/proc/prepare()
	epicenter = get_turf(epicenter)
	if (!epicenter)
		return 0

	if(devastation_range > 2 || heavy_impact_range > 2)
		if(HasAbove(epicenter.z) && z_transfer & UP)
			explosion(GetAbove(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, UP)
		if(HasBelow(epicenter.z) && z_transfer & DOWN)
			explosion(GetAbove(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, DOWN)

	max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)
	start_time = world.timeofday

	if (!fast_process)
		handle_shake()

// processes()s multiple times
/datum/explosiondata/proc/process_many(var/ticks)
	for (var/i = 0, i < ticks, i++)
		if (process())
			return 1

// Processes ONE turf - returns true when done processing all turfs
/datum/explosiondata/proc/process()
	if (!processing_turfs)
		return 0

	if (!(processing_turfs.len))
		return 1

	var/turf/T = processing_turfs[1]
	processing_turfs -= T
	var/dist = sqrt((T.x - epi_x)**2 + (T.y - epi_y)**2)

	if(dist < devastation_range)		dist = 1
	else if(dist < heavy_impact_range)	dist = 2
	else if(dist < light_impact_range)	dist = 3
	else								continue

	T.ex_act(dist)

	if(T)
		for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
			var/atom/movable/AM = atom_movable
			if(AM && AM.simulated)	AM.ex_act(dist)

/datum/explosiondata/proc/notify_listeners()
	var/took = (world.timeofday - start_time) / 10
	if(Debug2)
		world.log << "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

	for (var/array in doppler_arrays)
		var/obj/machinery/doppler_array/A = Array
		if (A)
			A.sense_explosion(epi_x, epi_y, epi_z, devastation_range, heavy_impact_range, light_impact_range, took)

/datum/explosiondata/proc/handle_shake(var/max_duration = 60)
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
						shake_camera(M, min(max_duration, max(2,(power*18) / dist)), min(3.5,((power*3) / dist)),0.05)
						//Maximum duration is 6 seconds, and max strength is 3.5
						//Becuse values higher than those just get really silly
