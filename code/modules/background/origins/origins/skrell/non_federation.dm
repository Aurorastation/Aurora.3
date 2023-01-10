/singleton/origin_item/culture/non_federation
	name = "Non-Federation Skrell"
	desc = "With First Contact with humanity, the Skrell saw the opportunity to explore and learn, and many decided to emigrate to human space. These communities integrated to varying degrees of success into human society, adopting some human concepts over the generations while still keeping their traditional Skrell culture. More modern Skrell communities such as the Starlight Zone or those found in the Coalition of Colonies will consist of refugees fleeing the Nralakk Federation, and have a more anti-Federation sentiment than the older communities that formed during First Contact. "
	possible_origins = list(
		/singleton/origin_item/origin/skrell_alliance,
		/singleton/origin_item/origin/skrell_biesel,
		/singleton/origin_item/origin/skrell_coalition
	)

/singleton/origin_item/origin/skrell_alliance
	name = "Sol Alliance" //skrell with dreg accent how
	desc = "With first contact with Humanity, many Skrell elected to move into human space. The Nralakk Federation and the Sol Alliance have been historic allies, and a large majority of Skrell living outside of the Federation calls the Sol Alliance home."
	important_information = "The Nralakk Federation is known to use its relationship with the Sol Alliance to step in when Skrell citizens are deemed dangerous to its national security."
	possible_accents = list(ACCENT_SKRELLSOL, ACCENT_EUROPA, ACCENT_MICTLAN)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_EUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/skrell_biesel
	name = "Republic of Biesel"
	desc = "With first contact with Humanity, many Skrell elected to move into human space. The Republic of Biesel has a considerable population of Skrell as it was a former Sol Alliance colony, and the population has only increased with the acceptance of former Sol Alliance planets into the Republic. The Republic of Biesel is also a popular destination for those fleeing the Nralakk Federation as there is precedence for the Republic to refuse to deport Federation Skrell if they join the Tau Ceti Foreign Legion."
	important_information = "Skrell living in the Republic of Biesel are protected from deportation to the Nralakk Federation if they renounce their Nralakk citizenship and join the Tau Ceti Foreign Legion."
	possible_accents = list(ACCENT_SKRELLCETI, ACCENT_GIBSON_OVAN)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_EUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/skrell_coalition
	name = "Coalition of Colonies"
	desc = "With first contact with Humanity, many Skrell elected to move into human space. The Coalition of Colonies does not have a large population of Skrell, although it is popular amongst those who wish to avoid Nralakk authorities or otherwise flee the Federation."
	important_information = "The Nralakk Federation still monitors non-citizen Skrell living abroad, and is known to request deportation or otherwise detain reputable threats to its national security. The response to these requests depends on the planet in question due to the Coalition's decentralised nature."
	possible_accents = list(ACCENT_SKRELLCOC)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_EUM)
	possible_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)