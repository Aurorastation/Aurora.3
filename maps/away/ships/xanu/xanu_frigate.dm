/datum/map_template/ruin/away_site/xanu_frigate
	name = "Xanu Spacefleet Frigate"
	description = "The Shrike-class frigate is a formidable warship in use by the All-Xanu Spacefleet and forms a ubiquitous part of its naval force. \
	Despite it making up a large portion of the planet's navy, no expense was spared in engineering this warship, with thick hull plating and redundant\
	power, engines, and life support systems making this craft notoriously survivable even when taking massive blows, leaving it intact enough \
	to return the favor in a gunfight."
	suffixes = list("ships/xanu/xanu_frigate.dmm")
	sectors = list(ALL_COALITION_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "xanu_frigate"
	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/xanu_frigate
	map = "Xanu Spacefleet Frigate"
	descriptor = "The Shrike-class frigate is a formidable warship in use by the All-Xanu Spacefleet and forms a ubiquitous part of its naval force. \
	Despite it making up a large portion of the planet's navy, no expense was spared in engineering this warship, with thick hull plating and redundant\
	power, engines, and life support systems making this craft notoriously survivable even when taking massive blows, leaving it intact enough \
	to return the favor in a gunfight."

// ship

/obj/effect/overmap/visitable/ship/xanu_frigate
	name = "Xanu Spacefleet Frigate"
	class = "AXSV"
	desc = "The Shrike-class frigate is a formidable warship in use by the All-Xanu Spacefleet and forms a ubiquitous part of its naval force. \
	Despite it making up a large portion of the planet's navy, no expense was spared in engineering this warship, with thick hull plating and redundant\
	power, engines, and life support systems making this craft notoriously survivable even when taking massive blows, leaving it intact enough \
	to return the favor in a gunfight."
	icon_state = "sanctuary"
	moving_state = "sanctuary_moving"
	colors = "#899997"
	designer = "dNA Defense & Aerospace"
	volume = "108 meters length, 71 meters beam/width, 35 meters vertical height"
	drive = "Einstein Engines Type-33A Military FTL Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Dual extruding fore caliber ballistic armaments, aft obscured flight craft bay"
	sizeclass = "Shrike-class Frigate"
	shiptype = "Military frigate"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 6000
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = FALSE

/obj/effect/overmap/visitable/ship/xanu_frigate/New()
	designation = "[pick("Sterrenlicht", "Riviere", "Vandenberg", "Sterkarm", "Fontaine", "Souverain", "Zilverberg", "Vanhoorn", "Lefebure", "Eclairant", "Liberte", "Huyghe", "Dubois", "Montclair")]"
	..()
