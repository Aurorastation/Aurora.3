//landing site navpoints

/obj/effect/shuttle_landmark/groveworld
	name = "Landing Site"
	landmark_tag = "groveworld"

/obj/effect/shuttle_landmark/groveworld/clearing
	name = "Small Clearing"
	landmark_tag = "clearing2"

/obj/effect/shuttle_landmark/groveworld/bigclearing
	name = "Large Clearing"
	landmark_tag = "large_clearing"


/obj/effect/shuttle_landmark/groveworld/homestead_clearing
	name = "Homestead Landing Site"
	landmark_tag = "homestead"




//ruins :)


/datum/map_template/ruin/exoplanet/grovecave1
	name = "Cave"
	id = "grovecave1"
	description = "A cave with something living inside."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovecave1.dmm"

	ruin_tags = RUIN_WATER|RUIN_NATURAL

/datum/map_template/ruin/exoplanet/grovecave2
	name = "Cave"
	id = "grovecave2"
	description = "A cave with something volatile inside."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovecave1.dmm"

	ruin_tags = RUIN_WATER|RUIN_NATURAL



/datum/map_template/ruin/exoplanet/grovecave3
	name = "Cave"
	id = "grovecave3"
	description = "A cave with something living inside."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovecave3.dmm"

	ruin_tags = RUIN_WATER|RUIN_NATURAL



/datum/map_template/ruin/exoplanet/groveexcavation1
	name = "Worm Pit Crash"
	id = "groveexcavation1"
	description = "A quicksand pit with something living beneath."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/groveexcavation1.dmm"

	ruin_tags = RUIN_ALIEN|RUIN_WRECK


/datum/map_template/ruin/exoplanet/grovefield
	name = "Crashed Terraforming Pods"
	id = "grovefield"
	description = "Elyran terraforming pods have begun seeding this world for human life."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovefield.dmm"

	ruin_tags = RUIN_HUMAN|RUIN_WRECK


/datum/map_template/ruin/exoplanet/grovegrave1
	name = "Lone Tree"
	id = "grovegrave1"
	description = "The remnant of someone previous."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovegrave1.dmm"

	ruin_tags = RUIN_HUMAN


/datum/map_template/ruin/exoplanet/grovehome1_unique
	name = "Homestead"
	id = "grovehome1_unique"
	description = "A homestead with some farmland."

	spawn_weight = 9999
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovehome1_unique.dmm"

	ruin_tags = RUIN_HUMAN|RUIN_HABITAT


/datum/map_template/ruin/exoplanet/grovehome2_unique
	name = "Homestead"
	id = "grovehome2_unique"
	description = "A homestead with a garden and landing pad."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovehome2_unique.dmm"

	ruin_tags = RUIN_HUMAN|RUIN_HABITAT



/datum/map_template/ruin/exoplanet/groveinfestation1_unique
	name = "Mineral Stimulation Dome"
	id = "groveinfestation1_unique"
	description = "A metal dome with some homes nearby."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/groveinfestation1_unique.dmm"

	ruin_tags = RUIN_HUMAN|RUIN_HABITAT


/datum/map_template/ruin/exoplanet/groveinfestation2_unique
	name = "Cave"
	id = "groveinfestation2_unique"
	description = "A cave with something living inside."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/groveinfestation2_unique.dmm"

	ruin_tags = RUIN_HUMAN|RUIN_NATURAL|RUIN_WATER




/datum/map_template/ruin/exoplanet/grovelanding1
	name = "Small Clearing"
	id = "grovelanding1"
	description = "A clearing big enough for a small shuttle to land on, cleared out by someone previously."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovelanding1.dmm"

	ruin_tags = RUIN_HUMAN


/datum/map_template/ruin/exoplanet/grovelanding2
	name = "Large Clearing"
	id = "grovelanding2"
	description = "A clearing big enough for a large shuttle to land on."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovelanding2.dmm"

	ruin_tags = RUIN_NATURAL




/datum/map_template/ruin/exoplanet/groveliidra
	name = "Alien Crash Site"
	id = "groveliidra"
	description = "A crash site of some alien vessel. Local wildlife is being poisoned."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/groveliidra.dmm"

	ruin_tags = RUIN_ALIEN|RUIN_WRECK




/datum/map_template/ruin/exoplanet/grovemeteor1
	name = "Meteorite site"
	id = "grovemeteor1"
	description = "A solid piece of debris that's survived the fall from space."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovemeteor1.dmm"

	ruin_tags = RUIN_NATURAL



/datum/map_template/ruin/exoplanet/grovemeteor2
	name = "Meteorite site"
	id = "grovemeteor2"
	description = "A solid piece of debris that's survived the fall from space. This one has volatile materials surrounding it."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	suffix = "groveworld/grovemeteor2.dmm"

	ruin_tags = RUIN_NATURAL

