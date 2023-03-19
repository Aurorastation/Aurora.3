/singleton/origin_item/culture/unknown
	name = "Unknown"
	desc = "You are not sure where you come from."
	possible_origins = list(
		/singleton/origin_item/origin/unknown
	)

/singleton/origin_item/origin/unknown
	name = "Unknown"
	desc = "You're not sure where exactly you come from."
	possible_accents = list(ACCENT_CETI, ACCENT_BLUESPACE, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)

/singleton/origin_item/culture/golem
	name = "Golem"
	desc = "You are a Golem."
	possible_origins = list(
		/singleton/origin_item/origin/unknown
	)

/singleton/origin_item/origin/golem
	name = "Golem"
	desc = "You're a Golem."
	possible_accents = list(ACCENT_BLUESPACE)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)