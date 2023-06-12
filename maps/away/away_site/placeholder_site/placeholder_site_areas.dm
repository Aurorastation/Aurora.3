//For the placeholder away site itself. None of this should be used for ingame things
/area/placeholder_site
	name = "Navbeacon Control Site"//APCs and terminals that address the area will read out the area's name so don't make it too OOC
	icon_state = "red"//For your own readability while mapping entirely. Area icons should not be visible ingame ever
	flags = HIDE_FROM_HOLOMAP//For obvious reasons you don't want away sites seen on the Horizon holomaps

/area/placeholder_site/reactor
	name = "Control Site Reactor Room"
	icon_state = "yellow"

/area/placeholder_site/living_quarters
	name = "Control Site Living Room"
	icon_state = "purple"

/area/placeholder_site/hangar
	name = "Control Site Hangar"
	icon_state = "green"

/area/placeholder_site/lightroom
	name = "Control Site Light Room"
	icon_state = "yellow"
	requires_power = FALSE//In case you don't want things to require power to run. This generally makes wiring pointless and saves time
	no_light_control = TRUE//Locks light control from switches. What lighting it has will stay unless you bring flashlights for example
