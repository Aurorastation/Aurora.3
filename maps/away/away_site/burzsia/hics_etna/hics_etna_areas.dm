/area/burzsia_station
	name = "Etna"
	icon_state = "blue"
	luminosity = 0
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 0

/area/burzsia_station/command
	name = "Command Conference Room"
	icon_state = "blue"

/area/burzsia_station/afthall
	name = "Aft Hallway"
	icon_state = "green"

/area/burzsia_station/primaryhall
	name = "Primary Hall"
	icon_state = "green"

/area/burzsia_station/securityhall
	name = "Security Hallway"
	icon_state = "red"

/area/burzsia_station/opshall
	name = "Operations Hallway"
	icon_state = "dark"
	ambience = AMBIENCE_ENGINEERING

/area/burzsia_station/atmos
	name = "Atmospherics"
	icon_state = "engineering"
	ambience = AMBIENCE_ATMOS

/area/burzsia_station/tcomms
	name = "Telecommunications"
	icon_state = "dark160"
	requires_power = FALSE

/area/burzsia_station/medbay
	name = "Medbay"
	icon_state = "blue2"

/area/burzsia_station/mechbay
	name = "Robotics Bay"
	icon_state = "machinist_workshop"

/area/burzsia_station/security
	name = "Security"
	icon_state = "red2"

/area/burzsia_station/operations
	name = "Operations Office"
	icon_state = "quartoffice"

/area/burzsia_station/mining
	name = "Mining"
	icon_state = "brown"
	ambience = AMBIENCE_HANGAR

/area/burzsia_station/sorting
	name = "Sorting Room"
	icon_state = "quartloading"

/area/burzsia_station/shopette
	name = "Shopette"
	icon_state = "green"

/area/burzsia_station/hephrepoffice
	name = "Hephaestus Representative Office"
	icon_state = "blue"

/area/burzsia_station/sscrepoffice
	name = "Conglomerate Representative Office"
	icon_state = "blue"

/area/burzsia_station/bardiner
	name = "Bar and Diner"
	icon_state = "kitchen"

/area/burzsia_station/washroom
	name = "Washroom"
	icon_state = "washroom"

/area/burzsia_station/park
	name = "Indoor Park"
	icon_state = "red2"

/area/burzsia_station/pool
	name = "Pool"
	icon_state = "fitness_pool"

/area/burzsia_station/gym
	name = "Gym"
	icon_state = "fitness"

/area/burzsia_station/rechall
	name = "Recreation Hallway"
	icon_state = "red2"

/area/burzsia_station/karaoke
	name = "Karaoke Room"
	icon_state = "lounge"

/area/burzsia_station/charging
	name = "Charging Station"
	icon_state = "red2"

/area/burzsia_station/arrivals
	name = "Arrivals Atrium"
	icon_state = "blue"

/area/burzsia_station/arrivalshall
	name = "Arrivals Hallway"
	icon_state = "blue-red-d"
	ambience = AMBIENCE_ARRIVALS

/area/burzsia_station/custodial
	name = "Custodial Closet"
	icon_state = "red2"

/area/burzsia_station/lifts
	name = "Residential Lifts"
	icon_state = "red2"
	ambience = AMBIENCE_ELEVATOR

/area/burzsia_station/civilian_docks
	name = "Civilian Docks"
	icon_state = "purple"

/area/burzsia_station/exterior
	name = "HICS Etna - Exterior"
	icon_state = "exterior"
	base_turf = /turf/space
	dynamic_lighting = TRUE
	requires_power = FALSE
	has_gravity = FALSE
	no_light_control = TRUE
	allow_nightmode = FALSE
	ambience = AMBIENCE_SPACE

/area/burzsia_station/lifts
	name = "Residential Lifts"
	icon_state = "red2"
	ambience = AMBIENCE_ELEVATOR

// Lift
/area/turbolift/burzsia_station/burzsia_station_lift
	name = "HICS Etna Dockyard Lift"
	station_area = FALSE
