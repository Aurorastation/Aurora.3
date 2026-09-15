// ---------- Base Type

/area/crevus
	name = "Nikal Sahira - Base Type"
	requires_power = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	base_turf = /turf/simulated/floor/exoplanet/mineral/cave/adhomai

/area/crevus/out_of_bounds
	name = "Nikal Sahira"
	icon_state = "blue"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

/area/crevus/outside
	name = "Nikal Sahira - Streets"
	icon_state = "dark128"
	is_outside = OUTSIDE_YES
	sound_environment = SOUND_ENVIRONMENT_CITY
	ambience = AMBIENCE_KONYANG_TRAFFIC

/area/crevus/inside
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

// ---------- Restaurant

/area/crevus/inside/restaurant
	name = "Nikal'n Marr Diner - Base Type"

/area/crevus/inside/restaurant/table_area
	name = "Nikal'n Marr Diner - Tabling Area"
	starts_with_nightmode = TRUE // for ambiance
	lights_start_intact = TRUE

/area/crevus/inside/restaurant/balcony_1
	name = "Nikal'n Marr Diner - Balcony"
	is_outside = OUTSIDE_YES

/area/crevus/inside/restaurant/balcony_2
	name = "Nikal'n Marr Diner - Balcony"
	is_outside = OUTSIDE_YES

/area/crevus/inside/restaurant/private_dining_room
	name = "Nikal'n Marr Diner - Private Dining Room"

/area/crevus/inside/restaurant/lobby
	name = "Nikal'n Marr Diner - Lobby"

/area/crevus/inside/restaurant/kitchen
	name = "Nikal'n Marr Diner - Kitchen"

/area/crevus/inside/restaurant/azaula_enforcers
	name = "Azaula Entertainment Enforcement Office"

/area/crevus/inside/restaurant/floor_1/north
	name = "Nikal'n Marr Diner - Floor 1"

/area/crevus/inside/restaurant/floor_1/south
	name = "Nikal'n Marr Diner - Floor 1"

// ---------- Transit Centre

/area/crevus/inside/transit_centre
	name = "Transit Centre"

// ---------- Clothing Store

/area/crevus/inside/clothing_store
	name = "Clothing Store"

/area/crevus/inside/clothing_store/basement
	name = "Clothing Store - Basement"

// ---------- General Store

/area/crevus/inside/general_store
	name = "General Store"

/area/crevus/inside/general_store/storage
	name = "General Store - Storage"

/area/turbolift/crevus/inside/general_store
	name = "General Store - Lift"
	station_area = FALSE

// ---------- Artisan Shop

/area/crevus/inside/artisan_shop
	name = "Artisan Shop"

/area/crevus/inside/artisan_shop/basement
	name = "Artisan Shop - Basement"

// ---------- Firearm Store

/area/crevus/inside/firearm_store
	name = "Firearm Store"

/area/crevus/inside/firearm_store/basement
	name = "Firearm Store - Basement"

// ---------- NanoTrasen Pharmacy

/area/crevus/inside/nt_pharmacy
	name = "NanoTrasen Pharmacy"

/area/crevus/inside/nt_pharmacy/basement
	name = "NanoTrasen Pharmacy - Basement"

// ---------- Power Room

/area/crevus/inside/power_room
	name = "Power Room"

// ---------- Commercial Complex

/area/crevus/inside/commercial_complex/subway_floor
	name = "Commercial Complex - Subway Floor"

/area/crevus/inside/commercial_complex/floor_1
	name = "Commercial Complex - Floor 1"

/area/crevus/inside/commercial_complex/floor_2
	name = "Commercial Complex - Floor 2"

/area/crevus/inside/commercial_complex/library
	name = "Commercial Complex - Library"

/area/crevus/inside/commercial_complex/rhan_cresh_office
	name = "Commercial Complex - Rhan-Cresh Charities' Highway Patrol Office"

// ---------- Casino

/area/crevus/inside/casino
	name = "Keltra Zav Nikal"

/area/crevus/inside/casino/basement
	name = "Keltra Zav Nikal - Basement"

// ---------- Automobile Gallery

/area/crevus/inside/auto_gallery
	name = "Automobile Gallery"

// ---------- Sewers

/area/crevus/inside/sewers
	name = "Sewers"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	sound_environment = SOUND_ENVIRONMENT_STONE_CORRIDOR

// ---------- The Lock

/area/crevus/inside/the_lock
	name = "Sewers" // it's not "The Lock" incase a GPS makes its way here
	lights_start_intact = TRUE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/crevus/inside/the_lock/restroom

/area/crevus/inside/the_lock/backroom
