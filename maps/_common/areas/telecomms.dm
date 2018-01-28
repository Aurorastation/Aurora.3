

// Telecommunications Satellite
/area/tcommsat
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/tcommsat/entrance
	name = "\improper Telecoms Teleporter"
	icon_state = "tcomsatentrance"

/area/tcommsat/chamber
	name = "\improper Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "\improper Telecoms Satellite"
	icon_state = "tcomsatlob"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomfoyer
	name = "\improper Telecoms Foyer"
	icon_state = "tcomsatentrance"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomwest
	name = "\improper Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomeast
	name = "\improper Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tcommsat/computer
	name = "\improper Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/lounge
	name = "\improper Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"
	base_turf = /turf/space

/area/tcommsat/powercontrol
	name = "\improper Telecommunications Power Control"
	icon_state = "tcomsatwest"

/area/tcommsat/mainlvl_tcomms__relay
	name = "\improper Sublevel - Telecommunications Relay"
	icon_state = "tcomsatcham"
