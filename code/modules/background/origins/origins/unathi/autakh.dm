/singleton/origin_item/culture/autakh
	name = "Aut'akh"
	desc = "The Aut'akh are a decentralized, leaderless religious movement and society. Formed by a group of scientists and engineers on Ouerea after the Contact War, they took the Th'akh faith to extremes through ritualistic augmentation in the pursuit of self-actualization. After revealing themselves to the galaxy, these transhumanists seek to carve out a small space for themselves wherever they can seek refuge. Many disabled and elderly form these religious communes that seize and control their own spiritual destiny, and others who feel displaced by society - Guwan, those who claim their bodies and souls do not align, and even those of other species - they are found within these communes as well."
	possible_origins = list(
		/singleton/origin_item/origin/autakh,
		/singleton/origin_item/origin/autakh/undercity,
		/singleton/origin_item/origin/autakh/eridani,
		/singleton/origin_item/origin/autakh/razortail,
		/singleton/origin_item/origin/autakh/hidden
	)

/singleton/origin_item/origin/autakh
	name = "Aut'akh Valley"
	desc = "A large commune on Ouerea surrounded by mountains, the Aut'akh Valley is birthplace of the Aut'akh religion - a place for specifically augmented unathi to find sanctuary from the violence often found against their kind in cities and towns. It is largely disconnected from any government and is heavily guarded by the Aut'akh defending the clans there with their lives. Life here is simple, and more than half of the population is elderly or disabled with augments. The area is foggy and filled with natural lakes, and the area gets cold enough to snow in the cold season."
	possible_accents = list(ACCENT_HEARTLAND_NOBLE, ACCENT_HEARTLAND_PEASANT, ACCENT_TRAD_NOBLE, ACCENT_TRAD_PEASANT, ACCENT_WASTELAND, ACCENT_AUTAKH, ACCENT_TZA_PEASANT, ACCENT_TZA_NOBLE, ACCENT_SOUTHLANDS_PEASANT, ACCENT_SOUTHLANDS_NOBLE, ACCENT_TORN, ACCENT_ZAZ_LOW, ACCENT_ZAZ_HIGH, ACCENT_BROKEN_PEASANT, ACCENT_BROKEN_NOBLE, ACCENT_UNATHI_SPACER)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_AUTAKH)

/singleton/origin_item/origin/autakh/undercity
	name = "Undercity Communes"
	desc = "Beneath many cities on both Moghes and Ouerea is a small commune of Aut'akh, created by one of the original Aut'akh from Ouerea. These communes have become safe havens for some individuals. Unathi, regardless of being Aut'akh or not, come to these communes when they are in dire need - a new prosthetic, a repair from an assault, or simply for a place to sleep for a night. These communes are often heavily guarded by Aut'akh warriors set on keeping these people safe, and because of the possible danger of attacking these communes, they rarely see attack. It is not unheard of, though; whole communes have been arrested by city garrisons or lynched by mobs led by nobles."

/singleton/origin_item/origin/autakh/eridani
	name = "Eridani Underworld Commune"
	desc = "In the depths of Eridani I under the city, a small commune of Unathi have made some order out of the chaos. The first Aut'akh to come here didn't have the credits or the legal standing to make it on top in the corporate over-world; however, they did have enough muscle to clear out a mining drone factory of drug-addicted dregs. A few years is all it took for a community of Aut'akh to grow, walling off the Factory and setting up a safe spot for them to fit. Over time, the surrounding local dreg community came to accept the Aut'akh in. Even still, some have treated the augmented Unathi as just another gang they have to deal with."
	possible_citizenships = list(CITIZENSHIP_ERIDANI)

/singleton/origin_item/origin/autakh/razortail
	name = "Razortail Enclave"
	desc = "Considered a bunch of ruffians by their sister communes, the Razortail Enclave is a commune located in District 7 of Mendell City: Sin City. In order to survive in Biesel, Aut’akh participate in organized crime as hired muscle, allured to the practice by the prospect of stealing from the megacorps and Biesel’s own government to help the slums of the district. Similar to the Factory commune on Eridani I, the Razortail Enclave is stuck in the poorer regions of the city, trapped there by a lack of wealth and a conviction to not stray too far from their ideals; however, unlike their sister commune, these sinta do not ignore the gang conflicts of the streets, and often themselves get involved to prevent their rank from kidnappings and having their prosthetics stripped from them — a barbaric practice in the eyes of these fanatics."
	possible_citizenships = list(CITIZENSHIP_BIESEL)

/singleton/origin_item/origin/autakh/hidden
	name = "Unknown Aut'akh Commune"
	desc = "Either due to their fellow Unathi rejecting them and their way of life, or life among other species and cultures feeling too alien when away from Hegemonic space, most Aut'akh inevitably end up forming communes and living among each other in these. Aside from the few notable, larger communes, many more minor communes exist across the Spur."
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_ERIDANI)
