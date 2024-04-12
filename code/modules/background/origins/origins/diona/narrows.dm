/singleton/origin_item/culture/narrows
	name = "The Narrows"
	desc = "Hephaestus Penal Ship Narrows, colloquially referred to as \"The Narrows\", was originally one of the largest penal ships operated by Hephaestus in the Coalition of Colonies. Following the 2388 Uprising where a reactor meltdown led to the ship crashing into an asteroid, all but the Dionae prisoners aboard survived. Over the past century, the ship has been reclaimed and rebuilt by these Dionae who have formed their own, rigid culture spearheaded by one visionary leader. Working under Hephaestus Industries and with trade agreements with the Coalition of Colonies, the Narrows is one of the largest metals and alloys exporter in Coalition space - an image the Narrows strives to preserve. 'Majors' of the Narrows value order, following a strict hierarchy known as the Octaves System, and are separated by Blocks which dictate their duties. The Iron Eternal has a strong presence aboard the Narrows."
	possible_origins = list(
		/singleton/origin_item/origin/higher_octave,
		/singleton/origin_item/origin/lower_octave
	)

/singleton/origin_item/origin/higher_octave
	name = "Leased High Octave"
	desc = "The highly skilled, veteran Majors aboard the Narrows. 3rd and 4th Octaves are often leased to other facilities with a Hephaestus presence to show off the Narrows' prowess. These higher octave Majors are sure to have all desired traits the Narrows looks for in their crew, including a strong commitment to work, a collaborative spirit, exemplary mediation skills and a strong regard for authority."
	important_information = "3rd and 4th Octave Majors are skilled in their field and have been sent to show off the Narrows' prowess; this means they cannot be found in learning roles. 4th Octaves are the long-time veterans and have likely had supervisory positions aboard the Narrows, meaning they have likely been sent as Command personnel or Liaisons for Hephaestus Industries. Higher Octaves must work for Hephaestus or the SCC."
	possible_accents = list(ACCENT_LABOURSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/lower_octave
	name = "Low Octave Deserter"
	desc = "1st and 2nd Octaves aboard the Narrows are either new or who have repeatedly been disciplined for not adhering to the Narrows' culture and ideals, perhaps being Diminished. Aboard the Narrows, they are assigned to menial positions and are often under constant oversight from any higher octave supervisors. As the Narrows does not permit lower octaves to be leased off the Narrows, a number of dionae who do not align with the ideals of the ship consider smuggling themselves off the Narrows or fleeing their post."
	important_information = "Hephaestus Industries will not employ deserters of the Narrows; other companies will employ deserters in any position as long as they have received the training on or off the Narrows."
	possible_accents = list(ACCENT_LABOURSONG)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_ETERNAL_ICHOR, RELIGION_ETERNAL_IRON, RELIGION_OTHER, RELIGION_NONE)
