/decl/origin_item/culture/izweski
	name = "Izweski Hegemony"
	desc = "The Izweski Hegemony is home to a majority of Unathi and remains the most powerful centralized force for the species in the modern day. Under the rulership of the Izweski and the religious guidance of the Church of Sk'akh, the Hegemony plays an important role for Sinta interests abroad. It has a strict loyalty to the caste system it is under, prioritizes the importance of the clan first and foremost, and remains the most open to xenocentric interests and customs out of all the current cultures found among Unathi. They embody ideals of diplomatic and cultural adaptability."
	possible_origins = list(
		/decl/origin_item/origin/izweski_lower,
		/decl/origin_item/origin/izweski_upper
	)

/decl/origin_item/origin/izweski_lower
	name = "Hegemony Lower Castes"
	desc = "Peasants comprise the largest part of the population in the Hegemony. Around them are the Guwan, who are the \"untouchables\" at the bottom of the caste system, and small-time merchants working for their lords. The Contact War saw some Traditionalists ally with and migrate to the Hegemony that were too stubborn to fully integrate into society there. With permission from the owner of the land they work, the noble clan, one can leave their plot and traverse the stars— provided proper tithes are sent back home on behalf of their own clan. It is not uncommon for people to leave and seek education or better circumstances abroad, where they have a higher chance of moving up in the world."
	important_information = "Should one run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_HEGEMON_PEASANT, ACCENT_TRAD_PEASANT)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/decl/origin_item/origin/izweski_upper
	name = "Hegemony Upper Castes"
	desc = "Being born into the nobility is a privilege, it is said. Priests, warriors, merchants, doctors, rulers: all of these positions are typically linear through a clan and carried on by each successive generation. Although their nation is poorer than most human countries, the Hegemony nobility still enjoy many comforts and luxuries compared to most of their kin. Though it is hard and rare, there are some success stories of peasants becoming nobles. Feeling out of place on Moghes with their peasant tongue, many find their place abroad. Similarly, nobles that are at risk of dishonoring the clan but have no reason to be made Guwan are sent off-world."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_HEGEMON_NOBLE, ACCENT_TRAD_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH)