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
	department = LOC_AI
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	area_blurb = "Ticking, beeping, and buzzing. Great tides of invisible signal traffic across the electromagnetic spectrum, flowing in both directions. Otherwise, the silence and stillness of a tomb."

/area/horizon/ai/chamber
	name = "AI Chamber"

/area/horizon/ai/upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/horizon/ai/upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
