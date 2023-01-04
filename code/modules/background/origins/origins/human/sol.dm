#define RELIGIONS_SOLARIAN list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_SHINTO, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER, RELIGION_TRINARY)
#define CITIZENSHIPS_SOLARIAN list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_ERIDANI, CITIZENSHIP_COALITION)

/decl/origin_item/culture/solarian
	name = "Solarian"
	desc = "Despite the loss of much of its territory during the Solarian Collapse of 2463, most of those that fall under the general umbrella of Solarian culture are citizens or belong to statelets affiliated with the Alliance of Sovereign Solarian Nations (ASSN). By and large, Solarians are generally perceived as xenophobic, nationalistic, and militarist. Non-humans, aside from Skrell, are generally rare on Solarian worlds, and many that do reside on them are treated as second-class citizens at best."
	possible_origins = list(
		/decl/origin_item/origin/sol_system,
		/decl/origin_item/origin/earth,
		/decl/origin_item/origin/luna,
		/decl/origin_item/origin/venus_c,
		/decl/origin_item/origin/venus_j,
		/decl/origin_item/origin/mars,
		/decl/origin_item/origin/jupiter,
		/decl/origin_item/origin/pluto,
		/decl/origin_item/origin/eridani,
		/decl/origin_item/origin/eridani_dreg,
		/decl/origin_item/origin/middle_ring,
		/decl/origin_item/origin/new_hai_phong,
		/decl/origin_item/origin/silversun,
		/decl/origin_item/origin/outer_ring,
		/decl/origin_item/origin/konyang,
		/decl/origin_item/origin/visegrad,
		/decl/origin_item/origin/mictlan,
		/decl/origin_item/origin/antillia,
		/decl/origin_item/origin/sancolette
	)

/decl/origin_item/origin/sol_system
	name = "Sol System"
	desc = "The cradle of humanity itself, the Sol System stands above most other systems in terms of its quality of life, wealth, influence, and population. \
			Undisputedly controlled by the Solarian Alliance, the Sol System will likely remain the unofficial capital for centuries to come."
	possible_accents = list(ACCENT_SOL)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/earth
	name = "Earth"
	desc = "Perhaps the single most important planet in the Orion Spur, Earth is the homeworld of humanity. Most megacorporations originated on Earth, and many still operate from it. Expensive climate restoration efforts undertaken by the Solarian Alliance in cooperation with Zeng-Hu Pharmaceuticals have restored much of Earth's climate, though the scars of humanity's industrialization can still be seen across its surface."
	possible_accents = list(ACCENT_EARTH)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/luna
	name = "Luna"
	desc = " Earth's only natural satellite, Luna is humanity's oldest colony and one of the Solarian Alliance's wealthiest member states. While not every Lunarian is wealthy, and a significant working class population exists, much of the moon's population is stereotyped as being wealthy beyond what most can imagine. Lunarians are often stereotyped as haughty, arrogant people who are incredibly prideful and constantly brag about their origins on Luna."
	possible_accents = list(ACCENT_LUNA)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/venus_c
	name = "Venus, Cytherea"
	desc = "Venus is the cultural capital of the Alliance, and its residents mostly dwell in floating settlements referred to as \"aerostats.\" While wealthy and culturally rich, Venus is deeply divided between Cythereans, those involved in the cultural industry, and Jintarians, those involved in other industries. Cytherean culture is well known throughout the Orion Spur, and is typically stereotyped as hedonistic."
	possible_accents = list(ACCENT_VENUS)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN
	origin_traits = list(TRAIT_ORIGIN_ALCOHOL_RESISTANCE, TRAIT_ORIGIN_DRUG_RESISTANCE)
	origin_traits_descriptions = list("have a higher alcoholic tolerance", "have a higher tolerance to recreative drugs")

