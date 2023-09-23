/datum/map_template/ruin/away_site/harmony
	name = "Harmony"
	description = "NanoTrasen designed and operated combat-carrier. It dwarfs any other ship in the area..."
	suffixes = list("ships/carrier/harmony.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ, SECTOR_WEEPING_STARS)
	spawn_weight = 1
	spawn_cost = 1
	id = "harmony"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/harmony
	map = "NDV Harmony"
	descriptor = "NanoTrasen designed and operated combat-carrier. It dwarfs any other ship in the area..."

//areas
/area/ship/harmony
	name = "Harmony"
	dynamic_lighting = 0
	luminosity = 1

/area/ship/harmony/bridge
	name = "Harmony Bridge"
	icon_state = "bridge"

/area/ship/harmony/longbow
	name = "Unmarked Ship Third Gun"
	icon_state = "blueold"

/area/ship/harmony/grauwolf
	name = "Harmony Grauwolf"
	icon_state = "bluenew"

/area/ship/harmony/frankie
	name = "Harmony Franscisca"
	icon_state = "purple"

//ship stuff

/obj/effect/overmap/visitable/ship/harmony
	name = "Harmony"
	class = "NDV"
	desc = "The NDV Harmony is an Icarus Class warship, belonging to the NanoTrasen megacorporation."
	icon = 'icons/obj/overmap/overmap_48x48.dmi'
	icon_state = "carrier"
	moving_state = "carrier_moving"
	drive = "High Speed Bluespace Acceleration FTL Drive"
	shiptype = "NanoTrasen designed and operated combat-carrier. It dwarfs any other ship in the area..."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 100000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_LARGE
	designation = "Harmony"
