/*
	/// Only used for the Horizon, and mostly for mapping checks.
	var/horizon_deck = null
	/// Only used for the Horizon, and mostly for mapping checks.
	var/department = null
	/// Only used for the Horizon, and mostly for mapping checks.
	var/subdepartment = null
*/

/area/horizon/ai
	name = "AI Area (PARENT AREA - DON'T USE)"
	icon_state = "ai_chamber"
	ambience = AMBIENCE_AI
	horizon_deck = 3
	department = "LOC_AI"

/area/horizon/ai/chamber
	name = "AI Chamber"
	department = "LOC_AI"

/area/horizon/ai/upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/horizon/ai/upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
