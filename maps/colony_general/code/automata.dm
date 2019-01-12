/datum/terrain_map
	var/descriptor = "terrain map"   // Display name.

	// Locator/value vars.
	var/origin_x = 1                // Origin point, left.
	var/origin_y = 1                // Origin point, bottom.
	var/origin_z = 1                // Target Z-level.
	var/limit_x = 255               // Default x size.
	var/limit_y = 255               // Default y size.
	var/scale = 1
	var/octaves = 1
	var/persistence = 0.5
	var/seed = 1
	var/error

	var/target_turf                 //turf to scan for

/datum/terrain_map/New(var/zpos, var/xpos1, var/xpos2, var/ypos1, var/ypos2, var/seedy = 1, var/scalar = 1, var/octavius = 1, var/virility = 0.5)
	origin_z = zpos
	origin_x = xpos1
	origin_y = ypos1
	limit_x = xpos2
	limit_y = ypos2
	seed = seedy
	scale = scalar
	octaves = octavius
	persistence = virility

	CHECK_TICK

	generate()

/datum/terrain_map/proc/generate()
	//rand_seed(seed)
	PerlinPermutate()
	for(var/x = origin_x, x <= limit_x, x++)
		for(var/y = origin_y, y <= limit_y, y++)
			var/turf/T = locate(x, y, origin_z)
			if(istype(T, target_turf))
				T.ChangeTurf(/turf/unsimulated/marker)
				markTurf(locate(x, y, origin_z))
	finish()

/datum/terrain_map/proc/markTurf(var/turf/unsimulated/marker/M)
	if(!M || !istype(M))
		return

	M.value = perlin(M.x, M.y, seed, scale, octaves, persistence)

/datum/terrain_map/proc/finish()
	return

/datum/terrain_map/proc/river_dance()
	return

/datum/terrain_map/mountains
	descriptor = "mountains"   // Display name.

	target_turf = /turf/unsimulated/mask

/datum/terrain_map/mountains/finish()

	error = "rock"
	for(var/x = origin_x, x <= limit_x, x++)
		for(var/y = origin_y, y <= limit_y, y++)
			var/turf/T = locate(x, y, origin_z)
			if(istype(T, /turf/unsimulated/marker))
				var/turf/unsimulated/marker/M = T
				switch(round(M.value, 0.01))
					if(0 to 0.4)
						M.icon_state = "lava"
					if(0.41 to 0.42)
						M.icon_state = "dirt"
					if(0.43 to 0.6)
						if(prob(5))
							M.icon_state = "basalt[rand(1,13)]"
						else
							M.icon_state = "basalt"
					if(0.61 to 1)
						M.icon_state = "rock"
					else
						M.icon_state = error
				error = M.icon_state

	river_dance()