
// ------------------------- base/parent

/area/enviro_testing_facility
	name = "Base/Parent Area"
	icon_state = "white128a"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_IS_BACKGROUND
	holomap_color = "#747474"
	color = "#747474"
	is_outside = OUTSIDE_NO

// ------------------------- outside

/area/enviro_testing_facility/outside
	is_outside = OUTSIDE_YES
	holomap_color = "#494949"

/area/enviro_testing_facility/outside/landing
	name = "Landing Pad"
	holomap_color = "#575757"

/area/enviro_testing_facility/outside/surface
	name = "Surface"

/area/enviro_testing_facility/outside/cave
	name = "Cave"
	is_outside = OUTSIDE_NO
	holomap_color = "#2e2e2e"
	color = "#2e2e2e"

// ------------------------- inside

/area/enviro_testing_facility/inside
	is_outside = OUTSIDE_NO
	holomap_color = "#7e7e7e"
	color = "#7e7e7e"

// ------------- hallway

/area/enviro_testing_facility/inside/hallway
	holomap_color = "#8d8d8d"
	color = "#8d8d8d"

/area/enviro_testing_facility/inside/hallway/entrance
	name = "Entrance"

/area/enviro_testing_facility/inside/hallway/central
	name = "Hallway, Central"

/area/enviro_testing_facility/inside/hallway/east
	name = "Hallway, East"

/area/enviro_testing_facility/inside/hallway/west
	name = "Hallway, West"

// ------------- crew

/area/enviro_testing_facility/inside/crew
	holomap_color = "#54654c"
	color = "#54654c"

/area/enviro_testing_facility/inside/crew/quarters
	name = "Crew Quarters"

/area/enviro_testing_facility/inside/crew/canteen
	name = "Canteen"

/area/enviro_testing_facility/inside/crew/cryo_1
	name = "Cryo Storage 1"

/area/enviro_testing_facility/inside/crew/cryo_2
	name = "Cryo Storage 2"

/area/enviro_testing_facility/inside/crew/lockers
	name = "Personal Lockers"

// ------------- medical

/area/enviro_testing_facility/inside/medical
	holomap_color = "#8daf6a"
	color = "#8daf6a"

/area/enviro_testing_facility/inside/medical/hallway
	name = "Medical, Hallway"

/area/enviro_testing_facility/inside/medical/lobby
	name = "Medical, Lobby"

/area/enviro_testing_facility/inside/medical/cryo
	name = "Medical, Cryo"

/area/enviro_testing_facility/inside/medical/pharmacy
	name = "Medical, Pharmacy"

/area/enviro_testing_facility/inside/medical/recovery_1
	name = "Medical, Recovery 1"

/area/enviro_testing_facility/inside/medical/recovery_2
	name = "Medical, Recovery 2"

/area/enviro_testing_facility/inside/medical/offices
	name = "Medical, Offices"

/area/enviro_testing_facility/inside/medical/general_treatment
	name = "Medical, GTR"

/area/enviro_testing_facility/inside/medical/surgery_1
	name = "Medical, Surgery 1"

/area/enviro_testing_facility/inside/medical/surgery_2
	name = "Medical, Surgery 2"

/area/enviro_testing_facility/inside/medical/chief_office
	name = "Medical, CMO Office"

/area/enviro_testing_facility/inside/medical/paramedic
	name = "Medical, Paramedic Ready Room"

// ------------- security

/area/enviro_testing_facility/inside/security
	holomap_color = "#708997"
	color = "#708997"

/area/enviro_testing_facility/inside/security/lobby
	name = "Security, Lobby"

/area/enviro_testing_facility/inside/security/equipment
	name = "Security, Equipment Room"

/area/enviro_testing_facility/inside/security/armory
	name = "Security, Armoury"

/area/enviro_testing_facility/inside/security/cells_1
	name = "Security, Cells 1"

/area/enviro_testing_facility/inside/security/cells_2
	name = "Security, Cells 2"

/area/enviro_testing_facility/inside/security/hallway
	name = "Security, Hallway"

/area/enviro_testing_facility/inside/security/hos_office
	name = "Security, HOS Office"

/area/enviro_testing_facility/inside/security/storage
	name = "Security, Storage"

// ------------- engineering

/area/enviro_testing_facility/inside/engineering
	holomap_color = "#ceb689"
	color = "#ceb689"

/area/enviro_testing_facility/inside/engineering/storage_1
	name = "Engineering, Storage 1"

/area/enviro_testing_facility/inside/engineering/storage_2
	name = "Engineering, Storage 2"

/area/enviro_testing_facility/inside/engineering/secure_storage
	name = "Engineering, Secure Storage"

/area/enviro_testing_facility/inside/engineering/reactors
	name = "Engineering, Reactors"

/area/enviro_testing_facility/inside/engineering/equipment
	name = "Engineering, Equipment"

