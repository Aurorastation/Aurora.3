/// SCIENCE_AREAS
/area/horizon/rnd
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	department = LOC_SCIENCE
	horizon_deck = 2
	area_blurb = "The science sectors of the ship lend themselves to a clean, functional sterility; at least when everything is going well."

/area/horizon/rnd/conference
	name = "Conference Room"
	horizon_deck = 2

/area/horizon/rnd/hallway
	name = "Hallway"
	icon_state = "research"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	lightswitch = TRUE
	location_ew = LOC_PORT

/area/horizon/rnd/hallway/secondary
	name = "Hallway"
	icon_state = "research"
	lightswitch = TRUE
	horizon_deck = 2
	location_ns = LOC_AFT

/area/horizon/rnd/telesci
	name = "Telescience"
	icon_state = "research"
	horizon_deck = 2

/area/horizon/rnd/chemistry
	name = "Exploratory Chemistry"
	icon_state = "chem"
	horizon_deck = 2

/area/horizon/rnd/lab
	name = "Research & Development"
	icon_state = "toxlab"
	horizon_deck = 2

/area/horizon/rnd/xenobiology
	name = "Primary Laboratory"
	icon_state = "xeno_lab"
	horizon_deck = 2
	subdepartment = SUBLOC_XENOBIO

/area/horizon/rnd/xenobiology/xenological
	name = "Xenological Studies"
	icon_state = "xeno_log"
	horizon_deck = 2

/area/horizon/rnd/xenobiology/hazardous
	name = "Hazardous Containment"
	icon_state = "xeno_lab"
	horizon_deck = 2
	subdepartment = SUBLOC_XENOBIO

/area/horizon/rnd/xenobiology/dissection
	name = "Dissection"
	icon_state = "xeno_lab"
	horizon_deck = 2
	subdepartment = SUBLOC_XENOBIO

/area/horizon/rnd/xenobiology/foyer
	name = "Foyer"
	icon_state = "xeno_lab"
	horizon_deck = 2
	subdepartment = SUBLOC_XENOBIO

/area/horizon/rnd/xenobiology/xenoflora
	name = "Grow Lab"
	icon_state = "xeno_f_lab"
	no_light_control = TRUE
	horizon_deck = 2
	subdepartment = SUBLOC_XENOBOT

/area/horizon/rnd/eva
	name = "EVA Preparation"
	icon_state = "blue"
	horizon_deck = 1

/area/horizon/rnd/xenoarch_atrium
	name = "Atrium"
	icon_state = "research"
	horizon_deck = 1
	subdepartment = SUBLOC_XENOARCH

/area/horizon/rnd/xenoarch_storage
	name = "Storage"
	icon_state = "purple"
	horizon_deck = 1
	subdepartment = SUBLOC_XENOARCH

/area/horizon/rnd/isolation_a
	name = "Anomaly Isolation A"
	icon_state = "blue"
	horizon_deck = 1
	subdepartment = SUBLOC_XENOARCH

/area/horizon/rnd/isolation_b
	name = "Anomaly Isolation B"
	icon_state = "red"
	horizon_deck = 1
	subdepartment = SUBLOC_XENOARCH

/area/horizon/rnd/isolation_c
	name = "Anomaly Isolation C"
	icon_state = "green"
	horizon_deck = 1
	subdepartment = SUBLOC_XENOARCH

/area/horizon/rnd/test_range
	name = "Weapons Testing Range"
	area_flags = AREA_FLAG_FIRING_RANGE
	horizon_deck = 1

/area/horizon/rnd/server
	name = "Server Room"
	icon_state = "server"
	horizon_deck = 2
