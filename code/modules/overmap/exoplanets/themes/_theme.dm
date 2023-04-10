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
	var/name = "Default Theme"
	/// List of /turf types that should be colored according to surface_color
	var/list/surface_turfs = list()
	/// Surface color applied to surface_turfs ; usually set by rock_colors on exoplanet
	var/surface_color
	/* Heightmap Generation
	 * Exoplanet themes work off of a series of 'heightmaps' generated from perlin noise.
	 * Essentially, perlin noise gives us a random value between 0 and 1 for every coordinate we plug into it
	 * If you apply thresholds to the data, e.g. "spawn walls above 0.5", it can very quickly produce believable terrain
	 * The following are several required and optional parameters to tweak the generation data.
	 * For more information, see https://www.redblobgames.com/maps/terrain-from-noise/.
	 */

	/// Exponent applied to the end result height value; values greater than 1 will preserve noise/height values near 1, while dragging the rest down near 0.
	var/height_exponent = 1
	/// Number of iterations (octaves) of perlin noise to use when generating the map. More iterations results in a smoother noise-map, but takes longer to generate.
	var/height_iterations = 3
	/// How 'zoomed in' we are to the noise map, with higher numbers generating smoother transitions and lower variability. 65 is a good base value for our purposes.
	var/perlin_zoom = 65

	/* Assoc list of possible /singleton/biomes, denoted by heat level and humidity
	 * possible_biomes => biome heat level: list(biome humidity => singleton/biome)
	 */
	var/list/possible_biomes

	/// Biome force-picked if height is over [mountain_threshold]. Set to null to disable.
	var/mountain_biome = /singleton/biome/mountain
	/// Height threshold for mountain generation; all turfs with a calculated height above this value will generate inside [mountain_biome]
	var/mountain_threshold = 0.85
	/// Biome force-picked if height is under [water_height] and humidity is over [water_humidity]. Set to null to disable.
	var/water_biome = /singleton/biome/water
	/// Humidity must be this value or higher for [water_biome] to generate.
	var/water_humidity = 0.80
	/// Height must be this value or lower for [water_biome] to generate.
	var/water_height = 0.10

	/* Assoc list of heat level defines to heat thresholds. Heat is taken as the inverse of height modified by distance from the equator (see get_heat)
	 * Biome is selected if the heat found is less than or equal to its correlated value. Values should scale to 1.0 as below.
	 * You do not need to use all biome levels, however any changes you make here should be reflected in [possible_biomes] and vice versa.
	 */
	var/list/heat_levels = list(
		BIOME_POLAR 	= 0.25,
		BIOME_COOL 		= 0.5,
		BIOME_WARM 		= 0.75,
		BIOME_TROPICAL 	= 1.0
	)
	/// Assoc list of humidity level defines to humidity thresholds. Humidity is a seperate noise-map generated only for turfs ensured not to be a mountain.
	var/list/humidity_levels = list(
		BIOME_ARID 		= 0.25,
		BIOME_SUBARID 	= 0.5,
		BIOME_SUBHUMID 	= 0.75,
		BIOME_HUMID 	= 1.0
	)
	/* Ore generation
	 * These values reflect both the raw distribution of ores in the ground, and spawned minerals in rocks.
	 */
	var/list/ore_levels = list(
		ORE_PLATINUM 	= 0.13,
		ORE_DIAMOND 	= 0.11,
		ORE_URANIUM 	= 0.14,
		ORE_GOLD 		= 0.13,
		ORE_SILVER 		= 0.14,
		ORE_COAL 		= 0.2,
		ORE_IRON 		= 0.2,
	)
	/// List of random seeds used for ore noise generation. Automatically generated on New() using ore_levels.
	var/list/ore_seeds
	/// Count of each ore present in mineral walls, used by cleanup() to ensure resource availability.
	var/list/ore_counts

	/// Used for flora generation via poisson disk sampling. Set to FALSE to disable; ensure no biomes on your planet theme need it before you do!
	var/seed_flora = TRUE
	var/seed_fauna = TRUE

	var/list/map_flora
	var/list/map_fauna

/datum/exoplanet_theme/New()
	if(!length(ore_levels))
		return

	sortTim(ore_levels, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE) // We want the rarest first
	for(var/o in ore_levels)
		var/conv_level = max(-0.5, ore_levels[o] - 0.5) // seems like the noise range from DBP noise is (-0.5, 0.5) so we'll convert to that
		LAZYSET(ore_seeds, o, rustg_dbp_generate("[rand(0, 50000)]", "16", "8", "[world.maxx]", "-0.5", "[conv_level]"))

	if(seed_flora)
		seed_flora = rand(1, 50000) // we don't do 0,50000 here because rolling a seed of 0 would cause a failure to generate (and be very funny)
		LAZYINITLIST(map_flora)
	if(seed_fauna)
		seed_fauna = rand(1, 50000)
		LAZYINITLIST(map_fauna)

