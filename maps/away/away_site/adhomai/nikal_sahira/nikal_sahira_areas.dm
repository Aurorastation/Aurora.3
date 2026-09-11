// ---------- Base Type

/area/crevus
	name = "Nikal Sahira - Base Type"
	requires_power = FALSE

/area/crevus/outside
	name = "Nikal Sahira - Streets"
	is_outside = OUTSIDE_YES

// ---------- Restaurant

/area/crevus/restaurant
	name = "Restaurant - Base Type"

/area/crevus/restaurant/table_area
	name = "Restaurant - Tabling Area"
	starts_with_nightmode = TRUE // for ambiance
	lights_start_intact = TRUE

/area/crevus/restaurant/balcony_1
	name = "Restaurant - Balcony"
	is_outside = OUTSIDE_YES

/area/crevus/restaurant/balcony_2
	name = "Restaurant - Balcony"
	is_outside = OUTSIDE_YES

/area/crevus/restaurant/private_dining_room
	name = "Restaurant - Private Dining Room"

// ---------- General Store

/area/crevus/general_store
	name = "General Store"

/area/crevus/general_store/storage
	name = "General Store - Storage"

/area/turbolift/crevus/general_store
	name = "General Store - Lift"
	station_area = FALSE

// ---------- Landing Zone Lift
/area/turbolift/crevus/lz
	name = "Landing Zone - Lift"
	station_area = FALSE
