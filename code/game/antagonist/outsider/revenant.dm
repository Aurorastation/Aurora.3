var/datum/antagonist/revenant/revenants = null

/datum/antagonist/revenant
	id = MODE_REVENANT
	role_text = "Revenant"
	role_text_plural = "Revenants"
	welcome_text = "A creature borne of bluespace, you are here to wreak havoc and put an end to bluespace experimentation, one station at a time."
	antaghud_indicator = "hudmagineer"
	initial_spawn_req = 0
	initial_spawn_target = 0
	hard_cap = 12
	hard_cap_round = 12

/datum/antagonist/revenant/New()
	..()

	revenants = src