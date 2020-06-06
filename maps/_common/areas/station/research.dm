/area/assembly
	station_area = 1

/area/assembly/chargebay
	name = "Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "Robotics Lab"
	icon_state = "robotics"

/area/assembly/robotics/workshop
	name = "Robotics Workshop"
	icon_state = "robotics"

/area/assembly/robotics_cyborgification
	name = "Cyborgification Bay"
	icon_state = "robotics"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "Assembly Line"
	icon_state = "robotics"
	power_equip = 0
	power_light = 0
	power_environ = 0


//rnd (Research and Development
/area/rnd
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/hallway
	name = "Research - Hallway"
	icon_state = "research"
	lightswitch = TRUE

/area/rnd/research
	name = "Research and Development"
	icon_state = "research"

/area/rnd/telesci
	name = "Research - Telescience Laboratory"
	icon_state = "research"

/area/rnd/chemistry
	name = "Research - Exploratory Chemistry"
	icon_state = "chem"

/area/rnd/docking
	name = "Research Dock"
	icon_state = "research_dock"

/area/rnd/lab
	name = "Research - R&D Laboratory"
	icon_state = "toxlab"

/area/rnd/rdoffice
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/supermatter
	name = "Research - Supermatter Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "Research - Xenobiology Lab"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "Research - Xenoflora Storage"
	icon_state = "xeno_f_store"
	no_light_control = TRUE

/area/rnd/xenobiology/xenoflora
	name = "Research - Xenoflora Lab"
	icon_state = "xeno_f_lab"
	no_light_control = TRUE

/area/rnd/xenobiology/xenoflora_hazard
	name = "Research - Xenoflora Hazardous Specimens"
	icon_state = "red"
	no_light_control = TRUE

/area/rnd/xenobiology/cells
	name = "Research - Xenobiology Cell"
	no_light_control = TRUE
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/rnd/xenobiology/cells/alpha
	name = "Research - Xenobiology Alpha"
	icon_state = "red"

/area/rnd/xenobiology/cells/bravo
	name = "Research - Xenobiology Bravo"
	icon_state = "green"

/area/rnd/xenobiology/cells/charlie
	name = "Research - Xenobiology Charlie"
	icon_state = "red"

/area/rnd/xenobiology/cells/delta
	name = "Research - Xenobiology Delta"
	icon_state = "green"

/area/rnd/xenobiology/cells/echo
	name = "Research - Xenobiology Echo"
	icon_state = "red"

/area/rnd/xenobiology/cells/foxtrot
	name = "Research - Xenobiology Foxtrot"
	icon_state = "green"

/area/rnd/xenobiology/cells/golf
	name = "Research - Xenobiology Golf"
	icon_state = "red"

/area/rnd/xenobiology/cells/hotel
	name = "Research - Xenobiology Hotel"
	icon_state = "green"

/area/rnd/storage
	name = "Research - Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "Research - Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/mixing
	name = "Research - Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/misc_lab
	name = "Research - Circuitry Lab"
	icon_state = "toxmisc"

/area/rnd/eva
	name = "Research - EVA Preparation"
	icon_state = "blue"

/area/rnd/xenoarch_atrium
	name = "Research - Xenoarcheology Atrium"
	icon_state = "research"

/area/rnd/xenoarch_storage
	name = "Research - Xenoarcheology Storage"
	icon_state = "purple"

/area/rnd/isolation_a
	name = "Research - Anomaly Isolation A"
	icon_state = "blue"

/area/rnd/isolation_b
	name = "Research - Anomaly Isolation B"
	icon_state = "red"

/area/rnd/isolation_c
	name = "Research - Anomaly Isolation C"
	icon_state = "green"

/area/rnd/test_range
	name = "Research - Weapons Testing Range"
	flags = FIRING_RANGE

/area/toxins
	station_area = 1

/area/toxins/server
	name = "Research - Server Room"
	icon_state = "server"
	station_area = 1
