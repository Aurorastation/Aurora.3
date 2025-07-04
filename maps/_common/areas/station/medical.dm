
//MedBay

/area/medical
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	area_blurb = "Various smells waft through the air: disinfectants, various medicines, sterile gloves, and gauze. It's not a pleasant smell, but one you could grow to ignore."
	area_blurb_category = "mecical"

//Medbay is a large area, these additional areas help level out APC load.

/area/medical/paramedic
	name = "Medical - Paramedic Equipment Storage"
	icon_state = "medbay"

/area/medical/temp_morgue
	name = "Medical - Temporary Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/medical/biostorage
	name = "Medical - Secondary Storage"
	icon_state = "medbay2"

/area/medical/reception
	name = "Medical - Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/psych
	name = "Medical - Psych Room"
	icon_state = "medbay3"
	area_blurb = "Featuring wood floors and soft carpets, this room has a warmer feeling compared to the sterility of the rest of the medical department."
	area_blurb_category = "psych"

/area/medical/morgue
	name = "Medical - Long-term Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY
	area_blurb = "Morgue trays sit within this room, ready to hold the deceased until their postmortem wishes can be attended to."
	area_blurb_category = "morgue"

/area/medical/pharmacy
	name = "Medical - Pharmacy"
	icon_state = "phar"

/area/medical/surgery
	name = "Medical - Operating Theatre"
	icon_state = "surgery"
	no_light_control = 1

/area/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/medical/gen_treatment
	name = "Medical - General Treatment"
	icon_state = "cryo"

/area/medical/icu
	name = "Medical - Intensive Care Unit"
	icon_state = "cryo"
	area_blurb = "The sounds of pumps and cooling equipment can be heard within the room."
	area_blurb_category = "icu"

/area/medical/main_storage
	name = "Medical - Main Storage"
	icon_state = "exam_room"
