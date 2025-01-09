/singleton/origin_item/culture/dionae_moghes
	name = "Izweski Hegemony"
	desc = "The Izweski Hegemony is home to a majority of Unathi and remains the most powerful centralized force for the species in the modern day. Under the rulership of the Izweski and the religious guidance of the Church of Sk'akh, the Hegemony plays an important role for Sinta interests abroad. It has a strict loyalty to the caste system it is under, prioritizes the importance of the clan first and foremost, and remains the most open to xenocentric interests and customs out of all the current cultures found among Unathi. They embody ideals of diplomatic and cultural adaptability. However, things outside the Hegemony are not so good."
	possible_origins = list(
		/singleton/origin_item/origin/viridis_noble,
		/singleton/origin_item/origin/viridis_common,
		/singleton/origin_item/origin/dionae_wasteland
	)

/singleton/origin_item/origin/viridis_noble
	name = "Viridis Noble"
	desc = "The elevation of Dionae to nobility in 2466 was a controversial decision, but one deemed necessary for the continued operation of Project Viridis. Since their creation, the noble gestalts known as the Lords Verdant have created many offshoots, which are deemed to hold the station of lesser nobility in Izweski society. Many of these gestalts have been sent to other regions of the Hegemony and even beyond, in the hopes of building connections and securing the still-fragile political position of their progenitors."
	important_information = "The noble gestalts of the Viridis are carefully cultivated to serve in their roles, and only specific mindtypes are permitted to exist among them. A list of these can be found on the wiki."
	possible_accents = list(ACCENT_GARDENSONG)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_OTHER)

/singleton/origin_item/origin/viridis_common
	name = "Viridis Commoner"
	desc = "The Hegemony's grand bioterraforming project has led to the growth and recruitment of countless Dionae gestalts in the lands of the Viridis. While most of these Dionae remain in the region of their growth, the Lords Verdant have transferred a sizeable number outside the Viridis as workers, in order to grow their own influence."
	possible_accents = list(ACCENT_SANDSONG,ACCENT_WASTESONG)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_OTHER)

/singleton/origin_item/origin/dionae_wasteland
	name = "Wasteland"
	desc = "Dionae who were grown in and largely influenced by the wasteland of Moghes. A sort of symbolic bond has formed between these Dionae and the local Unathi, with the Dionae helping clear and absorb Radiation to allow for safer crop growth, and the Unathi providing protection and blood. Dionae will occasionally leave the wastes and Moghes entirely in search of purpose elsewhere in the spur, although influence from Unathi society can certainly still be felt by them."
	important_information = "This option is for both Dionae who were originally grown in the Wastes and Wild Dionae who somehow managed to find their way to Moghes and the Wastes."
	possible_accents = list(ACCENT_IRONSONG, ACCENT_CRIMSONSONG, ACCENT_SANDSONG, ACCENT_WASTESONG)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_OTHER)
