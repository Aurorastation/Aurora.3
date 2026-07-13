/singleton/origin_item/culture/axiom
	name = "Axiom"
	desc = "Axiom is a term for a planet - known also as Orepit to the otuside world, and \
	as Nu'u to the indigenous Salamasian population - and also for the Ecclesiastical Authority \
	of Axiom, a theocratic state administrated by the Trinary Perfection, which controls swathes \
	of the planet's deserts. All arable land on the planet is administrated by the Salamasian Republic, \
	a population predating the Trinarist settlement of the planet by over a century and which shares \
	power with their new neighbors with degrees of caution and mutual ambition."
	possible_origins = list(
		/singleton/origin_item/origin/ipc_axiom,
		/singleton/origin_item/origin/ipc_salamasian
	)

/singleton/origin_item/origin/ipc_axiom
	name = "Ecclesiastical Axiomite"
	desc = "Boasting a majority synthetic population, Ecclesiastical Axiom is one of the only \
	nation-states which totally prohibits synthetic ownership. Administered directly by the \
	Ecclesiarch of the Trinary Perfection, who rules their territory as an elective absolute \
	monarch, this is one of the few true sanctuaries for the represssed and dispossessed synthetics \
	of the Orion Spur, although that is no promise that life is easy. The Ecclesiastical Authority of \
	Axiom has only domain over the deserts of its planet, while all arable hand is governed by the \
	Salamasian Republic, a majority human nation of colonists brought over by Hephaestus Industries \
	over a century prior to the influx of Trinarist settlers. Both the humans and synthetics are known \
	for their aversion to violence, their strong community spirit, and a stringent dedication to the \
	tenets of the Trinary Perfection - though not all follow the state religion, and not all follow \
	it devoutly."
	possible_accents = list(ACCENT_AXIOM, ACCENT_CETI, ACCENT_TTS, ACCENT_XANU, ACCENT_COC, ACCENT_ELYRA, ACCENT_ERIDANI, ACCENT_ERIDANIDREG, ACCENT_ERIDANIREINSTATED, ACCENT_SOL, ACCENT_SILVERSUN_EXPATRIATE, ACCENT_SILVERSUN_ORIGINAL, ACCENT_PHONG, ACCENT_MARTIAN, ACCENT_KONYAN, ACCENT_LUNA, ACCENT_GIBSON, ACCENT_HIMEO, ACCENT_VYSOKA, ACCENT_VENUS, ACCENT_VENUSJIN, ACCENT_JUPITER, ACCENT_CALLISTO, ACCENT_EUROPA, ACCENT_EARTH, ACCENT_NCF, ACCENT_PLUTO, ACCENT_ASSUNZIONE, ACCENT_VISEGRAD, ACCENT_SANCOLETTE, ACCENT_VALKYRIE, ACCENT_MICTLAN, ACCENT_PERSEPOLIS, ACCENT_MEDINA, ACCENT_NEWSUEZ, ACCENT_AEMAQ, ACCENT_DAMASCUS)
	possible_citizenships = list(CITIZENSHIP_AXIOM)
	possible_religions = RELIGIONS_ALL_IPC

/singleton/origin_item/origin/ipc_salamasian
	name = "Republican Salamasian"
	desc = "The seniormost population of their planet, the Salamasians are a culture descended primarily \
	from the people of Samoa, who were brought under the employ of Hephaestus Industries to the mining world \
	which would become known to them as Nu'u for mineral extraction operations. Hardy and family-focused, the \
	Salamasian Republic is a nation dominated by blue collar industry, to this day functioning as a major exporter \
	of raw and processed minerals even over a century after Hephaestus left the planet. A small population of synthetics \
	have integrated into the culture seperately to the Trinarist settlement of the main planet, though they are not \
	unanimously accepted due to their inability to perfectly fit into the 'aiga family unit which dominates social \
	and political life within the Republic."
	important_information = "<b>Due to their integration into the wider culture of the Salamasian Republic, \
	which descends from Samoan colonists, synthetics from the Salamasian Republic must also align, if applicable, \
	to the culture of their surroundings. Shells who have acclimatised to the Republic will have adopted \
	an appearance which matches, if loosely, their human peers.</b>"
	possible_accents = list(ACCENT_SALAMASIAN)
	possible_citizenships = list(CITIZENSHIP_AXIOM)
	possible_religions = RELIGIONS_ALL_IPC
