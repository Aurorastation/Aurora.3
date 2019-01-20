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
	for(var/x = origin_x, x <= limit_x, x++)
		for(var/y = origin_y, y <= limit_y, y++)
			var/turf/T = locate(x, y, origin_z)
			if(istype(T, target_turf))
				markTurf(T)
	finish()

/datum/terrain_map/proc/markTurf(var/turf/T)
	return

/datum/terrain_map/proc/finish()
	return

/datum/terrain_map/surface
	descriptor = "surface"   // Display name.
	error = /turf/simulated/lava

	target_turf = /turf/unsimulated/mask

/datum/terrain_map/surface/markTurf(var/turf/T)
	switch(round(perlin(T.x, T.y, T.z + seed, scale, octaves, persistence), 0.01))
		if(0 to 0.45)
			T.ChangeTurf(/turf/simulated/lava)
			error = /turf/simulated/lava
		if(0.46 to 0.58)
			T.ChangeTurf(/turf/simulated/floor/asteroid/basalt)
			error = /turf/simulated/floor/asteroid/basalt
		if(0.59 to 1)
			T.ChangeTurf(/turf/simulated/mineral/surface)
			error = /turf/simulated/mineral/surface
		else
			T.ChangeTurf(error)

/datum/terrain_map/sky
	descriptor = "sky"   // Display name.

	target_turf = /turf/unsimulated/mask

/datum/terrain_map/sky/markTurf(var/turf/T)
	switch(round(perlin(T.x, T.y, T.z + seed, scale, octaves, persistence), 0.01))
		if(0.65 to 1)
			T.ChangeTurf(/turf/simulated/mineral/surface)
		else
			var/turf/below = GET_BELOW(T)
			if(below)
				if(below.density)
					T.ChangeTurf(/turf/simulated/floor/asteroid/basalt)
				else
					T.ChangeTurf(/turf/simulated/open)

/datum/terrain_map/shallow
	descriptor = "shallow"   // Display name.

	target_turf = /turf/unsimulated/mask
	error = /turf/simulated/floor/asteroid/basalt
	var/chasmseed

/datum/terrain_map/shallow/markTurf(var/turf/T)
	if(!chasmseed)
		chasmseed = text2num("[rand(0,9)][rand(0,9)][rand(0,9)]")

	switch(round(perlin(T.x, T.y, T.z + seed, scale, octaves, persistence), 0.01))
		if(0.41 to 0.5)
			if(round(perlin(T.x, T.y, chasmseed, 20, 6, 0.5), 0.01) >= 0.65)
				var/turf/below = GET_BELOW(T)
				if(below)
					if(below.density)
						T.ChangeTurf(/turf/simulated/floor/asteroid/basalt)
					else
						T.ChangeTurf(/turf/simulated/open/chasm)
			else
				T.ChangeTurf(/turf/simulated/floor/asteroid/basalt)
			error = /turf/simulated/floor/asteroid/basalt
		if(0 to 0.4)
			T.ChangeTurf(/turf/simulated/mineral/surface)
			error = /turf/simulated/mineral/surface
		if(0.5 to 1)
			T.ChangeTurf(/turf/simulated/mineral/surface)
			error = /turf/simulated/mineral/surface
		else
			T.ChangeTurf(error)

/datum/terrain_map/deep
	descriptor = "deep"   // Display name.

	target_turf = /turf/unsimulated/mask

/datum/terrain_map/deep/markTurf(var/turf/T)
	switch(round(perlin(T.x, T.y, T.z + seed, scale, octaves, persistence), 0.01))
		if(0 to 0.5)
			T.ChangeTurf(/turf/simulated/floor/asteroid/basalt)
		else
			T.ChangeTurf(/turf/simulated/mineral/surface)