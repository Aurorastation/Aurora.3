/// CREW_AREAS
/area/horizon/crew
	name = "Crew Areas (PARENT AREA - DON'T USE)"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	department = LOC_CREW

/// Hallway areas
/area/horizon/hallway
	name = "Horizon - Hallway (PARENT AREA - DON'T USE)"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	icon_state = "hallC"
	allow_nightmode = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	emergency_lights = TRUE
	subdepartment = SUBLOC_HALLS

/area/horizon/hallway/primary/deck_three
	name = "Deck 3 Primary Hallway (PARENT AREA - DON'T USE)"
	horizon_deck = 3

/area/horizon/hallway/primary/deck_three/central
	name = "Central Primary Hallway"

/area/horizon/hallway/primary/deck_three/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/horizon/hallway/primary/deck_three/starboard/docks
	name = "Starboard Primary Hallway - Docks"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/horizon/hallway/primary/deck_three/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/horizon/hallway/primary/deck_three/port/docks
	name = "Port Primary Hallway - Docks"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/horizon/hallway/primary/deck_two
	name = "Deck 2 Primary Hallway (PARENT AREA - DON'T USE)"
	horizon_deck = 2

/area/horizon/hallway/primary/deck_two/central
	name = "Central Primary Hallway"
	icon_state = "hallF"

/area/horizon/hallway/primary/deck_two/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/horizon/hallway/primary/deck_one
	name = "Deck 1 Primary Hallway (PARENT AREA - DON'T USE)"
	horizon_deck = 1

/area/horizon/hallway/primary/deck_one/central
	name = "Central Primary Hallway"
	icon_state = "hallF"

// Stairwells
/area/horizon/stairwell
	name = "Stairwell (PARENT AREA - DON'T USE)"
	icon_state = "stairwell"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	allow_nightmode = TRUE
	lightswitch = TRUE
	emergency_lights = TRUE
	subdepartment = SUBLOC_STAIRS

// Starboard Stairwell (Medical/Evac)
/area/horizon/stairwell/starboard
	name = "Starboard Stairwell (PARENT AREA - DON'T USE)"

/area/horizon/stairwell/starboard/deck_one
	name = "Starboard Stairwell"
	horizon_deck = 1

/area/horizon/stairwell/starboard/deck_two
	name = "Starboard Stairwell"
	horizon_deck = 2

/area/horizon/stairwell/starboard/deck_three
	name = "Starboard Stairwell"
	horizon_deck = 3

// Starboard Stairwell (Security/Cafe)
/area/horizon/stairwell/port
	name = "Port Stairwell (PARENT AREA - DON'T USE)"

/area/horizon/stairwell/port/deck_two
	name = "Port Stairwell"
	horizon_deck = 2

/area/horizon/stairwell/port/deck_three
	name = "Port Stairwell"
	horizon_deck = 3

// Bridge Stairwell (Captain/Kitchen/Hydro)
/area/horizon/stairwell/bridge
	name = "Horizon - Bridge Stairwell (PARENT AREA - DON'T USE)"
	icon_state = "bridge_stairs"
	ambience = AMBIENCE_HIGHSEC

/area/horizon/stairwell/bridge/deck_two
	name = "Bridge Stairwell"
	horizon_deck = 2

/area/horizon/stairwell/bridge/deck_three
	name = "Bridge Stairwell"
	horizon_deck = 3

// Engineering Stairwell (Engineering/Atmos)
/area/horizon/stairwell/engineering
	name = "Horizon - Engineering Stairwell (PARENT AREA - DON'T USE)"
	ambience = AMBIENCE_HIGHSEC
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/horizon/stairwell/engineering/deck_one
	name = "Engineering Stairwell"
	horizon_deck = 1

/area/horizon/stairwell/engineering/deck_two
	name = "Engineering Stairwell"
	horizon_deck = 2

/// Cryogenics
/area/horizon/crew/cryo
	name = "Cryogenic Storage"
	area_flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "Sleep"
	horizon_deck = 3
	subdepartment = SUBLOC_CRYO

/// Residential Deck (access)
/area/horizon/crew/resdeck/living_quarters_lift
	name = "Living Quarters Lift"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 1
	subdepartment = SUBLOC_RESDECK

/// Fitness Center (legacy)
/area/horizon/crew/fitness
	name = "Horizon - Fitness Center (PARENT AREA - DON'T USE)"
	icon_state = "fitness"
	horizon_deck = 3

/area/horizon/crew/fitness/gym
	name = "Gym"
	icon_state = "fitness_gym"

/area/horizon/crew/fitness/changing
	name = "Changing Room"
	icon_state = "fitness_changingroom"

/area/horizon/crew/fitness/showers
	name = "Showers"
	icon_state = "showers"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/// Representative and Consular offices.
// Yeah yeah I know, they're technically not 'Crew,' but they're also not Command...
/area/horizon/repoffice
	name = "Representative Office (PARENT AREA - DON'T USE)"
	icon_state = "law"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	horizon_deck = 3
	department = LOC_COMMAND

/area/horizon/repoffice/consular_one
	name = "Consular Office A"
	icon_state = "law_con"

/area/horizon/repoffice/consular_two
	name = "Consular Office B"
	icon_state = "law_con_b"

/area/horizon/repoffice/representative_one
	name = "Representative Office A"
	icon_state = "law_rep"

/area/horizon/repoffice/representative_two
	name = "Representative Office B"
	icon_state = "law_rep_b"

/// Uncategorized/general
/area/horizon/crew/journalistoffice
	name = "Journalist's Office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	horizon_deck = 3

/area/horizon/crew/lounge
	name = "Crew Lounge"
	icon_state = "lounge"
	horizon_deck = 3

/area/horizon/crew/chargebay
	name = "Mech Bay"
	icon_state = "mechbay"
	horizon_deck = 1

/area/horizon/crew/washroom
	name = "Horizon - Washroom (PARENT AREA - DON'T USE)"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/washroom/deck_two
	name = "Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/crew/washroom/deck_three
	name = "Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 3

/area/horizon/crew/vacantoffice
	name = "Vacant Office"
	no_light_control = 0
	horizon_deck = 3
