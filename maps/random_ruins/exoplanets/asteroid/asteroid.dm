/datum/map_template/ruin/exoplanet/abandoned_mining
	name = "Abandoned Mining Site"
	id = "miningsite"
	description = "An abandoned mining site. Some tools and materials were left behind."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/mining_base/mining_base.dmm")

	ruin_tags = RUIN_HUMAN|RUIN_VOID

/datum/map_template/ruin/exoplanet/carp_nest
	name = "Carp Nest"
	id = "carp_nest"
	description = "A nest of deadly space carps."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/carp_nest/carp_nest.dmm")

	ruin_tags = RUIN_ALIEN|RUIN_VOID

/datum/map_template/ruin/exoplanet/hideout
	name = "Abandoned Hideout"
	id = "hideout"
	description = "An abandoned hideout, seemingly once belonging to a marooned crew."

	spawn_weight = 0.5
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/hideout/hideout.dmm")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_shuttle_01
	name = "Crashed Shuttle"
	id = "crashedshuttle01"
	description = "A crashed shuttle, with some gear left behind."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/crashed_shuttle/crashed_shuttle_01.dmm")

	ruin_tags = RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01
	name = "Crashed Solarian Shuttle"
	id = "crashed_sol_shuttle_1"
	description = "A crashed sol shuttle, with some gear left behind."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS
	
	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/sol_ship/sol_ship_unique")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01
	name = "Crashed Skrellian Shuttle"
	id = "crashed_skrell_shuttle_1"
	description = "A crashed skrell shuttle, with some gear left behind."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/skrell_ship/skrell_crash_unique")

	ruin_tags = RUIN_WRECK|RUIN_VOID|RUIN_ALIEN

/datum/map_template/ruin/exoplanet/mystery_ship_1
	name = "Mystery Ship"
	id = "mystery_ship_1"
	description = "An unmarked shuttle in almost pristine condition. The occupants are nowhere to be found."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/mystery_ship/mystery_ship_unique")

	ruin_tags = RUIN_HUMAN|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_satelite
	name = "Crashed Satelite"
	id = "crashed_satelite"
	description = "A crashed satelite."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA)
	suffixes = list("asteroid/satelite_crash/satelite_crash_unique")

	ruin_tags = RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/abandoned_listening_post
	name = "Abandoned Listening Post"
	id = "abandoned_listening_post"
	description = "An abandoned listening post."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/listening_post/listening_post_unique")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_escape_pod_1
	name = "Crashed Escape Pod"
	id = "crashed_escape_pod_1"
	description = "A crashed escape pod."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ)
	suffixes = list("asteroid/escape_pod/escape_pod_unique")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/digsite
	name = "Digsite"
	id = "digsite"
	description = "A research digsite."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS
	
	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ)
	suffixes = list("asteroid/digsite/digsite_unique")

	ruin_tags = RUIN_HUMAN

/datum/map_template/ruin/exoplanet/crashed_pod
	name = "Crashed Pod"
	id = "crashed_pod"
	description = "A crashed pod."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ)
	suffixes = list("asteroid/crashed_pod/crashed_pod_unique")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_coc_skipjack
	name = "Crashed Coalition Skipjack"
	id = "crashed_coc_skipjack"
	description = "A crashed Coalition skipjack, with some gear left behind."
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/coc_ship/coc_ship_unique")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID