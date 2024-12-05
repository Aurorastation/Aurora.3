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
	holomap_color = "#7D5443"

/area/nuclear_silo/outside/surface
	name = "Surface"
	area_blurb = "An arctic valley, the air around you frigid and stinging. In the distance can be seen the illumination from lanterns and streetlights."

/area/nuclear_silo/outside/mountain
	name = "Mountain"
	icon_state = "unexplored"
	is_outside = OUTSIDE_NO
	holomap_color = "#382405"
	base_turf = /turf/simulated/floor/exoplanet/barren

/area/nuclear_silo/outside/cave/bunker
	name = "Bunker"
	icon_state = "dark128"
	holomap_color = "#615e5b"

/area/nuclear_silo/outside/buildings
	name = "Building"
	icon_state = "away"
	is_outside = OUTSIDE_NO
	holomap_color = "#7c4d14"
	area_blurb = "As you enter the building, the quiet hum of electric lights is magnified as the dim bulbs around you flicker gently, the floorboards under your feet creaking and straining with every step."
	requires_power = 0

/area/nuclear_silo/outside/buildings/snowmobiles
	name = "Snowmobiles"
	icon_state = "away2"
	area_blurb = "As you enter the building, it appears to be completely abandoned. Snow and dust coat the floor around you, and a lone button sits on a desk, coated in a thick film of dust."

/area/nuclear_silo/outside/buildings/town
	name = "Building"
	icon_state = "away1"
	area_blurb = "As you step foot into the town, the quiet hum of electric streetlights can be heard. Overhead are powerlines, strung across from building to building, some reaching up into the streetlights."
	holomap_color = null
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
	holomap_color = "#641c1c"

/area/nuclear_silo/lower_level/nuke_silo
	name = "Nuclear Missile Silo"
	icon_state = "observatory"
	holomap_color = "#d81414"

// --- Civilian

/area/nuclear_silo/lower_level/civilian
	holomap_color = "#11570e"

/area/nuclear_silo/lower_level/civilian/crew_quarters
	name = "Crew Quarters and Offices"
	icon_state = "crew_quarters"

/area/nuclear_silo/lower_level/civilian/bathrooms
	name = "Bathrooms"
	icon_state = "restrooms"

/area/nuclear_silo/lower_level/civilian/messhall
	name = "Messhall"
	icon_state = "kitchen"

/area/nuclear_silo/lower_level/civilian/freezer
	name = "Freezer"
	icon_state = "kitchen"

/area/nuclear_silo/lower_level/civilian/gym
	name = "Gym"
	icon_state = "fitness_gym"

/area/nuclear_silo/lower_level/civilian/hydroponics
	name = "Hydroponics"
	icon_state = "garden"

/area/nuclear_silo/lower_level/civilian/janitor
	name = "Janitors Closet"
	icon_state = "janitor"

/area/nuclear_silo/lower_level/civilian/cryogenics
	name = "Cryogenic Storage"
	icon_state = "cryo"

// --- Maintenance

/area/nuclear_silo/lower_level/maintenance
	name = "Maintenance"
	icon_state = "maintenance"

/area/nuclear_silo/lower_level/maintenance/lift
	name = "Maintenance, Lift"

/area/nuclear_silo/lower_level/maintenance/engimed
	name = "Maintenance, Engineering and Medical Interstitial"

/area/nuclear_silo/lower_level/maintenance/east
	name = "Maintenance, Eastern Tunnels"

/area/nuclear_silo/lower_level/maintenance/east/robotics_bay
	name = "Maintenance, Abandoned Storage Room"
	icon_state = "mechbay"

/area/nuclear_silo/lower_level/maintenance/east/cellar
	name = "Tavern Cellar"
	icon_state = "bar"

/area/nuclear_silo/lower_level/maintenance/south
	name = "Maintenance, Southern Tunnels"

/area/nuclear_silo/lower_level/maintenance/central
	name = "Maintenance, Central"

/area/nuclear_silo/lower_level/maintenance/north
	name = "Maintenance, North"

// --- Lifts

/area/nuclear_silo/lower_level_lift
	name = "Nuclear Missile Silo Bunker - Lower Level Lift Passage"
	icon_state = "exit"
	area_blurb = "The elevator descends with a low hum, air hissing from hydraulic tubes as it slowly descends into the passage below. The walls are lined with intricate marks and pipes, dotted with cables sheathed in metal covers. Eventually, the elevator settles down after what must have been thirty metres, a loud metallic banging as it impacts the plating at the base of the passage."

/area/nuclear_silo/upper_level_lift
	name = "Nuclear Missile Silo Bunker - Upper Level Lift Passage"
	icon_state = "exit"

// --- Lift area

/area/turbolift/nuclear_silo/bunker_lift
	name = "Nuclear Silo Lift"
	station_area = FALSE
