/singleton/origin_item/culture/non_federation_sol
	name = "Solarian Alliance Skrell"
	desc = "With First Contact with humanity, the skrell saw the opportunity to explore and learn, and many decided to emigrate to human space. \
	The Solarian Alliance has remained the first and closest ally of the Nralakk Federation, and saw the first waves of skrell integrating into their societies and planets. \
	These communities and enclaves have since grown and developed throughout the tumultuous breakaways of their new homes, \
	and the distance from the Federation has allowed for unique cultures to develop away from their original nation."
	possible_origins = list(
		/singleton/origin_item/origin/skrell_alliance,
		/singleton/origin_item/origin/skrell_europa,
		/singleton/origin_item/origin/skrell_mictlan,
		/singleton/origin_item/origin/skrell_silversun,
		/singleton/origin_item/origin/skrell_venus
	)

/singleton/origin_item/origin/skrell_alliance
	name = "Sol Alliance"
	desc = "With first contact with Humanity, many skrell elected to move into human space. \
	The Nralakk Federation and the Sol Alliance have been historic allies, and a large majority of skrell living outside of the Federation calls the Sol Alliance home."
	important_information = "The Nralakk Federation is known to use its relationship with the Sol Alliance to step in when skrell citizens are deemed dangerous to its national security."
	possible_accents = list(ACCENT_SKRELLSOL)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_CONSORTIUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/skrell_venus
	name = "Venus"
	desc = "With first contact with Humanity, many skrell elected to move into human space. \
	The aerostats of Venus are typically not a permanent home for skrell, but among the many Skrellian Stars and Washouts roosting in the entertainment capital, \
	some decided to settle down and form families here. The newer generations of Venusian skrell have integrated into either the more stoic and labor-focused Jintarian communities, \
	or have embraced the loud and hedonistic noise of the Cytherean lifestyle."
	important_information = "The Nralakk Federation is known to use its relationship with the Sol Alliance to step in when skrell citizens are deemed dangerous to its national security."
	possible_accents = list(ACCENT_SKRELLSOL, ACCENT_SKRELLVENUS, ACCENT_SKRELLVENUSJIN)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_CONSORTIUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_ALCOHOL_RESISTANCE, TRAIT_ORIGIN_DRUG_RESISTANCE)
	origin_traits_descriptions = list("have a higher alcoholic tolerance", "have a higher tolerance to recreative drugs")

/singleton/origin_item/origin/skrell_europa
	name = "Europa"
	desc = "With first contact with Humanity, many skrell elected to move into human space. \
	While Europa's frigid depths and cold exterior was unfavorable before, their psionic abilities to navigate the depths made them invaluable to its industry, \
	and were drawn in to live on the icy moon by lucrative contracts to become psionic navigators. While far from luxurious, \
	the dedicated crewmembers and adrenaline junkies laid their stakes here, and formed the local skrell population on Europa that remains to this day."
	important_information = "The Nralakk Federation is known to use its relationship with the Sol Alliance to step in when skrell citizens are deemed dangerous to its national security."
	possible_accents = list(ACCENT_SKRELLSOL, ACCENT_SKRELLEUROPA)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_CONSORTIUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/skrell_silversun
	name = "Silversun"
	desc = "With first contact with Humanity, many skrell elected to move into human space. \
	Considered scientifically remarkable and quite comfortable with its tropical climate and rainy seasons, \
	the wave of skrell tourists and researchers are considered the source of (and often blamed for) the tourism boom that led to Silversun's fame as a vacation destination in the modern day. \
	Silversun's skrell enclaves are notable in being the largest Primary Numericals and Idol communities, with only Venus being comparable in number. \
	Helios City hosts a majority of the skrell on Silversun, being the beating heart of the planet's education and research, particularly The Helios City Institute of Botanical Sciences, \
	with Yincheng a close second due to its growing technology industry."
	important_information = "The Nralakk Federation is known to use its relationship with the Sol Alliance to step in when skrell citizens are deemed dangerous to its national security."
	possible_accents = list(ACCENT_SKRELLSOL, ACCENT_SKRELLSILVERSUN)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_CONSORTIUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_HOT_RESISTANCE)
	origin_traits_descriptions = list("are more acclimatised to the heat")

/singleton/origin_item/origin/skrell_mictlan
	name = "Mictlan"
	desc = "With first contact with Humanity, many skrell elected to move into human space. \
	Originally a wave of researchers monitoring the unique ecology of Mictlan, the descendents of these insular research groups who remained have adapted and involved themselves in Mictlan's energetic, communal culture. \
	Whether still huddled in academic circles or integrated in the planet's broader, turbulent society, the skrell families on Mictlan are there to stay."
	important_information = "Skrell living in the Republic of Biesel are protected from deportation to the Nralakk Federation if they renounce their Nralakk citizenship and join the Tau Ceti Foreign Legion."
	possible_accents = list(ACCENT_SKRELLCETI, ACCENT_SKRELLMICTLAN)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_CONSORTIUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_IGNORE_CAPSAICIN)
	origin_traits_descriptions = list("are not affected by spicy foods")
