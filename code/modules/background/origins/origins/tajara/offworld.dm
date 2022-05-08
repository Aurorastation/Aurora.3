/decl/origin_item/culture/offworld_tajara
	name = "Off-World Tajaran"
	desc = "Due to its violent history, Adhomai is a large source of migrants to the rest of the galaxy. These Tajara, fleeing conflict or seeking better opportunities, have settled mainly on Tau Ceti. While notable communities existed in the Sol Alliance, they were dissolved following growing hostility against them. Due to the recent migrations and government influence, no major difference exists between the Adhomian and Off-World cultures. However, as the Tajaran communities grow, their peculiarities begin to take a more important role in their identity."
	possible_origins = list(
		/decl/origin_item/origin/free_council,
		/decl/origin_item/origin/little_adhomai
	)

/decl/origin_item/culture/offworld_tajara/zhan
	possible_origins = list(
		/decl/origin_item/origin/free_council,
		/decl/origin_item/origin/little_adhomai/zhan
	)

/decl/origin_item/culture/offworld_tajara/msai
	possible_origins = list(
		/decl/origin_item/origin/free_council,
		/decl/origin_item/origin/little_adhomai/msai
	)

/decl/origin_item/origin/free_council
	name = "Free Tajaran Council"
	desc = "The Free Tajaran Council is the largest Tajaran community in Himeo. Its origins can be traced back to the First Revolution-era revolutionaries that fled Adhomai. The Free Council culture is the traditional Northern Ras'nrr way of life heavily influenced by the Council's ideology, the situation in Himeo, and the past isolation from the wide Tajaran community. A great emphasis is put on the collective and the survival of the society above the individual. Himean Tajara will usually have an aversion to strict chains of command, preferring to make decisions based on common consensus instead of relying on a leader. Diligence and modesty are considered virtues that every Tajara should strive for. While not necessarily xenophobic, the Free Council Tajara are highly suspicious of outsiders and will take more time to establish bonds with people from outside of their communities."
	possible_accents = list(ACCENT_NORTHRASNRR)
	possible_citizenships = list(CITIZENSHIP_FREE_COUNCIL)
	possible_religions = RELIGIONS_ADHOMAI

/decl/origin_item/origin/little_adhomai
	name = "Little Adhomai"
	desc = "Little Adhomai is the largest off-world Tajaran community. Situated in Mendell City, District Six is the home of most Tajara living in the Republic of Tau Ceti. Because of its relatively short existence, discrimination, and other barriers present in Tau Ceti, the Tajara of Little Adhomai still clings to their native culture. Even the few individuals born here carry a great Adhomian influence, usually identifying themselves with their family's origins. Despite this influence, District Six is also home to its own cultural expressions."
	possible_accents = list(ACCENT_REPUBICLANSIIK, ACCENT_NAZIRASIIK, ACCENT_CREVAN, ACCENT_DASNRRASIIK, ACCENT_HIGHHARRSIIK, ACCENT_LOWHARRSIIK, ACCENT_AMOHDASIIK, ACCENT_NORTHRASNRR, ACCENT_DINAKK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/decl/origin_item/origin/little_adhomai/zhan
	possible_accents = list(ACCENT_REPUBICLANSIIK, ACCENT_NAZIRASIIK, ACCENT_CREVAN, ACCENT_DASNRRASIIK, ACCENT_HIGHHARRSIIK, ACCENT_LOWHARRSIIK, ACCENT_AMOHDASIIK, ACCENT_NORTHRASNRR, ACCENT_DINAKK, ACCENT_HARRNRRI, ACCENT_RURALDELVAHHI)

/decl/origin_item/origin/little_adhomai/msai
	possible_accents = list(ACCENT_REPUBICLANSIIK, ACCENT_NAZIRASIIK, ACCENT_CREVAN, ACCENT_DASNRRASIIK, ACCENT_HIGHHARRSIIK, ACCENT_LOWHARRSIIK, ACCENT_AMOHDASIIK, ACCENT_NORTHRASNRR, ACCENT_DINAKK, ACCENT_HARRNRRI, ACCENT_ZARRJIRI)
