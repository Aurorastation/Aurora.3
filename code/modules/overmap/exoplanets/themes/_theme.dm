/datum/exoplanet_theme
	var/name = "Default Theme"
	/// List of /turf types that should be colored according to surface_color
	var/list/surface_turfs = list()
	/// Surface color applied to surface_turfs ; usually set by rock_colors on exoplanet
	var/surface_color
	/* Heightmap Generation
	 * Exoplanet themes work off of a series of 'heightmaps' generated from perlin noise.
	 * Essentially, perlin noise gives us a random value between 0 and 1 for every coordinate we plug into it
	 * If you apply thresholds to the data, e.g. "spawn a forest biome above 0.5", it can very quickly produce believable terrain
	 * The following are several required and optional parameters to tweak the generation data.
	 * For more information, see https://www.redblobgames.com/maps/terrain-from-noise/.
	 */

	/// Exponent applied to the end result height value; values greater than 1 will preserve noise/height values near 1, while dragging the rest down near 0.
	var/height_exponent = 1
	/// Number of iterations (octaves) of perlin noise to use when generating the map. More iterations results in a smoother noise-map, but takes longer to generate.
	var/height_iterations = 3
	/// How 'zoomed in' we are to the noise map, with higher numbers generating smoother transitions and lower variability. 65 results in a relatively smooth noise map.
	var/perlin_zoom = 65

	/* Assoc list of possible /singleton/biomes, denoted by heat level and humidity
	 * possible_biomes => biome heat level: list(biome humidity => singleton/biome)
	 */
	var/list/possible_biomes

	/// Biome force-picked if height is over [mountain_threshold]. Set to null to disable.
	var/mountain_biome = /singleton/biome/mountain
	/// Height threshold for mountain generation; all turfs with a calculated height above this value will generate inside [mountain_biome]
	/// Value calculated from noise is in range of 0.0 to 1.0.
	/// Higher threshold means less mountains, lower means more.
	var/mountain_threshold = 0.85

	/* Assoc list of heat level defines to heat thresholds. Heat is taken as the inverse of height modified by distance from the equator (see get_heat)
	 * Biome is selected if the heat found is less than or equal to its correlated value. Values should scale to 1.0 as below.
	 * You do not need to use all biome levels, however any changes you make here should be reflected in [possible_biomes] and vice versa.
	 */
	var/list/heat_levels = list(
		BIOME_POLAR 	= 0.25,
		BIOME_COOL 		= 0.5,
		BIOME_WARM 		= 0.75,
		BIOME_EQUATOR 	= 1.0
	)
	/// Assoc list of humidity level defines to humidity thresholds. Humidity is a seperate noise-map generated only for turfs ensured not to be a mountain.
	var/list/humidity_levels = list(
		BIOME_ARID 		= 0.25,
		BIOME_SEMIARID 	= 0.5,
		BIOME_SUBHUMID 	= 0.75,
		BIOME_HUMID 	= 1.0
	)
	/* Ore generation
	 * These values reflect both the raw distribution of ores in the ground, and spawned minerals in rocks.
	 * The values are somewhat arbitrary, but the comments here should explain what values get what # of ore. You'll need to experiment.
	 * These values are divided by 4 and then clamped to (-0.5, 0.5); w.o the multiplication the "usable" range is roughly (-0.35, -0.27), so
	 * this gives us a bit more room to fine tune (at the cost of arbitrary numbers).
	 * Bear in mind that distribution will be affected by the mountain_threshold as well; these default values are picked to ensure a relatively similar amount
	 * of ores found in walls to the previous system on asteroids.
	 */
	var/list/wall_ore_levels = list(
		ORE_PLATINUM 	= 0.6,
		ORE_DIAMOND 	= 0.6,
		ORE_URANIUM 	= 0.7,
		ORE_GOLD 		= 0.68,
		ORE_SILVER 		= 0.7,
		ORE_COAL 		= 0.9,
		ORE_IRON 		= 0.92,
		ORE_BAUXITE     = 0.8,
		ORE_GALENA      = 0.75,
	)

	/// This is more straight forward. We use three noise maps and assign drillables based on that
	var/list/ground_ore_levels = list(
		SURFACE_ORES = list(
			ORE_IRON = list(2, 4),
			ORE_GOLD = list(0, 2),
			ORE_SILVER = list(0, 2),
			ORE_URANIUM = list(0, 2),
			ORE_BAUXITE = list(1, 3)
		),
		RARE_ORES = list(
			ORE_GOLD = list(1, 3),
			ORE_SILVER = list(1, 3),
			ORE_URANIUM = list(1, 3),
			ORE_PLATINUM = list(1, 3),
			ORE_GALENA = list(1, 3)
		),
		DEEP_ORES = list(
			ORE_URANIUM = list(0, 2),
			ORE_DIAMOND = list(0, 2),
			ORE_PLATINUM = list(2, 4),
			ORE_HYDROGEN = list(1, 3)
		)
	)

	/// relatively speaking, the % (0-1) of turfs that will have resources generated in them
	var/gnd_ore_coverage = 0.3
	/// List of random seeds used for ore noise generation. Automatically generated on New() using wall_ore_levels.
	var/list/ore_seeds
	var/list/gnd_ore_seeds
	/// Count of each ore present in mineral walls, used by cleanup() to ensure resource availability.
	var/list/ore_counts

	/// Assoc list of selected biomes to their random seed information, used in terrain generation
	var/list/biome_seeds