// This inverts our height value to get a heat value, and then maps that to a sine wave such that heat is preserved at the equator and reduced at the poles.
#define GET_EQUATORIAL_HEAT(height, y_val) cos(TO_DEGREES(clamp(1 - height, 0, 1))) * sin(TO_DEGREES((y_val * M_PI) / 255))

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		surface_color = pick(E.rock_colors)


#define SEED_LANDSCAPE(ftype) if(!(map_##ftype[selected_biome])) { map_##ftype[selected_biome] = rustg_noise_poisson_sample("[seed_##ftype]", "[world.maxx]", "[world.maxy]", "[selected_biome.radius_##ftype]"); }
#define GEN_LANDSCAPE(ftype, spot) (map_##ftype[selected_biome][spot] == "1")

// In the name of not having 65,025 proc calls (and their overhead) for every turf, we instead get to have a massive monolith of a proc. Enjoy. I didn't.
/datum/exoplanet_theme/proc/generate_map(obj/effect/overmap/visitable/sector/exoplanet/E, z_to_gen, min_x, min_y, max_x, max_y)
	var/list/height_seeds = list()
	for (var/i = 1 to height_iterations)
		height_seeds += rand(0, 50000)
	var/humidity_seed = rand(0, 50000)

	for(var/turf/gen_turf in block(locate(min_x, min_y, z_to_gen), locate(max_x, max_y, z_to_gen)))
		// Drift here gives us a bit of extra noise on the edges of biomes, to make it transition slightly more naturally
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
					heat = GET_EQUATORIAL_HEAT(height, gen_turf.y)

				var/heat_level = BIOME_POLAR // No proc for this because proc overhead be damned
				for(var/L in heat_levels)
					if(heat <= heat_levels[L])
						heat_level = L

				var/humidity_level = BIOME_ARID // ditto
				for(var/L in humidity_levels)
					if(humidity <= humidity_levels[L])
						humidity_level = L

				selected_biome = GET_SINGLETON(possible_biomes[heat_level][humidity_level])
		else
			selected_biome = GET_SINGLETON(mountain_biome)

		var/turf_type_to_gen = selected_biome.turf_type
		var/coord_to_str = (world.maxx * gen_turf.y) + gen_turf.x
		if(istype(selected_biome, mountain_biome))
			for(var/ore in ore_seeds)
				if(text2num(ore_seeds[ore][coord_to_str]))
					turf_type_to_gen = ore_to_turf[ore]
					if(!LAZYISIN(ore_counts, ore))
						LAZYSET(ore_counts, ore, 0)
					ore_counts[ore]++
					break

		gen_turf.ChangeTurf(turf_type_to_gen, mapload = TRUE)
		if(gen_turf.density) // No need to check flora/fauna/grass if we're a wall
			continue

		if(seed_flora)
			SEED_LANDSCAPE(flora)
			var/atom/A = GEN_LANDSCAPE(flora, coord_to_str) ? pickweight(selected_biome.avail_flora) : null
			if(A) new A(gen_turf)

		if(seed_fauna)
			SEED_LANDSCAPE(fauna)
			var/atom/B = GEN_LANDSCAPE(fauna, coord_to_str) ? pickweight(selected_biome.avail_fauna) : null
			if(B) new B(gen_turf)

		if(length(selected_biome.grass_types))
			var/atom/C = pickweight(selected_biome.grass_types)
			new C(gen_turf)

		CHECK_TICK

/datum/exoplanet_theme/proc/on_turf_generation(turf/T, area/use_area)
	if(use_area && T.loc == world.area)
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
		if(ore_counts[o] < 100) // Bit of a magic number but we just want to make sure there's a little bit of every ore
			var/conv_level = max(-0.5, ore_levels[o] - 0.5) // seems like the noise range from DBP noise is (-0.5, 0.5) so we'll convert to that
			LAZYSET(ore_seeds, o, rustg_dbp_generate("[rand(0, 50000)]", "16", "8", "[world.maxx]", "-0.5", "[conv_level]"))
		else
			LAZYREMOVE(ore_seeds, o)

	if(!length(ore_seeds))
		return

	var/list/turfs_to_gen = block(locate(min_x, min_y, z_to_check), locate(max_x, max_y, z_to_check))
	for(var/t in turfs_to_gen)
		var/turf/simulated/mineral/M = t
		if(!istype(M) || M.mineral)
			continue
		var/coord_to_str = (world.maxx * M.y) + M.x
		for(var/ore in ore_seeds)
			if(text2num(ore_seeds[ore][coord_to_str]))
				M.mineral = ore_data[ore]
				M.UpdateMineral() // It's already a mineral turf, so we can avoid changeturf here

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/random_map/automata/cave_system/mountains/adhomai
	wall_type = /turf/simulated/mineral/adhomai
	mineral_sparse =  /turf/simulated/mineral/random/adhomai
	mineral_rich = /turf/simulated/mineral/random/high_chance/adhomai
	floor_type = /turf/simulated/floor/exoplanet/mineral/adhomai
	use_area = FALSE
