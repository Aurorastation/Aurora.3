
//MedBay

/area/medical
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/medical/medbay
	name = "\improper Medbay Hallway - Port"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

//Medbay is a large area, these additional areas help level out APC load.

/area/medical/emt
	name = "\improper Medical - Emergency Technician Storage"
	icon_state = "medbay"

/area/medical/temp_morgue
	name = "\improper Medical - Temporary Morgue"
	icon_state = "morgue"

/area/medical/medbay2
	name = "\improper Medbay Hallway - Starboard"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/medbay3
	name = "\improper Medbay Hallway - Fore"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/medbay4
	name = "\improper Medbay Hallway - Staff Wing"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/biostorage
	name = "\improper Medical - Secondary Storage"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/reception
	name = "\improper Medical - Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/psych
	name = "\improper Medical - Psych Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/crew_quarters/medbreak
	name = "\improper Medical - Break Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/patients_rooms
	name = "\improper Medical - Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "\improper Medical - Recovery Ward"
	icon_state = "patients"

/area/medical/patient_a
	name = "\improper Medical - Isolation A"
	icon_state = "patients"

/area/medical/patient_b
	name = "\improper Medical - Isolation B"
	icon_state = "patients"

/area/medical/patient_c
	name = "\improper Medical - Isolation C"
	icon_state = "patients"

/area/medical/patient_wing
	name = "\improper Medical - Patient Wing"
	icon_state = "patients"

/area/medical/cmostore
	name = "\improper Secure Storage"
	icon_state = "CMO"

/area/medical/robotics
	name = "\improper Robotics"
	icon_state = "medresearch"

/area/medical/virology
	name = "\improper Medical - Virology"
	icon_state = "virology"

/area/medical/virologyaccess
	name = "\improper Medical - Virology Access"
	icon_state = "virology"

/area/medical/morgue
	name = "\improper Medical - Long-term Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg','sound/music/main.ogg')

/area/medical/chemistry
	name = "\improper Medical - Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "\improper Medical - Operating Theatre"
	icon_state = "surgery"
	no_light_control = 1

/area/medical/surgeryobs
	name = "\improper Medical - Operation Observation Room"
	icon_state = "surgery"

/area/medical/surgeryprep
	name = "\improper Medical - Pre-Op Prep Room"
	icon_state = "surgery"

/area/medical/surgerywing
	name = "\improper Medical - Surgery Wing"
	icon_state = "surgery"

/area/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

/area/medical/gen_treatment
	name = "\improper Medical - General Treatment"
	icon_state = "cryo"

/area/medical/exam_room
	name = "\improper Medical - Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/medical/genetics_cloning
	name = "\improper Medical - Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "\improper Medical - Emergency Treatment Centre"
	icon_state = "exam_room"
	no_light_control = 1

/area/medical/icu
	name = "\improper Medical -  Intensive Care Unit"
	icon_state = "cryo"
