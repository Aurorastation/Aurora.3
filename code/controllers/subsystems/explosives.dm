#define EXPLFX_BOTH 3
#define EXPLFX_SOUND 2
#define EXPLFX_SHAKE 1
#define EXPLFX_NONE 0

SUBSYSTEM_DEF(explosives)
	name = "Explosives"
	wait = 1
	flags = SS_NO_INIT | SS_BACKGROUND | SS_POST_FIRE_TIMING
	priority = SS_PRIORITY_EXPLOSIVES
	runlevels = RUNLEVELS_PLAYING

	can_fire = FALSE	// Start disabled, explosions will wake us if need be.

	var/list/work_queue = list()
	var/ticks_without_work = 0
	var/list/explosion_turfs
	var/explosion_in_progress

	var/mc_notified = FALSE

/datum/controller/subsystem/explosives/Recover()
	work_queue = SSexplosives.work_queue
	explosion_in_progress = SSexplosives.explosion_in_progress
	explosion_turfs = SSexplosives.explosion_turfs

/datum/controller/subsystem/explosives/fire(resumed = FALSE)
	if(!length(work_queue))
		ticks_without_work++
		if (ticks_without_work > 5)
			// All explosions handled, we can sleep now.
			can_fire = FALSE

			mc_notified = FALSE
			Master.ExplosionEnd()
		return

	ticks_without_work = 0

	if (!mc_notified)
		Master.ExplosionStart()
		mc_notified = TRUE

	for (var/A in work_queue)
		var/datum/explosiondata/data = A

		if (data.spreading)
			explosion_iter(data.epicenter, data.rec_pow, data.z_transfer)
		else
			explosion(data)

		work_queue -= data

