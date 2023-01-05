/decl/origin_item/culture/diona_dominia
	name = "Empire of Dominia"
	desc = "The Empire of Dominia (often simply referred to as \"the Empire\") is an autocratic monarchy that is heavily influenced by its state religion, the Moroz Holy Tribunal, which is often regarded as an offshoot of old Earth faiths. Imperial society is sharply divided between Morozians, which are themselves divided between noble Primaries and commoner Secondaries, and Ma'zals, which make up the population of its conquered worlds. Militaristic and expansionist, the Empire has been increasingly brought into conflict with its neighbors: the Serene Republic of Elyra and Coalition of Colonies. Dominians are often stereotyped as militant, religious, and egotistical."
	possible_origins = list(
		/decl/origin_item/origin/dominia_grown
	)

/decl/origin_item/origin/dominia_grown
	name = "Dominia Grown"
	desc = "Dionae who were originally grown in and influenced by the Empire of Dominia."
	important_information = "Dionae grown within Dominian space are expected to adhere strictly to Dominian law and religion. They are also subject to a system that randomly selects them for a position they are expected to work in for their entire life such as a menial worker for a noble house, although on rare occasion they may be assigned a much more influential position such as a priest or diplomat, although they will still spend decades working as an aide or intern until being allowed the full-time position, and even then, will still be monitored closely to ensure they're only a boon to the Empire."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_DOMINIA, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_MOROZ, RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)