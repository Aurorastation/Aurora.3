/// OPERATIONS_AREAS
/area/horizon/operations
	name = "Ops (PARENT AREA - DON'T USE)"
	icon_state = "dark"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS
	department = LOC_OPERATIONS
	area_blurb = "The halls of Operations ever resound with the clamor of pallets and materiel and rustling paper."

/area/horizon/operations/warehouse
	name = "Warehouse"
	icon_state = "dark160"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_blurb = "Scuff marks scar the floor from the movement of many crates and stored goods."
	area_blurb_category = "ops_warehouse"
	horizon_deck = 1

/area/horizon/operations/package_conveyors
	name = "Package Conveyors"
	icon_state = "dark128"
	horizon_deck = 1

/area/horizon/operations/lobby
	name = "Lobby"
	horizon_deck = 2

/area/horizon/operations/loading
	name = "Loading Bay"
	icon_state = "quartloading"
	horizon_deck = 1

/area/horizon/operations/break_room
	name = "Break Room"
	icon_state = "blue"
	horizon_deck = 2

/area/horizon/operations/office
	name = "Office"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	horizon_deck = 2

/area/horizon/operations/office_aux
	name = "Auxiliary Office"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	horizon_deck = 3

/area/horizon/operations/mail_room
	name = "Mail Room"
	icon_state = "red"
	horizon_deck = 2

/area/horizon/operations/commissary
	name = "Commissary"
	horizon_deck = 2
	area_blurb = "Even here, all the way out into the depths of space, retail work is found. The commissary room is eerily bare when not run— with empty shelves being such a rarity in the 25th century for most worlds, seeing them here is almost unnatural. Where are your treats?"

/area/horizon/operations/secure_ammunition_storage
	name = "Secure Ammunitions Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_FOREBODING
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS
	horizon_deck = 2
	area_blurb = "Armor-piercing, bunker-busting, high-explosive... Don't sneeze!"

/// OPERATIONS_AREAS - HANGAR_AREAS
/area/horizon/hangar
	name = "Hangar (PARENT AREA - DON'T USE)"
	icon_state = "bluenew"
	ambience = AMBIENCE_HANGAR
	sound_environment = SOUND_ENVIRONMENT_HANGAR
	holomap_color = HOLOMAP_AREACOLOR_HANGAR
	horizon_deck = 1
	department = LOC_HANGAR

/area/horizon/hangar/airstation
	name = "Hangar Air Station"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS)
	area_blurb = "A small area of the hangar serving the shuttles with fresh air and \
	giving the access to dispose of any bad air the shuttles brought back during their expeditions."

/area/horizon/hangar/control
	name = "Hangar Control Room"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/hangar/intrepid
	name = "Primary Hangar"
	area_blurb = "A big, open room, home to the SCCV Horizon's largest shuttle, the Intrepid."
	area_blurb_category = "hanger"

/area/horizon/hangar/intrepid/interstitial
	name = "Intrepid Hangar Access"

/area/horizon/hangar/operations
	name = "Starboard Auxiliary Hangar"
	area_blurb = "A big, open room, home to the SCCV Horizon's mining shuttle, the Spark."
	area_blurb_category = "hanger"

/area/horizon/hangar/auxiliary
	name = "Port Auxiliary Hangar"
	area_blurb = "A big, open room, home to two of the SCCV Horizon's shuttles, the Quark and the Canary."
	area_blurb_category = "hanger"

/// OPERATIONS_AREAS - MACHINIST_AREAS
/area/horizon/operations/machinist
	name = "Machinist Workshop"
	icon_state = "machinist_workshop"
	area_blurb = "The scents of oil and mechanical lubricants fill the air in this workshop."
	area_blurb_category = "robotics"
	subdepartment = SUBLOC_MACHINING
	horizon_deck = 2

/area/horizon/operations/machinist/surgicalbay
	name = "Machinist Surgical Bay"
	icon_state = "machinist_workshop"
	area_blurb = "Back in the workshop's surgical bay, the sharp-edged odor of sterilized equipment predominates."
	area_blurb_category = "robotics"
	horizon_deck = 2

/// OPERATIONS_AREAS - MINING_AREAS
/area/horizon/operations/mining_main
	name = "Mining (PARENT AREA - DON'T USE)"
	icon_state = "outpost_mine_main"
	ambience = AMBIENCE_EXPOUTPOST
	subdepartment = SUBLOC_MINING
	area_blurb = "Even louder and noisier and rowdier than the rest of Operations, which is really saying something."

/area/horizon/operations/mining_main/eva
	name = "Mining EVA Storage"
	horizon_deck = 1

/area/horizon/operations/mining_main/refinery
	name = "Mining Refinery"
	horizon_deck = 1

/// WEAPONS_AREAS
/area/horizon/weapons/longbow
	name = "Longbow Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	horizon_deck = 3
	area_blurb = "One of the SCCV Horizon's daunting weapons bays."
	department = LOC_COMMAND

/area/horizon/weapons/grauwolf
	name = "Grauwolf Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	horizon_deck = 2
	area_blurb = "One of the SCCV Horizon's daunting weapons bays."
	department = LOC_COMMAND

/// STORAGE_AREAS
/area/horizon/storage
	name = "Storage (PARENT AREA - DON'T USE)"
	department = LOC_CREW

/area/horizon/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"
	horizon_deck = 2
	area_blurb = "A compartment for keeping the various things useful on any ship."

/area/horizon/storage/eva
	name = "EVA Storage"
	icon_state = "eva"
	horizon_deck = 1
	area_blurb = "Row after row of various types of void suits and the ancillary equipment for their use reside here, carefully checked and double-checked before each excursion."

/// Science-restricted section of EVA.
/area/horizon/storage/eva/expedition
	name = "Expedition EVA Storage"
	icon_state = "eva"
	horizon_deck = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	department = LOC_SCIENCE

/// THE VAAAAAAUULLT
/area/horizon/storage/secure
	name = "Secure Storage"
	icon_state = "storage"
	horizon_deck = 2
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	department = LOC_COMMAND
	area_blurb = "A place not to be visited unless things are going either horribly wrong or horribly right."
