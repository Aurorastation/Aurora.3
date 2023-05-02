/singleton/origin_item/culture/izweski
	name = "Izweski Hegemony"
	desc = "The Izweski Hegemony is home to a majority of Unathi and remains the most powerful centralized force for the species in the modern day. Under the rulership of the Izweski and the religious guidance of the Church of Sk'akh, the Hegemony plays an important role for Sinta interests abroad. It has a strict loyalty to the caste system it is under, prioritizes the importance of the clan first and foremost, and remains the most open to xenocentric interests and customs out of all the current cultures found among Unathi. They embody ideals of diplomatic and cultural adaptability."
	possible_origins = list(
		/singleton/origin_item/origin/izweski_lower,
		/singleton/origin_item/origin/izweski_upper,
		/singleton/origin_item/origin/tza_lower,
		/singleton/origin_item/origin/tza_upper,
		/singleton/origin_item/origin/southlands_lower,
		/singleton/origin_item/origin/southlands_upper
	)

/singleton/origin_item/origin/izweski_lower
	name = "Hegemony Lower Castes"
	desc = "Peasants comprise the largest part of the population in the Hegemony. Around them are the Guwan, who are the \"untouchables\" at the bottom of the caste system, and small-time merchants working for their lords. The Contact War saw some Traditionalists ally with and migrate to the Hegemony that were too stubborn to fully integrate into society there. With permission from the owner of the land they work, the noble clan, one can leave their plot and traverse the stars— provided proper tithes are sent back home on behalf of their own clan. It is not uncommon for people to leave and seek education or better circumstances abroad, where they have a higher chance of moving up in the world."
	important_information = "Should one run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_HEGEMON_PEASANT, ACCENT_TRAD_PEASANT)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/singleton/origin_item/origin/izweski_upper
	name = "Hegemony Upper Castes"
	desc = "Being born into the nobility is a privilege, it is said. Priests, warriors, merchants, doctors, rulers: all of these positions are typically linear through a clan and carried on by each successive generation. Although their nation is poorer than most human countries, the Hegemony nobility still enjoy many comforts and luxuries compared to most of their kin. Though it is hard and rare, there are some success stories of peasants becoming nobles. Feeling out of place on Moghes with their peasant tongue, many find their place abroad. Similarly, nobles that are at risk of dishonoring the clan but have no reason to be made Guwan are sent off-world."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_HEGEMON_NOBLE, ACCENT_TRAD_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH)

/singleton/origin_item/origin/tza_lower
	name = "Tza Prairie Lower Castes"
	desc = "To the north of Moghes, surrounded by the harsh peaks of the Tza Mountains, lies the Tza Prairie, also known as the Tza Basin. It is the heartland of the Th'akh faith, and its culture has remained \
	largely the same for centuries - one of determination, hard work and grit. The peasantry of the region have kept to their traditional lifestyle through war, famine and upheaval, which \
	has created a culture as hardy and resilient as the mountains that they call their home."
	important_information = "Should a peasant run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_TZA_PEASANT)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH)

/singleton/origin_item/origin/tza_upper
	name = "Tza Prairie Upper Castes"
	desc = "To the north of Moghes, surrounded by the harsh peaks of the Tza Mountains, lies the Tza Prairie, also known as the Tza Basin. It is the heartland of the Th'akh faith, and its culture has remained \
	largely the same for centuries - one of determination, hard work and grit. The nobility of the region have historically been more willing to adapt to changing times, but even then they largely keep to the same \
	traditional ways of the region, even through war, famine and upheaval. This has created a culture as hardly and resilient as the mountains they call their home."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_TZA_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH)

/singleton/origin_item/origin/southlands_lower
	name = "Southlands Lower Castes"
	desc = "Along the southern coast of the Moghresian Sea lies the Southlands. The largest region of the Untouched Lands, the Southlands is a wealthy, cosmopolitan and prosperous region. It is the home of several prominent \
	industrial guilds, and its factories have historically been one of the largest production centers of the Hegemony. However, in recent years industrial, religious and political tensions grip the region, as the Si'akh faith grows and \
	the ancient guilds clash with Hephaestus for power. The peasantry of the region tend to be better educated than most, as a result of the region's cosmopolitan culture - and in recent years, the urban peasants working in the factories have formed a guild of their own, similar in structure \
	to a workers' union - the Hearts of Industry."
	important_information = "Should a peasant run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_SOUTHLANDS_PEASANT)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/singleton/origin_item/origin/southlands_upper
	name = "Southlands Upper Castes"
	desc = "Along the southern coast of the Moghresian Sea lies the Southlands. The largest region of the Untouched Lands, the Southlands is a wealthy, cosmopolitan and prosperous region. It is the home of several prominent industrial guilds, \
	which has made many of its noble families particularly wealthy. However, that wealth has been stretched thin in recent years, as industrial, religious and political tensions grip the region, \
	with the Si'akh faith rapidly gaining strength and the urban peasantry agitating for better conditions in their factories. The Southlands is a stack of kindling, and the region's nobility anxiously wait to see \
	what will be the spark to set it off."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_SOUTHLANDS_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_NONE)