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

/datum/terrain_map/proc/markTurf(var/turf/T)
	var/area/A = T.loc
	if(A.station_area)
		return

///////////////
////TERRAIN////
///////////////

/datum/terrain_map/surface
	descriptor = "surface"   // Display name.
	error = /turf/simulated/lava

	target_turf = /turf/unsimulated/mask

/datum/terrain_map/surface/markTurf(var/turf/T)
	..()
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
	..()
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
	..()
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
	..()
	switch(round(perlin(T.x, T.y, T.z + seed, scale, octaves, persistence), 0.01))
		if(0 to 0.5)
			T.ChangeTurf(/turf/simulated/floor/asteroid/basalt)
		else
			T.ChangeTurf(/turf/simulated/mineral/surface)

///////////////
/////FLORA/////
///////////////

/obj/effect/landmark/flora_spawn
	icon_state = "x3"

/obj/effect/landmark/flora_spawn/New()
	return

/obj/effect/landmark/flora_spawn/mushrooms/New()
	return


/datum/terrain_map/flora
	var/scale2 = 0
	var/persistence2 = 0
	var/octaves2 = 0
	var/seed2 = 0

/datum/terrain_map/flora/New(var/zpos, var/xpos1, var/xpos2, var/ypos1, var/ypos2, var/seedy = 1, var/scalar = 1, var/octavius = 1, var/virility = 0.5, var/seedy2, var/scalar2, var/octavius2, var/virility2)
	scale2 = scalar2
	octaves2 = octavius2
	seed2 = seedy2
	persistence2 = virility2
	..()

/datum/terrain_map/flora/mushrooms
	descriptor = "mushroom"   // Display name.

	target_turf = /turf/simulated/floor/asteroid/basalt

/datum/terrain_map/flora/mmushrooms/markTurf(var/turf/T)
	..()
	var/perlin1 = round(perlin(T.x, T.y, T.z + seed, scale, octaves, persistence), 0.01)
	var/perlin2 = round(perlin(T.x, T.y, T.z + seed2, scale2, octaves2, persistence2), 0.01)

	if(perlin1 >= 0.6 && perlin1 <= 1)
		if(perlin2 >= 0.6 && perlin2 <= 0.58)
			new /obj/effect/landmark/flora_spawn/mushrooms(T)

///////////////
//////POI//////
///////////////
/obj/effect/landmark/point_of_interest
	icon_state = "x"

/obj/effect/landmark/point_of_interest/New()
	return

/obj/effect/landmark/point_of_interest/lavaland/New()
	return


/datum/dungeon_spawner
	var/descriptor = "spooky dungeons"   // Display name.

	// Locator/value vars.
	var/origin_x = 1                // Origin point, left.
	var/origin_y = 1                // Origin point, bottom.
	var/origin_z = 1                // Target Z-level.
	var/limit_x = 255               // Default x size.
	var/limit_y = 255               // Default y size.
	var/dungeon_density = 100
	var/x_iterand = 25
	var/y_iterand = 25
	var/dungeon_likelihood = 0
	var/marker_type = /obj/effect/landmark/point_of_interest
	var/list/blacklisted_turfs = list()

/datum/dungeon_spawner/New(var/zpos, var/xpos1, var/xpos2, var/ypos1, var/ypos2, var/density)
	origin_z = zpos
	origin_x = xpos1
	origin_y = ypos1
	limit_x = xpos2
	limit_y = ypos2
	dungeon_density = density

	CHECK_TICK

	generate()

/datum/dungeon_spawner/proc/generate()
	for(var/x = origin_x, x <= limit_x, x++)
		x_iterand = max(0, x_iterand - 1)
		for(var/y = origin_y, y <= limit_y, y++)
			y_iterand = max(0, y_iterand - 1)
			if(!x_iterand && !y_iterand)
				if(prob(dungeon_density + dungeon_likelihood))
					var/turf/T = locate(x, y, origin_z)
					var/area/A = T.loc
					var/blacklist = 0
					for(var/turf in blacklisted_turfs)
						if(istype(T, turf))
							blacklist = 1
							break

					if(!A.station_area && !blacklist)
						new marker_type(T)
						x_iterand = 25
						y_iterand = 25
						dungeon_likelihood = 0
				else
					dungeon_likelihood += 2

/datum/dungeon_spawner/lavaland
	descriptor = "lavaland dungeons"   // Display name.

	marker_type = /obj/effect/landmark/point_of_interest/lavaland