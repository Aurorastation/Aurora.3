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

/area/crevus/restaurant/lobby
	name = "Restaurant - Lobby"

/area/crevus/restaurant/kitchen
	name = "Restaurant - Kitchen"

/area/crevus/restaurant/azaula_enforcers
	name = "Azaula Entertainment Enforcement Office"

// ---------- Transit Centre
/area/crevus/transit_centre
	name = "Transit Centre"

// ---------- Clothing Store
/area/crevus/clothing_store
	name = "Clothing Store"

/area/crevus/clothing_store/basement
	name = "Clothing Store - Basement"

// ---------- General Store

/area/crevus/general_store
	name = "General Store"

/area/crevus/general_store/storage
	name = "General Store - Storage"

/area/turbolift/crevus/general_store
	name = "General Store - Lift"
	station_area = FALSE

// ---------- The Lock

/area/crevus/the_lock
	name = "Sewers" // it's not "The Lock" incase a GPS makes its way here
	lights_start_intact = TRUE

/area/crevus/the_lock/restroom

/area/crevus/the_lock/backroom
