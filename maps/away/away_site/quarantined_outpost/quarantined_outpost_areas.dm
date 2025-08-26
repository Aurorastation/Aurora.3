
/area/quarantined_outpost
	name = "base type"
	ambience = list(AMBIENCE_FOREBODING, AMBIENCE_LAVA)

/area/quarantined_outpost/exterior
	name = "Exterior"
	icon_state = "exterior"
	always_unpowered = TRUE

/area/quarantined_outpost/exterior/powered
	requires_power = FALSE
	always_unpowered = FALSE

/area/quarantined_outpost/chasm
	name = "Chasm"
	icon_state = "exterior"
	always_unpowered = TRUE

// South - Entrance

/area/quarantined_outpost/reception
	name = "Reception"
	icon_state = "bluenew"

/area/quarantined_outpost/entrance_lobby
	name = "Entrance Lobby"
	icon_state = "green"

/area/quarantined_outpost/entrance_maintenance
	name = "Entrance Maintenance"
	icon_state = "maintcentral"

// South East - Cargo

/area/quarantined_outpost/cargo_bay
	name = "Cargo Bay"
	icon_state = "quartloading"

// West side - Engineering

/area/quarantined_outpost/engineering
	name = "Engineering"
	icon_state = "engineering"

/area/quarantined_outpost/engineering/tunnel
	name = "Engineering Tunnels"
	icon_state = "green"

/area/quarantined_outpost/engineering/winch_room
	name = "Engineering Winch Room"
	icon_state = "engineering_workshop"

/area/quarantined_outpost/engineering/atmospherics
	name = "Atmospherics"
	icon_state = "atmos"

// North-East side - Medbay/Science

/area/quarantined_outpost/medbay
	name = "Medical Ward"
	icon_state = "medbay3"

/area/quarantined_outpost/research
	name = "Research Laboratory"
	icon_state = "research"

/area/quarantined_outpost/research/containment
	name = "Research Heavy Containment Zone"
	icon_state = "security_sub"

/area/quarantined_outpost/extraction_lab
	name = "Extraction Laboratory"
	icon_state = "purple"

// Center - Cafeteria

/area/quarantined_outpost/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/quarantined_outpost/cafeteria/maintenance
	name = "Cafeteria Maintenance"
	icon_state = "maintenance"

// Hallways

/area/quarantined_outpost/dorm_hallway
	name = "Central Dormitory Hallway"
	icon_state = "hallC"

/area/quarantined_outpost/elevator_hallway
	name = "Residential Lift Hallway"
	icon_state = "hallS"

/area/quarantined_outpost/elevator_hallway/maintenance
	name = "Residential Lift Maintennace"
	icon_state = "maintenance"

/area/quarantined_outpost/north_east_hallway
	name = "North East Hallway"
	icon_state = "dk_yellow"

/area/quarantined_outpost/north_east_hallway/maintenance
	name = "North East Hallway Maintenance"
	icon_state = "maintenance"

// East - Security

/area/quarantined_outpost/security
	name = "Security Wing"
	icon_state = "security"

// Caverns

/area/quarantined_outpost/cavern
	name = "Caverns"
	icon_state = "dark128"
	requires_power = FALSE
	always_unpowered = FALSE

/area/quarantined_outpost/cavern/east_cavern
	name = "East Caverns"

/area/quarantined_outpost/cavern/south_west_cavern
	name = "South West Caverns"

// Misc

/area/quarantined_outpost/auxiliary_power
	name = "Auxiliary Power Storage"
	icon_state = "storage"

/area/quarantined_outpost/gym
	name = "Gym"
	icon_state = "fitness_gym"

/area/quarantined_outpost/server_relay
	icon_state = "dark128"

/area/quarantined_outpost/server_relay/south_east
	name = "Server Relay Room - South East"

/area/quarantined_outpost/server_relay/north_east
	name = "Server Relay Room - North East"

/area/quarantined_outpost/server_relay/north_west
	name = "Server Relay Room - North West"
