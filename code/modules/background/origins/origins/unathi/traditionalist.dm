/decl/origin_item/culture/traditionalists //insert political joke
	name = "Traditionalists"
	desc = "Almost every former or current nation under the sun that isn't allied with the Izweski Hegemony is considered a part of the now-defunct Traditionalist Coalition. This includes people that fled to the Hegemony to escape the nuclear fallout, the majority of Traditionalists on Ouerea that have once rallied against Not'zar Izweski and will do so again, or those left to the Touched Lands to suffer and adapt to harsh new climates. Traditionalists are known to make new homes and embody the strength of the Unathi species: geographical and physical adaptability."
	possible_origins = list(
		/decl/origin_item/origin/trad_peasants,
		/decl/origin_item/origin/trad_nobles,
		/decl/origin_item/origin/wastelander
	)

/decl/origin_item/origin/trad_peasants //Do not make the joke. Do not make the joke. Do not m
	name = "Traditionalist Peasants"
	desc = "Though not necessarily restricted to a caste structure like the Hegemony, there is still a clear divide between the rich and the poor, and the peasantry show this. Strong, hardy, and stubborn, these folk are arguably the most hardy among Unathi, willing to stick their claws in the mud to do what needs to be done to survive and even thrive. Their religions, traditions, and practices vary strongly, and it is likely that two Unathi from the same Traditionalist town may look completely different from each other, both literally and figuratively. Some that used to be considered nobles are now peasants due to losing their land, riches, and clans."
	important_information = "Traditionalists are the most likely to emigrate decades before showing up on ship, so they are the least restricted when it comes to their background."
	possible_accents = list(ACCENT_TRAD_PEASANT, ACCENT_TRAD_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_AUTAKH, RELIGION_NONE)

/decl/origin_item/origin/trad_nobles
	name = "Traditionalist Upper Castes"
	desc = "The wealthy of the Traditionalists managed to find better purchase than most of their kin. Some fled to Dominia to form the Great House Kazhkz and others left Moghes to join them later; some decided to stake their chances abroad while clinging to their beliefs, such as on Ouerea; some still, stubborn as they were, stayed firmly in their spot and tried to survive on the fringes of Unathite society. These former nobles, depending on who you ask, are now trying to build up their former lives and luxuries, though sometimes to no avail. To most, they hold little standing other than titles above the average peasant. Despite this, Traditionalists managed to find success on Ouerea, where they hold a semblance of their former societies while living under the rule of the Hegemon and Hephaestus Industries."
	important_information = "Traditionalists are the most likely to emigrate decades before showing up on ship, so they are the least restricted when it comes to their background."
	possible_accents = list(ACCENT_TRAD_NOBLE)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_AUTAKH, RELIGION_SIAKH, RELIGION_NONE)

/decl/origin_item/origin/wastelander
	name = "Wastelander"
	desc = "The Wastelanders carved out a life for themselves amidst nuclear devastation. Si'akh managed to abuse the despair and pain of these Unathi to form a cult of personality for himself, as well as a new religion. Banditry remains common as new tribes and clans form in the desert wastes, but there is still hope. The Oasis Clans and some other settlements have made new towns and villages where life is starting to recuperate and find normalcy again. Still, every day is a struggle, and whenever there is an opportunity to flee offworld, it is taken eagerly."
	possible_accents = list(ACCENT_WASTELAND)
	possible_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_THAKH, RELIGION_SIAKH, RELIGION_OTHER, RELIGION_NONE)