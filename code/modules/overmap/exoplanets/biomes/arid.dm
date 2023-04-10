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
	avail_grass = list(
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
	avail_grass = list(
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
