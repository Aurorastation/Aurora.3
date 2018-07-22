/area/assembly
	station_area = 1

/area/assembly/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "\improper Assembly Line"
	icon_state = "ass_line"
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
	name = "\improper Research - Miscellaneous Research"
	icon_state = "toxmisc"

/area/rnd/test_range
	name = "\improper Research - Weapons Testing Range"
	flags = FIRING_RANGE

/area/toxins
	station_area = 1

/area/toxins/server
	name = "\improper Research - Server Room"
	icon_state = "server"
	station_area = 1
