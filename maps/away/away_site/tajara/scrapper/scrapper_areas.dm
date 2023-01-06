/area/scrapper_base
	name = "Scrapper Outpost"
	icon_state = "bluenew"
	requires_power = 1
	dynamic_lighting = 1
	no_light_control = 0
	base_turf = /turf/space
	flags = RAD_SHIELDED | HIDE_FROM_HOLOMAP

/area/scrapper_base/quarters
	name = "Scrapper Outpost Crew Quarters"
	icon_state = "crew_quarters"

/area/scrapper_base/atmos
	name = "Scrapper Outpost Atmospherics"
	icon_state = "atmos"

/area/scrapper_base/solars
	name = "Scrapper Outpost Atmospherics"
	icon_state = "SolarcontrolS"

/area/scrapper_base/storage
	name = "Scrapper Outpost Storage"
	icon_state = "primarystorage"

//Shuttle
/area/shuttle/scrapper_ship
	flags = HIDE_FROM_HOLOMAP
	requires_power = TRUE

/area/shuttle/scrapper_ship/bridge
	name = "Scrapper Bridge"
	icon_state = "bridge_stairs"

/area/shuttle/scrapper_ship/port_engines
	name = "Scrapper Port Engines"
	icon_state = "east"

/area/shuttle/scrapper_ship/starboard_engines
	name = "Scrapper Starboard Engines"
	icon_state = "west"

/area/shuttle/scrapper_ship/atmos
	name = "Scrapper Atmospherics"
	icon_state = "atmos"

/area/shuttle/scrapper_ship/power_station
	name = "Scrapper Power Station"
	icon_state = "substation"

/area/shuttle/scrapper_ship/workshop
	name = "Scrapper Workshop"
	icon_state = "workshop"

/area/shuttle/scrapper_ship/storage
	name = "Scrapper Storage"
	icon_state = "red"