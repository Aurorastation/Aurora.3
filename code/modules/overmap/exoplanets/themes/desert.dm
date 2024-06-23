/datum/exoplanet_theme/desert
	name = "Desert"
	surface_turfs = list(
		/turf/simulated/mineral/planet
		)
	possible_biomes = list(
		BIOME_POLAR = list(
			BIOME_ARID = /singleton/biome/desert/scrub,
			BIOME_SEMIARID = /singleton/biome/desert/thorn,
			BIOME_SUBHUMID = /singleton/biome/desert/thorn,
			BIOME_HUMID = /singleton/biome/desert/scrub
			),
		BIOME_COOL = list(
			BIOME_ARID = /singleton/biome/desert,
			BIOME_SEMIARID = /singleton/biome/desert/scrub,
			BIOME_SUBHUMID = /singleton/biome/desert/thorn,
			BIOME_HUMID = /singleton/biome/desert/thorn
			),
		BIOME_WARM = list(
			BIOME_ARID = /singleton/biome/desert,
			BIOME_SEMIARID = /singleton/biome/desert,
			BIOME_SUBHUMID = /singleton/biome/desert/scrub,
			BIOME_HUMID = /singleton/biome/desert/thorn
			),
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/desert,
			BIOME_SEMIARID = /singleton/biome/desert,
			BIOME_SUBHUMID = /singleton/biome/desert,
			BIOME_HUMID = /singleton/biome/desert/scrub
			)
	)

	heat_levels = list(
		BIOME_POLAR = 0.1,
		BIOME_COOL = 0.3,
		BIOME_WARM = 0.5,
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 0.6,
		BIOME_SEMIARID = 0.8,
		BIOME_SUBHUMID = 0.9,
		BIOME_HUMID = 1.0
	)

/datum/exoplanet_theme/desert/savannah
	name = "Savannah"

	humidity_levels = list(
		BIOME_ARID = 0.3,
		BIOME_SEMIARID = 0.6,
		BIOME_SUBHUMID = 0.8,
		BIOME_HUMID = 1.0
	)

/datum/exoplanet_theme/desert/wasteland //nuked Moghes theme
	name = "Wasteland"
	possible_biomes = list(
		BIOME_EQUATOR = list(
			BIOME_ARID = /singleton/biome/desert/wasteland //ecological diversity? in this economy?
		)
	)
	mountain_threshold = 0.6

	heat_levels = list(
		BIOME_EQUATOR = 1.0
	)

	humidity_levels = list(
		BIOME_ARID = 1.0
	)

/datum/exoplanet_theme/desert/wasteland/after_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E) //irradiate to shit
	var/area/A = E.planetary_area
	LAZYDISTINCTADD(A.ambience, AMBIENCE_DESERT)
	A.area_blurb = "The sweltering heat presses down on you from every direction. Clouds of sand swirl around your feet. In the distance, the jagged shapes of broken skyscrapers loom on the horizon. This is the Wasteland of Moghes, a bleeding scar of a war that had no victors."
	var/radiation_power = rand(10, 37.5)
	var/num_craters = round(min(0.04, rand()) * 0.02 * E.maxx, E.maxy)
	for(var/i = 1 to num_craters)
		var/turf/simulated/T = pick_area_turf(E.planetary_area, list(/proc/not_turf_contains_dense_objects))
		if(!T)
			return
		var/datum/radiation_source/S = new(T, radiation_power, FALSE)
		S.range = 4
		SSradiation.add_source(S)
