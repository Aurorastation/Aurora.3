/// MEDICAL_AREAS
/area/horizon/medical
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	area_blurb = "Various smells waft through the air: disinfectants, various medicines, sterile gloves, and gauze. It's not a pleasant smell, but one you could grow to ignore."
	area_blurb_category = "mecical"
	department = LOC_MEDICAL

/area/horizon/medical/paramedic
	name = "Paramedic Equipment Storage"
	icon_state = "medbay"
	horizon_deck = 3

/area/horizon/medical/reception
	name = "Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')
	horizon_deck = 2

// Rad-shielded because its annoying as fuck
/area/horizon/medical/psych
	name = "Psych Office"
	icon_state = "medbay3"
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "Featuring wood floors and soft carpets, this room has a warmer feeling compared to the sterility of the rest of the medical department."
	area_blurb_category = "psych"
	horizon_deck = 2

/area/horizon/medical/pharmacy
	name = "Pharmacy"
	icon_state = "phar"
	horizon_deck = 2

/area/horizon/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"
	horizon_deck = 2

/area/horizon/medical/gen_treatment
	name = "General Treatment"
	icon_state = "cryo"
	horizon_deck = 2

/area/horizon/medical/icu
	name = "Intensive Care Unit"
	icon_state = "cryo"
	area_blurb = "The sounds of pumps and cooling equipment can be heard within the room."
	horizon_deck = 2

/area/horizon/medical/main_storage
	name = "Main Storage"
	icon_state = "exam_room"
	horizon_deck = 2

/area/horizon/medical/surgery
	name = "Operating Theatre"
	icon_state = "surgery"
	horizon_deck = 2

/area/horizon/medical/surgery/storage
	name = "Operating Theatre Storage"
	icon_state = "surgery"
	no_light_control = 1
	horizon_deck = 2

/area/horizon/medical/exam
	name = "Examination Room"
	icon_state = "exam_room"
	horizon_deck = 2

// Contains a player spawn area = rad-shielded
/area/horizon/medical/ward
	name = "Recovery Ward"
	area_flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "patients"
	horizon_deck = 2

/area/horizon/medical/ward/isolation
	name = "Isolation Ward"
	area_blurb = "This seldom-used ward somehow smells sterile and musty at the same time."
	area_blurb_category = "medical_isolation"
	horizon_deck = 3

/area/horizon/medical/emergency_storage
	name = "Emergency Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 1

/area/horizon/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY
	area_blurb = "Morgue trays sit within this room, ready to hold the deceased until their postmortem wishes can be attended to."
	area_blurb_category = "morgue"
	horizon_deck = 1

/area/horizon/medical/equipment
	name = "Equipment Room"
	horizon_deck = 3

/area/horizon/medical/smoking
	name = "Smoking Lounge"
	area_blurb = "The smell of cigarette smoke lingers within this room."
	area_blurb_category = "medical_smoking"
	horizon_deck = 3

/area/horizon/medical/washroom
	name = "Washroom"
	horizon_deck = 3
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/medical/hallway
	name = "Atrium"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	icon_state = "medbay"
	horizon_deck = 2

/area/horizon/medical/hallway/upper
	name = "Upper Atrium"
	horizon_deck = 3