#define ORE_LEVEL_TO_DBP_RANGE(oval) (((oval) / 4) - 0.5)
/datum/exoplanet_theme/New()
	if(!length(wall_ore_levels))
		return ..()

	sortTim(wall_ore_levels, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE) // We want the rarest first
	for(var/o in wall_ore_levels)
		var/conv_level = max(-0.5, ORE_LEVEL_TO_DBP_RANGE(wall_ore_levels[o])) // seems like the noise range from DBP noise is (-0.5, 0.5) so we'll convert to that
		LAZYSET(ore_seeds, o, rustg_dbp_generate("[rand(0, 50000)]", "16", "8", "[world.maxx]", "-0.5", "[conv_level]"))
		LAZYSET(ore_counts, o, 0)

	for(var/g in ground_ore_levels)
		LAZYSET(gnd_ore_seeds, g, rustg_dbp_generate("[rand(0, 50000)]", "16", "8", "[world.maxx]", "-0.5", "[gnd_ore_coverage - 0.5]"))
		LAZYSET(ore_counts, g, 0)

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		surface_color = pick(E.rock_colors)

/// This inverts our height value to get a heat value, and then maps that to a sine wave such that heat is preserved at the equator and reduced at the poles.
#define GET_EQUATORIAL_HEAT(height, y_val) cos(TO_DEGREES(clamp(1 - height, 0, 1))) * sin(TO_DEGREES((y_val * M_PI) / 255))

/* This will create a seed entry in biome_seeds to use in generation; we generate a unique "seed" for each type of generation in each biome.
 * PURE_RANDOM and HEIGHT_MOD will simply copy over their probability and multiplier, respectively, from singleton/biome::generators
 * POISSON_SAMPLE and BATCHED_NOISE will make calls to their respective rust-g functions, returning a string of 1s and 0s which correlates to X and Y coordinates
 */
#define SEED_TERRAIN(ftype) \
	var/singleton/biome/SB = selected_biome; \
	if(SB.generators[ftype][1] & ALWAYS_GEN) { LAZYSET(biome_seeds[SB], ftype, TRUE); } \
	else if(SB.generators[ftype][1] & (PURE_RANDOM|HEIGHT_MOD)) { LAZYSET(biome_seeds[SB], ftype, SB.generators[ftype][2]); } \
	else if(SB.generators[ftype][1] & POISSON_SAMPLE) { LAZYSET(biome_seeds[SB], ftype, rustg_noise_poisson_sample("[rand(1, 50000)]", "[world.maxx]", "[world.maxy]", "[SB.generators[ftype][2]]")); } \
	else if(SB.generators[ftype][1] & BATCHED_NOISE) { LAZYSET(biome_seeds[SB], ftype, rustg_dbp_generate("[rand(1, 50000)]", "[SB.generators[ftype][3]]", "[SB.generators[ftype][4]]", "[world.maxx]", "-0.5", "[selected_biome.generators[ftype][2]]")); }

