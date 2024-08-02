/singleton/origin_item/culture/hieroaetheria
	name = "The Commonwealth of Hieroaetheria"
	desc = "The Commonwealth of Hieroaetheria is a habitable world in the tumultuous system of Titan's Rapture, home to three nations which, \
	though distinct and with their own interests and strong cultural identities, work together to elevate their homeworld. While not the origin \
	of the species, Hieroaetheria is the largest known world to have been colonized exclusively by dionae without contact or help from outside species, \
	being home to dionae for thousands of years prior to discovery. The teachings of the Eternal have come to have a large impact on all nations within \
	the Commonwealth of Hieroaetheria, with the majority of Hieroaetherian dionae subscribing to one of the Eternal schools."
	possible_origins = list(
		/singleton/origin_item/origin/hieroaetheria,
		/singleton/origin_item/origin/hieroaetheria/rapturian,
		/singleton/origin_item/origin/hieroaetheria/consortium,
		/singleton/origin_item/origin/hieroaetheria/glaorr,
		/singleton/origin_item/origin/hieroaetheria/ekane
	)

/singleton/origin_item/origin/hieroaetheria
	name = "Hieroaetherian"
	desc = "Though life on Hieroaetheria is dominated by the three largest nations, there exist a significant number of \
	member states who hold a smaller portion of seats on the Grand Assembly, as well as a notable populace of dionae who live nomadic lives on \
	either the surface - such as along the Ratheus River Basin - or within the subterranean. These dionae simply refer to themselves as Hieroaetherian."
	possible_accents = list(ACCENT_HIEROAETHERIAN)
	possible_citizenships = list(CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/hieroaetheria/rapturian
	name = "Rapturian"
	desc = "Though life in the Titan's Rapture system is dominated by the Commonwealth of Hieroaetheria and it's nations, there exist a significant number of \
	dionae who originated from the Rapture system outside of the direct influence of the Commonwealth. These dionae may live around one of the system's stars, \
	within an independent outpost on a planet or asteroid, or in a nomadic spacevessel that roams the Rapture System. These dionae simply refer to themselves as \
	Rapturian. With the Commonwealth having entered a new space age, many of these dionae have since come under the fold of the Commonwealth, taking up work \
	for the major Hieroaetherian nations or companies."
	possible_accents = list(ACCENT_RAPTURIAN)

/singleton/origin_item/origin/hieroaetheria/consortium
	name = "The Consortium of Hieroaetheria"
	desc = "A nation of Hieroaetheria predating Nralakk discovery, the Consortium was a loose confederation of dozens of dionae groups \
	across the region of Mede that have since unified into one alliance. The Consortium prides itself on progressive stances, aiming to foster a \
	multicultural society inclusive of non-Dionae."
	possible_accents = list(ACCENT_CONSORTIUM, ACCENT_ANU, ACCENT_GENTLEWINDS, ACCENT_HOPESTENDRILS)

/singleton/origin_item/origin/hieroaetheria/glaorr
	name = "The Union of Gla'orr"
	desc = "An affront to the ideals of ther Consortium, the Union of Gla'orr is autocratic and xenophobic, opposed to the integration of non-Dionae \
	into Hieroaetherian societies. Though opposed to the ideals of the Consortium and though wishing a more secular handling of issues compared to Ekane, \
	they continue to engage in diplomatic relations with the other nations of the Commonwealth."
	possible_citizenships = list(CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_GLAORR, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_accents = list(ACCENT_GLAORR)

/singleton/origin_item/origin/hieroaetheria/ekane
	name = "The Eternal Republic of the Ekane"
	desc = "Founded after first contact with the Nralakk Federation in communities gripped by Eternal thoughts, the Eternal Republic is an autocratic \
	theocracy staunchly against propositions of reform, inclusion of non-dionae, centralisation and deeply entwined with Eternal schools of thoughts, with \
	faith being a central component of all facets of life within the Eternal Republic."
	possible_accents = list(ACCENT_EKANE)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_OTHER, RELIGION_NONE)
