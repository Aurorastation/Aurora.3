/singleton/origin_item/culture/coalition
	name = "Coalition of Colonies"
	desc = "The Coalition of Colonies was born out of the fires of the Interstellar War, the bloodiest war humanity has seen since its dawn as a species. The majority of its citizens prize their freedom above all else, which has led to problems with governance for the Coalition: to this day, it remains a very decentralized and fragmented entity that can only be brought together as a unified front in moments of extreme crisis. But with the recent growth of the Republic of Biesel, retreat of the Solarian Alliance, and an increasingly militaristic Empire of Dominia, perhaps this matter shall change in the years to come."
	possible_origins = list(
		/singleton/origin_item/origin/xanu_prime,
		/singleton/origin_item/origin/himeo,
		/singleton/origin_item/origin/vysoka,
		/singleton/origin_item/origin/galatea,
		/singleton/origin_item/origin/coa_spacer,
		/singleton/origin_item/origin/gadpathur,
		/singleton/origin_item/origin/gadpathur_exile,
		/singleton/origin_item/origin/assunzione,
		/singleton/origin_item/origin/ncf,
		/singleton/origin_item/origin/orepit,
		/singleton/origin_item/origin/other_coalition
	)

/singleton/origin_item/origin/xanu_prime
	name = "All-Xanu Republic"
	desc = "Xanu Prime has long been considered one of the most important planets in the Coalition of Colonies, housing its current capital. The citizens of the All-Xanu Republic, the government of the planet, are a diverse body of people that value their freedom highly, and are known throughout the broader Spur as traders. Much of Xanu's surface is scarred due to damage inflicted upon the planet by the Solarian Alliance during the Interstellar War."
	possible_accents = list(ACCENT_XANU)
	possible_citizenships = CITIZENSHIPS_COALITION
	possible_religions = list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_SHINTO, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_SIKHISM, RELIGION_OTHER, RELIGION_TRINARY, RELIGION_STOLITISM, RELIGION_MOROZ, RELIGION_LUCEISM)

/singleton/origin_item/origin/himeo
	name = "United Syndicates of Himeo"
	desc = "A bastion of worker's rights in the corporate-dominated Orion Spur, the citizens of the United Syndicates of Himeo can trace their roots to an unsuccessful mining operation owned by Hephaestus Industries. Abandoned by its megacorporate master centuries ago, Himeo has since charted its own course through history. Its citizens are still very hostile towards Hephaestus Industries, which they view as having abandoned them to die."
	possible_accents = list(ACCENT_HIMEO)
	possible_citizenships = CITIZENSHIPS_COALITION
	possible_religions = RELIGIONS_COALITION
	origin_traits = list(TRAIT_ORIGIN_COLD_RESISTANCE, TRAIT_ORIGIN_LIGHT_SENSITIVE)
	origin_traits_descriptions = list("are more acclimatised to the cold.", "are more sensitive to bright lights")

/singleton/origin_item/origin/vysoka
	name = "Free System of Vysoka"
	desc = "The agricultural center of the Coalition of Colonies, the Free System of Vysoka is generally conservative and often seen as heavily traditional by the broader Coalition. Most Vysokans live in rural environments, and few cities can be found across the planet's surface. Vysoka is also home to large semi-nomadic communities known as \"Hosts,\" that are not connected with any particular community or city. Religion and spiritualism are important aspects of Vysokan life, particularly for its rural population."
	important_information = "Vysoka's remoteness and relatively undeveloped status has made it a planet with little outside immigration. Due to these factors, <b>characters born on Vysoka will have names and appearances consistent with people from Central Asia, Siberia, and Eastern Europe, the original colonists of the planet.</b> Only native Vysokans may take the Vysokan accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_VYSOKA)
	possible_citizenships = CITIZENSHIPS_COALITION
	possible_religions = list(RELIGION_NONE, RELIGION_STOLITISM, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER)

/singleton/origin_item/origin/galatea
	name = "Federal Technocracy of Galatea"
	desc = "The Federal Technology of Galatea is an unusual human society which prizes academic knowledge and progress above almost all other things. It is originally descended from a Solarian scientific expedition which was sent to the current Weeping Stars to terraform the Yggdrasil System, and retains a focus on expert guidance. To have a political voice in the Federation, one must have some form of degree, and Galatean academicia is infamously rigorous. The non-degreed population of Galatea is kept in line \
	through an extensive system of welfare, propaganda, and state surveillance known as the Welfare-Propaganda State. Dissent is rare and confidence in the government is high across the Technocracy. Galatea is widely known for its biotechnology; most of its citizens have some form of biological augmentations, with those lacking them viewed as social oddities. The Federation consists of four member-planets: Galatea, Tsukuyomi, Svarog, and Empyrean."
	possible_accents = list(ACCENT_GALATEA, ACCENT_TSUKUYOMI, ACCENT_EMPYREAN, ACCENT_SVAROG)
	possible_citizenships = CITIZENSHIPS_COALITION
	possible_religions = RELIGIONS_COALITION