// Constructs a dijkstra map of distances from origin using breadth-first search
/obj/effect/overmap/visitable/sector/exoplanet/proc/build_heatmap(turf/origin)
	if(!origin) return
	var/Queue/frontier = new
	frontier.enqueue(origin)
	var/list/distance = list(origin = 0)
	origin.maptext = "0"

	while(length(frontier.contents))
		var/turf/current = frontier.dequeue()
		for (var/turf/N in RANGE_TURFS(1, current))
			if(!(N in distance) && !N.density) // we don't care about turfs we've already seen, or ones we can't go through
				frontier.enqueue(N)
				distance[N] = 1 + distance[current]
				N.maptext = "[distance[N]]"

// In the name of not having 65,025 proc calls (and their overhead) for every turf, we instead get to have a massive monolith of a proc. Enjoy. I didn't.
/// Generates exoplanet on `z_to_gen` zlevel, in the specified min/max x/y bounds, and on turfs of type `target_turf_type`.
/// Does nothing to turfs outside of the zlevel, outside of the bounds, or not of the target turf type.
/datum/exoplanet_theme/proc/generate_map(z_to_gen, min_x, min_y, max_x, max_y, target_turf_type)
	var/list/height_seeds = list()
	for (var/i = 1 to height_iterations)
		height_seeds += rand(0, 50000)
	var/humidity_seed = rand(0, 50000)

	for(var/turf/gen_turf in block(locate(min_x, min_y, z_to_gen), locate(max_x, max_y, z_to_gen)))

		if(gen_turf.type != target_turf_type)
			continue

		// Drift here gives us a bit of extra noise on the edges of biomes, to make it transition slightly more naturally
		var/drift_x = (gen_turf.x + rand(-BIOME_RANDOM_SQUARE_DRIFT, BIOME_RANDOM_SQUARE_DRIFT)) / perlin_zoom
		var/drift_y = (gen_turf.y + rand(-BIOME_RANDOM_SQUARE_DRIFT, BIOME_RANDOM_SQUARE_DRIFT)) / perlin_zoom

		var/height = 0
		var/height_divisor = 0
		// Here we're creating 'octaves' by sampling different height maps at different zoom levels;
		// [octave] gives us (1, 2, 4...), which we then use to sample additional maps at higher frequencies
		// We then multiply by the inverse to reduce its weight relative to the initial octave
		// [height_divisor] keeps track of the multiplications we've done so we can divide the ending height value to return to a sane range of (0, 1)
		for(var/i in 1 to height_seeds.len)
			var/octave = 2 ** (i - 1)
			height += (1 / octave) * text2num(rustg_noise_get_at_coordinates("[height_seeds[i]]", "[octave * drift_x]", "[octave * drift_y]"))
			height_divisor += (1 / octave)

		height = (height / height_divisor) ** height_exponent

		var/humidity = 0
		var/heat = 0
		var/singleton/biome/selected_biome
		var/heat_level = BIOME_POLAR
		var/humidity_level = BIOME_ARID

		if((height < mountain_threshold) || !mountain_biome)
			// We're only going to bother with secondary heatmaps and heat-level parsing if there's actually more than one level
			if(length(humidity_levels) > 1)
				humidity = text2num(rustg_noise_get_at_coordinates("[humidity_seed]", "[drift_x]", "[drift_y]"))
			if(length(heat_levels) > 1)
				heat = GET_EQUATORIAL_HEAT(height, gen_turf.y)

			for(var/L in heat_levels)
				if(heat <= heat_levels[L])
					heat_level = L
					break

			for(var/L in humidity_levels)
				if(humidity <= humidity_levels[L])
					humidity_level = L
					break

			selected_biome = GET_SINGLETON(possible_biomes[heat_level][humidity_level])
		else
			selected_biome = GET_SINGLETON(mountain_biome)

		LAZYDISTINCTADD(biome_seeds, selected_biome)
		LAZYINITLIST(biome_seeds[selected_biome])

		// Converting (255 * 255) coordinates to a 65025 character string; each block of 255 is one Y coordinate, and what's left over is our X coordinate
		var/coord_to_str = (world.maxx * gen_turf.y) + gen_turf.x
		var/turf_type_to_gen

		// Code duplication for the sake of clarity over a define; this is the main generation function. PLANET_TURF is a special case;
		// We don't always have PLANET_TURF specified as a generator (in fact we usually don't), so we'll just defer to [selected_biome.turf_type] in that case
		if(PLANET_TURF in selected_biome.generators)
			if(!LAZYISIN(biome_seeds[selected_biome], PLANET_TURF))
				SEED_TERRAIN(PLANET_TURF)
			var/alt_turf = FALSE
			switch(selected_biome.generators[PLANET_TURF][1])
				if(ALWAYS_GEN)
					alt_turf = TRUE
				if(PURE_RANDOM)
					alt_turf = prob(biome_seeds[selected_biome][PLANET_TURF])
				if(HEIGHT_MOD)
					var/new_heat_level
					var/new_humid_level
					for(var/L in heat_levels)
						if((heat * biome_seeds[selected_biome][PLANET_TURF]) <= heat_levels[L])
							new_heat_level = L
							break
					for(var/L in humidity_levels)
						if((humidity * biome_seeds[selected_biome][PLANET_TURF]) <= humidity_levels[L])
							new_humid_level = L
							break
					alt_turf = ((heat_level == new_heat_level) && (humidity_level == new_humid_level))
				if(POISSON_SAMPLE)
					alt_turf = biome_seeds[selected_biome][PLANET_TURF][coord_to_str] == "1"
				if(BATCHED_NOISE)
					alt_turf = biome_seeds[selected_biome][PLANET_TURF][coord_to_str] == "1"
			if(alt_turf)
				turf_type_to_gen = pickweight(selected_biome.spawn_types[PLANET_TURF])

		if(!ispath(turf_type_to_gen, /turf))
			turf_type_to_gen = selected_biome.turf_type

		gen_turf.ChangeTurf(turf_type_to_gen, mapload = TRUE)
		if(istype(selected_biome, mountain_biome))
			for(var/ore in ore_seeds)
				if(text2num(ore_seeds[ore][coord_to_str]))
					var/turf/simulated/mineral/M = gen_turf
					M.change_mineral(ore, TRUE)
					ore_counts[ore]++
					break

		if(gen_turf.has_resources)
			var/ground_resources_roll
			for(var/ore in gnd_ore_seeds)
				if(text2num(gnd_ore_seeds[ore][coord_to_str]))
					ore_counts[ore]++
					ground_resources_roll = ore
					break
			gen_turf.resources = list()
			gen_turf.resources[ORE_SAND] = rand(3, 5)
			gen_turf.resources[ORE_COAL] = rand(3, 5)
			if(ground_resources_roll)
				var/image/resource_indicator = image('icons/obj/mining.dmi', null, "indicator_" + ground_resources_roll, gen_turf.layer, pick(GLOB.cardinals))
				resource_indicator.alpha = rand(30, 60)
				gen_turf.resource_indicator = resource_indicator
				if(!gen_turf.density)
					gen_turf.AddOverlays(resource_indicator)
				for(var/OT in ground_ore_levels[ground_resources_roll])
					var/rand_vals = ground_ore_levels[ground_resources_roll][OT]
					gen_turf.resources[OT] = rand(rand_vals[1], rand_vals[2])

		if(gen_turf.density) // No need to check flora/fauna/grass if we're a wall
			continue

		if(PLANET_TURF in selected_biome.generators)
			if((turf_type_to_gen != selected_biome.turf_type) && (PLANET_TURF in selected_biome.exclusive_generators))
				continue // snowflake check since the terrain gen code below won't look for PLANET_TURF, and we only want to stop gen for non-standard turf types

		/* Main terrain generation function. Once we have our turf and we know we're not dense, we can loop through our generators as noted in our biome file
		 * Each generators definition follows the format: generators = list(GENERATOR_NAME = list(GENERATOR_TYPE, PARAMS...))
		 * Different generation types have different parameters; ALWAYS_GEN has none, since it's always generating if valid.
		 * This is essentially just a switch that goes through each generator, checks if it returns true for this tile, and if so, picks something from the weighted spawn_types list.
		 */
		for(var/to_gen in selected_biome.generators)
			if(to_gen == PLANET_TURF)
				continue // we dealt with turfs already
			if(!LAZYISIN(biome_seeds[selected_biome], to_gen))
				SEED_TERRAIN(to_gen)
			var/check = FALSE
			switch(selected_biome.generators[to_gen][1])
				if(ALWAYS_GEN)
					check = TRUE
				if(PURE_RANDOM)
					check = prob(biome_seeds[selected_biome][to_gen])
				if(HEIGHT_MOD)
					var/new_heat_level
					var/new_humid_level
					// Here we apply the HEIGHT_MOD to heat and humidity, and see if they still meet the same level.
					for(var/L in heat_levels)
						if((heat * biome_seeds[selected_biome][to_gen]) <= heat_levels[L])
							new_heat_level = L
							break
					for(var/L in humidity_levels)
						if((humidity * biome_seeds[selected_biome][to_gen]) <= humidity_levels[L])
							new_humid_level = L
							break
					check = ((heat_level == new_heat_level) && (humidity_level == new_humid_level))
				if(POISSON_SAMPLE)
					check = biome_seeds[selected_biome][to_gen][coord_to_str] == "1"
				if(BATCHED_NOISE)
					check = biome_seeds[selected_biome][to_gen][coord_to_str] == "1"
			if(!check)
				continue
			var/obj_path = pickweight(selected_biome.spawn_types[to_gen])
			if(obj_path)
				new obj_path(gen_turf)
				if(to_gen in selected_biome.exclusive_generators)
					break // we break out of the generation loop for this turf if we come across an 'exclusive generator'

		CHECK_TICK

