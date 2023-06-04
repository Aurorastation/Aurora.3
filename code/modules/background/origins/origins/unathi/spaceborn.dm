/singleton/origin_item/culture/spaceborn
	name = "Spaceborn"
	desc = "Whether colonists in the far reaches of space, pirates that have forsaken their lives to find a new culture, or those that are merely living on ships and roaming or serving the Hegemon, the Spaceborn Unathi are a vast collective of emerging or niche cultures found across the Orion Spur."
	possible_origins = list(
		/singleton/origin_item/origin/unathi_pirate,
		/singleton/origin_item/origin/colonist,
		/singleton/origin_item/origin/mictlan_unathi
	)

/singleton/origin_item/origin/unathi_pirate
	name = "Pirates of the Spur"
	desc = "Pirates have no common group holding them all together to work as one. They tend towards ambition and passion, acting impulsively towards what they desire. With Not'zar Izweski's call to pirates to forsake their lifestyles and join his space navy, any pirate that has served four or more years under the Hegemony has their crimes pardoned by him (but not necessarily other states). With this, a good handful of pirates that knew no normalcy are now finding it abroad. Unathi pirates don't have citizenship in their respective countries, typically having a work or visitation visa instead."
	important_information = "Outside of the Hegemony, records should say they have some kind of visa instead of citizenship."
	possible_accents = list(ACCENT_TRAD_PEASANT, ACCENT_HEGEMON_PEASANT, ACCENT_TRAD_NOBLE, ACCENT_WASTELAND, ACCENT_UNATHI_SPACER, ACCENT_HAZANA)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/colonist
	name = "Colonist"
	desc = "Regardless of what country you serve and the religion you hold, you became a colonist, living on a gritty world with little infrastructure to carve out a new life for yourself. It could be a Dominian Primary helping guide a colony, relegated with this tiny responsibility as a means to keep you out of the way; it could be living on Ouerea and Gakal'zaal and being one of the first Unathi to settle down and find your way among xenos; it could be living on a nomadic vessel, trading and salvaging, to earn your keep and see the cosmos. By whatever means you acquired, you found your way to the Horizon to move up in the world."
	possible_accents = list(ACCENT_TRAD_PEASANT, ACCENT_TRAD_NOBLE, ACCENT_HEGEMON_PEASANT, ACCENT_HEGEMON_NOBLE, ACCENT_WASTELAND, ACCENT_DOMINIA_VULGAR, ACCENT_DOMINIA_HIGH, ACCENT_UNATHI_SPACER)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_ERIDANI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_AUTAKH, RELIGION_OTHER, RELIGION_MOROZ, RELIGION_NONE)

/singleton/origin_item/culture/dominian_unathi
	name = "Empire of Dominia"
	desc = "The Empire of Dominia (often simply referred to as \"the Empire\") is an autocratic monarchy that is heavily influenced by its state religion, the Moroz Holy Tribunal, which is often regarded as an offshoot of old Earth faiths. Imperial society is sharply divided between Morozians, which are themselves divided between noble Primaries and commoner Secondaries, and Ma'zals, which make up the population of its conquered worlds. Militaristic and expansionist, the Empire has been increasingly brought into conflict with its neighbors: the Serene Republic of Elyra and Coalition of Colonies. Dominians are often stereotyped as militant, religious, and egotistical."
	possible_origins = list(
		/singleton/origin_item/origin/dominian_unathi
	)

/singleton/origin_item/origin/dominian_unathi
	name = "Dominian Unathi"
	desc = "Dominian Unathi are those that either helped found House Kazhkz or came after the Great House was created and sought refuge from the Contact War. The Unathi in Dominia are Primaries and Secondaries, with next to none being Ma'zals. Their recent integration proves to be a point of contention among the Empire of Dominia: some find them welcome, should they be loyal, while others find their presence and conduct to be distasteful and dishonorable. For good or bad, they're here to stay, and they follow some semblance of their former codes and traditions here under the Great Holy Emperor."
	possible_accents = list(ACCENT_DOMINIA_VULGAR, ACCENT_DOMINIA_HIGH)
	possible_citizenships = list(CITIZENSHIP_DOMINIA, CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_MOROZ, RELIGION_THAKH)

/singleton/origin_item/origin/mictlan_unathi
	name = "Mictlan Unathi"
	desc = "Following the Contact War, many Unathi refugees fled the ravaged Wasteland to the wider Spur, arriving in the space of the Sol Alliance. To prevent the Jewel Worlds from being flooded with alien refugees, the Alliance resettled the \
	Unathi refugees on the planet of Mictlan, where they began to rebuild - and eventually established the Free City of Vezdukh. The Unathi of Mictlan have restructured their society, creating one which is far more meritocratic than the feudal states of Moghes, \
	and have integrated into the population smoothly. Following the Republic of Biesel's annexation of Mictlan, the Unathi of the planet have largely refused to involve themselves in the ongoing struggle between the Samaritan movement and Biesel, simply wishing not to see another home consumed in war."
	possible_accents = list(ACCENT_MICTLAN)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_NONE)
