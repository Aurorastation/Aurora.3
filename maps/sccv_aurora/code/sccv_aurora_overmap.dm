/obj/effect/overmap/visitable/ship/sccv_aurora
	name = "SCCV Aurora"
	desc = "A Stellar Conglomerate Vessel general purpose ship."
	fore_dir = SOUTH
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	base = TRUE


/obj/effect/overmap/visitable/ship/landable/intrepid
	name = "Intrepid"
	desc = "An exploration shuttle used by SCC general purpose ships"
	shuttle = "Intrepid"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/mining_shuttle
	name = "Mining Shuttle"
	desc = "An mining shuttle used by SCC general purpose ships to gather resources in asteroid fields."
	shuttle = "Mining Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY