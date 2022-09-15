
// ---------------- main stuff
/datum/map_template/ruin/away_site/crashed_elyran_tanker
	name = "crashed elyran tanker"
	description = "desc 1"
	suffix = "generic/crashed_elyran_tanker/crashed_elyran_tanker.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 100000
	spawn_cost = 1
	id = "crashed_elyran_tanker"
    // A medium-size tanker, emitting a very faint IFF signal of civilian vessels registered in Elyra. It seems to be partially embedded into an asteroid, and completely cold.

/decl/submap_archetype/crashed_elyran_tanker
	map = "crashed_elyran_tanker"
	descriptor = "desc 2"

/obj/effect/overmap/visitable/crashed_elyran_tanker
	name = "crashed elyran tanker"
	desc = "desc 3"

// ---------------- areas
/area/crashed_elyran_tanker/bridge
	name = "bridge"
	icon_state = "bridge"

/area/crashed_elyran_tanker/crew
	name = "crew area"
	icon_state = "crew_area"

/area/crashed_elyran_tanker/engineering
	name = "engineering"
	icon_state = "engineering"

/area/crashed_elyran_tanker/thruster
	name = "thruster maintenance"
	icon_state = "engine"

/area/crashed_elyran_tanker/tanks
	name = "tanks"
	icon_state = "atmos"
