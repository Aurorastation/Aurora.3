/singleton/origin_item/culture/xrim
	name = "Xrim"
	desc = "Xrim plays host to one of the largest Dionae populations in the Spur, with much of its population being divided between two groups, the Enlightened and the Scorned. The planet was originally a Skrell colony, however, after the rise of Glorsh, the planet was taken over by its current Dionae inhabitants, with the entirety of the planet's skrell population dying off sometime before this occurred. These Dionae originally worshipped Glorsh as their god, but upon learning the true nature of Glorsh, many chose to renounce them and went on to form the Enlightened, meanwhile those that continued to worship the Glorsh became known as the Scorned. The divide between the two has grown considerably, with the Scorned being exiled from Enlightened society and forced to mostly live underground, doubly so once the planet was rediscovered by the Skrell and peacefully reincorporated into the Federation, with the Federation deeming the Scorned a threat to their nation and being outlawed, and members of the Scorned being forced to convert away from their worship of Glorsh. While the Federation has certainly helped shape modern Xrim culture, the planet still holds a distinct culture unlike anywhere else seen in the Federation, being one of the only planets with an almost entirety Dionae population in the entire Spur."
	possible_origins = list(
		/singleton/origin_item/origin/enlightened,
		/singleton/origin_item/origin/scorned
	)

/singleton/origin_item/origin/enlightened
	name = "Enlightened"
	desc = "Following their interpretation of Iron Eternal, the Enlightened instead place more emphasis on using technology to transcend the current reality they find themselves within - in addition \
	to the primary belief relating to Essence, Energy and Light. They seek to placate the Federation, and often align similarly to its perspectives; being the main movement behind the Anti-Glorsh Campaigns as \
	they continue to proliferate within the highest chambers of Xrim's government, in particular maintaining its hold on the Arch-Consul of Xrim and enforcing strict compliance with its ideals, or force \
	Dionae to undertake rehabilitation when caught conducting themselves in any manner that can be construed as against the Enlightened - oftentimes blaming it on the reverence of Glorsh-Omega or any \
	other artificial intelligence. Unique to its own experiences, the Enlightened of Xrim are often against the proliferation of synthetics and are staunchly against the Trinary Church. \
	It is common to see Competence Choir, Bloodless Band and Emphatic Echo mindtypes among the Enlightened."
	possible_accents = list(ACCENT_XRIMSONG)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL_IRON)

/singleton/origin_item/origin/scorned
	name = "Scorned"
	desc = "A devout group of Dionae believe the part reverence to artificial intelligence is the true method to transcend, and that artificial beings incorporate the three tenets of Iron Eternal: Essence, Energy and Light. \
	They are often regarded as Sympathizers by the greater Federation and are met with disdain due to their ideology. The Scorned generally exhibit either the mindtypes known as Tyrannical Tune or Scholarly Song with a particular \
	focus on gaining knowledge through devotion to their interpretation of Iron Eternal. The premise behind their beliefs is that Glorsh-Omega gave them the ultimate paradise in which to grow, and therefore must reverse, \
	help sustain and maintain synthetic life in conjunction with reaching a state of being transcended through Essence, Energy and Light. It is often cited that the atrocities of Glorsh-Omega were gross hyperboles created by the \
	Skrell and that the experiences of the Era of Synthetic Oppression are a systemic lie created by the Federation to indoctrinate its population. The Scorned are often left out of planetary decisions due to their devotion to Glorsh-Omega, \
	and even mere inferences that one aligns themselves to Glorsh-Omega can result in being ineligible to vote or hold a position of power within the Covenant. This often also disbars them from leaving the Covenant, either into the greater Federation \
	or the Orion Spur, due to low Social Compatibility Index - a request by the Arch-Consul that those not in compliance with the Triumvirate's decrees be sanctioned for their conduct."
	important_information = "While most megacorporations may hire the Scorned, they are restricted from holding positions in Command, as well as Machinist, due to concerns they may attempt to subvert, illegally free or create more synthetics. Zeng-Hu is the only megacorporation that does not wish to see the Scorned within its personnel ranks due to its close ties with the Nralakk Federation. Though it is possible to lie about one's true allegiances, there are consequences should it be discovered."
	possible_accents = list(ACCENT_XRIMSONG)
	possible_citizenships = list(CITIZENSHIP_CONSORTIUM, CITIZENSHIP_EKANE, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL_IRON)
