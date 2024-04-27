/singleton/origin_item/culture/izweski
	name = "Izweski Hegemony"
	desc = "The Izweski Hegemony is home to a majority of Unathi and remains the most powerful centralized force for the species in the modern day. Under the rulership of the Izweski and the religious guidance of the Church of Sk'akh, the Hegemony plays an important role for Sinta interests abroad. It has a strict loyalty to the caste system it is under, prioritizes the importance of the clan first and foremost, and remains the most open to xenocentric interests and customs out of all the current cultures found among Unathi. They embody ideals of diplomatic and cultural adaptability."
	possible_origins = list(
		/singleton/origin_item/origin/heartland_lower,
		/singleton/origin_item/origin/heartland_upper,
		/singleton/origin_item/origin/tza_lower,
		/singleton/origin_item/origin/tza_upper,
		/singleton/origin_item/origin/southlands_lower,
		/singleton/origin_item/origin/southlands_upper,
		/singleton/origin_item/origin/zazalai_lower,
		/singleton/origin_item/origin/zazalai_upper
	)

/singleton/origin_item/origin/heartland_lower
	name = "Izweski Heartland Lower Castes"
	desc = "The peasantry of the Izweski Heartland are some of the more prosperous peasants throughout the Izweski Hegemony. They have access to the full conveniences of modern life, and as a consequence of this tend to be highly supportive \
	and patriotic towards their nation and Hegemon. In recent years, the arrival of thousands of refugees from the Wasteland has placed the region under great strain, and many of the local peasantry resent the refugees for the impact on the local economy."
	important_information = "Should one run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_HEARTLAND_PEASANT)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/singleton/origin_item/origin/heartland_upper
	name = "Izweski Heartland Upper Castes"
	desc = "Wealth, glamor, and the seductive taste of power lie at the heart of nobility - but nowhere more than in the Izweski Heartland. The nobles of this land are the elte of the elite, known for their wealth, refinement and intrigue. Others may deride them as \
	treacherous or dishonorable, but the nobles of the Heartland do not care. They stand near the top of the Hegemony, and each of them is constantly seeking advantage over their rivals."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_HEARTLAND_NOBLE)
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
	origin_traits = list(TRAIT_ORIGIN_STAMINA_BONUS)
	origin_traits_descriptions = list("have slightly more stamina")

/singleton/origin_item/origin/tza_upper
	name = "Tza Prairie Upper Castes"
	desc = "To the north of Moghes, surrounded by the harsh peaks of the Tza Mountains, lies the Tza Prairie, also known as the Tza Basin. It is the heartland of the Th'akh faith, and its culture has remained \
	largely the same for centuries - one of determination, hard work and grit. The nobility of the region have historically been more willing to adapt to changing times, but even then they largely keep to the same \
	traditional ways of the region, even through war, famine and upheaval. This has created a culture as hardly and resilient as the mountains they call their home."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_TZA_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH)
	origin_traits = list(TRAIT_ORIGIN_STAMINA_BONUS)
	origin_traits_descriptions = list("have slightly more stamina")

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

/singleton/origin_item/origin/zazalai_lower
	name = "Zazalai Mountains Lower Castes"
	desc = "Spanning nearly the entirety of Moghes, the Zazalai Mountains were the Hegemony's eastern border for centuries, and were reinforced as a mighty bulwark against any potential aggression. In the modern day, however, the only thing they guard \
	against is the ever-spreading Wasteland. Much of the region has been rendered uninhabitable in the aftermath of the Contact War, and the cities and villages of the mountain range are gripped by famine, plagued by raiders and struggling with influxes of refugees from \
	both the Wasteland, and the many communities of the mountain range left abandoned. The Sinta of this region are known for their skill as defenders, with every man of the range being obliged to undergo rigorous military training. With the Wasteland spreading further and further into \
	the mountains, and more and more towns and cities being left uninhabitable, many of the cities of the region are not predicted to survive the decade. The Unathi of Zazalai are known for their strong sense of duty, often being described as being as unbreakable as the mountains they call their home."
	important_information = "Should a peasant run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_ZAZ_LOW)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_PAIN_RESISTANCE)
	origin_traits_descriptions = list("are slightly more resistant to pain")

/singleton/origin_item/origin/zazalai_upper
	name = "Zazalai Mountains Upper Castes"
	desc = "Spanning nearly the entirety of Moghes, the Zazalai Mountains were the Hegemony's eastern border for centuries, and were reinforced as a mighty bulwark against any potential aggression. In the modern day, however, the only thing they guard \
	against is the ever-spreading Wasteland. Much of the region has been rendered uninhabitable in the aftermath of the Contact War, and the cities and villages of the mountain range are gripped by famine, plagued by raiders and struggling with influxes of refugees from \
	both the Wasteland, and the many communities of the mountain range left abandoned. The nobility of the Zazalai Mountains have had a historically prestigious role, acting as the foremost sentinels of the Hegemony against its enemies to the east. For many, adjusting to the \
	modern age - where the mountains are considerably less important from a military point of view - has been difficult, and some have even abandoned their ancestral estates to seek gener pastures elsewhere. The Unathi of Zazalai are known for their strong sense of duty, often \
	being described as being as unbreakable as the mountains they call their home."
	important_information = "Work and visitation visas should be mentioned in records as they are possible in any country where a peasant can get citizenship; almost all nobles shy away from getting citizenship abroad as it would be seen as betraying the Hegemon."
	possible_accents = list(ACCENT_ZAZ_HIGH)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_PAIN_RESISTANCE)
	origin_traits_descriptions = list("are slightly more resistant to pain")
