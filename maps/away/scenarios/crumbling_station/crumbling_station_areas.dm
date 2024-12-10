/area/crumbling_station
	name = "Commercial Waypoint"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS //| AREA_FLAG_IS_BACKGROUND (must check what this does)
	holomap_color = "#2c301f"
	area_blurb = "The air reeks of damp stagnancy and something faintly like a distant rot. The noises of small mechanical faults emanate from every direction - the hissing of pressurised air most of them all - and scuttering can be heard in the walls. This place is old, and the years have not been kind to it."

// For the asteroid bits.
/area/crumbling_station/asteroid
	icon_state = "exterior"
	requires_power = FALSE
	holomap_color = "#1c1c1c"

/area/crumbling_station/asteroid/exterior
	name = "Asteroid Exterior"

/area/crumbling_station/asteroid/interior
	name = "Asteroid Interior"

// Docking.
/area/crumbling_station/docking
	icon_state = "dk_yellow"

/area/crumbling_station/docking/docking_ports
	name = "Docking Ports"

/area/crumbling_station/docking/storage
	name = "Storage Compartment"

/area/crumbling_station/docking/docking_approach
	name = "Docking Foyer"

// Service.
/area/crumbling_station/service
	icon_state = "green"

/area/crumbling_station/service/dining
	name = "Mess Hall"

/area/crumbling_station/service/kitchen
	name = "Kitchen"

/area/crumbling_station/service/smoking
	name = "Service Smoking Room"

/area/crumbling_station/service/freezer
	name = "Freezer"

/area/crumbling_station/service/custodial
	name = "Custodial Closet"

/area/crumbling_station/service/washroom
	name = "Crewman's Washroom"

/area/crumbling_station/service/hydro
	name = "Hydroponics Bay"

/area/crumbling_station/service/hydro_secure
	name = "Secure Specimens"

/area/crumbling_station/service/shop
	name = "Station Commissary"

/area/crumbling_station/service/shop_storage
	name = "Station Commissary Storage"

/area/crumbling_station/service/utilities
	name = "Utilities Closet"

/area/crumbling_station/service/disposals
	name = "Disposals"

// Public areas and crew quarters.
/area/crumbling_station/civilian
	icon_state = "yellow"

/area/crumbling_station/civilian/hallway_central
	name = "Primary Central Hallway"

/area/crumbling_station/civilian/hallway_east
	name = "Habitation Block Hallway"

/area/crumbling_station/civilian/hallway_west
	name = "Critical Services Hallway"

/area/crumbling_station/civilian/quarters_1
	name = "Private Habitation Unit #1"

/area/crumbling_station/civilian/quarters_2
	name = "Private Habitation Unit #2"

/area/crumbling_station/civilian/quarters_3
	name = "Private Habitation Unit #3"

/area/crumbling_station/civilian/quarters_4
	name = "Private Habitation Unit #4"

/area/crumbling_station/civilian/quarters_5
	name = "Private Habitation Unit #5"

/area/crumbling_station/civilian/quarters_6
	name = "Private Habitation Unit #6"

/area/crumbling_station/civilian/quarters_7
	name = "Private Habitation Unit #7"

// Medical
/area/crumbling_station/medical
	icon_state = "medbay"

/area/crumbling_station/medical/lobby
	name = "Medical Lobby"

/area/crumbling_station/medical/hallway
	name = "Medical Hallway"

/area/crumbling_station/medical/gtr
	name = "General Treatment Room"

/area/crumbling_station/medical/surgery
	name = "Operating Theatre"

/area/crumbling_station/medical/pharmacy
	name = "Pharmacy"

/area/crumbling_station/medical/recovery1
	name = "Recovery Room #1"

/area/crumbling_station/medical/recovery2
	name = "Recovery Room #2"

// Maintenance
/area/crumbling_station/maints
	icon_state = "maintenance"

/area/crumbling_station/maints/medical
	name = "Medical Maintenance"

/area/crumbling_station/maints/custodial
	name = "Custodial Maintenance"

/area/crumbling_station/maints/civilian
	name = "Civilian Maintenance"

/area/crumbling_station/maints/hydroponics
	name = "Hydroponics Maintenance"

/area/crumbling_station/maints/security
	name = "Security Maintenance"

/area/crumbling_station/maints/solar1
	name = "Solar Array #1 Maintenance"

/area/crumbling_station/maints/solar2
	name = "Solar Array #2 Maintenance"

/area/crumbling_station/maints/reactor
	name = "Reactor Maintenance"

/area/crumbling_station/maints/engi
	name = "Engineering Maintenance"

/area/crumbling_station/maints/disposals
	name = "Disposals Maintenance"

/area/crumbling_station/maints/auxiliary
	name = "Auxiliary Supplies"

/area/crumbling_station/maints/radiator
	name = "Radiator Access Maintenance"

/area/crumbling_station/maints/atmospherics
	name = "Auxiliary Atmospherics"

/area/crumbling_station/maints/hangar
	name = "Auxiliary Hangar"

// Security
/area/crumbling_station/security
	icon_state = "security"

/area/crumbling_station/security/ready
	name = "Security Ready Room"

/area/crumbling_station/security/brig
	name = "Brig"

/area/crumbling_station/security/hallway
	name = "Security Hallway"

// Command
/area/crumbling_station/command
	icon_state = "bridge"

/area/crumbling_station/command/foyer
	name = "Command Foyer"

/area/crumbling_station/command/vault
	name = "Secure Storage"

/area/crumbling_station/command/control
	name = "Control Room"

/area/crumbling_station/command/administrator
	name = "Administrator's Office"

/area/crumbling_station/command/washroom
	name = "Privileged Washroom"

// Engineering
/area/crumbling_station/engi
	icon_state = "engineering"

/area/crumbling_station/engi/lobby
	name = "Engineering Lobby"

/area/crumbling_station/engi/hallway
	name = "Engineering Hallway"

/area/crumbling_station/engi/storage
	name = "Engineering Storage"

/area/crumbling_station/engi/atmospherics
	name = "Atmospherics"

/area/crumbling_station/engi/hard_storage
	name = "Hard Storage"

/area/crumbling_station/engi/reactor
	name = "Supermatter Reactor"

/area/crumbling_station/engi/workshop
	name = "Workshop"
