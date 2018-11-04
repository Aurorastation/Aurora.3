/datum/terrain_map
	var/descriptor = "terrain map"   // Display name.

	// Locator/value vars.
	var/origin_x = 1                // Origin point, left.
	var/origin_y = 1                // Origin point, bottom.
	var/origin_z = 1                // Target Z-level.
	var/limit_x = 255               // Default x size.
	var/limit_y = 255               // Default y size.
	var/scale = 1
	var/seed = 0
	var/iterations = 1

	var/target_turf                 //turf to scan for

/datum/terrain_map/New(var/zpos, var/xpos1, var/xpos2, var/ypos1, var/ypos2, var/seedy = 0, var/scalar = 1)
	origin_z = zpos
	origin_x = xpos1
	origin_y = ypos1
	limit_x = xpos2
	limit_y = ypos2
	seed = seedy
	scale = scalar

	CHECK_TICK

	generate()

/datum/terrain_map/proc/generate()
	rand_seed(seed)
	for(var/i = 0, i < iterations, i++)
		for(var/x = origin_x, x < limit_x, x++)
			for(var/y = origin_y, y < limit_y, y++)
				var/turf/T = locate(x, y, origin_z)
				if(istype(T, target_turf))
					T.ChangeTurf(/turf/unsimulated/marker)
					markTurf(locate(x, y, origin_z))
	finish()

/datum/terrain_map/proc/markTurf(var/turf/unsimulated/marker/M)
	if(!M || !istype(M))
		return

	M.value = perlin(M.x/scale, M.y/scale)
	//log_ss(" X: [M.x] | Y: [M.y] | P: [perlin(M.x/scale, M.y/scale)]")

	var/colorval = MAP(M.value, -1, 1, 0, 1)
	M.color = rgb(colorval*255, colorval*255, colorval*255)

/datum/terrain_map/proc/finish()
	return

/datum/terrain_map/mountains
	descriptor = "mountains"   // Display name.

	target_turf = /turf/unsimulated/mask