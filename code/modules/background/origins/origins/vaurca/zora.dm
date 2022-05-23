/decl/origin_item/culture/zora
	name = "Zo'ra Hive"
	desc = "Known as 'the Unstoppable', Zo'ra is the largest and most powerful Hive. It was discovered by humanity following the spotting of their Hiveship, dubbed as 'Titan Prime'. Zo'ra themselves to be the best of their species, and the face of the Vaurca as a whole. They have settled mainly in Tau Ceti across multiple planets including Biesel, New Gibson, Luthien and Caprice. The latter two are official colonies of the hive, with the Zo'ra's \"Capital\" of New Sedantis residing on Caprice, along with the reformed Court of Queens chambers."
	possible_origins = list(
		/decl/origin_item/origin/zoleth,
		/decl/origin_item/origin/scay,
		/decl/origin_item/origin/vaur,
		/decl/origin_item/origin/xakt,
		/decl/origin_item/origin/athvur,
		/decl/origin_item/origin/queenless_zora
	)

/decl/origin_item/origin/zoleth
	name = "Zoleth Brood"
	desc = "The Warrior brood of the Zo'ra, Zoleth is established in Caprice, Tau Ceti. Although feared as a warmonger, the Zoleth Brood is known for their diplomacy."
	possible_accents = list(ACCENT_ZORA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/decl/origin_item/origin/scay
	name = "Scay Brood"
	desc = "The scientific brood of the Zo'ra, Scay is established in the Xerxes Biodome, New Gibson. The Queen is reluctant and eccentric, qualities shared with her brood."
	possible_accents = list(ACCENT_ZORA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/decl/origin_item/origin/vaur
	name = "Vaur Brood"
	desc = "The brood of the current High Queen. While Queen Vaur now resides in Caprice, most of her subjects remain in Flagsdale, Mendell City."
	possible_accents = list(ACCENT_ZORA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/decl/origin_item/origin/xakt
	name = "Xakt Brood"
	desc = "Located in Luthien, Tau Ceti, the brood is mostly Bound Workers in industrial roles."
	possible_accents = list(ACCENT_ZORA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/decl/origin_item/origin/athvur
	name = "Athvur Brood"
	desc = "Athvur is a unique brood, as it has assimilated plenty of human customs. While the brood originally resided in Phoenixport, Biesel, they have relocated to Belle Côte."
	possible_accents = list(ACCENT_ZORA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/decl/origin_item/origin/queenless_zora
	name = "Queenless"
	desc = "A broad descriptor for the unrepresented groups in the Hive. The Breeders of the factions once belonged to forgotten broods or were foreign rulers that fell into the domain of the Zo'ra. Most of the Queenless Vaurcae live impoverished in Flagsdale, Mendell City."
	possible_accents = list(ACCENT_ZORA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_OTHER, RELIGION_NONE)