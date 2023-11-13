/singleton/origin_item/culture/spaceborn
	name = "Spaceborn"
	desc = "Whether colonists in the far reaches of space, pirates that have forsaken their lives to find a new culture, or those that are merely living on ships and roaming or serving the Hegemon, the Spaceborn Unathi are a vast collective of emerging or niche cultures found across the Orion Spur."
	possible_origins = list(
		/singleton/origin_item/origin/ouerea,
		/singleton/origin_item/origin/unathi_pirate,
		/singleton/origin_item/origin/colonist,
		/singleton/origin_item/origin/mictlan_unathi
	)

/singleton/origin_item/origin/unathi_pirate
	name = "Pirates of the Spur"
	desc = "Pirates have no common group holding them all together to work as one. They tend towards ambition and passion, acting impulsively towards what they desire. With Not'zar Izweski's call to pirates to forsake their lifestyles and join his space navy, any pirate that has served four or more years under the Hegemony has their crimes pardoned by him (but not necessarily other states). With this, a good handful of pirates that knew no normalcy are now finding it abroad. Unathi pirates don't have citizenship in their respective countries, typically having a work or visitation visa instead."
	important_information = "Outside of the Hegemony, records should say they have some kind of visa instead of citizenship."
	possible_accents = list(ACCENT_TRAD_PEASANT, ACCENT_HEARTLAND_PEASANT, ACCENT_TRAD_NOBLE, ACCENT_TZA_PEASANT, ACCENT_TZA_NOBLE, ACCENT_SOUTHLANDS_NOBLE, ACCENT_SOUTHLANDS_PEASANT, ACCENT_TORN, ACCENT_ZAZ_LOW, ACCENT_ZAZ_HIGH, ACCENT_BROKEN_PEASANT, ACCENT_BROKEN_NOBLE, ACCENT_WASTELAND, ACCENT_UNATHI_SPACER, ACCENT_HAZANA, ACCENT_OUEREA)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/ouerea
	name = "Ouerea"
	desc = "Established in 2390, Ouerea was the first colony of the Izweski Hegemony, which quickly became home to large numbers of human and Skrell immigrants following first contact. During the Contact War, the Hegemony was incapable of governing it, and the planet was administrated by the Sol Alliance and Nralakk Federation. \
	This period led to the establishment of a fledgeling democracy, until Hegemon Sk'resti Izweski restored Hegemony control of the planet, reestablishing the feudal system. Following the Ouerean Revolution of 2460, Ouerea's democracy was restored, though still as a vassal of the Hegemon. Today, it is a society defined by contrasts, \
	with human, Skrell and Unathi culture blending into something strange, new and altogether unique within the Orion Spur."
	possible_accents = list(ACCENT_OUEREA)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/colonist
	name = "Colonist"
	desc = "Regardless of what country you serve and the religion you hold, you became a colonist, living on a gritty world with little infrastructure to carve out a new life for yourself. It could be a Dominian Primary helping guide a colony, relegated with this tiny responsibility as a means to keep you out of the way; it could be living on an outlying colony and being one of the first Unathi to settle down and find your way among xenos; it could be living on a nomadic vessel, trading and salvaging, to earn your keep and see the cosmos. By whatever means you acquired, you found your way to the Horizon to move up in the world."
	possible_accents = list(ACCENT_TRAD_PEASANT, ACCENT_TRAD_NOBLE, ACCENT_HEARTLAND_PEASANT, ACCENT_HEARTLAND_NOBLE, ACCENT_WASTELAND, ACCENT_DOMINIA_VULGAR, ACCENT_DOMINIA_HIGH, ACCENT_UNATHI_SPACER, ACCENT_TZA_PEASANT, ACCENT_TZA_NOBLE, ACCENT_SOUTHLANDS_NOBLE, ACCENT_SOUTHLANDS_PEASANT, ACCENT_TORN, ACCENT_ZAZ_LOW, ACCENT_ZAZ_HIGH, ACCENT_BROKEN_PEASANT, ACCENT_BROKEN_NOBLE)
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
	origin_traits = list(TRAIT_ORIGIN_COLD_RESISTANCE)
	origin_traits_descriptions = list("are more acclimatised to the cold.")

/singleton/origin_item/origin/mictlan_unathi
	name = "Mictlan Unathi"
	desc = "Following the Contact War, many Unathi refugees fled the ravaged Wasteland to the wider Spur, arriving in the space of the Sol Alliance. To prevent the Jewel Worlds from being flooded with alien refugees, the Alliance resettled the \
	Unathi refugees on the planet of Mictlan, where they began to rebuild - and eventually established the Free City of Vezdukh. The Unathi of Mictlan have restructured their society, creating one which is far more meritocratic than the feudal states of Moghes, \
	and have integrated into the population smoothly. Following the Republic of Biesel's annexation of Mictlan, the Unathi of the planet have largely refused to involve themselves in the ongoing struggle between the Samaritan movement and Biesel, simply wishing not to see another home consumed in war."
	possible_accents = list(ACCENT_MICTLAN)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_IGNORE_CAPSAICIN)
	origin_traits_descriptions = list("are not affected by spicy foods")
