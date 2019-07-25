var/global/list/citizenship_choices = list()

/datum/citizenship
	var/name
	var/description

/datum/citizenship/New()
	..()
	citizenship_choices.Add(src)

