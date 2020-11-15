var/datum/antagonist/bluespace_golem/bluespace_golems = null

/datum/antagonist/bluespace_golem
	id = MODE_GOLEM
	role_text = "Golem"
	role_text_plural = "Golems"
	welcome_text = "You are a golem summoned by a powerful mage. Serve your master, and assist them in completing their goals at any cost."
	antaghud_indicator = "hudmagineer"

/datum/antagonist/bluespace_golem/New()
	..()

	bluespace_golems = src