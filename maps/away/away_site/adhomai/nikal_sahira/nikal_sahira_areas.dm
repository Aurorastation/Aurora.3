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
	name = "Nikal Sahira Inside - Base Type"

// ---------- Restaurant

/area/crevus/inside/restaurant
	name = "Nikal'n Marr Diner - Base Type"
	icon_state = "purple"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

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
	icon_state = "red"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/crevus/inside/restaurant/floor_1/north
	name = "Nikal'n Marr Diner - Floor 1"

/area/crevus/inside/restaurant/floor_1/south
	name = "Nikal'n Marr Diner - Floor 1"

// ---------- Transit Centre

/area/crevus/inside/transit_centre
	name = "Transit Centre"
	icon_state = "green"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

// ---------- Clothing Store

/area/crevus/inside/clothing_store
	name = "Clothing Store"
	icon_state = "green"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/crevus/inside/clothing_store/basement
	name = "Clothing Store - Basement"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

// ---------- General Store

/area/crevus/inside/general_store
	name = "General Store"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/crevus/inside/general_store/storage
	name = "General Store - Storage"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

/area/turbolift/crevus/inside/general_store
	name = "General Store - Lift"
	station_area = FALSE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

// ---------- Artisan Shop

/area/crevus/inside/artisan_shop
	name = "Artisan Shop"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/crevus/inside/artisan_shop/basement
	name = "Artisan Shop - Basement"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

// ---------- Firearm Store

/area/crevus/inside/firearm_store
	name = "Firearm Store"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/crevus/inside/firearm_store/basement
	name = "Firearm Store - Basement"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

// ---------- NanoTrasen Pharmacy

/area/crevus/inside/nt_pharmacy
	name = "NanoTrasen Pharmacy"
	icon_state = "blue"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/crevus/inside/nt_pharmacy/basement
	name = "NanoTrasen Pharmacy - Basement"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

// ---------- Power Room

/area/crevus/inside/power_room
	name = "Power Room"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

// ---------- Commercial Complex

/area/crevus/inside/commercial_complex
	name = "Commercial Complex - Base Type"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/crevus/inside/commercial_complex/subway_floor
	name = "Commercial Complex - Subway Floor"

/area/crevus/inside/commercial_complex/floor_1
	name = "Commercial Complex - Floor 1"

/area/crevus/inside/commercial_complex/floor_2
	name = "Commercial Complex - Floor 2"

/area/crevus/inside/commercial_complex/library
	name = "Commercial Complex - Library"
	icon_state = "yellow"

/area/crevus/inside/commercial_complex/rhan_cresh_office
	name = "Commercial Complex - Rhan-Cresh Charities' Highway Patrol Office"
	icon_state = "red"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

// ---------- Casino

/area/crevus/inside/casino
	name = "Keltra Zav Nikal"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	icon_state = "jockey"

/area/crevus/inside/casino/basement
	name = "Keltra Zav Nikal - Basement"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH

// ---------- Automobile Gallery

/area/crevus/inside/auto_gallery
	name = "Automobile Gallery"
	icon_state = "dk_yellow"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

// ---------- Public Park

/area/crevus/outside/public_park
	name = "Public Park"
	icon_state = "green"
	sound_environment = SOUND_ENVIRONMENT_FOREST
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

// ---------- Sewers

/area/crevus/inside/sewers
	name = "Sewers"
	icon_state = "dark128"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	sound_environment = SOUND_ENVIRONMENT_SEWER_PIPE

// ---------- The Lock

/area/crevus/inside/the_lock
	name = "Sewers" // it's not "The Lock" incase a GPS makes its way here
	lights_start_intact = TRUE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/crevus/inside/the_lock/restroom

/area/crevus/inside/the_lock/backroom
