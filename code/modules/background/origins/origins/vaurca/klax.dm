/singleton/origin_item/culture/klax
	name = "K'lax Hive"
	desc = "Known as 'The Deceivers', it was the second Hive discovered by humanity after their Hiveship, Klo'zxera, appeared in the Unathi system of Uueoa-Esa. K'lax is known as a client state of the Zo'ra, but since the Exodus from Sedantis they have struggled for political independence. Now parting their own ways, both Hives have developed differently. "
	possible_origins = list(
		/singleton/origin_item/origin/zkaii,
		/singleton/origin_item/origin/vetju,
		/singleton/origin_item/origin/leto,
		/singleton/origin_item/origin/vedhra,
		/singleton/origin_item/origin/tupii,
		/singleton/origin_item/origin/mikuetz,
		/singleton/origin_item/origin/queenless_klax
	)

/singleton/origin_item/origin/zkaii
	name = "Zkaii Brood"
	desc = "The new High Queen of the K'lax, the Zkaii Brood is often mocked for their eccentric Mother Dream religion. Many still remain within Tret and other Izweski territories."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_PILOTDREAM)

/singleton/origin_item/origin/vetju
	name = "Vetju Brood"
	desc = "Often regarded as a K'lax-supremacist brood, Vetju is also known for her engineers. The brood has recently expanded beyond Tret."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/singleton/origin_item/origin/leto
	name = "Leto Brood" //jared?
	desc = "The brood is mostly known for their archeological work and their production of k'ois in Pid, a moon near Tret."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_PILOTDREAM, RELIGION_NONE)

/singleton/origin_item/origin/vedhra
	name = "Vedhra Brood"
	desc = "One of the youngest Vaurca Queens, Vedhra wishes to unite the Vaurca civilization under Preimminence. The brood is also known for their augments and fascination with the Unathi culture. As with most K'lax broods, they mainly reside in Tret."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_PREIMMINENNCE)

/singleton/origin_item/origin/tupii
	name = "Tupii-K'lax Brood"
	desc = "The old K'lax brood, reinvigorated by the newly elected Queen Tupii. While older generations retain many customs of Mother K'lax, Tupii has attempted to modernize the brood and prove their loyalty."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_PREIMMINENNCE, RELIGION_HIVEPANTHEON)

/singleton/origin_item/origin/mikuetz
	name = "Mi'kuetz"
	desc = " A group of Queenless K'lax in the Moghesian Wasteland. They are known for their cheerfulness and their aid in the reconstruction of the Unathi home planet."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_PILOTDREAM, RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/queenless_klax
	name = "Queenless"
	desc = " A broad descriptor for the unrepresented groups in the Hive. The Breeders of the factions once belonged to forgotten broods or were foreign rulers that fell into the domain of the K'lax. The Yiaa'mak'tzut diaspora and other rebellious K'lax are spread across Izweski territory, Biesel, and even Eridani."
	possible_accents = list(ACCENT_KLAX, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_PILOTDREAM, RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_OTHER, RELIGION_NONE)
