/singleton/origin_item/culture/axiom
	name = "Axiom"
	desc = "Axiom - also known as Orepit to the outside world - is governed by the Ecclesiastical \
	Authority of Axiom, the theocratic state administered by the Trinary Perfection who control \
	the swathes of the planet's equatorial desert. It is shared by the indigenous Salamasian \
	population who know the planet as Nu'u, predating the arrival of Trinarists by over a century. \
	Their government, through the Salamasian Republic, occupies the arable northern and southern \
	hemispheres. This duo of neighbors shares power over the former Hephaestus colony with degrees \
	of both caution and mutual ambition."
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
	possible_accents = list(ACCENT_AXIOM, ACCENT_CETI, ACCENT_TTS, ACCENT_XANU, ACCENT_COC, ACCENT_ELYRA, ACCENT_ERIDANI, ACCENT_ERIDANIDREG, ACCENT_ERIDANIREINSTATED, ACCENT_SOL, ACCENT_SILVERSUN_EXPATRIATE, ACCENT_SILVERSUN_ORIGINAL, ACCENT_PHONG, ACCENT_MARTIAN, ACCENT_KONYAN, ACCENT_LUNA, ACCENT_GIBSON, ACCENT_HIMEO, ACCENT_VYSOKA, ACCENT_VENUS, ACCENT_VENUSJIN, ACCENT_JUPITER, ACCENT_CALLISTO, ACCENT_EUROPA, ACCENT_EARTH, ACCENT_NCF, ACCENT_PLUTO, ACCENT_ASSUNZIONE, ACCENT_VISEGRAD, ACCENT_SANCOLETTE, ACCENT_VALKYRIE, ACCENT_MICTLAN, ACCENT_PERSEPOLIS, ACCENT_MEDINA, ACCENT_NEWSUEZ, ACCENT_AEMAQ, ACCENT_DAMASCUS, ACCENT_READE)
	possible_citizenships = list(CITIZENSHIP_AXIOM)
	possible_religions = RELIGIONS_ALL_IPC

/singleton/origin_item/origin/ipc_salamasian
	name = "Republican Salamasian"
	desc = "The original population of the planet, the Salamasians are a culture descended primarily from the \
	people of Samoa and America Samoa, brought under the employ of Hephaestus Industries to the mining world \
	they would name Nu'u for mineral extraction. Traditionalist and family-focused, the Salamasian Republic is \
	a nation dominated by blue collar industry, historically operating as a major exporter of raw and processed \
	minerals, a lucrative market to this day. A small population of synthetics have integrated into Salamasian \
	culture separately from Trinarist settlement of Axiom, who face difficulty gaining unanimous acceptance into \
	the 'aiga family unit that dominates social and political life within the Republic."
	important_information = "<b>Due to the assimilation of Synthetics into the Samoan-derived culture of the \
	Salamasian Republic, IPCs must align where possible to the culture of their inhabitants. Shells who have \
	acclimated to the Republic will have appearances consistent with their organic counterparts.</b>"
	possible_accents = list(ACCENT_SALAMASIAN)
	possible_citizenships = list(CITIZENSHIP_AXIOM)
	possible_religions = RELIGIONS_ALL_IPC
