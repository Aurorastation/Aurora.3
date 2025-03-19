/singleton/origin_item/culture/traditionalists //insert political joke
	name = "Traditionalists"
	desc = "Almost every former or current nation under the sun that isn't allied with the Izweski Hegemony is considered a part of the now-defunct Traditionalist Coalition. This includes people that fled to the Hegemony to escape the nuclear fallout, the majority of Traditionalists on Ouerea that have once rallied against Not'zar Izweski and will do so again, or those left to the Touched Lands to suffer and adapt to harsh new climates. Traditionalists are known to make new homes and embody the strength of the Unathi species: geographical and physical adaptability."
	possible_origins = list(
		/singleton/origin_item/origin/trad_peasants,
		/singleton/origin_item/origin/trad_nobles,
		/singleton/origin_item/origin/wastelander,
		/singleton/origin_item/origin/broken_peasants,
		/singleton/origin_item/origin/broken_nobles,
		/singleton/origin_item/origin/torn_cities
	)

/singleton/origin_item/origin/trad_peasants //Do not make the joke. Do not make the joke. Do not m
	name = "Traditionalist Peasants"
	desc = "Though not necessarily restricted to a caste structure like the Hegemony, there is still a clear divide between the rich and the poor, and the peasantry show this. Strong, hardy, and stubborn, these folk are arguably the most hardy among Unathi, willing to stick their claws in the mud to do what needs to be done to survive and even thrive. Their religions, traditions, and practices vary strongly, and it is likely that two Unathi from the same Traditionalist town may look completely different from each other, both literally and figuratively. Some that used to be considered nobles are now peasants due to losing their land, riches, and clans."
	important_information = "Traditionalists are the most likely to emigrate decades before showing up on ship, so they are the least restricted when it comes to their background."
	possible_accents = list(ACCENT_TRAD_PEASANT, ACCENT_TRAD_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_AUTAKH, RELIGION_NONE)

/singleton/origin_item/origin/trad_nobles
	name = "Traditionalist Upper Castes"
	desc = "The wealthy of the Traditionalists managed to find better purchase than most of their kin. Some fled to Dominia to form the Great House Kazhkz and others left Moghes to join them later; some decided to stake their chances abroad while clinging to their beliefs, such as on Ouerea; some still, stubborn as they were, stayed firmly in their spot and tried to survive on the fringes of Unathite society. These former nobles, depending on who you ask, are now trying to build up their former lives and luxuries, though sometimes to no avail. To most, they hold little standing other than titles above the average peasant. Despite this, Traditionalists managed to find success on Ouerea, where they hold a semblance of their former societies while living under the rule of the Hegemon and Hephaestus Industries."
	important_information = "Traditionalists are the most likely to emigrate decades before showing up on ship, so they are the least restricted when it comes to their background."
	possible_accents = list(ACCENT_TRAD_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/singleton/origin_item/origin/broken_peasants
	name = "Broken Coalition Peasant"
	desc = "The peasantry of the Broken Coalition once pledged fealty to the Azarak Kingdom, heartland of the Traditionalist Coalition. Now they try their best to make a living in the ruins of their once-great cities, and endure the difficulties faced by the region as it rebuilds from the Contact War. \
	Strong, stubborn and quick to hold grudges, these Unathi are some of the most vengeful and resilient to be found across Moghes. Some few of these peasants have fled the Hegemony entirely, and can be found throughout the Spur. They are majority Th'akh."
	important_information = "Should one run away and stop paying tithes back home, especially if they have renounced their Izweski citizenship, they are at risk of having a bounty put on them or being found out and deported."
	possible_accents = list(ACCENT_BROKEN_PEASANT)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/singleton/origin_item/origin/broken_nobles
	name = "Broken Coalition Noble"
	desc = "The Nobles of the Broken Coalition, once the Azarak Kingdom, are some of those clinging tightest to the scars of the Contact War. They are known for being vengeful and bitter, resenting the Izweski Hegemony greatly for their victory in the Contact War. \
	While some nobles of the Broken Coalition have embraced their new Izweski rulers, they are a definite minority, with most of the nobles of the region clinging fiercely to their hatred of the Izweski. Some of these nobles have fled the Hegemony entirely rather than admit defeat, and can be found across the Spur."
	important_information = "While the nobles of the Broken Coalition can have other citizenships, those who have done so would be considered as traitors to the Hegemony."
	possible_accents = list(ACCENT_BROKEN_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/singleton/origin_item/origin/torn_cities
	name = "Torn Cities"
	desc = "The western coast of the Moghresian Sea holds what was once the Kopesk States - a powerful league of theocratic Th'akh city-states, venerating spirits of the ocean. After they aligned with the Traditionalists during the \
	Contact War, the Kopesk States and their people have suffered greatly, their ancient shamans cast from power in favor of the newly-appointed Hegemonic governors. Now the region is known as the Torn Cities, as the region struggles to maintain its identity and survive \
	against the encroaching Wasteland to the west and the increasingly overfished Moghresian Sea to the east. In recent years, however, a new figure has arisen - a mysterious prophet of Kopesk Th'akh, known to their followers as 'The Marine Messiah'. \
	Time will tell if this wandering preacher marks a restoration for the old ways of the Kopesk States, or simply a dying spasm of the Torn Cities' culture."
	possible_accents = list(ACCENT_TORN)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_NONE)

/singleton/origin_item/origin/wastelander
	name = "Wastelander"
	desc = "The Wastelanders carved out a life for themselves amidst nuclear devastation. Si'akh managed to abuse the despair and pain of these Unathi to form a cult of personality for himself, as well as a new religion. Banditry remains common as new tribes and clans form in the desert wastes, but there is still hope. The Oasis Clans and some other settlements have made new towns and villages where life is starting to recuperate and find normalcy again. Still, every day is a struggle, and whenever there is an opportunity to flee offworld, it is taken eagerly."
	possible_accents = list(ACCENT_WASTELAND)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SIAKH, RELIGION_SKAKH, RELIGION_OTHER, RELIGION_NONE)
	origin_traits_descriptions = list("have a small resistance to radiation")

/singleton/origin_item/origin/wastelander/on_apply(var/mob/living/carbon/human/H)
	. = ..()
	H.AddComponent(/datum/component/armor, list(RAD = ARMOR_RAD_MINOR))

/singleton/origin_item/origin/wastelander/on_remove(mob/living/carbon/human/H)
	. = ..()
	var/datum/component/armor/armor_component = H.GetComponent(/datum/component/armor)
	qdel(armor_component)
