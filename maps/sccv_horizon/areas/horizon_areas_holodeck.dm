/// HOLODECK_AREAS
/area/horizon/holodeck_control
	name = "Holodeck Alpha"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	horizon_deck = 3
	area_blurb = "One of the SCCV Horizon's very expensive holodecks."
	department = LOC_CREW

/area/horizon/holodeck_control/beta
	name = "Holodeck Beta"

/area/horizon/holodeck
	name = "Holodeck (PARENT AREA - DON'T USE)"
	icon_state = "Holodeck"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = TRUE
	dynamic_lighting = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_NO_GHOST_TELEPORT_ACCESS
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	horizon_deck = 3
	area_blurb = "One of the SCCV Horizon's very expensive holodecks."
	department = LOC_CREW

/area/horizon/holodeck/alphadeck
	name = "Holodeck Alpha"
	dynamic_lighting = TRUE

/area/horizon/holodeck/betadeck
	name = "Holodeck Beta"
	dynamic_lighting = TRUE

/area/horizon/holodeck/source_plating
	name = "Holodeck - Off"

/area/horizon/holodeck/source_chapel
	name = "Holodeck - Chapel"

/area/horizon/holodeck/source_gym
	name = "Holodeck - Gym"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_range
	name = "Holodeck - Range"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_emptycourt
	name = "Holodeck - Empty Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_boxingcourt
	name = "Holodeck - Boxing Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_basketball
	name = "Holodeck - Basketball Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_thunderdomecourt
	name = "Holodeck - Thunderdome Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_courtroom
	name = "Holodeck - Courtroom"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/horizon/holodeck/source_burntest
	name = "Holodeck - Atmospheric Burn Test"

/area/horizon/holodeck/source_wildlife
	name = "Holodeck - Wildlife Simulation"

/area/horizon/holodeck/source_meetinghall
	name = "Holodeck - Meeting Hall"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/horizon/holodeck/source_theatre
	name = "Holodeck - Callistean Theatre"
	sound_environment = SOUND_ENVIRONMENT_CONCERT_HALL

/area/horizon/holodeck/source_picnicarea
	name = "Holodeck - Picnic Area"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_dininghall
	name = "Holodeck - Dining Hall"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_snowfield
	name = "Holodeck - Bursa Tundra"
	sound_environment = SOUND_ENVIRONMENT_FOREST

/area/horizon/holodeck/source_desert
	name = "Holodeck - Desert"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_space
	name = "Holodeck - Space"
	has_gravity = FALSE
	sound_environment = SOUND_AREA_SPACE

/area/horizon/holodeck/source_battlemonsters
	name = "Holodeck - Battlemonsters Arena"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_chessboard
	name = "Holodeck - Chessboard"

/area/horizon/holodeck/source_adhomai
	name = "Holodeck - Adhomian Campfire"

/area/horizon/holodeck/source_beach
	name = "Holodeck - Silversunner Coast"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_pool
	name = "Holodeck - Swimming Pool"

/area/horizon/holodeck/source_sauna
	name = "Holodeck - Sauna"

/area/horizon/holodeck/source_jupiter
	name = "Holodeck - Jupiter Upper Atmosphere"

/area/horizon/holodeck/source_konyang
	name = "Holodeck - Konyanger Boardwalk"

/area/horizon/holodeck/source_moghes
	name = "Holodeck - Moghresian Jungle"

/area/horizon/holodeck/source_biesel
	name = "Holodeck - Foggy Mendell Skyline"

/area/horizon/holodeck/source_tribunal
	name = "Holodeck - Tribunalist Chapel"

/area/horizon/holodeck/source_trinary
	name = "Holodeck - Trinarist Chapel"

/area/horizon/holodeck/source_cafe
	name = "Holodeck - Animal Cafe"

/area/horizon/holodeck/source_lasertag
	name = "Holodeck - Laser Tag Arena"

/area/horizon/holodeck/source_combat_training
	name = "Holodeck - Combat Training Arena"
