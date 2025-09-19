/// SECURITY_AREAS
/area/horizon/security
	name = "Security (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY
	department = LOC_SECURITY
	area_blurb = "Every sound seems to echo just a little louder and more threateningly in the Security sectors of the SCCV Horizon."

/area/horizon/security/lobby
	name = "Lobby"
	icon_state = "security"
	horizon_deck = 2

/area/horizon/security/office
	name = "Office"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/security/hallway
	name = "Main Hallway"
	icon_state = "security"
	horizon_deck = 2

/area/horizon/security/equipment
	name = "Equipment Room"
	icon_state = "security"
	horizon_deck = 2

/area/horizon/security/washroom
	name = "Washroom"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED
	horizon_deck = 2

/area/horizon/security/brig
	name = "Brig"
	icon_state = "brig"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PRISON
	ambience = AMBIENCE_HIGHSEC
	horizon_deck = 2

/area/horizon/security/holding_cell_a
	name = "Holding Cell A"
	icon_state = "brig_proc"
	horizon_deck = 2

/area/horizon/security/holding_cell_b
	name = "Holding Cell B"
	icon_state = "brig_proc_two"
	horizon_deck = 2

/area/horizon/security/warden
	name = "Warden's Office"
	icon_state = "Warden"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/security/armoury
	name = "Armoury"
	icon_state = "Warden"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	horizon_deck = 2

/area/horizon/security/investigations_hallway
	name = "Investigations Hallway"
	icon_state = "security"
	horizon_deck = 3

// Security (Deck 3)
/area/horizon/security/meeting_room
	name = "Meeting Room"
	icon_state = "security"
	horizon_deck = 3

/area/horizon/security/firing_range
	name = "Firing Range"
	icon_state = "security"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	horizon_deck = 3

/area/horizon/security/investigators_office
	name = "Investigators' Office"
	icon_state = "investigations_office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	horizon_deck = 3

/area/horizon/security/interrogation
	name = "Interrogation"
	icon_state = "investigations"
	ambience = list(AMBIENCE_HIGHSEC, AMBIENCE_FOREBODING)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 3

/area/horizon/security/interrogation/monitoring
	name = "Interrogation Monitoring"
	ambience = list(AMBIENCE_HIGHSEC)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 3

/area/horizon/security/forensic_laboratory
	name = "Forensic Laboratory"
	icon_state = "investigations"
	horizon_deck = 3

/area/horizon/security/autopsy_laboratory
	name = "Autopsy Laboratory"
	icon_state = "investigations"
	ambience = list(AMBIENCE_GHOSTLY, AMBIENCE_FOREBODING)
	horizon_deck = 3

/area/horizon/security/evidence_storage
	name = "Evidence Storage"
	icon_state = "evidence"
	ambience = AMBIENCE_FOREBODING
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 3

/area/horizon/security/checkpoint
	name = "Hangar Checkpoint"
	icon_state = "checkpoint1"
	no_light_control = 0
	horizon_deck = 1
	area_blurb = "A functional, unfriendly-looking compartment."

/area/horizon/security/checkpoint2
	name = "Arrivals Checkpoint"
	icon_state = "security"
	ambience = AMBIENCE_ARRIVALS
	horizon_deck = 2
	area_blurb = "A functional, unfriendly-looking compartment."
