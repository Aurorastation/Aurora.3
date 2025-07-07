/// SECURITY_AREAS
/area/horizon/security
	name = "Horizon - Security (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/horizon/security/lobby
	name = "Horizon - Security - Lobby"
	icon_state = "security"

/area/horizon/security/office
	name = "Horizon - Security - Office"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/hallway
	name = "Horizon - Security - Main Hallway"
	icon_state = "security"

/area/horizon/security/equipment
	name = "Horizon - Security - Equipment Room"
	icon_state = "security"

/area/horizon/security/washroom
	name = "Horizon - Security - Washroom"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/brig
	name = "Horizon - Security - Brig"
	icon_state = "brig"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PRISON
	ambience = AMBIENCE_HIGHSEC

/area/horizon/security/holding_cell_a
	name = "Horizon - Security - Holding Cell A"
	icon_state = "brig_proc"

/area/horizon/security/holding_cell_b
	name = "Horizon - Security - Holding Cell B"
	icon_state = "brig_proc_two"

/area/horizon/security/head_of_security
	name = "Horizon - Security - Head of Security's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/warden
	name = "Horizon - Security - Warden's Office"
	icon_state = "Warden"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/armoury
	name = "Horizon - Security - Armoury"
	icon_state = "Warden"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

// Security (Deck 3)
/area/horizon/security/investigations_hallway
	name = "Horizon - Security - Investigations Hallway"
	icon_state = "security"

/area/horizon/security/meeting_room
	name = "Horizon - Security - Meeting Room"
	icon_state = "security"

/area/horizon/security/firing_range
	name = "Horizon - Security - Firing Range"
	icon_state = "security"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/horizon/security/investigators_office
	name = "Horizon - Security - Investigators' Office"
	icon_state = "investigations_office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/horizon/security/interrogation
	name = "Horizon - Security - Interrogation"
	icon_state = "investigations"
	ambience = list(AMBIENCE_HIGHSEC, AMBIENCE_FOREBODING)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/interrogation/monitoring
	name = "Horizon - Security - Interrogation Monitoring"

/area/horizon/security/forensic_laboratory
	name = "Horizon - Security - Forensic Laboratory"
	icon_state = "investigations"

/area/horizon/security/autopsy_laboratory
	name = "Horizon - Security - Autopsy Laboratory"
	icon_state = "investigations"
	ambience = list(AMBIENCE_GHOSTLY, AMBIENCE_FOREBODING)

/area/horizon/security/evidence_storage
	name = "Horizon - Security - Evidence Storage"
	icon_state = "evidence"
	ambience = AMBIENCE_FOREBODING
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"
	no_light_control = 0

/area/horizon/security/checkpoint2
	name = "Security - Arrivals Checkpoint"
	icon_state = "security"
	ambience = AMBIENCE_ARRIVALS
