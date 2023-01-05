/decl/origin_item/culture/xrim
	name = "Xrim"
	desc = "Xrim plays host to one of the largest Dionae populations in the Spur, with much of its population being divided between two groups, the Kshrr and the Shrkh. The planet was originally a Skrell colony, however, after the rise of Glorsh, the planet was taken over by its current Dionae inhabitants, with the entirety of the planet's skrell population dying off sometime before this occurred. These Dionae originally worshiped Glorsh as their god, but upon learning the true nature of Glorsh, many chose to renounce them and went on to form the Kshrr, meanwhile those that continued to worship the Glorsh became known as the Shrkh. The divide between the two has grown considerably, with the Shrkh being exiled from Kshrr society and forced to mostly live underground, doubly so once the planet was rediscovered by the Skrell and peacefully reincorporated into the Federation, with the Federation deeming the Shrkh a threat to their nation and being outlawed, with members of the Shrkh religion being forced to convert away from their worship of Glorsh. While the Federation has certainly helped shape modern Xrim culture, the planet still holds a distinct culture unlike anywhere else seen in the Federation, being one of the only planets with an almost entirety Dionae population in the entire Spur."
	possible_origins = list(
		/decl/origin_item/origin/kshrr,
		/decl/origin_item/origin/shrkh
	)

/decl/origin_item/origin/kshrr
	name = "Kshrr"
	desc = "Making up the majority of the population on Xrim, The Kshrr are those who chose to reject their old god once its true nature was made known to them as the genocidal AI known as Glorsh that terrorized the Skrell for decades."
	important_information = "Not every member of Kshrr society has to be a member of the Kshrr religion, however, it's indisputable that the religion has played a large part in shaping Kshrr culture and society."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_KSSHR, RELIGION_SHRKH, RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/decl/origin_item/origin/shrkh
	name = "Shrkh"
	desc = "The Shrkh are those who continued to worship \"First Consciousness\" even after its true nature and crimes were made known to Xrim's inhabitants as the genocidal AI that terrorized the Skrell for decades. These Dionae were largely exiled and went on to form their own communities away from the view of the Kshrr and later the Nralakk Federation once Xrim joined them. In more modern times the Nralakk Federation and the Kshrr are making attempts to deconvert the Shrkh away from their worship of Glorsh through both passive and more forceful means, however, many secretive communities do still exist underneath the planet's surface such as the city of Entombed Hope."
	important_information = "Dionae can originate from Shrkh society but do not have to still follow the Shrkh religion, these Dionae are not beholden to the same restrictions that active Shrkh worshippers are so long as they have rejected their old god."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_KSSHR, RELIGION_SHRKH, RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)