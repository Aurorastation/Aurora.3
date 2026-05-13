// ---- Base area
/area/abandoned_casino
	name = "Casino Station (base)"
	icon = 'maps/away/away_site/abandoned_casino/casino_sprites.dmi'

// ---- Exterior
/area/abandoned_casino/exterior
	name = "Casino Station - Exterior"
	icon = 'icons/turf/areas.dmi'
	icon_state = "exterior"
	needs_starlight = TRUE
	area_flags = null

// ---- Docking arms
/area/abandoned_casino/docking_arm
	icon_state = "docks"

/area/abandoned_casino/docking_arm/starboard
	name = "Starboard Docking Arm"

/area/abandoned_casino/docking_arm/center
	name = "Docking Arm Hallway"

/area/abandoned_casino/docking_arm/port
	name = "Port Docking Arm"

// ---- Maintenance
/area/abandoned_casino/maintenance
	icon_state = "maint"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/abandoned_casino/maintenance/security_checkpoint
	name = "Security Checkpoint - Maintenance"

/area/abandoned_casino/maintenance/kitchen
	name = "Kitchen - Maintenance"

/area/abandoned_casino/maintenance/solar_wing
	name = "Solar Panel Maintenance"

/area/abandoned_casino/maintenance/starboard
	name = "Starboard Maintenance"

/area/abandoned_casino/maintenance/port
	name = "Port Maintenance"

/area/abandoned_casino/maintenance/reception
	name = "Reception - Maintenance"

// ---- Casino interior
/area/abandoned_casino/security_checkpoint
	name = "Security Checkpoint"
	icon_state = "staff"

/area/abandoned_casino/reception
	name = "Casino Reception"
	icon_state = "reception"

/area/abandoned_casino/casino
	name = "Casino"
	icon_state = "casino"

/area/abandoned_casino/restaurant
	name = "Restaurant"
	icon_state = "restaurant"

/area/abandoned_casino/bar
	name = "Bar"
	icon_state = "bar"

/area/abandoned_casino/bar/kitchen
	name = "Kitchen"

/area/abandoned_casino/bar/kitchen/freezer
	name = "Kitchen Freezer"

/area/abandoned_casino/restroom
	name = "Restroom"
	icon_state = "maint"

/area/abandoned_casino/vip_room_one
	name = "V.I.P. Room #1"
	icon_state = "vip"

/area/abandoned_casino/vip_room_two
	name = "V.I.P. Room #2"
	icon_state = "vip"

/area/abandoned_casino/the_bank
	name = "The Bank"
	icon_state = "the_bank"

/area/abandoned_casino/the_bank/office
	name = "The Bank - Office"

/area/abandoned_casino/the_bank/vault
	name = "Secure Vault"
	area_flags = AREA_FLAG_RAD_SHIELDED

// ---- Staff areas
/area/abandoned_casino/staff
	icon_state = "staff"

/area/abandoned_casino/staff/warehouse
	name = "Warehouse"

/area/abandoned_casino/staff/breakroom
	name = "Breakroom"

/area/abandoned_casino/staff/hangar_passage
	name = "Hangar Passage"

/area/abandoned_casino/staff/operator_room
	name = "Operator Room"



