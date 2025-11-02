/// SCIENCE_AREAS
/area/horizon/rnd
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	department = LOC_SCIENCE
	horizon_deck = 2
	icon_state = "research"
	area_blurb = "The science sectors of the ship lend themselves to a clean, functional sterility; at least when everything is going well."

/area/horizon/rnd/conference
	name = "Conference Room"

/area/horizon/rnd/hallway
	name = "Hallway"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	lightswitch = TRUE
	location_ew = LOC_PORT

/area/horizon/rnd/hallway/secondary
	name = "Hallway"
	lightswitch = TRUE
	location_ns = LOC_AFT

/area/horizon/rnd/telesci
	name = "Telescience"

/area/horizon/rnd/chemistry
	name = "Exploratory Chemistry"
	icon_state = "chem"

/area/horizon/rnd/lab
	name = "Research & Development"
	icon_state = "toxlab"

/area/horizon/rnd/server
	name = "Server Room"
	icon_state = "server"

/area/horizon/rnd/xenological
	name = "Xenological Studies"
	icon_state = "xeno_log"

/area/horizon/rnd/xenobiology
	name = "Primary Laboratory"
	icon_state = "xeno_lab"
	subdepartment = SUBLOC_XENOBIO

/area/horizon/rnd/xenobiology/hazardous
	name = "Hazardous Containment"

/area/horizon/rnd/xenobiology/dissection
	name = "Dissection"

/area/horizon/rnd/xenobiology/foyer
	name = "Foyer"

/area/horizon/rnd/xenobiology/xenoflora
	name = "Grow Lab"
	icon_state = "xeno_f_lab"
	no_light_control = TRUE
	subdepartment = SUBLOC_XENOBOT

/area/horizon/rnd/test_range
	name = "Weapons Testing Range"
	area_flags = AREA_FLAG_FIRING_RANGE
	horizon_deck = 1

/area/horizon/rnd/eva
	name = "EVA Preparation"
	icon_state = "blue"
	horizon_deck = 1

/area/horizon/rnd/xenoarch
	name = "Xenoarchaology - PARENT AREA DO NOT USE"
	icon_state = "research"
	horizon_deck = 1
	subdepartment = SUBLOC_XENOARCH

/area/horizon/rnd/xenoarch/atrium
	name = "Atrium"

/area/horizon/rnd/xenoarch/storage
	name = "General Storage"
	icon_state = "purple"

/area/horizon/rnd/xenoarch/presentation
	name = "Xenoarchaeology Presentation"

/area/horizon/rnd/xenoarch/hallway/elevator
	name = "Xenoarchaeology Hallway"

/area/horizon/rnd/xenoarch/hallway/hangar
	name = "Xenoarchaeology Hanger Hallway"

/area/horizon/rnd/xenoarch/anomaly_storage
	name = "Artifact Storage"

/area/horizon/rnd/xenoarch/spectrometry
	name = "Spectrometry"

/area/horizon/rnd/xenoarch/isolation_a
	name = "Anomaly Isolation A"
	icon_state = "blue"

/area/horizon/rnd/xenoarch/isolation_b
	name = "Anomaly Isolation B"
	icon_state = "red"

/area/horizon/rnd/xenoarch/isolation_c
	name = "Anomaly Isolation C"
	icon_state = "green"
