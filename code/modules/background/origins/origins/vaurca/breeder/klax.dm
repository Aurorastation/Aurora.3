/singleton/origin_item/culture/klax_breeder
	name = "K'lax Hive"
	desc = "The new High Queen of the K'lax, the Zkaii Brood is often mocked for their eccentric Mother Dream religion. Many still remain within Tret and other Izweski territories."
	possible_origins = list(
		/singleton/origin_item/origin/zkaii_b,
		/singleton/origin_item/origin/leto_b,
		/singleton/origin_item/origin/vedhra_b,
		/singleton/origin_item/origin/tupii_b
	)

/singleton/origin_item/origin/zkaii_b
	name = "Zkaii Brood"
	desc = "The new High Queen of the K'lax, the Zkaii Brood is often mocked for their eccentric Mother Dream religion. Many still remain within Tret and other Izweski territories."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_KLAX)
	possible_religions = list(RELIGION_PILOTDREAM)

/singleton/origin_item/origin/leto_b
	name = "Leto Brood" //jared?
	desc = "The brood is mostly known for their archeological work and their production of k'ois in Pid, a moon near Tret."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_KLAX)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_PILOTDREAM, RELIGION_NONE)

/singleton/origin_item/origin/vedhra_b
	name = "Vedhra Brood"
	desc = "One of the youngest Vaurca Queens, Vedhra wishes to unite the Vaurca civilization under Preimminence. The brood is also known for their augments and fascination with the Unathi culture. As with most K'lax broods, they mainly reside in Tret."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_KLAX)
	possible_religions = list(RELIGION_PREIMMINENNCE)

/singleton/origin_item/origin/tupii_b
	name = "Tupii-K'lax Brood"
	desc = "The old K'lax brood, reinvigorated by the newly elected Queen Tupii. While older generations retain many customs of Mother K'lax, Tupii has attempted to modernize the brood and prove their loyalty."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_KLAX)
	possible_religions = list(RELIGION_PREIMMINENNCE, RELIGION_HIVEPANTHEON)
