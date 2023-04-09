#define FUDGE_VALUE 1.1 // This is needed for math reasons; changing it will wildly change resource distribution, so uh, be careful

/singleton/biome
	/// Base turf this biome generates
	var/turf_type
	/*
	 * Flora and fauna generation works off of poisson disk sampling. In short, that means uniformly placed random points within the biome.
	 * The values below are the radius (in turfs, more or less) that one object must be from another to be able to spawn.
	 * Thus, a value of 1 would cause very tight clumps, while 3 would be dense but walkable, and 7 would be more spread out.
	 * Grass works off a strict binary (because otherwise it looks weird); if you define grass types, it will pick between them. Otherwise, it will not.
	 */
	/// Minimum radius one chosen piece of flora must be from another
	var/radius_flora = 0
	/// As above, for fauna (mobs)
	var/radius_fauna = 0
	/// Weighted list of flora types to spawn; for example setting one type to 3 and the other to 1 will result in a 75% / 25% mix on average
	var/list/avail_flora = list()
	/// Weighted list of fauna types to spawn
	var/list/avail_fauna = list()
	/// Weighted list of grass types to spawn
	var/list/grass_types = list()

/singleton/biome/barren
	turf_type = /turf/simulated/floor/exoplanet/barren
	radius_fauna = 15
	avail_fauna = list(
		/mob/living/simple_animal/hostile/gnat = 5,
		/mob/living/simple_animal/hostile/carp/asteroid = 3,
		/mob/living/simple_animal/hostile/carp/bloater = 1,
		/mob/living/simple_animal/hostile/carp/shark/reaver = 1,
		/mob/living/simple_animal/hostile/carp/shark/reaver/eel = 1
	)

/singleton/biome/barren/asteroid
	turf_type = /turf/unsimulated/floor/asteroid/ash

/singleton/biome/arid
	turf_type = /turf/simulated/floor/exoplanet/desert/sand
	radius_flora = 7
	avail_flora = list(
		/obj/structure/flora/rock/desert = 3,
		/obj/structure/flora/rock/desert/scrub = 2,
		/obj/structure/flora/tree/desert/tiny = 1
	)

/singleton/biome/arid/scrub
	radius_flora = 4
	grass_types = list(
		/obj/structure/flora/grass/desert/bush = 1,
		/obj/structure/flora/grass/desert = 3
	)
	avail_flora = list(
		/obj/structure/flora/tree/desert/tiny = 5,
		/obj/structure/flora/rock/desert = 1,
		/obj/structure/flora/rock/desert/scrub = 4,
	)

/singleton/biome/arid/thorn
	turf_type = /turf/simulated/floor/exoplanet/desert/sand/dune
	grass_types = list(
		/obj/structure/flora/grass/desert/bush = 3,
		/obj/structure/flora/grass/desert = 2
	)
	radius_flora = 3
	avail_flora = list(
		/obj/structure/flora/rock/desert = 1,
		/obj/structure/flora/rock/desert/scrub = 1,
		/obj/structure/flora/tree/desert/tiny = 10,
		/obj/structure/flora/tree/desert/small = 8,
		/obj/structure/flora/tree/desert = 6
	)

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