/area/enviro_testing_facility/inside/engineering/robo_lab
	name = "Engineering, Robotics Lab"

/area/enviro_testing_facility/inside/engineering/mech_lab
	name = "Engineering, Mechatronics Lab"

// ------------- research

/area/enviro_testing_facility/inside/research
	holomap_color = "#8a7387"
	color = "#8a7387"

/area/enviro_testing_facility/inside/research/hallway
	name = "Research, Hallway"

/area/enviro_testing_facility/inside/research/entrance
	name = "Research, Entrance"

/area/enviro_testing_facility/inside/research/chem_lab
	name = "Research, Chem Lab"

/area/enviro_testing_facility/inside/research/telescience
	name = "Research, Telescience"

/area/enviro_testing_facility/inside/research/rnd
	name = "Research, RnD"

/area/enviro_testing_facility/inside/research/meeting
	name = "Research, Meeting Room"

/area/enviro_testing_facility/inside/research/rd_office
	name = "Research, RD Office"

/area/enviro_testing_facility/inside/research/electronics
	name = "Research, Electronics"

// ------------- testing domes

/area/enviro_testing_facility/inside/testing_dome
	holomap_color = "#587577"
	color = "#587577"

/area/enviro_testing_facility/inside/testing_dome/anna
	name = "Testing Dome, Anna"

/area/enviro_testing_facility/inside/testing_dome/boris
	name = "Testing Dome, Boris"

/area/enviro_testing_facility/inside/testing_dome/vasily
	name = "Testing Dome, Vasily"

/area/enviro_testing_facility/inside/testing_dome/galina
	name = "Testing Dome, Galina"


// ------------- operations

/area/enviro_testing_facility/inside/operations
	holomap_color = "#ceb689"
	color = "#ceb689"

/area/enviro_testing_facility/inside/operations/storage_long_term
	name = "Operations, Long-Term Storage"

/area/enviro_testing_facility/inside/operations/storage_materials
	name = "Operations, Materials Storage"

/area/enviro_testing_facility/inside/operations/fabrication
	name = "Operations, Fabrication"

// ------------- control

/area/enviro_testing_facility/inside/control
	holomap_color = "#536c91"
	color = "#536c91"

/area/enviro_testing_facility/inside/control/facility_controls
	name = "Control, Facility Main Controls"

/area/enviro_testing_facility/inside/control/offices
	name = "Control, Offices"

/area/enviro_testing_facility/inside/control/comms
	name = "Control, Comms"

/area/enviro_testing_facility/inside/control/presentation
	name = "Control, Presentation Room"

/area/enviro_testing_facility/inside/control/observation
	name = "Control, Observation Room"

// ------------------------- maint

/area/enviro_testing_facility/inside/maintenance
	holomap_color = "#4b4b4b"
	color = "#4b4b4b"

/area/enviro_testing_facility/inside/maintenance/center_east
	name = "Maintenance, Center, East"

/area/enviro_testing_facility/inside/maintenance/center_west
	name = "Maintenance, Center, West"

/area/enviro_testing_facility/inside/maintenance/center_far
	name = "Maintenance, Center, Far"

/area/enviro_testing_facility/inside/maintenance/center_construction
	name = "Maintenance, Center, Construction"

/area/enviro_testing_facility/inside/maintenance/center_canteen
	name = "Maintenance, Center, Canteen"

/area/enviro_testing_facility/inside/maintenance/east
	name = "Maintenance, East"

/area/enviro_testing_facility/inside/maintenance/east_far
	name = "Maintenance, East, Far"

/area/enviro_testing_facility/inside/maintenance/east_lockers
	name = "Maintenance, East, Lockers"

/area/enviro_testing_facility/inside/maintenance/west
	name = "Maintenance, West"

/area/enviro_testing_facility/inside/maintenance/west_far
	name = "Maintenance, West, Far"

/area/enviro_testing_facility/inside/maintenance/control
	name = "Maintenance, Control"

/area/enviro_testing_facility/inside/maintenance/operations
	name = "Maintenance, Operations"

/area/enviro_testing_facility/inside/maintenance/aux_engineering_storage
	name = "Maintenance, Aux Engineering Storage"

/area/enviro_testing_facility/inside/maintenance/entrance
	name = "Maintenance, Entrance"

/area/enviro_testing_facility/inside/maintenance/presentation
	name = "Maintenance, Presentation"

/area/enviro_testing_facility/inside/maintenance/medical
	name = "Maintenance, Medical"

/area/enviro_testing_facility/inside/maintenance/security
	name = "Maintenance, Security"

/area/enviro_testing_facility/inside/maintenance/engineering_south
	name = "Maintenance, Engineering, South"

/area/enviro_testing_facility/inside/maintenance/engineering_north
	name = "Maintenance, Engineering, North"

/area/enviro_testing_facility/inside/maintenance/research
	name = "Maintenance, Research"
