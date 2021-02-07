var/datum/antagonist/wizard_golem/wizard_golems = null

/datum/antagonist/wizard_golem
	id = MODE_GOLEM
	role_text = "Golem"
	role_text_plural = "Golems"
	welcome_text = "You are a golem summoned by a powerful mage. Serve your master, and assist them in completing their goals at any cost."
	antaghud_indicator = "hudmagineer"

/datum/antagonist/wizard_golem/New()
	..()

	wizard_golems = src