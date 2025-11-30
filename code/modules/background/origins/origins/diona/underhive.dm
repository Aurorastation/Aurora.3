/singleton/origin_item/culture/diona_eridani
	name = "Underhive Collective"
	desc = "The Underhive Collective is an elusive community of Dionae gestalts endemic to the Eridani Federation. Initially smuggled in to fuel a burgeoning drug trade, \
			the ones that escaped it managed to organize into a business-oriented secretive society of syndicated interests."
	possible_origins = list(
		/singleton/origin_item/origin/mycelumias,
		/singleton/origin_item/origin/glowcaps,
		/singleton/origin_item/origin/sporeveils
	)

/singleton/origin_item/origin/mycelumias
	name = "Mycelumias"
	desc = "The Mycelumias, or just Lumias, are a renowned Aphrodite syndicate within the underbelly of the Eridani Federation in Den. Some have claimed that it has operated since the creation of the trade."
	possible_accents = list(ACCENT_UNDERSONG)
	possible_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL_IRON)

/singleton/origin_item/origin/glowcaps
	name = "Glowcaps"
	desc = "Residing in New Kivu, the Glowcaps are significantly smaller than the Lumias. They were originally part of the Lumias, seceding later due to differences in business practices and values."
	possible_accents = list(ACCENT_UNDERSONG)
	possible_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL)

/singleton/origin_item/origin/sporeveils
	name = "Sporeveils"
	desc = "The Sporeveils are the smallest syndicate, but also the most vicious, with numerous attacks against Suits and Dregs alike under their belt. Like the Lumias, they reside in Den."
	important_information = "Characters are allowed to be from the Sporeveils, but only in secret. They are an antagonistic entity within the lore, and no megacorporation would hire a Diona openly displaying such an allegiance."
	possible_accents = list(ACCENT_UNDERSONG)
	possible_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL_ICHOR)
