//
// Sol Facility Areas
//

// Sol Facility
/area/sol_facility // Parent area.
	name = "Facility (PARENT AREA - DON'T USE)" // Name intentionally kept vague as to not spoil its origin in APC and air alarm names.
	icon = 'maps/away/away_site/sol_facility/icons/areas.dmi'
	flags = RAD_SHIELDED
	sound_env = LARGE_ENCLOSED
	ambience = list(AMBIENCE_FOREBODING, AMBIENCE_HIGHSEC)
	turf_initializer = new /datum/turf_initializer/sol_facility()

// General
/area/sol_facility/general
	name = "Facility - General"
	icon_state = "general"

// General Hallway
/area/sol_facility/hallway
	name = "Facility - Hallway"
	icon_state = "hallway"

// Solars
/area/sol_facility/solar_panel_array // Parent area.
	name = "Facility - Solar Panel Array (PARENT AREA - DON'T USE)"
	always_unpowered = TRUE
	ambience = AMBIENCE_SPACE

/area/sol_facility/solar_panel_array/west
	name = "Facility - West Solar Panel Array"

/area/sol_facility/solar_panel_array/east
	name = "Facility - East Solar Panel Array"

// Arrivals Hangar
/area/sol_facility/arrivals_hangar
	name = "Facility - Arrivals Hangar"
	icon_state = "hangar"

// Arrivals Lounge
/area/sol_facility/arrivals_lounge
	name = "Facility - Arrivals Lounge"
	icon_state = "hangar"

// Arrivals Security Checkpoint
/area/sol_facility/arrivals_checkpoint
	name = "Facility - Arrivals Security Checkpoint"
	icon_state = "checkpoint"

// Turrets
/area/sol_facility/turrets
	name = "Facility - Turrets"
	icon_state = "turrets"
	requires_power = FALSE // The turrets never rest.

// Medical
/area/sol_facility/medical
	name = "Facility - Medical"

// Cargo
/area/sol_facility/cargo
	name = "Facility - Cargo"

// Custodial
/area/sol_facility/custodial
	name = "Facility - Custodial"

// Mess Hall
/area/sol_facility/mess_hall
	name = "Facility - Mess Hall"

// Engineering
/area/sol_facility/engineering
	name = "Facility - Engineering"

// Atmospherics
/area/sol_facility/atmospherics
	name = "Facility - Atmospherics"

// Security
/area/sol_facility/security
	name = "Facility - Security"

// Research
/area/sol_facility/research
	name = "Facility - Research Division"

// High Security Research
/area/sol_facility/research/high_security
	name = "Facility - High Security Research"