/singleton/origin_item/origin/coa_spacer
	name = "Coalition Offworlders"
	desc = "The offworlders of the Coalition of Colonies are an odd mix of nomadic or semi-nomadic peoples that do not call any planet home, and instead opt to live in spaceborne fleets. The most notable offworlder group in the Coalition is the Scarabs, though many more are present in the Coalition's borders."
	possible_accents = list(ACCENT_NCF, ACCENT_SCARAB, ACCENT_COC, ACCENT_BURZSIA)
	possible_citizenships = CITIZENSHIPS_COALITION
	possible_religions = list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER, RELIGION_TRINARY, RELIGION_SCARAB)

/singleton/origin_item/origin/gadpathur
	name = "United Planetary Defense Council of Gadpathur"
	desc = "During the Interstellar War, Gadpathur was orbitally bombarded by the Solarian Alliance until the planet was barely able to sustain human life. The planet has clawed its way back into stability over the intervening centuries, and is currently an ultra-militarized regime absolutely dedicated to ensuring that the Alliance is never again able to challenge the Coalition."
	important_information = "Because of Gadpathur's insular nature that is unwelcome to outsiders and its origins of being settled by Indian colonists, <b>characters born on the planet must have names and physical characteristics typical of people from the modern-day Indian Subcontinent.</b> Only native Gadpathurians may take the Gadpathuri accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_GADPATHUR)
	possible_citizenships = list(CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_SIKHISM, RELIGION_OTHER)
	origin_traits = list(TRAIT_ORIGIN_LIGHT_SENSITIVE)
	origin_traits_descriptions = list("have a small resistance to radiation", "are more sensitive to bright lights")

/singleton/origin_item/origin/gadpathur/on_apply(var/mob/living/carbon/human/H)
	H.AddComponent(/datum/component/armor, list(rad = ARMOR_RAD_MINOR))

/singleton/origin_item/origin/gadpathur_exile
	name = "Gadpathurian Exile"
	desc = "As an exile from Gadpathur you are, above all other things, a failure. A failure to meet the standards of Gadpathurian society found unworthy of defending it from the Solarian imperialists. You are a weakness that the planet and its people cannot afford to keep around, lest you compromise its defense. Stripped over everything that makes you Gadpathurian and cast aside to the Republic of Biesel or Coalition of Colonies, it is now up to you -- and you alone -- to make something of yourself despite your status as a failure. The one certainty is that your home will not take you back, no matter what you do."
	possible_accents = list(ACCENT_GADPATHUR)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_COALITION
	origin_traits = list(TRAIT_ORIGIN_LIGHT_SENSITIVE)
	origin_traits_descriptions = list("have a small resistance to radiation", "are more sensitive to bright lights")

/singleton/origin_item/origin/gadpathur_exile/on_apply(var/mob/living/carbon/human/H)
	H.AddComponent(/datum/component/armor, list(rad = ARMOR_RAD_MINOR))

/singleton/origin_item/origin/assunzione
	name = "Republic of Assunzione"
	desc = "One of the most remote planets colonized by humanity, the Republic of Assunzione is widely known for its lack of a functional sun - which burnt out mysteriously shortly after the planet was colonized - and its unusual native faith, Luceism. Luceism itself is an offshoot of traditional Abrahamic faiths and is centered around the worship of Ennoia, an abstract representation of light. Assunzionii society is quite insular and is centered around the planet's faith, with an overwhelming majority of the planet's residents adhering to Luceism."
	important_information = "Assunzione's remote location and urban planning which places a premium on available housing and space has made it unattractive to outsiders as a destination for immigration. Because of this, <b>characters born on Assunzione will have names and appearances consistent with the peoples living on or around the Mediterranean Sea, much like the planet's original colonists.</b> Only native Assunzioniis may take the Assunzionii accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_ASSUNZIONE)
	possible_citizenships = CITIZENSHIPS_COALITION
	possible_religions = list(RELIGION_LUCEISM)
	origin_traits = list(TRAIT_ORIGIN_DARK_AFRAID)
	origin_traits_descriptions = list("tend to feel nervous in the dark")

/singleton/origin_item/origin/ncf
	name = "Non-Coalition Frontier"
	desc = "The frontier beyond the Coalition of Colonies before unexplored \"deadspace,\" has seen limited human colonization, but still dwells mostly outside of the influence of any government. Most residents of this distant frontier that drift back to the more populated Orion Spur eventually claim citizenship with the Coalition of Colonies due to its ease of acquisition."
	possible_accents = list(ACCENT_NCF)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL)
	possible_religions = list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER, RELIGION_TRINARY, RELIGION_LUCEISM, RELIGION_MOROZ, RELIGION_SCARAB, RELIGION_STOLITISM)

/singleton/origin_item/origin/other_coalition
	name = "Other Coalition"
	desc = "The Coalition is home to a multitude of worlds, ranging from prosperous democracies to struggling dictatorships. Nearly anything can be found within its borders, and many of its worlds are only united by their common allegiance to the Coalition."
	possible_accents = list(ACCENT_COC, ACCENT_NCF)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_COALITION

/singleton/origin_item/origin/orepit
	name = "Orepit"
	desc = "The human population of Orepit includes the Native Orepitters, who descend from Hephaestus employees following the abandoned mining mission on the planet, as well as immigrants and pilgrims of the Trinary religion."
	important_information = "All humans from Orepit are vetted Trinary faithful, and their behaviour should reflect that."
	possible_accents = list(ACCENT_OREPIT, ACCENT_PROVIDENCE)
	possible_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_COALITION)
	possible_religions =  list(RELIGION_TRINARY)
