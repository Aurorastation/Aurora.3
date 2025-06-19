/datum/map_template/ruin/away_site/phoron_deposit
	name = "phoron deposit"
	description = "An asteroid with a phoron deposit."

	prefix = "away_site/phoron_deposit/"
	suffix = "phoron_deposit.dmm"

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_VALLEY_HALE, SECTOR_TABITI)
	spawn_weight = 1
	spawn_cost = 2
	id = "deposit"
	unit_test_groups = list(3)

/singleton/submap_archetype/deposit
	map = "phoron deposit"
	descriptor = "An asteroid with a phoron deposit."

/obj/effect/overmap/visitable/sector/deposit
	name = "phoron deposit"
	desc = "Sensors have detected a rare high yield subsurface phoron deposit within a canyon on this asteroid. Additional scanning of the area reveals that there's a large underground cavern system surrounding it, with a plethora of lifesigns within, likely being aggressive fauna. Expeditionary personnel are advised to fortify the area before commencing drilling, as the process may attract intense hostile attention from the caverns."
	icon_state = "object"
	in_space = FALSE

/area/phoron_deposit_shuttle
	name = "Einstein Engines Shuttle"
	icon_state = "yellow"
