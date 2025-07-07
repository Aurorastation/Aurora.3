/// MEDICAL_AREAS
/area/horizon/medical
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	area_blurb = "Various smells waft through the air: disinfectants, various medicines, sterile gloves, and gauze. It's not a pleasant smell, but one you could grow to ignore."
	area_blurb_category = "mecical"

//Medbay is a large area, these additional areas help level out APC load.

/area/horizon/medical/paramedic
	name = "Medical - Paramedic Equipment Storage"
	icon_state = "medbay"

/area/horizon/medical/temp_morgue
	name = "Medical - Temporary Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/horizon/medical/biostorage
	name = "Medical - Secondary Storage"
	icon_state = "medbay2"

/area/horizon/medical/reception
	name = "Medical - Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/horizon/medical/psych
	name = "Medical - Psych Room"
	icon_state = "medbay3"
	area_blurb = "Featuring wood floors and soft carpets, this room has a warmer feeling compared to the sterility of the rest of the medical department."
	area_blurb_category = "psych"

/area/horizon/medical/morgue
	name = "Medical - Long-term Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY
	area_blurb = "Morgue trays sit within this room, ready to hold the deceased until their postmortem wishes can be attended to."
	area_blurb_category = "morgue"

/area/horizon/medical/pharmacy
	name = "Medical - Pharmacy"
	icon_state = "phar"

/area/horizon/medical/surgery
	name = "Medical - Operating Theatre"
	icon_state = "surgery"
	no_light_control = 1

/area/horizon/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/horizon/medical/gen_treatment
	name = "Medical - General Treatment"
	icon_state = "cryo"

/area/horizon/medical/icu
	name = "Medical - Intensive Care Unit"
	icon_state = "cryo"
	area_blurb = "The sounds of pumps and cooling equipment can be heard within the room."
	area_blurb_category = "icu"

/area/horizon/medical/main_storage
	name = "Medical - Main Storage"
	icon_state = "exam_room"

/area/horizon/medical/ors
	name = "Medical - Combined Operating Rooms"
	icon_state = "surgery"

/area/horizon/medical/exam
	name = "Medical - Examination Room"
	icon_state = "exam_room"

/area/horizon/medical/ward
	name = "Medical - Ward"
	icon_state = "patients"

/area/horizon/medical/ward/isolation
	name = "Medical - Isolation Ward"
	area_blurb = "This seldom-used ward somehow smells sterile and musty at the same time."
	area_blurb_category = "medical_isolation"

/area/horizon/medical/emergency_storage
	name = "Medical - Lower Deck Emergency Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/medical/morgue/lower
	name = "Medical - Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/horizon/medical/equipment
	name = "Medical - Equipment Room"

/area/horizon/medical/smoking
	name = "Medical - Smoking Lounge"
	area_blurb = "The smell of cigarette smoke lingers within this room."
	area_blurb_category = "medical_smoking"

/area/horizon/medical/washroom
	name = "Medical - Washroom"

/area/horizon/medical/hallway
	name = "Medical - Atrium"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	icon_state = "medbay"

/area/horizon/medical/hallway/upper
	name = "Medical - Upper Atrium"
