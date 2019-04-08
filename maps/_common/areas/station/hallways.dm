
//Hallway

/area/hallway
	sound_env = LARGE_ENCLOSED
	allow_nightmode = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "\improper Central Primary Hallway"
	icon_state = "hallC1"

/area/hallway/primary/central_two
	name = "\improper Central Primary Hallway"
	icon_state = "hallC2"

/area/hallway/primary/central_three
	name = "\improper Central Primary Hallway"
	icon_state = "hallC3"

/area/hallway/secondary/exit
	name = "\improper Surface - Red Dock"
	icon_state = "escape"
	no_light_control = 1
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/hallway/secondary/construction
	name = "\improper Construction Area"
	icon_state = "construction"
	allow_nightmode = 0

/area/hallway/secondary/entry/fore
	name = "\improper Surface Lvl. Hallway Fore"
	icon_state = "entry_1"

/area/hallway/secondary/entry/port
	name = "\improper Surface - Yellow Dock"
	icon_state = "entry_2"

/area/hallway/secondary/entry/starboard
	name = "\improper Arrival Shuttle Hallway - Starboard"
	icon_state = "entry_3"

/area/hallway/secondary/entry/aft
	name = "\improper Surface Lvl. Hallway Aft"
	icon_state = "entry_4"

/area/hallway/secondary/entry/dock
	name = "\improper Surface - Blue Dock"
	icon_state = "arrivals_dock"
	holomap_color = HOLOMAP_AREACOLOR_ARRIVALS
