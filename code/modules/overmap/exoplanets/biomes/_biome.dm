#define FUDGE_VALUE 1.1 // This is needed for math reasons; changing it will wildly change resource distribution, so uh, be careful

/singleton/biome
	/// Type of turf this biome creates
	var/turf_type
	/// Chance of having a structure from the flora types list spawn
	var/flora_density = 0
	/// Chance of having a mob from the fauna types list spawn
	var/fauna_density = 0
	var/grass_density = 0
	/// List of lists of type paths of objects that can be spawned when the turf spawns flora, associated to a weighted value
	var/list/flora_types = list(
		list(/obj/structure/flora/grass/jungle) = 3,
		list(/obj/structure/flora/tree/jungle) = 1
	)
	/// List of lists of type paths of mobs that can be spawned when the turf spawns fauna, associated to a weighted value
	var/list/fauna_types = list()

	var/list/grass_types = list()

/// This proc handles the creation of a turf of a specific biome type
/singleton/biome/proc/generate_turf(turf/gen_turf, obj/effect/overmap/visitable/sector/exoplanet/E, height)
	gen_turf.ChangeTurf(turf_type)
	E.theme.on_turf_generation(gen_turf, E.planetary_area)

	if(gen_turf.density)
		return

	if(length(fauna_types) && prob(fauna_density))
		var/mob/fauna = pick(pickweight(fauna_types))
		new fauna(gen_turf)

	if(length(grass_types) && prob(grass_density))
		var/obj/structure/grass = pick(pickweight(grass_types))
		new grass(gen_turf)

	if(length(flora_types) && prob(flora_density))
		var/obj/structure/flora = pick(pickweight(flora_types))
		new flora(gen_turf)

/singleton/biome/mountain/generate_turf(turf/gen_turf, obj/effect/overmap/visitable/sector/exoplanet/E, noise)
	var/turf_type_gen = turf_type
	var/datum/exoplanet_theme/ET = E.theme

	var/zoom_x = gen_turf.x / ore_zoom
	var/zoom_y = gen_turf.y / ore_zoom

	for(var/ore in ET.ore_levels)
		var/ore_val = 0
		var/ore_div = 0
		if(!(ore in ET.ore_seeds))
			ET.ore_seeds[ore] = rand(0, 50000) // This should never happen, which means it definitely will

		for(var/i = 1 to ore_octaves)
			var/octave = 2 ** (i - 1)
			var/octave_offset = 33 * (octave - 1) // a bit of a magic number, but this is just so we don't use the same seed for each octave w.o needing to store 800 seeds
			ore_val += (1 / octave) * text2num(rustg_noise_get_at_coordinates("[ET.ore_seeds[ore] + octave_offset]", "[octave * zoom_x]", "[octave * zoom_y]"))
			ore_div += (1 / octave)

		ore_val = (ore_val / ore_div) * FUDGE_VALUE
		ore_val = ore_val ** ore_exponent

		if(ore_val >= ET.ore_levels[ore])
			turf_type_gen = ore_to_turf[ore]
			if(!LAZYISIN(ET.ore_counts, ore))
				LAZYSET(ET.ore_counts, ore, 0)
			ET.ore_counts[ore]++
			break

	gen_turf.ChangeTurf(turf_type_gen)
	E.theme.on_turf_generation(gen_turf, E.planetary_area)

/singleton/biome/barren
	turf_type = /turf/simulated/floor/exoplanet/barren

/singleton/biome/barren/asteroid
	turf_type = /turf/unsimulated/floor/asteroid/ash

/singleton/biome/arid
	turf_type = /turf/simulated/floor/exoplanet/desert/sand
	flora_density = 1
	flora_types = list(
		list(/obj/structure/flora/rock/desert) = 3,
		list(/obj/structure/flora/rock/desert/scrub) = 2,
		list(/obj/structure/flora/tree/desert/tiny) = 1
	)

/singleton/biome/arid/scrub
	grass_density = 100
	flora_density = 2
	grass_types = list(
		list(/obj/structure/flora/grass/desert/bush) = 1,
		list(/obj/structure/flora/grass/desert) = 3
	)
	flora_types = list(
		list(/obj/structure/flora/tree/desert/tiny) = 5,
		list(/obj/structure/flora/rock/desert) = 1,
		list(/obj/structure/flora/rock/desert/scrub) = 4,
	)

/singleton/biome/arid/thorn
	turf_type = /turf/simulated/floor/exoplanet/desert/sand/dune
	grass_types = list(
		list(/obj/structure/flora/grass/desert/bush) = 3,
		list(/obj/structure/flora/grass/desert) = 2
	)
	flora_types = list(
		list(/obj/structure/flora/rock/desert) = 1,
		list(/obj/structure/flora/rock/desert/scrub) = 1,
		list(/obj/structure/flora/tree/desert/tiny) = 10,
		list(/obj/structure/flora/tree/desert/small) = 8,
		list(/obj/structure/flora/tree/desert) = 6
	)
	grass_density = 100
	flora_density = 10

/singleton/biome/mountain
	turf_type = /turf/simulated/mineral

	var/ore_zoom = 25.01
	var/ore_octaves = 3
	var/ore_exponent = 5

/singleton/biome/water
	turf_type = /turf/simulated/floor/exoplanet/water/shallow

/obj/structure/flora/tree/desert
	name = "cactus tree"
	icon = 'icons/obj/flora/desert_cactus_trees.dmi'
	icon_state = "desert_tree"
	desc = "A prickly cactus with a woody trunk."

/obj/structure/flora/tree/desert/Initialize(mapload)
	. = ..()
	icon_state = "desert_tree[rand(1,2)]"

/obj/structure/flora/tree/desert/small/Initialize(mapload)
	. = ..()
	icon_state = "desert_tree[rand(3,4)]"

/obj/structure/flora/tree/desert/tiny/Initialize(mapload)
	. = ..()
	icon_state = "desert_tree[rand(5,6)]"

/obj/structure/flora/grass/desert
	name = "desert grass"
	desc = "Alien scrubland."
	icon = 'icons/turf/desert_color_tweak.dmi'
	icon_state = "desert_grass"

/obj/structure/flora/grass/desert/Initialize()
	. = ..()
	icon_state = "desert_grass[rand(1,3)]"

/obj/structure/flora/grass/desert/bush/Initialize()
	. = ..()
	icon_state = "desert_grass_bush[rand(1,4)]"

/obj/structure/flora/rock/desert
	desc = "A sand-swept rock."
	icon = 'icons/turf/desert_color_tweak.dmi'
	icon_state = "desert_rock"

/obj/structure/flora/rock/desert/Initialize()
	. = ..()
	icon_state = "desert_rock[rand(1,4)]"

/obj/structure/flora/rock/desert/scrub/Initialize()
	. = ..()
	icon_state = "desert_rock[rand(5,8)]"

/turf/simulated/floor/exoplanet/desert/sand
	icon = 'icons/turf/desert_color_tweak.dmi'
	icon_state = "desert_sand"

/turf/simulated/floor/exoplanet/desert/sand/Initialize()
	. = ..()
	icon_state = "desert_sand[rand(4,7)]"

/turf/simulated/floor/exoplanet/desert/sand/dune/Initialize()
	. = ..()
	icon_state = "desert_sand[rand(1,3)]"

#undef FUDGE_VALUE
