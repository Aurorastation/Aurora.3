/datum/map_template/ruin/away_site/stranded
	name = "grove planet with escape pods"
	description = "Automated emergency distress signals are being emitted from this grove planet. They appear to be coming from two escape pods currently landed there."
	suffix = "away_site/stranded/stranded.dmm"
	sectors = list(SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 1
	spawn_cost = 2
	id = "stranded"

/decl/submap_archetype/stranded
	map = "grove planet with escape pods"
	descriptor = "Automated emergency distress signals are being emitted from this grove planet. They appear to be coming from two escape pods currently landed there."

/obj/effect/overmap/visitable/sector/stranded
	name = "grove planet with escape pods"
	desc = "Automated emergency distress signals are being emitted from this grove planet. They appear to be coming from two escape pods currently landed there."


/area/stranded
	name="survivor planet"
	icon_state = "outpost_mine_main"
	requires_power = FALSE