// Handle a non-recusrive explosion.
/datum/controller/subsystem/explosives/proc/explosion(var/datum/explosiondata/data)
	var/turf/epicenter = data.epicenter
	var/devastation_range = data.devastation_range
	var/heavy_impact_range = data.heavy_impact_range
	var/light_impact_range = data.light_impact_range
	var/flash_range = data.flash_range
	var/adminlog = data.adminlog
	var/z_transfer = data.z_transfer
	var/power = data.rec_pow

	if(data.spreading)
		explosion_iter(epicenter, power, z_transfer)
		return

	var/start = world.timeofday
	epicenter = get_turf(epicenter)
	if(!epicenter)
		return

	// Handles recursive propagation of explosions.
	if(devastation_range > 2 || heavy_impact_range > 2)
		if(HasAbove(epicenter.z) && z_transfer & UP)
			global.explosion(GetAbove(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, UP, spreading = FALSE)
		if(HasBelow(epicenter.z) && z_transfer & DOWN)
			global.explosion(GetBelow(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, DOWN, spreading = FALSE)

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

	var/closedist = round(max_range + world.view - 2, 1)

	//Whether or not this explosion causes enough vibration to send sound or shockwaves through the station
	var/vibration = 1
	if(istype(epicenter, /turf/space))
		vibration = 0
		for(var/thing in RANGE_TURFS(max_range, epicenter))
			var/turf/T = thing
			if (!istype(T, /turf/space))
		//If there is a nonspace tile within the explosion radius
		//Then we can reverberate shockwaves through that, and allow it to be felt in a vacuum
				vibration = 1

	if (vibration)
		for(var/thing in GLOB.player_list)
			var/mob/M = thing
			CHECK_TICK
			// Double check for client
			var/reception = 2//Whether the person can be shaken or hear sound
			//2 = BOTH
			//1 = shockwaves only
			//0 = no effect
			if(M?.client)
				var/turf/M_turf = get_turf(M)

				if(M_turf && M_turf.z == epicenter.z)
					if (istype(M_turf,/turf/space))
					//If the person is standing in space, they wont hear
						//But they may still feel the shaking
						reception = 0
						for(var/t_thing in RANGE_TURFS(1, M))
							var/turf/T = t_thing
							if(!istype(T, /turf/space))
							//If theyre touching the hull or on some extruding part of the station
								reception = 1//They will get screenshake
								break

					if (!reception)
						continue

					var/dist = get_dist(M_turf, epicenter)
					var/explosion_dir = angle2text(Get_Angle(M_turf, epicenter))
					if (reception == 2 && (M.ear_deaf <= 0 || !M.ear_deaf)) //Dont play sounds to deaf people

						// Anyone with sensitive hearing gets a bonus to hearing explosions
						var/extendeddist = closedist
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							var/hearing_sensitivity = H.get_hearing_sensitivity()
							if (hearing_sensitivity)
								if(H.is_listening())
									if (hearing_sensitivity == HEARING_VERY_SENSITIVE)
										extendeddist *= 2
									else
										extendeddist = round(closedist *= 1.5, 1)
								else
									if (hearing_sensitivity == HEARING_VERY_SENSITIVE)
										extendeddist *= 1.5
									else
										extendeddist = round(closedist *= 1.2, 1)

						// If inside the blast radius + world.view - 2
						if (dist <= closedist)
							to_chat(M, FONT_LARGE(SPAN_WARNING("You hear the sound of a nearby explosion coming from \the [explosion_dir].")))
							M.playsound_simple(epicenter, get_sfx(/singleton/sound_category/explosion_sound), min(100, volume), use_random_freq = TRUE, falloff = 5)
						else if (dist > closedist && dist <= extendeddist) // People with sensitive hearing get a better idea of how far it is
							to_chat(M, FONT_LARGE(SPAN_WARNING("You hear the sound of a semi-close explosion coming from \the [explosion_dir].")))
							M.playsound_simple(epicenter, get_sfx(/singleton/sound_category/explosion_sound), min(100, volume), use_random_freq = TRUE, falloff = 5)
						else //You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
							volume = M.playsound_simple(epicenter, 'sound/effects/explosionfar.ogg', volume, use_random_freq = TRUE, falloff = 1000, use_pressure = TRUE)
							if(volume)
								to_chat(M, FONT_LARGE(SPAN_NOTICE("You hear the sound of a distant explosion coming from \the [explosion_dir].")))

					//Deaf people will feel vibrations though
					if (volume > 0)//Only shake camera if someone was close enough to hear it
						shake_camera(M, min(30,max(2,(power*2) / dist)), min(3.5,((power/3) / dist)),0.05)
						//Maximum duration is 3 seconds, and max strength is 3.5
						//Becuse values higher than those just get really silly

	if(adminlog)
		message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
		log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

	if(heavy_impact_range > 1)
		var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
		E.set_up(epicenter)
		E.start()

	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/z0 = epicenter.z

	for(var/thing in RANGE_TURFS(max_range, epicenter))
		var/turf/T = thing
		if (!T)
			CHECK_TICK
			continue

		var/dist = sqrt((T.x - x0)**2 + (T.y - y0)**2)

		if (dist < devastation_range)
			dist = 1
		else if (dist < heavy_impact_range)
			dist = 2
		else if (dist < light_impact_range)
			dist = 3
		else
			CHECK_TICK
			continue

		T.ex_act(dist)
		CHECK_TICK
		if(T)
			for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
				var/atom/movable/AM = atom_movable
				if(!QDELETED(AM) && AM.simulated)
					var/obj/O = AM
					if(istype(O) && O.hides_under_flooring() && !T.is_plating())
						continue
					AM.ex_act(dist)

				CHECK_TICK

	var/took = (world.timeofday-start)/10
	//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
	if(GLOB.Debug2)	world.log <<  "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

// All the vars used on the turf should be on unsimulated turfs too, we just don't care about those generally.
#define SEARCH_DIR(dir) \
	search_direction = dir;\
	search_turf = get_step(current_turf, search_direction);\
	if (istype(search_turf, /turf/simulated)) {\
		turf_queue += search_turf;\
		dir_queue += search_direction;\
		power_queue += current_power;\
	}

// Handle an iterative explosion.
/datum/controller/subsystem/explosives/proc/explosion_iter(turf/epicenter, power, z_transfer)
	if(power <= 0)
		return

	epicenter = get_turf(epicenter)
	if(!epicenter)
		return

	message_admins("Explosion with size ([power]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
	log_game("Explosion with size ([power]) in area [epicenter.loc.name] ")

	LOG_DEBUG("iexpl: Beginning discovery phase.")
	var/time = world.time

	explosion_in_progress = TRUE
	var/list/act_turfs = list()
	act_turfs[epicenter] = power

	power -= epicenter.explosion_resistance
	for (var/obj/O in epicenter)
		if (O.explosion_resistance)
			power -= O.explosion_resistance

	if (power >= GLOB.config.iterative_explosives_z_threshold)
		if ((z_transfer & UP) && HasAbove(epicenter.z))
			var/datum/explosiondata/data = new
			data.epicenter = GetAbove(epicenter)
			data.rec_pow = (power * GLOB.config.iterative_explosives_z_multiplier) - GLOB.config.iterative_explosives_z_subtraction
			data.z_transfer = UP
			data.spreading = TRUE
			queue(data)

		if ((z_transfer & DOWN) && HasBelow(epicenter.z))
			var/datum/explosiondata/data = new
			data.epicenter = GetBelow(epicenter)
			data.rec_pow = (power * GLOB.config.iterative_explosives_z_multiplier) - GLOB.config.iterative_explosives_z_subtraction
			data.z_transfer = DOWN
			data.spreading = TRUE
			queue(data)

	// These three lists must always be the same length.
	var/list/turf_queue = list(epicenter, epicenter, epicenter, epicenter)
	var/list/dir_queue = list(NORTH, SOUTH, EAST, WEST)
	var/list/power_queue = list(power, power, power, power)

	var/turf/simulated/current_turf
	var/turf/search_turf
	var/origin_direction
	var/search_direction
	var/current_power
	var/index = 1
	while (index <= turf_queue.len)
		current_turf = turf_queue[index]
		origin_direction = dir_queue[index]
		current_power = power_queue[index]
		++index

		if (!istype(current_turf) || current_power <= 0)
			CHECK_TICK
			continue

		if (act_turfs[current_turf] >= current_power && current_turf != epicenter)
			CHECK_TICK
			continue

		act_turfs[current_turf] = current_power
		current_power -= current_turf.explosion_resistance

		// Attempt to shortcut on empty tiles: if a turf only has a LO on it, we don't need to check object resistance. Some turfs might not have LOs, so we need to check it actually has one.
		if (current_turf.contents.len > !!current_turf.lighting_overlay)
			for (var/thing in current_turf)
				var/atom/movable/AM = thing
				if (AM.simulated && AM.explosion_resistance)
					current_power -= AM.explosion_resistance

		if (current_power <= 0)
			CHECK_TICK
			continue

		SEARCH_DIR(origin_direction)
		SEARCH_DIR(turn(origin_direction, 90))
		SEARCH_DIR(turn(origin_direction, -90))

		CHECK_TICK

	LOG_DEBUG("iexpl: Discovery completed in [(world.time-time)/10] seconds.")
	LOG_DEBUG("iexpl: Beginning SFX phase.")
	time = world.time

	var/volume = 10 + (power * 20)

	var/close_dist = round(power + world.view - 2, 1)

	var/sound/explosion_sound = sound(get_sfx(/singleton/sound_category/explosion_sound))

	for (var/thing in GLOB.player_list)
		var/mob/M = thing
		var/reception = EXPLFX_BOTH

		var/turf/T = isturf(M.loc) ? M.loc : get_turf(M)

		if (!T)
			CHECK_TICK
			continue

		if (!AreConnectedZLevels(T.z, epicenter.z))
			CHECK_TICK
			continue

		if (T.type == /turf/space)	// Equality is faster than istype.
			reception = EXPLFX_NONE

			for (var/turf/simulated/THING in RANGE_TURFS(1, M))
				reception |= EXPLFX_SHAKE
				break

			if (!reception)
				CHECK_TICK
				continue

		var/dist = get_dist(M, epicenter) || 1
		if ((reception & EXPLFX_SOUND) && !isdeaf(M))
			if (dist <= close_dist)
				M.playsound_simple(epicenter, explosion_sound, min(100, volume), use_random_freq = TRUE, falloff = 5)
				//You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
			else
				volume = M.playsound_simple(epicenter, 'sound/effects/explosionfar.ogg', volume, use_random_freq = TRUE, falloff = 1000, use_pressure = FALSE)

		if ((reception & EXPLFX_SHAKE) && volume > 0)
			shake_camera(M, min(30, max(2,(power*2) / dist)), min(3.5, ((power/3) / dist)),0.05)
			//Maximum duration is 3 seconds, and max strength is 3.5
			//Becuse values higher than those just get really silly

		CHECK_TICK

	LOG_DEBUG("iexpl: SFX phase completed in [(world.time-time)/10] seconds.")
	LOG_DEBUG("iexpl: Beginning application phase.")
	time = world.time

	var/turf_tally = 0
	var/movable_tally = 0
	for (var/thing in act_turfs)
		var/turf/T = thing
		if (act_turfs[T] <= 0)
			CHECK_TICK
			continue

		//Wow severity looks confusing to calculate... Fret not, I didn't leave you with any additional instructions or help. (just kidding, see the line under the calculation)
		var/severity = 4 - round(max(min( 3, ((act_turfs[T] - T.explosion_resistance) / (max(3,(power/3)))) ) ,1), 1)
		//sanity			effective power on tile				divided by either 3 or one third the total explosion power
		//															One third because there are three power levels and I
		//															want each one to take up a third of the crater

		if (T.simulated)
			T.ex_act(severity)
		if (T.contents.len > !!T.lighting_overlay)
			for (var/subthing in T)
				var/atom/movable/AM = subthing
				if (AM.simulated)
					var/obj/O = AM
					if(istype(O) && O.hides_under_flooring() && !T.is_plating())
						continue
					AM.ex_act(severity)
					movable_tally++
				CHECK_TICK
		else
			CHECK_TICK

		turf_tally++

	explosion_in_progress = FALSE
	LOG_DEBUG("iexpl: Application completed in [(world.time-time)/10] seconds; processed [turf_tally] turfs and [movable_tally] movables.")

#undef SEARCH_DIR

// Add an explosion to the queue for processing.
/datum/controller/subsystem/explosives/proc/queue(var/datum/explosiondata/data)
	if (!data || !istype(data))
		return

	work_queue += data

	// Wake it up from sleeping if necessary.
	if (!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/explosives/stat_entry(msg)
	msg ="P:[work_queue.len]"
	return ..()

// The data datum for explosions.
/datum/explosiondata
	var/turf/epicenter
	var/devastation_range
	var/heavy_impact_range
	var/light_impact_range
	var/flash_range
	var/adminlog
	var/z_transfer
	var/spreading
	var/rec_pow

#undef EXPLFX_BOTH
#undef EXPLFX_SOUND
#undef EXPLFX_SHAKE
#undef EXPLFX_NONE
