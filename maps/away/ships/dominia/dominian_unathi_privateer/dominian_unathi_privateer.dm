/datum/map_template/ruin/away_site/dominian_unathi
	name = "Kazhkz Privateer Ship"
	description = "Dominian Unathi pirates"
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_unathi"
	shuttles_to_initialise = list()

/singleton/submap_archetype/dominian_unathi
	map = "Kazhkz Privateer Ship"
	descriptor = "Dominian Unathi pirates"

/obj/effect/overmap/visitable/ship/dominian_unathi
	name = "Kazhkz Privateer Ship"
	class = "ICV"
	desc = "woah dude, lizards"
	icon_state = ""
	moving_state = ""
	colors = list("#e67f09", "#fcf9f5")