/decl/origin_item/origin/venus_j
	name = "Venus, Jintaria"
	desc = "Venus is the cultural capital of the Alliance, and its residents mostly dwell in floating settlements referred to as \"aerostats.\" While wealthy and culturally rich, Venus is deeply divided between Cythereans, those involved in the cultural industry, and Jintarians, those involved in other industries. Jintarian culture can often be defined as the polar opposite of Cytherean culture in many facets, but it borrows as much as it opposes."
	possible_accents = list(ACCENT_VENUSJIN)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/mars
	name = "Mars"
	desc = "Martians as a people have suffered grievously throughout their history. Most recently the 2462 Violet Dawn catastrophe rendered much of their planet uninhabitable, and placed much of the rest on the brink of collapse. As a result many Martians can be found abroad, and many Solarian planets have recently gained significant refugee populations of Martians."
	possible_accents = list(ACCENT_MARTIAN)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/jupiter
	name = "Jupiter"
	desc = "The three major inhabited moons of Jupiter - Callisto, Ganymede, and Europa - are key Solarian worlds. Callisto serves as a major port for the Alliance, Ganymede produces much of the food the Alliance consumes, and Europa is a major research hub. The Jovian Moons are home to a remarkable diversity of humanity, and humans from almost anywhere in the Orion Spur can be found in their ports."
	possible_accents = list(ACCENT_JUPITER, ACCENT_EUROPA, ACCENT_CALLISTO)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/pluto
	name = "Pluto"
	desc = "One of the last bodies in the Sol System to be colonized, Pluto's economy is centered around Helium-3 mining and refinement. Originally colonized by the Union of Soviet Socialist Republics, Pluto has retained much of its Soviet-bloc influences up to the present day. Going abroad from Pluto is often a slow process: one must either navigate the Party bureaucracy that defines much of life on the planet, or enter (and win) the Party's labour lottery."
	important_information = "Pluto's unique status as a colony established by the USSR and its unique system of government that is distrustful of outsiders from \"corporate influenced,\" places, <b>characters born on Pluto will have names and appearances characteristic of the peoples native to the Eastern European or Baltic republics in the USSR, Russia, the Caucasus Mountains, or Central Asia.</b> Only native Plutonians may select the Plutonian accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_PLUTO)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/eridani
	name = "Eridani Corporate Federation Citizen"
	desc = "The Eridani Corporate Federation is an autonomous member of the Solarian Alliance that is infamous abroad for its starkly divided society and extreme levels of corporate involvement in daily life. Corporations touch every aspect of Eridani, and its society is divided between corporate \"Suits\" that work for its companies and non-citizen \"Dregs\" that live off the scraps of society. Between the two, \"Reinstated Dregs\" chart an awkward balance: too corporate to be Dregs, but not corporate enough to be Suits."
	important_information = "<b>Due to Epsilon Eridani being originally settled by colonists of West and Central African descent, human characters born in the Eridani Corporate Federation must have names and appearances consistent with the indigenous peoples of these regions as any human moving to the ECF would assimilate into the dominant cultures and ethnic groups of the federation. Eridani dregs have developed cultures of abstract or unconventional names however and this is tolerated.</b> Only native Eridanians may select the Eridanian accents. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_ERIDANI, ACCENT_ERIDANIREINSTATED)
	possible_citizenships = list(CITIZENSHIP_ERIDANI, CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/eridani_dreg
	name = "Eridani Corporate Federation Dreg"
	desc = "The Eridani Corporate Federation is an autonomous member of the Solarian Alliance that is infamous abroad for its starkly divided society and extreme levels of corporate involvement in daily life. Corporations touch every aspect of Eridani, and its society is divided between corporate \"Suits\" that work for its companies and non-citizen \"Dregs\" that live off the scraps of society. Between the two, \"Reinstated Dregs\" chart an awkward balance: too corporate to be Dregs, but not corporate enough to be Suits."
	important_information = "<b>Due to Epsilon Eridani being originally settled by colonists of West and Central African descent, human characters born in the Eridani Corporate Federation must have names and appearances consistent with the indigenous peoples of these regions as any human moving to the ECF would assimilate into the dominant cultures and ethnic groups of the federation. Eridani dregs have developed cultures of abstract or unconventional names however and this is tolerated.</b> Only native Eridanians may select the Eridanian accents. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_ERIDANIDREG)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN
	origin_traits = list(TRAIT_ORIGIN_TOX_RESISTANCE, TRAIT_ORIGIN_DRUG_RESISTANCE)
	origin_traits_descriptions = list("have a higher resistance to toxins", "have a higher tolerance to recreative drugs")

/decl/origin_item/origin/middle_ring
	name = "Middle Ring"
	desc = "The Middle Ring of the Solarian Alliance was partially lost in the Solarian Collapse, but the Alliance retains much of its influence in this region."
	possible_accents = list(ACCENT_SOL)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/new_hai_phong
	name = "New Hai Phong"
	desc = "Originally intended to be a mining colony, New Hai Phong has since become one of the industrial centers of the modern Alliance thanks to Hephaestus Industries. Space on New Hai Phong is at a premium, which has led to a communal style of living centered around blockfams — small organizational units consisting of several families living in close proximity. Corruption is a massive issue on the planet and dissent against Hephaestus has been growing in recent years. Respiratory issues plague many residents of New Hai Phong thanks to the harsh environment of the planet."
	important_information = "<b>Due to the ethnic make-up of its original settlers and ability for the massive New Hai Phongese population to absorb immigrants into its culture via assimilation, characters born on New Hai Phong must have names and appearances consistent with the peoples of Southeast Asia.</b> Only characters native to New Hai Phong may take the New Hai Phongese accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_PHONG)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN
	origin_traits = list(TRAIT_ORIGIN_IGNORE_CAPSAICIN)
	origin_traits_descriptions = list("are not affected by spicy foods")

/decl/origin_item/origin/silversun
	name = "Silversun"
	desc = "The most sought-after vacation spot in the Alliance, Silversun is dominated by Idris Incorporated. It is culturally and politically divided between the Originals - the first settlers of the planet that predate the involvement of Idris Incorporated - and the Expatriates - those affiliated with Idris Incorporated that now reside on the planet. Tensions have only grown worse following the Solarian Collapse and the formation of the Stellar Corporate Conglomerate, yet Idris' PR machine has managed to keep the planet the Alliance's best vacation destination."
	possible_accents = list(ACCENT_SILVERSUN_ORIGINAL, ACCENT_SILVERSUN_EXPATRIATE)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN
	origin_traits = list(TRAIT_ORIGIN_HOT_RESISTANCE)
	origin_traits_descriptions = list("are more acclimatised to the heat")

/decl/origin_item/origin/outer_ring
	name = "Outer Ring"
	desc = " The furthest zone of the Alliance's reach, almost all of the Outer Ring fell away from the Alliance's control during the Solarian Collapse. Much of this region was annexed by the Coalition of Colonies or the Republic of Biesel."
	possible_accents = list(ACCENT_SOL)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/konyang
	name = "Konyang"
	desc = "A Solarian planet until very recently, Konyang is one of the youngest members of the Coalition of Colonies. The planet is famous for its robotics industry, which has resulted in a large amount of synthetic residents on the planet itself. The human population of Konyang still retains much of its Earther heritage."
	important_information = "<b>Because of the ethnic make-up of Konyang's original settlers and assimilation of immigrants into the native population during the first AI boom, human characters born on Konyang will have appearances consistent with the people of China, the Korean Peninsula, and Japanese Islands.</b> Only native Konyangers or Konyang-made IPCs may select the Konyanger accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_KONYAN)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/visegrad
	name = "Visegrad"
	desc = "Originally a penal colony of the Warsaw Pact, Visegrad's society is generally divided between the urban and rural population. Visegradi are often stereotyped as gloomy and distrustful people, thanks to the planet's origins as a Soviet penal colony and a history of intrusive government observation programs. Visegradi culture additionally has a heavy emphasis on luck and fatalism, and many that go abroad bring their superstitions with them."
	important_information = "Due to Visegrad's history as a former penal colony housing Eastern European political dissidents and its current status as the de facto capital of a warlord state hostile to outsiders, <b>characters born on Visegrad will have names and appearances consistent with the peoples of Non-Soviet Eastern Europe, East Germany, and the Non-Yugoslav & non-Greek Balkans.</b> Only native Visegradis may take the Visegradi accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_VISEGRAD)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN
	origin_traits = list(TRAIT_ORIGIN_IGNORE_CAPSAICIN, TRAIT_ORIGIN_COLD_RESISTANCE)
	origin_traits_descriptions = list("are not affected by spicy foods", "are more acclimatised to the cold")

/decl/origin_item/origin/mictlan
	name = "Mictlan"
	desc = "One of the worlds unlucky enough to be annexed into the Republic of Biesel's Corporate Reconstruction Zone following the Solarian Collapse, Mictlan has become the site of growing fighting and unrest directed at the Republic and its forces. Mictlaners now find themselves increasingly caught between Sol and Biesel, and the conflict on their planet shows no signs of deescalating."
	important_information = "While Mictlan has been a beacon of multiculturalism among humans and aliens in the Orion Spur, many humans that have immigrated to the planet have been assimilated into Mictlan's culture and society. Because of this, <b>human characters born on Mictlan must have names and appearances consistent with the peoples of Central and South America.</b> Only characters native to Mictlan may take the Mictlan accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_MICTLAN)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN
	origin_traits = list(TRAIT_ORIGIN_IGNORE_CAPSAICIN)
	origin_traits_descriptions = list("are not affected by spicy foods")

/decl/origin_item/origin/antillia
	name = "Port Antillia"
	desc = "A former middle ring Solarian colony annexed into the Corporate Reconstruction Zone following the Solarian Collapse. Port Antillia is an under-developed ocean world with a unique, unstable geological profile and strong tradition of regional governance. Now with the formation of a unified planetary government within the Corporate Reconstruction Zone, Port Antillia looks forward to a hopeful, brighter future."
	important_information = "Due to the rather insular and unstable history of Port Antillia as the singular colonisation attempt by the Caribbean Federation, <b>characters born on Port Antillia will have names and appearances consistent with the peoples of the Antilles.</b> Only those native to Port Antillia may take its accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_ANTILLIA)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/sancolette
	name = "San Colette"
	desc = "The system of San Colette is the heartland of the Sovereign Solarian Republic of San Colette, a Solarian member state formerly located on the border between the Middle and Outer Rings and now located almost exactly in the middle of the Northern Wildlands. \
	The Republic has historically been a major hub for warp gate travel between both rings and has become quite wealthy as a result of its trade. Unfortunately this has made it a target for the warlords of the Northern Wildlands: \
	the Coalition-backed League of Independent Corporate-Free Systems and Solarian Navy-supported Solarian Restoration Front. Whether or not San Colette's own defensive alliance - the Middle Ring Shield Pact - will be able to weather the storm approaching its borders remains to be seen. \
	Coletters are, by Outer and Middle Ring standards, a wealthy people with a high standard of living. Culturally they have a strong connection to service in their local military, the Civil Guard of the Sovereign Solarian Republic of San Colette, \
	and are often viewed as martial and dutiful people by the broader Alliance. Most value family highly and hold onto cultural traditions from the colonial origin of Iberia. The vast majority of Coletters are concerned for the future, and many have adopted a fatalistic attitude \
	towards what seems to be a steadily approaching war in the Northern Wildands."
	important_information = "Because of the ethnic make-up of San Colette's original settlers and assimilation of immigrants into the native population during and following the Warp Gate Project, human characters born on San Colette will have appearances consistent with the people of the Iberian Peninsula. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_SANCOLETTE)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN
