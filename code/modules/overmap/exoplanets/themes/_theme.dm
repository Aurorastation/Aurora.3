#define BIOME_RANDOM_SQUARE_DRIFT 2

#define BIOME_POLAR "polar"
#define BIOME_COOL "cool"
#define BIOME_WARM "warm"
#define BIOME_TROPICAL "tropical"

#define BIOME_ARID "arid"
#define BIOME_SUBARID "subarid"
#define BIOME_SUBHUMID "subhumid"
#define BIOME_HUMID "humid"

/datum/exoplanet_theme
	var/name = "Nothing Special"
	var/list/surface_turfs = list()
	var/surface_color
	var/list/possible_biomes
	var/mountain_biome = /singleton/biome/mountain
	var/mountain_threshold = 0.85
	var/height_exponent = 1
	var/height_iterations = 3
	var/water_biome = /singleton/biome/water
	var/water_humidity = 0.80
	var/water_height = 0.10
	var/list/heat_levels = list(
		BIOME_POLAR 	= 0.25,
		BIOME_COOL 		= 0.5,
		BIOME_WARM 		= 0.75,
		BIOME_TROPICAL 	= 1.0
	)
	var/list/humidity_levels = list(
		BIOME_ARID 		= 0.25,
		BIOME_SUBARID 	= 0.5,
		BIOME_SUBHUMID 	= 0.75,
		BIOME_HUMID 	= 1.0
	)
	/// These levels SHOULD NOT add up to 1.0. Each one is their threshold for appearing independent of others, rarest first.
	var/list/ore_levels = list(
		ORE_PLATINUM 	= 0.9,
		ORE_DIAMOND 	= 0.97,
		ORE_URANIUM 	= 0.85,
		ORE_GOLD 		= 0.85,
		ORE_SILVER 		= 0.85,
		ORE_COAL 		= 0.6,
		ORE_IRON 		= 0.5,
	)
	var/list/ore_seeds
	var/list/ore_counts
	var/perlin_zoom = 65

/datum/exoplanet_theme/New()
	if(!length(ore_levels))
		return
	for(var/o in ore_levels)
		LAZYSET(ore_seeds, o, rand(0, 50000))

/datum/exoplanet_theme/proc/get_heat(height, y_val)
	var/tmp_heat = clamp(1 - height, 0, 1)
	var/equator = sin(ToDegrees((y_val * M_PI) / 255))
	return cos(ToDegrees(tmp_heat)) * equator

/datum/exoplanet_theme/proc/get_heat_level(heat)
	for(var/level in heat_levels)
		if(heat <= heat_levels[level])
			return level

	return pick(heat_levels)

/datum/exoplanet_theme/proc/get_humidity_level(noise)
	for(var/level in humidity_levels)
		if(noise <= humidity_levels[level])
			return level

	return pick(humidity_levels)

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		surface_color = pick(E.rock_colors)

/datum/exoplanet_theme/proc/generate_map(obj/effect/overmap/visitable/sector/exoplanet/E, z_to_gen, min_x, min_y, max_x, max_y)
	var/list/height_seeds = list()
	for (var/i = 1 to height_iterations)
		height_seeds += rand(0, 50000)
	var/humidity_seed = rand(0, 50000)

	var/list/turfs_to_gen = block(locate(min_x, min_y, z_to_gen), locate(max_x, max_y, z_to_gen))
	for(var/t in turfs_to_gen)
		var/turf/gen_turf = t

		var/drift_x = (gen_turf.x + rand(-BIOME_RANDOM_SQUARE_DRIFT, BIOME_RANDOM_SQUARE_DRIFT)) / perlin_zoom
		var/drift_y = (gen_turf.y + rand(-BIOME_RANDOM_SQUARE_DRIFT, BIOME_RANDOM_SQUARE_DRIFT)) / perlin_zoom

		var/height = 0
		var/height_divisor = 0
		for(var/i in 1 to height_seeds.len)
			var/octave = 2 ** (i - 1)
			height += (1 / octave) * text2num(rustg_noise_get_at_coordinates("[height_seeds[i]]", "[octave * drift_x]", "[octave * drift_y]"))
			height_divisor += (1 / octave)

		height = (height / height_divisor) ** height_exponent

		var/humidity = 0
		var/heat = 0
		var/singleton/biome/selected_biome

		if((height < mountain_threshold) || !mountain_biome)
			if(length(humidity_levels) > 1)
				humidity = text2num(rustg_noise_get_at_coordinates("[humidity_seed]", "[drift_x]", "[drift_y]"))
			if(water_biome && humidity >= water_humidity && height <= water_height)
				selected_biome = GET_SINGLETON(water_biome)
			else
				if(length(heat_levels) > 1)
					heat = get_heat(height, gen_turf.y)
				var/heat_level = get_heat_level(heat)
				var/humidity_level = get_humidity_level(humidity)
				selected_biome = GET_SINGLETON(possible_biomes[heat_level][humidity_level])
		else
			selected_biome = GET_SINGLETON(mountain_biome)

		if(selected_biome)
			selected_biome.generate_turf(gen_turf, E, height)

		CHECK_TICK

/datum/exoplanet_theme/proc/on_turf_generation(turf/T, area/use_area)
	if(use_area && T.loc != use_area)
		ChangeArea(T, use_area)
	if(surface_color && is_type_in_list(T, surface_turfs))
		T.color = surface_color

	var/turf/simulated/mineral/M = T
	if(use_area && istype(M))
		M.mined_turf = use_area.base_turf

/datum/exoplanet_theme/proc/cleanup(obj/effect/overmap/visitable/sector/exoplanet/E, z_to_check, min_x, min_y, max_x, max_y)
	if(!LAZYLEN(ore_counts) || !LAZYLEN(ore_levels))
		return

	for(var/o in ore_counts)
		if(ore_counts[o] < 100) // Bit of a magic number but we just want to make sure there's a little bit of ore
			ore_seeds[o] = rand(0, 50000)
		else
			LAZYREMOVE(ore_seeds, o)

	if(!ore_seeds)
		return

	var/list/turfs_to_gen = block(locate(min_x, min_y, z_to_check), locate(max_x, max_y, z_to_check))
	var/singleton/biome/mtn_biome = GET_SINGLETON(mountain_biome)
	for(var/t in turfs_to_gen)
		var/turf/simulated/mineral/M = t
		if(istype(M) || !M.mineral)
			mtn_biome.generate_turf(M, E) // We regen unfilled mineral turfs with new ore seeds to pump the numbers up

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/random_map/automata/cave_system/mountains/adhomai
	wall_type = /turf/simulated/mineral/adhomai
	mineral_sparse =  /turf/simulated/mineral/random/adhomai
	mineral_rich = /turf/simulated/mineral/random/high_chance/adhomai
	floor_type = /turf/simulated/floor/exoplanet/mineral/adhomai
	use_area = FALSE
