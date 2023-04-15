

// Telecommunications Satellite
/area/tcommsat
	ambience = AMBIENCE_ENGINEERING
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/tcommsat/entrance
	name = "Telecoms Entrance"
	icon_state = "tcomsatentrance"
	lightswitch = TRUE

/area/tcommsat/chamber
	name = "Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "Telecoms Exterior"
	icon_state = "tcomsatlob"
	ambience = AMBIENCE_ENGINEERING

/area/turret_protected/tcomfoyer
	name = "Telecoms Foyer"
	icon_state = "tcomsatentrance"
	ambience = AMBIENCE_ENGINEERING

/area/turret_protected/tcomwest
	name = "Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambience = AMBIENCE_ENGINEERING

/area/turret_protected/tcomeast
	name = "Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambience = AMBIENCE_ENGINEERING

/area/tcommsat/computer
	name = "Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/lounge
	name = "Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"
	base_turf = /turf/space

/area/tcommsat/powercontrol
	name = "Telecommunications Power Control"
	icon_state = "tcomsatwest"

/area/tcommsat/mainlvl_tcomms__relay
	name = "First Deck Telecommunications Relay"
	icon_state = "tcomsatcham"

/area/tcommsat/mainlvl_tcomms__relay/second
	name = "Second Deck Telecommunications Relay"