/datum/exoplanet_theme/proc/on_turf_generation(turf/T, area/use_area)
	if(use_area && istype(T.loc, world.area))
		T.change_area(T.loc, use_area) // Switch our generated turfs from world.area (space) to our chosen exoplanet area

	if(surface_color && is_type_in_list(T, surface_turfs))
		T.color = surface_color

	var/turf/simulated/mineral/M = T
	if(use_area && istype(M))
		M.mined_turf = use_area.base_turf

/datum/exoplanet_theme/proc/cleanup(obj/effect/overmap/visitable/sector/exoplanet/E, z_to_check, min_x, min_y, max_x, max_y)
	if(!LAZYLEN(ore_counts) || !LAZYLEN(wall_ore_levels))
		return

	for(var/o in ore_counts)
		if(ore_counts[o] < 100) // Bit of a magic number but we just want to make sure there's a little bit of every ore
			var/conv_level = max(-0.5, ORE_LEVEL_TO_DBP_RANGE(wall_ore_levels[o])) // seems like the noise range from DBP noise is (-0.5, 0.5) so we'll convert to that
			LAZYSET(ore_seeds, o, rustg_dbp_generate("[rand(0, 50000)]", "16", "8", "[world.maxx]", "-0.5", "[conv_level]"))
		else
			LAZYREMOVE(ore_seeds, o)

	if(!length(ore_seeds))
		return

	for(var/turf/simulated/S in block(locate(min_x, min_y, z_to_check), locate(max_x, max_y, z_to_check)))
		if(!istype(S))
			continue
		S.update_air_properties()
		var/turf/simulated/mineral/M = S
		if(!istype(M) || M.mineral)
			continue
		var/coord_to_str = (world.maxx * M.y) + M.x
		for(var/ore in ore_seeds)
			if(text2num(ore_seeds[ore][coord_to_str]))
				M.mineral = GLOB.ore_data[ore]
				M.UpdateMineral() // It's already a mineral turf, so we can avoid changeturf here

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/exoplanet_theme/proc/after_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E) //after the map is generated and ruins exist
