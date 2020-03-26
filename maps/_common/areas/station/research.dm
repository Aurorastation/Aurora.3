/area/assembly
	station_area = 1

/area/assembly/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/assembly/robotics/workshop
	name = "\improper Robotics Workshop"
	icon_state = "robotics"

/area/assembly/robotics_cyborgification
	name = "\improper Cyborgification Bay"
	icon_state = "robotics"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "\improper Assembly Line"
	icon_state = "robotics"
	power_equip = 0
	power_light = 0
	power_environ = 0


//rnd (Research and Development
/area/rnd
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/research
	name = "\improper Research and Development"
	icon_state = "research"

/area/rnd/telesci
	name = "\improper Research - Telescience Laboratory"
	icon_state = "research"

/area/rnd/chemistry
	name = "\improper Research - Exploratory Chemistry"
	icon_state = "chem"

/area/rnd/docking
	name = "\improper Research Dock"
	icon_state = "research_dock"

/area/rnd/lab
	name = "\improper Research - R&D Laboratory"
	icon_state = "toxlab"

/area/rnd/rdoffice
	name = "\improper Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/supermatter
	name = "\improper Research - Supermatter Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "\improper Research - Xenobiology Lab"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "\improper Research - Xenoflora Storage"
	icon_state = "xeno_f_store"
	no_light_control = TRUE

/area/rnd/xenobiology/xenoflora
	name = "\improper Research - Xenoflora Lab"
	icon_state = "xeno_f_lab"
	no_light_control = TRUE

/area/rnd/xenobiology/xenoflora_hazard
	name = "\improper Research - Xenoflora Hazardous Specimens"
	icon_state = "red"
	no_light_control = TRUE

/area/rnd/xenobiology/cells
	name = "\improper Research - Xenobiology Cell"
	no_light_control = TRUE
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/rnd/xenobiology/cells/alpha
	name = "\improper Research - Xenobiology Alpha"
	icon_state = "red"

/area/rnd/xenobiology/cells/bravo
	name = "\improper Research - Xenobiology Bravo"
	icon_state = "green"

/area/rnd/xenobiology/cells/charlie
	name = "\improper Research - Xenobiology Charlie"
	icon_state = "red"

/area/rnd/xenobiology/cells/delta
	name = "\improper Research - Xenobiology Delta"
	icon_state = "green"

/area/rnd/xenobiology/cells/echo
	name = "\improper Research - Xenobiology Echo"
	icon_state = "red"

/area/rnd/xenobiology/cells/foxtrot
	name = "\improper Research - Xenobiology Foxtrot"
	icon_state = "green"

/area/rnd/xenobiology/cells/golf
	name = "\improper Research - Xenobiology Golf"
	icon_state = "red"

/area/rnd/xenobiology/cells/hotel
	name = "\improper Research - Xenobiology Hotel"
	icon_state = "green"

/area/rnd/storage
	name = "\improper Research - Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "\improper Research - Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/mixing
	name = "\improper Research - Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/misc_lab
	name = "\improper Research - Circuitry Lab"
	icon_state = "toxmisc"

/area/rnd/eva
	name = "\improper Research - EVA Preparation"
	icon_state = "blue"

/area/rnd/xenoarch_atrium
	name = "\improper Research - Xenoarcheology Atrium"
	icon_state = "research"

/area/rnd/xenoarch_storage
	name = "\improper Research - Xenoarcheology Storage"
	icon_state = "purple"

/area/rnd/isolation_a
	name = "\improper Research - Anomaly Isolation A"
	icon_state = "blue"

/area/rnd/isolation_b
	name = "\improper Research - Anomaly Isolation B"
	icon_state = "red"

/area/rnd/isolation_c
	name = "\improper Research - Anomaly Isolation C"
	icon_state = "green"

/area/rnd/test_range
	name = "\improper Research - Weapons Testing Range"
	flags = FIRING_RANGE

/area/toxins
	station_area = 1

/area/toxins/server
	name = "\improper Research - Server Room"
	icon_state = "server"
	station_area = 1
