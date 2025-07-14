/// SERVICE_AREAS
/area/horizon/service
	name = "Service (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	department = LOC_SERVICE

/// Hydroponics areas
/area/horizon/service/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"
	horizon_deck = 2

/area/horizon/service/hydroponics/lower
	name = "Hydroponics"
	horizon_deck = 1

/area/horizon/service/hydroponics/garden
	name = "Public Garden"
	icon_state = "garden"
	horizon_deck = 2

/// Library areas
/area/horizon/service/library
	name = "Library"
	icon_state = "library"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	horizon_deck = 2

/// Kitchen areas
/area/horizon/service/kitchen
	name = "Kitchen"
	icon_state = "kitchen"
	allow_nightmode = FALSE
	horizon_deck = 2

/area/horizon/service/kitchen/freezer
	name = "Kitchen - Freezer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/// Bar areas
/area/horizon/service/bar
	name = "Bar"
	icon_state = "bar"
	horizon_deck = 2

/area/horizon/service/bar/backroom
	name = "Bar - Backroom"
	area_flags = AREA_FLAG_RAD_SHIELDED

// Dining Hall
/area/horizon/service/dining_hall
	name = "Dining Hall"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	horizon_deck = 2

// Cafeteria
/area/horizon/service/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"
	area_blurb = "The smell of coffee wafts over from the cafe. Patience, the tree, stands proudly in the centre of the atrium."
	area_blurb_category = "d3_cafe"
	horizon_deck = 3

// Custodial areas
/area/horizon/service/custodial
	name = "Custodial Closet"
	icon_state = "janitor"
	allow_nightmode = FALSE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = list(AMBIENCE_FOREBODING, AMBIENCE_ENGINEERING)
	area_blurb = "A strong, concentrated smell of many cleaning supplies linger within this room."
	area_blurb_category = "janitor"
	horizon_deck = 1

/area/horizon/service/custodial/disposals
	name = "Disposals and Recycling (PARENT AREA - DON'T USE)"
	icon_state = "disposal"
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS) // Industrial sounds.
	area_blurb = "A large trash compactor takes up much of the room, ready to crush the ship's rubbish."
	area_blurb_category = "trash_compactor"

/area/horizon/service/custodial/disposals/deck_1
	name = "Disposals and Recycling"
	horizon_deck = 1

/area/horizon/service/custodial/disposals/deck_2
	name = "Disposals and Recycling"
	horizon_deck = 2

/area/horizon/service/custodial/auxiliary
	name = "Auxiliary Custodial Closet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/service/chapel
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_CHAPEL
	horizon_deck = 2

/area/horizon/service/chapel/main
	name = "Chapel"
	icon_state = "chapel"

/area/horizon/service/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
