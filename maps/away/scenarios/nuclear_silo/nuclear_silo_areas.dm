/area/nuclear_silo
	name = "Nuclear Silo"
	icon_state = "exterior"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/snow
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_IS_BACKGROUND
	holomap_color = "#f0e0e0"

// --- Surface

/area/nuclear_silo/outside
	is_outside = OUTSIDE_YES


/area/nuclear_silo/outside/landing
	name = "Landing Pad"
	icon_state = "dk_yellow"
	luminosity = 1
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1

/area/nuclear_silo/outside/surface
	name = "Surface"
	area_blurb = "An arctic valley, the air around you frigid and stinging. In the distance can be seen the illumination from lanterns and streetlights."
	luminosity = 1
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1

/area/nuclear_silo/outside/cave
	name = "Cave"
	icon_state = "cave"
	is_outside = OUTSIDE_NO
	holomap_color = "#382405"


/area/nuclear_silo/outside/mountain
	name = "Mountain"
	icon_state = "unexplored"
	is_outside = OUTSIDE_NO
	holomap_color = "#382405"
	luminosity = 1
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1

/area/nuclear_silo/outside/cave/bunker
	name = "Bunker"
	icon_state = "dark128"
	holomap_color = "#615e5b"

/area/nuclear_silo/outside/buildings
	name = "Building"
	icon_state = "away"
	is_outside = OUTSIDE_NO
	luminosity = 1
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1

// --- Lower Level

/area/nuclear_silo/lower_level
	base_turf = /turf/simulated/floor/plating
	holomap_color = "#636161"

/area/nuclear_silo/lower_level/hallway
	name = "Hallway"
	icon_state = "hallC"

/area/nuclear_silo/lower_level/engineering
	name = "Engineering"
	icon_state = "engineering"
	holomap_color = "#d88314"

/area/nuclear_silo/lower_level/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"
	holomap_color = "#200266"

/area/nuclear_silo/lower_level/medbay
	name = "Medical Bay"
	icon_state = "medbay2"
	holomap_color = "#1a910b"

/area/nuclear_silo/lower_level/crew_quarters
	name = "Crew Quarters and Offices"
	icon_state = "crew_quarters"
	holomap_color = "#7e7d7c"

/area/nuclear_silo/lower_level/bathrooms
	name = "Bathrooms"
	icon_state = "restrooms"
	holomap_color = "#1bb3b3"

/area/nuclear_silo/lower_level/messhall
	name = "Messhall"
	icon_state = "kitchen"
	holomap_color = "#11570e"

/area/nuclear_silo/lower_level/freezer
	name = "Freezer"
	icon_state = "kitchen"
	holomap_color = "#11570e"

/area/nuclear_silo/lower_level/Gym
	name = "Gym"
	icon_state = "fitness_gym"
	holomap_color = "#424b42"

/area/nuclear_silo/lower_level/hydroponics
	name = "Hydroponics"
	icon_state = "garden"
	holomap_color = "#c114d8"

/area/nuclear_silo/lower_level/security
	name = "Security"
	icon_state = "security"
	holomap_color = "#3906b1"


/area/nuclear_silo/lower_level/brig
	name = "Brig"
	icon_state = "brig"
	holomap_color = "#5018d3"

/area/nuclear_silo/lower_level/nuke_monitoring
	name = "Nuclear Missile Silo Monitoring"
	icon_state = "conference"
	holomap_color = "#220d0d"

/area/nuclear_silo/lower_level/nuke_silo
	name = "Nuclear Missile Silo"
	icon_state = "observatory"
	holomap_color = "#d81414"
// --- Maintenance
/area/nuclear_silo/lower_level/maintenance
	name = "Maintenance"
	icon_state = "maintenance"

/area/nuclear_silo/lower_level/maintenance/lift
	name = "Maintenance, Lift"
	icon_state = "maintenance"

/area/nuclear_silo/lower_level/maintenance/engimed
	name = "Maintenance, Engineering and Medical Interstitial"
	icon_state = "maintenance"
// --- Lifts
/area/nuclear_silo/lower_level_lift
	name = "Nuclear Missile Silo Bunker - Lower Level Lift Passage"
	icon_state = "exit"
	area_blurb = "The elevator descends with a low hum, air hissing from hydraulic tubes as it slowly descends into the passage below. The walls are lined with intricate marks and pipes, dotted with cables sheathed in metal covers. Eventually, the elevator settles down after what must have been thirty metres, a loud metallic banging as it impacts the plating at the base of the passage."

/area/nuclear_silo/upper_level_lift
	name = "Nuclear Missile Silo Bunker - Upper Level Lift Passage"
	icon_state = "exit"

// --- Lift area.
/area/turbolift/nuclear_silo/bunker_lift
	name = "TCAF Lift"
	station_area = FALSE
