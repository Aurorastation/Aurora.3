/datum/map_template/ruin/away_site/deathbox
	name = "Unmarked Ship"
	description = "A mighty solarian battlecruiser."
	suffixes = list("ships/deathbox/deathbox.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ, SECTOR_WEEPING_STARS)
	spawn_weight = 1
	spawn_cost = 1
	id = "deathbox"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/deathbox
	map = "Unmarked Ship"
	descriptor = "An unmarked ship."

//areas
/area/ship/deathbox
	name = "Unmarked Ship"
	dynamic_lighting = 0
	luminosity = 1

/area/ship/deathbox/one
	name = "Unmarked Ship Second Gun"
	icon_state = "teleporter"

/area/ship/deathbox/two
	name = "Unmarked Ship Third Gun"
	icon_state = "cafeteria"

//ship stuff

/obj/effect/overmap/visitable/ship/deathbox
	name = "Unmarked Ship"
	class = "ICV"
	desc = "An unmarked ship."
	icon_state = "line_cruiser"
	moving_state = "line_cruiser_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_LARGE
	designation = "The Wolf"
