
//Hallway

/area/hallway
	sound_env = LARGE_ENCLOSED
	allow_nightmode = TRUE
	station_area = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "Central Primary Hallway"
	icon_state = "hallC1"

/area/hallway/primary/central_two
	name = "Central Primary Hallway"
	icon_state = "hallC2"

/area/hallway/primary/central_three
	name = "Central Primary Hallway"
	icon_state = "hallC3"

/area/hallway/secondary/exit
	name = "Surface - Red Dock"
	icon_state = "escape"
	no_light_control = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"
	allow_nightmode = FALSE
	lightswitch = FALSE

/area/hallway/secondary/entry/fore
	name = "Surface Lvl. Hallway Fore"
	icon_state = "entry_1"

/area/hallway/secondary/entry/port
	name = "Surface - Yellow Dock"
	icon_state = "entry_2"

/area/hallway/secondary/entry/starboard
	name = "Arrival Shuttle Hallway - Starboard"
	icon_state = "entry_3"

/area/hallway/secondary/entry/central
	name = "Surface Lvl. Hallway Central"
	icon_state = "entry_3"

/area/hallway/secondary/entry/aft
	name = "Surface Lvl. Hallway Aft"
	icon_state = "entry_4"

/area/hallway/secondary/entry/dock
	name = "Surface - Blue Dock"
	icon_state = "arrivals_dock"
	holomap_color = HOLOMAP_AREACOLOR_ARRIVALS

/area/hallway/secondary/entry/emergency
	name = "Emergency Services Dock"
	icon_state = "escape"

/area/hallway/secondary/entry/departure_lounge
	name = "Surface - Departures Lounge"
	icon_state = "dep_lounge"

/area/hallway/secondary/entry/locker
	name = "Surface - Locker Room"
	icon_state = "locker"

/area/hallway/secondary/entry/stairs
	name = "Surface Access Stairwell"
	icon_state = "dk_yellow"
