/decl/origin_item/culture/diona_coalition
	name = "Coalition of Colonies"
	desc = "The Coalition of Colonies was born out of the fires of the Interstellar War, the bloodiest war humanity has seen since its dawn as a species. The majority of its citizens prize their freedom above all else, which has led to problems with governance for the Coalition: to this day, it remains a very decentralized and fragmented entity that can only be brought together as a unified front in moments of extreme crisis. But with the recent growth of the Republic of Biesel, retreat of the Solarian Alliance, and an increasingly militaristic Empire of Dominia, perhaps this matter shall change in the years to come."
	possible_origins = list(
		/decl/origin_item/origin/coc_wildborn
	)
	
/decl/origin_item/origin/coc_grown
	name = "CoC Grown"
	desc = "Dionae who were originally grown in and influenced by a planet within the Coalition of Colonies "
	important_information = "As a result of no federal laws dictating how Dionae grown within CoC territory should be treated, their treatment can vary greatly from system to system, although generally are treated well and fully integrated into their local planet's society."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL, CITIZENSHIP_JARGON, CITIZENSHIP_EUM)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/decl/origin_item/origin/coc_wildborn
	name = "Wildborn"
	desc = "Dionae who were originally considered wild Dionae before being uplifted and integrated somewhere in the Coalition of Colonies or one of the megacorporations active within its borders."
	important_information = "Wild Dionae tend to have a much harder time within CoC borders as they're generally hunted for minerals stored within them, although in more recent decades this practice has begun to die down, with more and more wild Dionae being integrated into the CoC. Policies on uplifting and integrating Dionae within the CoC vary greatly from system to system as there are no set federal laws detailing how to handle them."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_JARGON, CITIZENSHIP_EUM, CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)
