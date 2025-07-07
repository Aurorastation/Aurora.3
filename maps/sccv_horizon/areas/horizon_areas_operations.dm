/// OPERATIONS_AREAS
/area/horizon/operations
	name = "Operations"
	icon_state = "dark"
	ambience = AMBIENCE_ENGINEERING
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/horizon/operations/lower
	name = "Lower Operations"
	icon_state = "dark160"

/area/horizon/operations/upper
	name = "Upper Operations"
	icon_state = "dark128"

/area/horizon/operations/storage
	name = "Operations Equipment Storage"
	icon_state = "dark160"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_blurb = "Scuff marks scar the floor from the movement of many crates and stored goods."
	area_blurb_category = "ops_warehouse"

/area/horizon/operations/lobby
	name = "Operations Lobby"

/area/horizon/operations/loading
	name = "Operations Bay"
	icon_state = "quartloading"

/area/horizon/operations/break_room
	name = "Operations Break Room"
	icon_state = "blue"

/area/horizon/operations/office
	name = "Operations Office"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/horizon/operations/office_aux
	name = "Operations Office (Aux)"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/horizon/operations/mail_room
	name = "Operations Mail Room"
	icon_state = "red"

/area/horizon/operations/commissary
	name = "Horizon - Commissary"

/area/horizon/operations/secure_ammunition_storage
	name = "Horizon - Secure Ammunitions Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_FOREBODING
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/// OPERATIONS_AREAS - HANGAR_AREAS
/area/horizon/hangar
	name = "Hangar"
	icon_state = "bluenew"
	ambience = AMBIENCE_HANGAR
	sound_environment = SOUND_ENVIRONMENT_HANGAR
	holomap_color = HOLOMAP_AREACOLOR_HANGAR

/area/horizon/hangar/briefing
	name = "Expedition Briefing Room"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/horizon/hangar/control
	name = "Hangar Control Room"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/hangar/intrepid
	name = "Intrepid Hangar"
	area_blurb = "A big, open room, home to the SCCV Horizon's largest shuttle, the Intrepid."
	area_blurb_category = "intrepid_hanger"

/area/horizon/hangar/intrepid/interstitial
	name = "Intrepid Hangar Access"

/area/horizon/hangar/operations
	name = "Operations Hangar"

/area/horizon/hangar/auxiliary
	name = "Auxiliary Hangar"

/// OPERATIONS_AREAS - MACHINIST_AREAS
/area/horizon/operations/lower/machinist
	name = "Machinist Workshop"
	icon_state = "machinist_workshop"
	area_blurb = "The scents of oil and mechanical lubricants fill the air in this workshop."
	area_blurb_category = "robotics"

/area/horizon/operations/lower/machinist/surgicalbay
	name = "Machinist Surgical Bay"
	icon_state = "machinist_workshop"
	area_blurb = "The scent of sterilized equipment fill the air in this surgical bay."
	area_blurb_category = "robotics"

/// OPERATIONS_AREAS - MINING_AREAS
/area/horizon/operations/mining_main
	ambience = AMBIENCE_EXPOUTPOST

/area/horizon/operations/mining_main
	icon_state = "outpost_mine_main"
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/horizon/operations/mining_main/eva
	name = "Mining EVA storage"

/area/horizon/operations/mining_main/refinery
	name = "Mining Refinery"

/// WEAPONS_AREAS
/area/horizon/weapons/longbow
	name = "Horizon - Longbow Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/weapons/grauwolf
	name = "Horizon - Grauwolf Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/// STORAGE_AREAS
/area/horizon/storage
	station_area = TRUE

/// STORAGE_AREAS
/area/horizon/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/horizon/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/horizon/storage/secure
	name = "Secure Storage"
	icon_state = "storage"
