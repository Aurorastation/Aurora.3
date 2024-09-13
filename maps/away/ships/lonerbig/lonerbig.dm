/datum/map_template/ruin/away_site/lonerbig
	name = "Saroka"
	description = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."

	prefix = "ships/lonerbig/"
	suffix = "lonerbig.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "lonerbig"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(2)

/singleton/submap_archetype/longerbig
	map = "Saroka"
	descriptor = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."

	// airlocks
/obj/effect/map_effect/marker/airlock/lonerbig/aft
	name = "Aft, Large"
	master_tag = "airlock_lonerbig_aft"

/obj/effect/map_effect/marker/airlock/lonerbig/aftstarboard
	name = "Aft, Starboard Large"
	master_tag = "airlock_lonerbig_aftstarboard"

/obj/effect/map_effect/marker/airlock/lonerbig/aftport
	name = "Aft, Port Large"
	master_tag = "airlock_lonerbig_aftport"

/obj/effect/map_effect/marker/airlock/lonerbig/starboard
	name = "Starboard, Small"
	master_tag = "airlock_lonerbig_starboard"

/obj/effect/map_effect/marker/airlock/lonerbig/starboardlarge
	name = "Starboard, Large"
	master_tag = "airlock_lonerbig_starboardlarge"

/obj/effect/map_effect/marker/airlock/lonerbig/port
	name = "Port, Small"
	master_tag = "airlock_lonerbig_port"

